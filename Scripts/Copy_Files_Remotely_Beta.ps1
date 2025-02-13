<#
 Developed in 2019 by Angelo Polatto using Powershell 3.0 supporting previous versions of Powershell.
 In summary this software performs a local copy of on screen selected file(s) found in a remote
 computer, preserving the remote three directory.
 
 As at the time this code was meant to be used in a joined domain computer, while executing this code 
 make sure that the current user has granted access permission in the remote computer.
#>

Add-Type -AssemblyName System.Windows.Forms
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '650,630'
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$form.MaximizeBox = $false
$Form.startposition = "centerscreen"
$Form.Text = "Copy Files Remotely - Beta"
$toolTip = New-Object System.Windows.Forms.ToolTip
$ShowHelp={
Switch ($this.name) {
"ButtonComputer" {$tip = "Enter the name of a remote computer."}
"ButtonDestination" {$tip = "Select a folder to store the backup."}
"iconInfoBox" {$tip = "Copy Files Remotely - Beta`nCreated by Angelo Polatto - 2019`nThis
software was developed using Powershell ISE V5,`ncapable of listing and copy files from a
remote computer,`nas long it runs Powershell V2 or more recent versions."}
"LabelHiddenCheckBox" {$tip = "Selecting this option the software will list an hidden objects,
excluding system files and folders.`nNonetheless it's a time consuming operation."}
"HiddenCheckBox" {$tip = "Selecting this option the software will list hidden objects,
excluding system files and folders.`nNonetheless it's a time consuming operation."}
"TextBox1" {$tip = "Type a string to exclude it from the search."}
"labelExclude" {$tip = "Type a string to exclude it from the search."}
}
$tooltip.SetToolTip($this,$tip)
}
$iconBase64 =
'iVBORw0KGgoAAAANSUhEUgAAAPwAAAD+CAYAAAAeY2hsAAAAAXNSR0IArs4c6QAAAARn-
QU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABLwSURBVHhe7Z3N-
r15VFcb9Z6BpGhjBqNNOOyAOMBoHzrQdODP+AR3aCXbCAIIfaSJGayTpQAeAxo8SWj+CIUSlaq-
T4ESqmAqFyOWbDWbjvvs/Z6zzvOvfcd5/9/
JJf3vPus7sunrWee973YMOnBiFENyjwe8DBwcF4tP+09M8qjqLAC9ERCnyFqbuZrUfPG/
n7dIzOl+toLYH2GXZse/
JziXLNjvP18jx6n68l5q4Ztf35erlWnhdHUeArTA1PPmCIuecNtH+qxty9S63l6wlvv8GuGd7+BFqfO-
haHUeAdpobNiL5P2FrtnIH25mu5Bnpv2LHtMW2tJD+Xa2sGWjPsz5g5U/
tz7H2+PnUsDqPAO5TDVQ5T9HwCnZvaz+xNePvm/llj7n60r/
ZnjTn70frUsTiMAj8DNGA5u5yvHefvE7ZW7jPK43wv2lfuMcr18nwiX6vtR/tybM3W8/
P5umFr5T5j6lgcRoHvEAWiXxT4DlHg+0WBF6IjFHghOkKBF6IjFHghOkKBF6IjwoH/
xguPy73xM8O3f/L54dmffWl47uWvDs+/8rXh5T9eHW7/4xfDf97759gx0TMKfEd+/5dfHl76/
TPD3/716vDhhx+OHRQ9ocB3agr/K395bnj/v++MnRQ9oMB37tWffmH4zZ++N9z/
4L2xo2LLKPDyI7/z8y9+9F1fbBsFXh4yPeh77/6/x+6KraHAyyOmp/x/f/u1scNiSyjwEvrNFz87/
OHNF8cui62gwMtJn3n+8eG3f/7B2GmxBRR46frr298duy1aR4GXs/
zV7WfHjouWUeDlbBX69lHgJaVC3zYKvKRV6NtFgZc7qdC3iQIvd1ahb48TD7yo88EH94e333ljeP-
WvPxp+
+NJX4DU8SRX6tlDgGyL9HfbX3vjx8K0XPgev5Ump0LeDAt8gb979nUIvdkKBb5R0p0fX8y-
RV6PcfBb5R0sd7facXLAp8w6QHeeianrQK/f6iwDdMenqPruk+qNDvJwp8w6R/
ZYeu6b6o0O8fCrwQHaHAC9ERCrwQHaHAC9ERCrwQHaHAC9ERCrwQHaHAC9ERCny-
QBx54QO6Jp06dGh566KHh7Nmzw2Offmy4ePHicPny5eH69evDnTt3xo71jQIfBA2e3E/
PnTs3XLp0abh582a3/318BT4IGiy5/6bwP/30U8O9e/
fGTvaBAh8EDZNsx0cefWS4cuXK8O6774wd3TYKfBA0RLI90/
f+9F1/6yjwQdDwyHa9cOHCcPfuW2N3t4cCHwQNjWzbdLe/devW2OFtocAHQQMj2/
f06dPDtWvXxi5vBwU+CBoWuR2ffPLJsdPbQIEPgoZEbssnnnhi7Hb7KPBB0IDI7fnE17cRegU+CBo-
OuU23EHoFPggaDLldWw+9Ah8EDYXcti2HXoEPggZCbt9WQ6/
AB0HDIPuwxdA3H3hUc0k90CAwijr3778/3L79+nD16tXh/Pnz8BqepK2FXoF39EBDwCjmk/
4Oewr+mTNn4LU8KVsKvQLv6IEGgFHw3LhxQ6HfEQXe0QM1n1HsRrrTo+t5krYQegXe0QM1nlHs-
Rvp4r+/0PAq8owdqOqPYnX28yyf3OfQKvKMHajij2J309B5d031wX//CjQLv6IGazSh2J/
0rO3RN98V9Cv3BwcFHKvCOHqjRjCIGuqaM6eM3Wl/
Kkw69Bd1Q4B09UJMZRQx0TRkTWw19HnQDBt5+K5S/HRAoJIxRUM0l9UANZhQx0DVlNHoJ/
ZHAewEvQSFhjIJqLqkHai6jiIGuKWPO1kKPsqzAO3qgxjKKGOiaMpZsMfR5pvWR3tEDNZVRxEDXl-
BGxxY/
3lmXd4R09UEMZRQx0TRmn2Op3egXe0QM1k1HEQNeUscaWQl+9w5fWQCFhbB3USEYRA11TRo/
WQ19mGH6HZ0AhZmwd1ERGEQNdU8Y5tBp6dLN2H9p5oBAztg5qIKOIga4p41y2Enr3O7wXeh-
RixtZBzWMUMdA1ZWRoLfQouwp8ENQ4RhEDXVNGlhZDn2dYgQ+CmsYoYqBryrgLLX68t+DrO3w
Q1DBGEQNdU8ZdafU7PQw8AwoxY+ugZjGKGOiaMkY47tAv+Z+qdu/
w+WsNFGLG1kGNYhQx0DVljHLcob927dr4k3bDgm7oO3wQ1CRGEQNdU8YlOM7Qnz59er-
h169b4kzhQdhX4IKhJjCIGuqaMS3GcoT979uxw9+5b40/
iKPOrh3ZBUIMYRQx0TRmX5DhDf+HChfGnzAflVw/tgqDmMIoY6JoyLs1xhv769evjT5lPeeN2A+/
d5VGIGVsHNYZRxEDXlPE4OK7Qp4/27777zvhTOCz4usMHQY1hFDHQNWU8Lo4r9FeuXBl/
gg+6WVe/w9txDRRixtZBTWEUMdA1ZTxOjiP0jzz6yHDv3r3xJ/
AcCXwZ9H0PPKq5pB6oKYxRUM2WjIJqbt2nn35q/F/Po8A7eqCGMEZBNVsyCqq5dc+dO/
fRf0zTI2W3tPqRPumBQsIYBdVcUg/UEMYoqGZLRkE1e/DmzZvjFeBo/
qEdqrmkHqgZjFFQzZaMgmr24KVLl8YrUKe8eU/
e4fPXGigkjFFQzSX1QM1gjIJqtmQUVLMH08d6jzK/
6f3kd3jDCz0KCWMUVHNJPVAzGKOgmi0ZBdXsxTt37oxXAaPA76AHagRjFFSzJaOgmr045/95Z/
m1Vz20c/
RAjWCMgmq2ZBRUsxcvX748XoX56KGdowdqBGMUVLMlo6CavXjx4sXxKkxT3rzdO7xtnAKFh-
DEKqrmkHqgRjFFQzZaMgmr24mOffmy8Cpgyu+m9+x3eA4WEMQqquaQeqBGMUVDNloyCavZi+
ss0NRT4HfRAjWCMgmq2ZBRUsxcffvjh8SpgZge+tAYKCWMUVHNJPVAjGKOgmi0ZBdXsxVOn-
To1XYZoyx3po5+iBGsEYBdVsySioZk+yVB/a2XENFBLGKKjmknqgJjBGQTVbMgqq2ZM1LMe5k9/
hy9cpUEgYo6CaS+qBmsAYBdVsySioZk8ybCLwJw1qAqPYNvfvvz/
cvv36cPXq1eH8+fNwBiIywMAn0gnTA4WYsXVQExhFP6S/
w56Cf+bMGTgLu1gjz7FlufmHdicNagKj6I8bN24sFnqWTwJvvwHK3wq2PgUKMWProCYwi-
j5Jd3o0D6weZY51hw+CmsAo+iR9vF/
iO30NC3n+OvnQbi4oxIytg5rAKPplibt8DQX+GEBNYBT9kp7eo5lgrJEH3Y7hR3om9CjEjK2DmsAo+
iX9Kzs0E4ws8A5fWgOFmLF1UBMYRd+gmWCskefXjvXQLghqAqPoGzQTjHPIb9qTH+nz3ww1UIg
ZWwc1gVH0DZoJxjlUA18GXYGvg5rAKPoGzQRjjZTdPMdJBT4IagKj6Bs0E4ws1Y/
0XtgTKMSMrYOawCj6Bs0EIyLPb6ke2gVBTWAUfYNmgrFGCnjOZODz3wgeKMSMrYOawCj6B-
s0EY41ZgUebaqAQM0ZBNZfUAzWBMUpZ78EHH/zkNTc/V+7Nj/
P9+ftyXX5sFFST0SPl10wo8I4eqAmMUcp6Fsr8tVwz8/
flnnLv1FrvRkE1GVlg4KdEoJAwRkE1l9QDNYExSlkPBTZfM8v3+drUn7E1+X+joJqMHmV+m39o-
h2ouqQdqAmMUVFOuZxRUk7GGhTx/
nbzDl8dToJAwRkE1l9QDNYExCqppMnfn8ry3X35sFFSTsUaeY3udvMN7QTdQSBijoJpL6oGawBg-
F1TSZ0CrwuxkF1WSskQfdjhV4Rw/UBMYoqKZpoU2v5XFuuY7eS2wUVJORRR/
pHT1QExijoJpmHtY8yLu8SmwUVJOxhuU3Vw/
tHD1QExijoJpmCmuurU29mui8xEZBNRnnksKegIG33wZ2XAOFhDEKqrmkHqgJjFFQTbmeUVBN-
RgZ4hy+DrsDXQU1gjIJqyvWMgmoyMijwM/RATWCMgmrK9YyCajKyVD/
Se2FPoJAwRkE1l9QDNYExCqop1zMKqslYI8+xqYd2jh6oCYxRUE25nlFQTUYW9w6frIFCwhgF1Vx-
SD9QExiioplzPKKgmo0eZ48nv8HNBIWGMgmouqQdqAmMUVFOuZxRUk7GGZTl/
bT7wJw1qAqPoGzQTjDVmB760BgoxY+ugJjCKvkEzwVjDspvnuPmHdicNagKj6Bs0E4ws7kM7Dx-
RixtZBTWAUfYNmgrFGnmPT/
Q5fvi9BIWZsHdQERtE3aCYYGRT4BUBNYBR9g2aCkUGBXwDUBEbRN2gmGGuk7OYm9B0+CGo-
Co+gbNBOMLDDwDCjEjK2DmsAo+gbNBKNHefOevMPnrzVQiBlbBzWBUfQNmgnGGmV+03t9hw
+CmsAo+gbNBGMNBf4YQE1gFH2DZoLRw/
Jrr3poFwQ1gVH0DZoJRhY9tAuCmsAo+gbNBKNHefP+JPC2kG8wa6AQM7YOagKj6Bs0E4w1L-
Lv5q+7wQVATGEXfoJlgrLHJwKOaS+qBmsAYBdWU6xkF1WSskQfdjt3A28YpUEgYo6CaS+qBms-
AYBdWU6xkF1WRkORL4/
LfBHFBIGKOgmkvqgZrAGAXVlOsZBdVkrIFyPHmHnxt8FBLGKKjmknqgJjBGQTXlekZBNRl-
Z9JHe0QM1gTEKqinXMwqqyehhN27LcTXwusMr8LJuFFSTsUaZ3/
Red3hHD9QExiioplzPKKgmYw0q8OmkF/
YECgljFFRzST1QExijoJpyPaOgmowelmF7PRL4uUE3UEgYo6CaS+qBmsAYBdWU6xkF1WRkcT/
Se6CQMEZBNZfUAzWBMQqqKdczCqrJ6GE3cN3hZ+qBmsAYBdWU6xkF1WSsUeY4vdd3eEc-
P1ATGKKimXM8oqCZjDSrwhhd6FBLGKKjmknqgJjBGQTXlekZBNRlr0IH3wp5AIWGMgmouqQdq-
AmMUVFOuZxRUk9EjZdhM6A7v6IGawBgF1ZTrGQXVZGTRd3hHD9QExiioplzPKKgmYw3LcO6R-
wNuJuaCQMLYOagKj6Bs0E4wMMPAsKMSMrYOawCj6Bs0EI4Pu8AuAmsAo+gbNBGMNy3Ke6ea/
w580qAmMom/QTDAypDy7H+m90KMQM7YOagKj6Bs0E4wMbuB1h/
dBTWAUfYNmgrFGym9uQnf4IKgJjKJv0Ewwsug7fBDUBEbRN2gmGFmOBH5u0A0UYsbWQU1g-
FH2DZoKRxf1I74FCzNg6qAmMom/
QTDCyKPBBUBMYRd+gmWBkUeCDoCYwir5BM8HIosAHQU1gFH2DZoKRRYEPgprAKPoGzQQjiw-
IfBDWBUfQNmglGFgU+CGoCo+gbNBOMLCce+H3XAzWBMQqqKdczCqrJyKLAO3qgJj-
BGQTXlekZBNRlZFHhHD9QExiioplzPKKgmI4sC7+iBmsAYBdWU6xkF1WRkUeAdPVATGKOgmn-
I9o6CajCwKvKMHagJjFFRTrmcUVJORRYF39EBNYIyCasr1jIJqMrIo8I4eqAmMUVBNuZ5RUE1GFg-
Xe0QM1gTEKqinXMwqqyciiwDt6oCYwRkE15XpGQTUZWRR4Rw/UBMYoqKZczyioJiOLAu/
ogZrAGAXVlOsZBdVkZFHgHT1QExijoJpyPaOgmowsCryjB2oCYxRUU65nFFSTkUWBd/
RATWCMgmrK9YyCajKyKPCOHqgJjFFQTbmeUVBNRpZw4HsHNYFR9A2aCUYWBT4IagKj6B-
s0E4wsCnwQ1ARG0TdoJhhZFPggqAmMom/
QTDCyKPBBUBMYRd+gmWBkUeCDoCYwir5BM8HIosAHQU1gFH2DZoKRRYEPgprAKPoGzQQjiw-
IfBDWBUfQNmglGFgU+CGoCo+gbNBOMLAp8ENQERtE3aCYYWRT4IKgJjKJv0EwwsijwQVAT-
GEXfoJlgZFHgg6AmMIq+QTPByKLAB0FNYBR9g2aCkUWBD4KawCj6Bs0EI4sCHwQ1Qcq1ZFHg-
g6AmSLmWLAp8ENQEKdeSRYEPgpog5VqyKPBBUBOkXEsWBT4IaoKUa8miwAdBTZByLVkU+CC
oCVKuJYsCHwQ1Qcq1ZFHgg6AmSLmWLAp8ENQEKdeSRYEPgpog5VqyKPBBUBOkXEs-
WBT4IaoKUa8miwAdBTZByLVkU+CCoCVKuJYsCL0RHKPBCdIQCL0RHKPBCdIQCL0RHKPBCdIQ-
CL0RHKPB7wMHBwXi0/7T0zyqOosAL0REKfIWpu5mtR88b+ft0jM6X62gtgfYZdmx78nOJcs2O8/
XyPHqfryXmrhm1/fl6uVaeF0dR4CtMDU8+YIi55w20f6rG3L1LreXrCW+/
wa4Z3v4EWp86FodR4B2mhs2Ivk/YWu2cgfbma7kGem/
Yse0xba0kP5drawZaM+zPmDlT+3Psfb4+dSwOo8A7lMNVDlP0fAKdm9rP7E14+
+b+WWPufrSv9meNOfvR+tSxOIwCPwM0YDm7nK8d5+8TtlbuM8rjfC/
aV+4xyvXyfCJfq+1H+3Jszdbz8/m6YWvlPmPqWBxGge8QBaJXhuF/
FYdVhyu7ZEQAAAAASUVORK5CYII='
$iconBytes = [Convert]::FromBase64String($iconBase64)
$stream = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)
$iconImage = [System.Drawing.Image]::FromStream($stream, $true)
$Form.Icon = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap
-Argument $stream).GetHIcon())
$Global:Panel1 = New-Object system.Windows.Forms.Panel
$Global:Panel1.height = 240
$Global:Panel1.width = 630
$Global:Panel1.location = New-Object System.Drawing.Point(10,25)
$Global:Panel1.BorderStyle = 'none'
$Global:Panel1.add
_paint({$whitePen = new-object
System.Drawing.Pen([system.drawing.color]::gray, 3)
$_.graphics.drawrectangle($whitePen,$this.clientrectangle)
})
$Panel2 = New-Object system.Windows.Forms.Panel
$Panel2.height = 185
$Panel2.width = 630
$Panel2.location = New-Object System.Drawing.Point(10,320)
$Panel2.BorderStyle = 'none'
$Panel2.add
_paint({$whitePen = new-object System.Drawing.Pen([system.drawing.color]::gray,
3)
$_.graphics.drawrectangle($whitePen,$this.clientrectangle)
})
$iconInfoBase64 =
'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/
AP+gvaeTAAAAg0lEQVQ4jWP0q9r6n4FMsKnNm5GFgYGBwdbWmmTNhw8fZWBgYGBgItd2GM-
BrAAcrI/kGcLAyMuQ48xE0BKcBP37/
Z5iy9xPDj9/4wxinAX4GXAw5znx4NeM1YNOFbwQ14zWAWEA7A0o8+FFoXIAFl0TPjo+UuY-
BYQLEBLAwMiIwxIAAA8D8aBR7xJWwAAAAASUVORK5CYII='
$iconInfoBytes = [Convert]::FromBase64String($iconInfoBase64)
$stream = New-Object IO.MemoryStream($iconInfoBytes, 0, $iconInfoBytes.Length)
$stream.Write($iconInfoBytes, 0, $iconInfoBytes.Length)
$iconInfoImage = [System.Drawing.Image]::FromStream($stream, $true)
$iconInfoBox = new-object Windows.Forms.PictureBox
$iconInfoBox.name = "iconInfoBox"
$iconInfoBox.Width = $iconInfoImage.Size.Width
$iconInfoBox.Height = $iconInfoImage.Size.Height
$iconInfoBox.Image = $iconInfoImage
$iconInfoBox.location = New-Object System.Drawing.Point(625,7)
$iconInfoBox.add
_MouseHover($ShowHelp)
$RichTextBox1 = New-Object System.Windows.Forms.RichTextBox
$RichTextBox1.location = New-Object System.Drawing.Point(0,0)
$RichTextBox1.height = 185
$RichTextBox1.width = 630
$RichTextBox1.ScrollBars = "Vertical"
$RichTextBox1.Multiline = $true
$RichTextBox1.ReadOnly = $true
$RichTextBox1.BackColor = "white"
$RichTextBox1.ForeColor = "black"
$TextBox1 = New-Object System.Windows.Forms.TextBox
$TextBox1.name = "TextBox1"
$TextBox1.location = New-Object System.Drawing.Point(55,270)
$TextBox1.AutoCompleteMode = 'SuggestAppend'
$TextBox1.AutoCompleteSource = 'FileSystem'
$TextBox1.Text = '%Windir%, %ProgramFiles%'
$TextBox1.AutoSize = $false
$TextBox1.Height = 18
$TextBox1.width = 475
$TextBox1.add
_MouseHover($ShowHelp)
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Value = 0
$progressBar.Step = 1
$progressBar.Location = new-object System.Drawing.Size(10,560)
$progressBar.size = new-object System.Drawing.Size(600,20)
$progressBarFile = New-Object System.Windows.Forms.ProgressBar
$progressBarFile.Minimum = 0
$progressBarFile.Value = 0
$progressBarFile.Step = 1
$progressBarFile.Location = new-object System.Drawing.Size(10,530)
$progressBarFile.size = new-object System.Drawing.Size(600,10)
$labelProgressBar = New-Object system.Windows.Forms.Label
$labelProgressBar.text = "0%"
$labelProgressBar.AutoSize = $true
$labelProgressBar.width = 25
$labelProgressBar.height = 10
$labelProgressBar.location = New-Object System.Drawing.Point(610,567)
$labelProgressBar.Font = 'Microsoft Sans Serif,8'
$labelProgressBarFile = New-Object system.Windows.Forms.Label
$labelProgressBarFile.text = "0%"
$labelProgressBarFile.AutoSize = $true
$labelProgressBarFile.width = 25
$labelProgressBarFile.height = 10
$labelProgressBarFile.location = New-Object System.Drawing.Point(610,528)
$labelProgressBarFile.Font = 'Microsoft Sans Serif,8'
$labelFolder = New-Object system.Windows.Forms.Label
$labelFolder.text = "Select File(s)/Folder(s):"
$labelFolder.AutoSize = $true
$labelFolder.width = 25
$labelFolder.height = 10
$labelFolder.location = New-Object System.Drawing.Point(8,10)
$labelFolder.Font = 'Microsoft Sans Serif,8'
$labelExclude = New-Object system.Windows.Forms.Label
$labelExclude.name = "labelExclude"
$labelExclude.text = "Exclude:"
$labelExclude.AutoSize = $true
$labelExclude.width = 25
$labelExclude.height = 10
$labelExclude.location = New-Object System.Drawing.Point(8,275)
$labelExclude.Font = 'Microsoft Sans Serif,8'
$labelExclude.add
_MouseHover($ShowHelp)
$labelOutput = New-Object system.Windows.Forms.Label
$labelOutput.text = "Log output:"
$labelOutput.AutoSize = $true
$labelOutput.width = 25
$labelOutput.height = 10
$labelOutput.location = New-Object System.Drawing.Point(8,300)
$labelOutput.Font = 'Microsoft Sans Serif,8'
$labelDestination = New-Object system.Windows.Forms.Label
$labelDestination.text = "..."
$labelDestination.AutoSize = $true
$labelDestination.width = 25
$labelDestination.height = 10
$labelDestination.location = New-Object System.Drawing.Point(220,605)
$labelDestination.Font = 'Microsoft Sans Serif,8'
$labelComputer = New-Object system.Windows.Forms.Label
$labelComputer.text = "..."
$labelComputer.AutoSize = $true
$labelComputer.width = 25
$labelComputer.height = 10
$labelComputer.location = New-Object System.Drawing.Point(70,605)
$labelComputer.Font = 'Microsoft Sans Serif,8'
$labelProgressBarText = New-Object system.Windows.Forms.Label
$labelProgressBarText.text = "Overall Progress:"
$labelProgressBarText.AutoSize = $true
$labelProgressBarText.width = 25
$labelProgressBarText.height = 10
$labelProgressBarText.location = New-Object System.Drawing.Point(8,543)
$labelProgressBarText.Font = 'Microsoft Sans Serif,8'
$labelProgressBarFileText = New-Object system.Windows.Forms.Label
$labelProgressBarFileText.text = "File Progress:"
$labelProgressBarFileText.AutoSize = $true
$labelProgressBarFileText.width = 25
$labelProgressBarFileText.height = 10
$labelProgressBarFileText.location = New-Object System.Drawing.Point(8,513)
$labelProgressBarFileText.Font = 'Microsoft Sans Serif,8'
$labelFileSize = New-Object system.Windows.Forms.Label
$labelFileSize.text = ""
$labelFileSize.AutoSize = $true
$labelFileSize.width = 25
$labelFileSize.height = 10
$labelFileSize.location = New-Object System.Drawing.Point(555,513)
$labelFileSize.Font = 'Microsoft Sans Serif,8'
$labelTotalFileSize = New-Object system.Windows.Forms.Label
$labelTotalFileSize.text = ""
$labelTotalFileSize.AutoSize = $true
$labelTotalFileSize.width = 25
$labelTotalFileSize.height = 10
$labelTotalFileSize.location = New-Object System.Drawing.Point(555,543)
$labelTotalFileSize.Font = 'Microsoft Sans Serif,8'
$labelpartialCopyBytes = New-Object system.Windows.Forms.Label
$labelpartialCopyBytes.text = ""
$labelpartialCopyBytes.AutoSize = $true
$labelpartialCopyBytes.width = 25
$labelpartialCopyBytes.height = 10
$labelpartialCopyBytes.location = New-Object System.Drawing.Point(485,543) #480
$labelpartialCopyBytes.Font = 'Microsoft Sans Serif,8'
$labelOf = New-Object system.Windows.Forms.Label
$labelOf.text = ""
$labelOf.AutoSize = $true
$labelOf.width = 25
$labelOf.height = 10
$labelOf.location = New-Object System.Drawing.Point(540,543)
$labelOf.Font = 'Microsoft Sans Serif,8'
$labelLine = New-Object system.Windows.Forms.Label
$labelLine.AutoSize = $false
$labelLine.width = 630
$labelLine.height = 2
$labelLine.location = New-Object System.Drawing.Point(10,585)
$labelLine.borderStyle = "Fixed3D"
$LabelHiddenCheckBox = New-Object system.Windows.Forms.Label
$LabelHiddenCheckBox.Name = 'LabelHiddenCheckBox'
$LabelHiddenCheckBox.text = "Show hidden files"
$LabelHiddenCheckBox.AutoSize = $true
$LabelHiddenCheckBox.width = 25
$LabelHiddenCheckBox.height = 10
$LabelHiddenCheckBox.location = New-Object System.Drawing.Point(550,275)
$LabelHiddenCheckBox.Font = 'Microsoft Sans Serif,8'
$LabelHiddenCheckBox.add
_MouseHover($ShowHelp)
$HiddenCheckBox = New-Object System.Windows.Forms.CheckBox
$HiddenCheckBox.name = 'HiddenCheckBox'
$HiddenCheckBox.Location = New-Object System.Drawing.Point(535,270)
$HiddenCheckBox.Checked = $false
$HiddenCheckBox.add
_MouseHover($ShowHelp)
$ButtonComputer = New-Object System.Windows.Forms.Button
$ButtonComputer.name = "ButtonComputer"
$ButtonComputer.text = "Computer"
$ButtonComputer.width = 60
$ButtonComputer.height = 30
$ButtonComputer.location = New-Object System.Drawing.Point(8,590)
$ButtonComputer.Font = 'Microsoft Sans Serif,8'
$ButtonComputer.add_MouseHover($ShowHelp)
$ButtonStop = New-Object System.Windows.Forms.Button
$ButtonStop.text = "Stop"
$ButtonStop.width = 60
$ButtonStop.height = 30
$ButtonStop.location = New-Object System.Drawing.Point(580,590)
$ButtonStop.Font = 'Microsoft Sans Serif,8'
$ButtonStop.Enabled = $false
$ButtonDestination = New-Object System.Windows.Forms.Button
$ButtonDestination.name = "ButtonDestination"
$ButtonDestination.text = "Destination"
$ButtonDestination.width = 70
$ButtonDestination.height = 30
$ButtonDestination.location = New-Object System.Drawing.Point(150,590)
$ButtonDestination.Font = 'Microsoft Sans Serif,8'
$ButtonDestination.add
_MouseHover($ShowHelp)
$ButtonCopy = New-Object System.Windows.Forms.Button
$ButtonCopy.text = "Copy"
$ButtonCopy.width = 60
$ButtonCopy.height = 30
$ButtonCopy.location = New-Object System.Drawing.Point(520,590)
$ButtonCopy.Font = 'Microsoft Sans Serif,8'
$imageListSmall = new-Object System.Windows.Forms.ImageList
$computerIconBase64 =
'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/
AP+gvaeTAAAAeUlEQVQ4y2PIqZtyPq2y/
z85OKdh8jkGEOPh609kYZBeuAF+VVtJwlgN6N7+gSg8agAtDaAoGslOSDl1k7+RnZTr-
p3wl2QUPXn/8f+bePTCN4gVCtsEMAGmOm1P2/+y9+7jD4OyNR2CMywUgzXAXgLIkuWGQWz/
lLABe4wCPkQWBQwAAAABJRU5ErkJggg=='
$hddIconBase64 =
'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/
AP+gvaeTAAABuUlEQVQ4jaVTy0pCURQ9k5r0LfUT9QvNapZvGlhBebs+KhsF3Xu9GjgyEzMywYr-
SyATJIgTFykFP7A09DDMr0MHu7APeogdZHVhwHnst9l57H0Lo6uwba9KZHadqkwD1AGORQ2p-
LNSC0Sd7F8ultCeqBMLlQ1nBSqyKgGRT6QrFUFR8PLwsQWEqCedwH3VYXA+4Dy+vsDWNC-
q6mqlhN7FQG9WQ6tZ48gvXcGxhE32CdmwbOQhOBalmFyfgNGJ4JgtLshs38GGGuwOoNvAh-
ZnPndyAzaHHyRfBMKJ3JeQfFEYkv2Qy1+DweI8ZmS12t2g4x2V/
E0RzYFQfEchDNLUeYraeS6+DXreASyWlyvtNlsj6eLElmF5mhk4xDKIfp/
BVARoLPNh2Bl4VPePNxOVSej0zide8BLrwzrttF4PrTsYyzJ4wkmwu2ahBz04OGcC3nDiWcO-
JHUTPy+LKZk5pETo9E0mCRZhSuoB7vKt1ARHd2AUtJ4mEmpFKH1zU1f/3SO+fg8Hm2iLUwIfDq/
tfCyBHy0slgqP5nWk/Abm/
Fig8PMFd8envAkj+l8CnEuj0Zer9xh9BRyD9Cr8I7W0+Xx11AAAAAElFTkSuQmCC'
$folderIconBase64 =
'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/
AP+gvaeTAAAAX0lEQVQ4y2NgoBRMq3L5j45n1Lr2kmTA7Q2pcHx1TfL/
BU2eX2bWuPSRZQAIH1sY839uvedfbK5Dx1i9sKjZ+//5tVn/P59t+f/
1XCtODDcAn6JRA0YNINoASjDFuRkAxodhfkNCKZEAAAAASUVORK5CYII='
$selectedFolderIconBase64 =
'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/
AP+gvaeTAAAA4klEQVQ4y2NgoBRMq3L5j45n1Lr2kmTA7Q2pcHxtTfL/
Rc2en2fWuPSRZQAIH18Y839eo+cfbK5Dx1i9sKTN9//ljXn/v5xt/f/
1HG4MNwCfooE34P2Z1v8rttb+L15c8T9pbhmYXrm17v/
7sy2EDQBprl9e+T9uThkGblhe9X9KjRt+A0A2I2sCAWR+VXcsfgNAzsVnQNr0fPwGgPwM04gO-
QOLxc0r/UeSC+Fml9/
EaAAptfAbEzS2rZ8CXTEGhnD0lG2ssADUfDV1VyEkwr4AUxc0uawBqug3EP8E00GaYZgB-
vq1N78gIeZAAAAABJRU5ErkJggg=='
$fileIconBase64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/
wD/AP+gvaeTAAAAXElEQVQ4y2NggIKK7jn/8eHa/gVXGPABkCJcACTXM3f1/9qJ8y+QbcC37z/
+989b+6+2H4chhAwAgS/fvv/
vmbPqX92EBcdJNgAdk2QANgNHDRg1AKcBpGAGagEAEhhnW3BRVwEAAAAASUVORK5CYII='
$selectedIconBase64 =
'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/
AP+gvaeTAAAA4ElEQVQ4T2NggIKK7jn/8eHa/gXXGP7/Z2TABUCKcAGQXM/c1f/
qJi44T7YB377/+N83d83/uokLL5BlAAiADZm39l/
dhAWnSDYAHZNkADqg2IBl2w8Tb8DP37/+rz2783/Jqs7/SfMqwfTEHav+h64q5CRoAEhz46Yp/
+PmlGHDx1AMwWYAyGZkTSCAYsjssga8BoCci9eAOWW38RoA8jNMIzqAGvCDUhfcwmvAur-
O78Bswt6wexQBk3DBp8f/d567+L13Rh24rTPNRjKjEBkCKQKENCjAg/
gmmgTbDNAMAMsNruPESSGIAAAAASUVORK5CYII='
$computerIconBytes = [Convert]::FromBase64String($computerIconBase64)
$hddIconBytes = [Convert]::FromBase64String($hddIconBase64)
$folderIconBytes = [Convert]::FromBase64String($folderIconBase64)
$selectedFolderIconBytes = [Convert]::FromBase64String($selectedFolderIconBase64)
$fileIconBytes = [Convert]::FromBase64String($fileIconBase64)
$selectedIconBytes = [Convert]::FromBase64String($selectedIconBase64)
$stream = New-Object IO.MemoryStream($computerIconBytes, 0, $computerIconBytes.Length)
$stream.Write($computerIconBytes, 0, $computerIconBytes.Length)
$computerIcon = [System.Drawing.Image]::FromStream($stream, $true)
$imageListSmall.Images.Add("computer",$computerIcon)
$stream = New-Object IO.MemoryStream($hddIconBytes, 0, $hddIconBytes.Length)
$stream.Write($hddIconBytes, 0, $hddIconBytes.Length)
$hddIcon = [System.Drawing.Image]::FromStream($stream, $true)
$imageListSmall.Images.Add("hdd",$hddIcon)
$stream = New-Object IO.MemoryStream($folderIconBytes, 0, $folderIconBytes.Length)
$stream.Write($folderIconBytes, 0, $folderIconBytes.Length)
$folderIcon = [System.Drawing.Image]::FromStream($stream, $true)
$imageListSmall.Images.Add("folder",$folderIcon)
$stream = New-Object IO.MemoryStream($selectedFolderIconBytes, 0,
$selectedFolderIconBytes.Length)
$stream.Write($selectedFolderIconBytes, 0, $selectedFolderIconBytes.Length)
$openedFolderIcon = [System.Drawing.Image]::FromStream($stream, $true)
$imageListSmall.Images.Add("selectedFolder",$openedFolderIcon)
$stream = New-Object IO.MemoryStream($fileIconBytes, 0, $fileIconBytes.Length)
$stream.Write($fileIconBytes, 0, $fileIconBytes.Length)
$fileIcon = [System.Drawing.Image]::FromStream($stream, $true)
$imageListSmall.Images.Add("file",$fileIcon)
$stream = New-Object IO.MemoryStream($selectedIconBytes, 0, $selectedIconBytes.Length)
$stream.Write($selectedIconBytes, 0, $selectedIconBytes.Length)
$selectedFileIcon = [System.Drawing.Image]::FromStream($stream, $true)
$imageListSmall.Images.Add("selectedFile",$selectedFileIcon)
$Global:tree = New-Object System.Windows.Forms.TreeView
$Global:tree.Dock = 'Fill'
$Global:tree.CheckBoxes = $true
$Global:tree.ImageList = $imageListSmall
$Global:treesub = New-Object System.Windows.Forms.TreeNode
$Global:performance_
1 = ''
$Global:performance_
2 = ''
$Global:computerName = '...'
$Global:folderPath = ''
$global:currentRunspace = ''
$Global:powershell = ''
$Global:asyncObject = ''
$global:flagJobCompleted= $false
$Global:jobCancelled = $false
$nl = "`r`n"
$Hash = [hashtable]::Synchronized(@{})
$ArrayObjectsToCopy = [System.Collections.ArrayList]::Synchronized((New-Object
System.Collections.ArrayList))
$ArrayRenameObjects = [System.Collections.ArrayList]::Synchronized((New-Object
System.Collections.ArrayList))
Function mountRemoteTree ($exception, $query){
$Global:performance_1 = Measure-Command -Expression {
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
$Runspace.SessionStateProxy.SetVariable("Hash", $Hash)
$Global:powershell = [PowerShell]::Create().AddScript({
Param ($exception, $query)
$Hash.SplittedArray = Invoke-Command $Hash.session -ArgumentList $exception, $query
-ScriptBlock {
param($exception, $query)
function AddNodes ($FSObject, $query){
$object = @{
name = $FSObject.name
Fullname = $FSObject.fullname
psparentpath = $FSObject.psparentpath
length = $FSObject.length
mode = $FSObject.mode
}
[void]$Array.add($object)
if ($FSObject -is [System.IO.DirectoryInfo]) {
$FSObjSub = Invoke-Expression $query | `
ForEach-Object{
if($_.mode -notmatch 'hs'){
if ($exception -ne $null){
Invoke-Expression $exception
}else{
$_
}
}
}
foreach($child in $FSObjSub){
if ([string]::IsNullOrEmpty($child)){
}else{
AddNodes $child $query
}
}
}
}
Function SplitArray ($Array) {
[int]$size = $Array.count-1
[int]$divider = 4
[int]$result = ($size / $divider) - 1
[int]$diff = 0
[int]$index = 0
[int]$part = $result
if ((($result * $divider) -lt $size) -or (($result * $divider) -gt $size)) {
$diff = $size - ($result * $divider)
$resultFinal = ($result * $divider) + $diff
}
for($i=0; $i -lt $divider; $i++){
if($i -eq ($divider-1)){
New-Variable -Name "splitArray$i" -Value $Array[$index..$size]
}elseif($part -lt $size){
New-Variable -Name "splitArray$i" -Value $Array[$index..$part]
$index = $part+1
$part = $index+$result
}
Write-Output(,((Get-Variable -name "splitArray$i").Value))
Remove-Variable "splitArray$i"
}
}
$objDriveLetters = GET-WMIOBJECT –query "SELECT * from win32_logicaldisk where
Drivetype=3"
$Array = [System.Collections.ArrayList]@()
foreach ($iDrive in $objDriveLetters){
if ( Test-Path $iDrive.DeviceID ) {
$DriveRootPath = Join-Path -ChildPath \ -Path $iDrive.DeviceID
$DriveRoot = Get-Item -Path $DriveRootPath
AddNodes $DriveRoot $query
}
}
SplitArray $Array
}
}).AddArgument($exception).AddArgument($query)
$Global:powershell.Runspace = $Runspace
$Global:AsyncObject = $Global:powershell.BeginInvoke()
$global:currentRunspace = $Runspace.id
do{
[System.Windows.Forms.Application]::DoEvents()
$global:flagJobCompleted = $true
}while(!$AsyncObject.IsCompleted)
if($AsyncObject.IsCompleted){
$global:flagJobCompleted = $false
}
if($global:flagJobCompleted -ne $true -and $Global:jobCancelled -ne $true){
$Global:powershell.EndStop($Global:powershell.BeginStop($null, $Global:asyncObject))
$thread = Get-Runspace -id $global:currentRunspace
$thread.Close()
$thread.Dispose()
}
}
}
Function mountLocalTree{
$Global:performance_2 = Measure-Command -Expression {
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
$SyncHash = [hashtable]::Synchronized(@{tree = $Global:tree; treesub = $Global:treesub})
$Runspace.SessionStateProxy.SetVariable("SyncHash", $SyncHash)
$Runspace.SessionStateProxy.SetVariable("Hash", $Hash)
$Global:powershell = [PowerShell]::Create().AddScript({
Param ($computerName)
for($i=0; $i -lt 4; $i++){
New-Variable -Name "ArrayFSObject$i" -Value $Hash.splittedArray[$i]
$Hash.performance_3 = Measure-Command -Expression {
ForEach($FSOBject in Get-Variable -name "ArrayFSObject$i" | % Value){
if ($FSOBject.PSParentPath -eq ''){
if($syncHash.tree.nodes.Count -eq 0 ){
[void]$syncHash.Tree.Nodes.Add($syncHash.treesub.nodes.Add($computerName,
$computerName))
$syncHash.treesub.nodes[$computerName].ImageIndex = 0
$syncHash.treesub.nodes[$computerName].SelectedImageIndex = 0
}
if($syncHash.tree.nodes.Count -eq 1 ){
[void]
$syncHash.treesub.Nodes[$computername].nodes.Add($syncHash.treesub.nodes.Add($FSOb-
ject.fullName, $FSObject.Name))
$syncHash.treesub.nodes[$FSObject.fullname].ImageIndex = 1
$syncHash.treesub.nodes[$FSObject.fullname].SelectedImageIndex = 1
}
}else{
if($FSOBject.mode -notmatch 'd'){
if($FSObject.PSParentPath -ne "Microsoft.PowerShell.Core\FileSystem::$($name)"){
$name = $FSOBject.PSParentPath
$name = $name.Substring($name.IndexOf('::')+2)
}
$child = New-Object System.Windows.Forms.TreeNode
$child.Name = $FSOBject.fullName
$child.Text = $FSOBject.name
$child.tag = $FSOBject.mode
$child.ToolTipText = $FSOBject.length
$child.ImageIndex = 4
$child.SelectedImageIndex = 4
[void]$syncHash.treesub.Nodes[$name].Nodes.Add($child)
}else{
if($FSObject.PSParentPath -ne "Microsoft.PowerShell.Core\FileSystem::$($name)"){
$name = $FSOBject.PSParentPath
$name = $name.Substring($name.IndexOf('::')+2)
}
[void]
$syncHash.treesub.Nodes[$name].Nodes.Add($syncHash.treesub.nodes.Add($FSObject.Full-
Name, $FSObject.Name))
$syncHash.treesub.nodes[$FSObject.fullname].Tag = $FSOBject.mode
$syncHash.treesub.nodes[$FSObject.fullname].ToolTipText = $FSOBject.length
$syncHash.treesub.nodes[$FSObject.fullname].ImageIndex = 2
$syncHash.treesub.nodes[$FSObject.fullname].SelectedImageIndex = 2
}
}
}
}
Remove-Variable ArrayFSObject$i
}
}).AddArgument($computerName)
$Global:powershell.Runspace = $Runspace
$Global:AsyncObject = $Global:powershell.BeginInvoke()
$global:currentRunspace = $Runspace.id
do{
[System.Windows.Forms.Application]::DoEvents()
$global:flagJobCompleted = $true
}while(!$AsyncObject.IsCompleted)
if($AsyncObject.IsCompleted){
$global:flagJobCompleted = $false
}
if($global:flagJobCompleted -ne $true -and $Global:jobCancelled -ne $true){
$Global:powershell.EndStop($Global:powershell.BeginStop($null, $Global:asyncObject))
$thread = Get-Runspace -id $global:currentRunspace
$thread.Close()
$thread.Dispose()
}
}
}
Function copyObjects {
$labelpartialCopyBytes.Text = ''
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
$SyncHash = [hashtable]::Synchronized(@{TextBox = $RichTextBox1; ProgressBar =
$progressBar; LabelProgressBar = $labelProgressBar; ProgressBarFile = $progressBarFile;
LabelProgressBarFile = $labelProgressBarFile; labelFileSize = $labelFileSize; labelTotalFileSize =
$labelTotalFileSize; labelpartialCopyBytes=$labelpartialCopyBytes; labelOf=$labelOf })
$Runspace.SessionStateProxy.SetVariable("SyncHash", $SyncHash)
$Runspace.SessionStateProxy.SetVariable("Hash", $Hash)
$Runspace.SessionStateProxy.SetVariable("ArrayObjectsToCopy", $ArrayObjectsToCopy)
$Runspace.SessionStateProxy.SetVariable("ArrayRenameObjects", $ArrayRenameObjects)
$Global:powershell = [PowerShell]::Create().AddScript({
$SyncHash.progressBar.Maximum = 0
$counter = 0
[int]$global:tempBytes = 0
$countMax = $ArrayObjectsToCopy.count + $ArrayRenameObjects.count
$SyncHash.progressBar.Maximum = $countMax
$percentage = [math]::floor(($counter/$countMax) * 100)
function copyRemote ($session, $source, $destination, $mode, $length, $SyncHash) {
$SyncHash.progressBarFile.Maximum = 0
if([int64]$length -le 4096){
$totalChunks = [int64]1
}else{
$totalChunks = [int64]($length / 4096)
}
$SyncHash.progressBarFile.Maximum = $totalChunks
[int]$counter = 0
$percentage = 0
$percentage = [math]::floor(($counter/$totalChunks) * 100)
$SyncHash.labelFileSize.Text = Format-Bytes $length
$errorFlag = $false
$error.Clear()
if($mode -notmatch 'd'){
if((Test-Path $destination -PathType Leaf) -eq $false){
try{
$writer = [System.IO.File]::OpenWrite($destination)
$SyncHash.TextBox.AppendText("Copying file from $($source) to $($destination)... ")
}catch{
$syncHash.TextBox.SelectionColor ="Red"
$SyncHash.TextBox.AppendText("Failed to open write the file, " + $destination +"
error: " + $error.exception.message + "`r`n")
}
if($error.count -eq 0){
if($hash.session.state -eq 'Opened'){
Invoke-Command -Session $Hash.session -ArgumentList $source -ScriptBlock{
param($source)
$error.clear()
function split ($path) {
$chunkSize=4096
$error.Clear()
try{
}catch{
return $error
$reader = [System.IO.File]::OpenRead($path)
}
if($error.count -eq 0){
$file = New-Object System.IO.FileInfo($path)
$totalChunks = [int64]($file.Length / $chunkSize) + 1
$count = 0
$buffer = New-Object Byte[] $chunkSize
$output = New-Object Byte[] $chunkSize
$hasMore = $true
while($hasMore){
$bytesRead = $reader.Read($buffer, 0, $buffer.Length)
$output = $buffer
if ($bytesRead -ne $buffer.Length){
$hasMore = $false
$output = New-Object Byte[] $bytesRead
[System.Array]::Copy($buffer, $output, $bytesRead)
}
++$count
Write-Output(,$output)
}
$reader.Close()
}
}
split $source
} | % {`
if($_.count -ge 0){
ForEach-Object {
$writer.write($_, 0, $_.length)
$counter++
$SyncHash.progressBarFile.PerformStep()
$percentage = [math]::floor(($counter/$totalChunks) * 100)
$SyncHash.LabelProgressBarFile.text = "$($percentage)%"
}
}else{
$errorFlag = $true
$syncHash.TextBox.SelectionColor ="Red"
$SyncHash.TextBox.AppendText("`r`nFailed to copy, $($destination), $
($_.exception.message)" + "`r`n")
$writer.close()
$writer.dispose()
Remove-Item $destination
}
}
}else{
$syncHash.TextBox.SelectionColor ="Red"
$SyncHash.TextBox.AppendText("A failure occurred on the active session, $
($hash.session.state), $($_.exception.message)" + "`r`n")
}
}
if($errorFlag -ne $true ){
$writer.Close()
$writer.dispose()
[int64]$global:tempBytes += [int64]$length
$SyncHash.labelpartialCopyBytes.Text = Format-Bytes $tempBytes
$SyncHash.labelOf.text = 'of'
$SyncHash.TextBox.AppendText("done!" + "`r`n")
}
}else{
$syncHash.TextBox.SelectionColor ="Red"
$SyncHash.TextBox.AppendText("File $($destination) already exists at destination."+
"`r`n")
}
}else{
if((Test-Path $destination -PathType Container) -eq $false){
$SyncHash.TextBox.AppendText("Creating folder $($destination) at destination... ")
New-Item -Path $destination -ItemType "directory"
$SyncHash.TextBox.AppendText("done!" + "`r`n")
$counter++
$SyncHash.progressBarFile.PerformStep()
$percentage = [math]::floor(($counter/$totalChunks) * 100)
$SyncHash.LabelProgressBarFile.text = "$($percentage)%"
}else{
$syncHash.TextBox.SelectionColor ="Red"
$SyncHash.TextBox.AppendText("Folder $($destination) already exists at destination."
+ "`r`n")
$counter++
$SyncHash.progressBarFile.PerformStep()
$percentage = [math]::floor(($counter/$totalChunks) * 100)
$SyncHash.LabelProgressBarFile.text = "$($percentage)%"
}
}
}
Function Format-Bytes {
Param([Parameter(ValueFromPipeline = $true)]
[ValidateNotNullOrEmpty()][float]$number)
Begin{
$sizes = 'KB','MB','GB','TB','PB'
}
Process {
for($x = 0;$x -lt $sizes.count; $x++){
if ($number -lt "1$($sizes[$x])"){
if ($x -eq 0){
return "$number Bytes"
}else{
$num = $number / "1$($sizes[$x-1])"
$num = "{0:N1}" -f $num
return "$num $($sizes[$x-1])"
}
}
}
}
End{}
}
ForEach($object in $ArrayRenameObjects){
Invoke-Command $Hash.session -ScriptBlock {
Rename-Item $args[0] $args[1] -Force -verbose *>&1
} -ArgumentList $object[0], $object[1] *>&1 | `
ForEach-Object {
if($_.exception){
$syncHash.TextBox.SelectionColor ="Red"
$SyncHash.TextBox.AppendText("Error trying to rename the object, " +
$_.exception.message + "`r`n")
}else{
$syncHash.TextBox.SelectionColor ="Blue"
$SyncHash.TextBox.AppendText("An object equal or greater than 247 characters was
found, renaming it." + "`r`n")
$syncHash.TextBox.SelectionColor ="Black"
$SyncHash.TextBox.AppendText("$($_)" + "`r`n")
}
}
$percentage = [math]::floor(($counter/$countMax) * 100)
$SyncHash.LabelProgressBar.text = "$($percentage)%"
$SyncHash.progressBar.PerformStep()
}
ForEach($object in $ArrayObjectsToCopy){
$destination = $object[0]
$source = $object[1]
$length = $object[2]
$mode = $object[3]
copyRemote $session $source $destination $mode $length $SyncHash
$counter++
$percentage = [math]::floor(($counter/$countMax) * 100)
$SyncHash.LabelProgressBar.text = "$($percentage)%"
$SyncHash.progressBar.PerformStep()
}
})
$Global:powershell.Runspace = $Runspace
$Global:AsyncObject = $Global:powershell.BeginInvoke()
$global:currentRunspace = $Runspace.id
do{
[System.Windows.Forms.Application]::DoEvents()
$global:flagJobCompleted = $true
}while(!$AsyncObject.IsCompleted)
if($AsyncObject.IsCompleted){
$global:flagJobCompleted = $false
}
if($global:flagJobCompleted -ne $true -and $Global:jobCancelled -ne $true){
$Global:powershell.EndStop($Global:powershell.BeginStop($null, $Global:asyncObject))
$thread = Get-Runspace -id $global:currentRunspace
$thread.Close()
$thread.Dispose()
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
$RichTextBox1.SelectionColor = 'Green'
$RichTextBox1.AppendText("Copy job has been completed!" + $nl)
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
}
}
Function createSession{
if ($Hash.session = New-PSSession -ComputerName $Global:computerName -ErrorAction
SilentlyContinue){
$RichTextBox1.AppendText("The remote session $($Hash.session) to $
($Global:computerName) was successfuly created." + $nl)
$RichTextBox1.ScrollToCaret()
}else{
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("Wasn't possible to create a session." + $nl)
$RichTextBox1.ScrollToCaret()
}
}
Function removeSession{
if (Remove-PSSession -session $Hash.session -ErrorAction SilentlyContinue){
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("Wasn't possible to remove active session." + $nl)
$RichTextBox1.ScrollToCaret()
}else{
$RichTextBox1.AppendText("The remote session $($Hash.session) to $
($Global:computerName) was successfuly removed." + $nl)
$RichTextBox1.ScrollToCaret()
}
}
Function clearVariables{
$Hash.Clear()
$Global:tree = New-Object System.Windows.Forms.TreeView
$Global:tree.Dock = 'Fill'
$Global:tree.CheckBoxes = $true
$Global:tree.ImageList = $imageListSmall
$Global:treesub = New-Object System.Windows.Forms.TreeNode
$Global:Panel1.Controls.Clear()
$ArrayObjectsToCopy.Clear()
$ArrayRenameObjects.Clear()
$global:flagJobCompleted= $false
$ButtonStop.Enabled = $false
$labelProgressBar.text = "0%"
$labelProgressBarFile.text = "0%"
$labelFileSize.text = ""
$labelTotalFileSize.text = ""
$labelpartialCopyBytes.text = ""
$labelOf.text = ""
$progressBar.Maximum = 0
$progressBarFile.Maximum = 0
}
Function addEventViewer($localComputer, $user, $domain, $date){
Invoke-Command $hash.session -ArgumentList $localComputer, $user, $domain, $date
-ScriptBlock {
param($localComputer, $user, $domain, $date)
if([System.Diagnostics.EventLog]::SourceExists('Copy Files Remotely') -eq $false){
New-EventLog -Source "Copy Files Remotely" -LogName Application
Write-EventLog –LogName Application –Source "Copy Files Remotely" –EntryType
Information –EventID 1 -Message "The software Copy Files Remotely - Beta was used on this
computer by $($user)@$($domain), logged remotely on $($localComputer) at $($date)."
}else{
Write-EventLog –LogName Application –Source "Copy Files Remotely" –EntryType
Information –EventID 1 -Message "The software Copy Files Remotely - Beta was used on this
computer by $($user)@$($domain), logged remotely on $($localComputer) at $($date)."
}
}
}
Function enableDisableButtons($flag){
if($flag -eq $true){
$ButtonComputer.Enabled = $true
$ButtonDestination.Enabled = $true
$ButtonCopy.Enabled = $true
$HiddenCheckBox.Enabled = $true
$TextBox1.Enabled = $true
$Global:tree.Enabled = $true
$ButtonStop.Enabled = $false
}else{
$ButtonComputer.Enabled = $false
$ButtonDestination.Enabled = $false
$ButtonCopy.Enabled = $false
$HiddenCheckBox.Enabled = $false
$TextBox1.Enabled = $false
$Global:tree.Enabled = $false
$ButtonStop.Enabled = $true
}
}
$TV
_AfterCheck ={
if($_.Action -ne 'Unknown'){
if ($labelDestination.Text -eq '...'){
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Select destination!",0,"Alert")
$_
.Node.checked = $false
}else{
$ButtonDestination.Enabled = $false
if($_.node.text -eq $computerName -or $_.node.text -match ':'){
$_
.node.checked = $false
}else{
$labelpartialCopyBytes.text = ""
$labelof.text = ""
enableDisableButtons $false
$Runspace = [runspacefactory]::CreateRunspace()
$Runspace.ThreadOptions = "ReuseThread"
$Runspace.Open()
$SyncHash = [hashtable]::Synchronized(@{ Tree = $global:tree; labelTotalFileSize =
$labelTotalFileSize})
$Runspace.SessionStateProxy.SetVariable("SyncHash", $SyncHash)
$Runspace.SessionStateProxy.SetVariable("Hash", $Hash)
$Runspace.SessionStateProxy.SetVariable("ArrayObjectsToCopy", $ArrayObjectsToCopy)
$Runspace.SessionStateProxy.SetVariable("ArrayRenameObjects",
$ArrayRenameObjects)
$Global:powershell = [PowerShell]::Create().AddScript({
Param ($treenode, $flagNode, $folderPath)
Function Format-Bytes {
Param([Parameter(ValueFromPipeline = $true)]
[ValidateNotNullOrEmpty()][float]$number)
Begin{
$sizes = 'KB','MB','GB','TB','PB'
}
Process {
for($x = 0;$x -lt $sizes.count; $x++){
if ($number -lt "1$($sizes[$x])"){
if ($x -eq 0){
return "$number Bytes"
}else{
$num = $number / "1$($sizes[$x-1])"
$num = "{0:N1}" -f $num
return "$num $($sizes[$x-1])"
}
}
}
}
End{}
}
Function checkAllChildNodes($treenode, $bool, $destination){
function renameNode($treenode){
$lastItem = '\' + $treenode.text
if($treenode.tag -notmatch 'd'){
$randomNum = Get-Random -Maximum 9999
$extension = [System.IO.Path]::GetExtension($treenode.name)
$lastItem = $lastItem.substring(0,7) + $randomNum + "
Renamed" + $extension
_
}else{
$randomNum = Get-Random -Maximum 9999
$lastItem = $lastItem.substring(0,7) + $randomNum + "
_
Renamed"
}
$sourcePath = $treenode.parent.name + $lastItem
if($sourcePath -match '\\\\'){
$sourcePath = $sourcePath -replace '\\\\', '\'
}
$ArrayRenameObjects.add(@($treenode.name, $sourcePath))
$treenode.name = $sourcePath
$lastItem = $lastItem.replace('\','')
$treenode.text = $lastItem
}
function addNode($treenode, $destination){
addChangeImage $treenode
$sourcePath = $treenode.parent.name + '\' + $treenode.text
$length = $treenode.toolTipText
$mode = $treenode.tag
$arrayParent = [System.Collections.ArrayList]@()
function getParent($treenode){
if($treenode.parent.checked -eq $true){
getParent $treenode.parent
}
$arrayParent.add($treenode.text)
}
if($global:tempPath -eq $null){
getParent $treenode
foreach($line in $arrayParent){
$global:tempPath += '\' + $line
}
}else{
$destination += $global:tempPath
$Global:parent = $treenode.name
if($treenode.parent.name -eq $Global:parent){
$destination += $global:tempPath +'\'+ $treenode.text
}else{
$global:tempPath = $null
getParent $treenode
foreach($line in $arrayParent){
$global:tempPath += '\' + $line
}
$Global:parent = $treenode.name
$destination += $global:tempPath
}
}
if($sourcePath -match '\\\\'){
$sourcePath = $sourcePath -replace '\\\\', '\'
}
$ArrayObjectsToCopy.add(@($destination,$sourcePath,$length,$mode))
[int64]$Hash.totalLengthBytes += [int64]$length
}
function deleteNode($treenode){
removeChangeImage $treenode
$lastItem = $treenode.text
$sourcePath = $treenode.parent.name + '\' + $treenode.text
if($sourcePath -match '\\\\'){
$sourcePath = $sourcePath -replace '\\\\', '\'
}
ForEach($line in $ArrayObjectsToCopy ) {
if($sourcePath -eq $line[1]){
$length = $line[2]
$delete = $line
break
}
}
if($delete -ne $null){
$ArrayObjectsToCopy.Remove($delete)
[int64]$Hash.totalLengthBytes -= [int64]$length
}
ForEach ($line in $ArrayRenameObjects ) {
if($sourcePath -eq $line[1]){
$delete = $line
break
}
}
if($delete -ne $null){
$ArrayRenameObjects.Remove($delete)
}
}
function addChangeImage($treenode){
if($treenode.tag -notmatch 'd'){
$treenode.ImageIndex = 5
$treenode.SelectedImageIndex = 5
}else{
$treenode.ImageIndex = 3
$treenode.SelectedImageIndex = 3
}
}
function removeChangeImage($treenode){
if($treenode.tag -notmatch 'd'){
$treenode.ImageIndex = 4
$treenode.SelectedImageIndex = 4
}else{
$treenode.ImageIndex = 2
$treenode.SelectedImageIndex = 2
}
}
$path = $treenode.parent.name + '\' + $treenode.text
$length = $path.length
if($treenode.checked -ne $bool){
if($treenode.checked -eq $false -and $treenode.parent.checked -eq $true){
#write-host "Add Child Node Recursively"
$treenode.checked = $bool
if($length -gt 247){
renameNode $treenode
addNode $treenode $destination
}else{
addNode $treenode $destination
}
}elseif($treenode.checked -eq $true -and $treenode.parent.checked -eq $false){
#write-host "Delete Child Node Recursively"
$treenode.checked = $bool
deleteNode $treenode
}
}else{
if($treenode.checked -eq $true -and $treenode.parent.checked -eq $true){
#write-host "Add Child Node deleting old adding new node"
deleteNode($treenode)
if($length -gt 247){
renameNode $treenode
addNode $treenode $destination
}else{
addNode $treenode $destination
}
}elseif($treenode.checked -eq $true){
#write-host "Add Parent Node"
$global:tempPath = $null
$Global:lastCheckedNode = $null
function getParent($treenode){
if($treenode.parent.checked -eq $false -or $treenode.parent.checked -eq $true)
{
if($treenode.checked -eq $true){
$Global:lastCheckedNode = $treenode
}
getParent $treenode.parent
}
}
getParent $treenode.parent
if($Global:lastCheckedNode -ne $null){
$treenode = $Global:lastCheckedNode
deleteNode($treenode)
$Global:lastCheckedNode = $null
}
if ($length -gt 247){
renameNode $treenode
addNode $treenode $destination
}else{
addNode $treenode $destination
}
}elseif ($treenode.checked -eq $false){
#write-host "Delete Parent Node"
deleteNode $treenode
}
}
$Synchash.labelTotalFileSize.Text = Format-Bytes $Hash.totalLengthBytes
Foreach($node in $treenode.nodes){
checkAllChildNodes $node $bool $destination
}
}
checkAllChildNodes $treenode $flagNode $folderPath
}).AddArgument($_.node).AddArgument($_.node.checked).AddArgument($Global:folder-
Path)
$Global:powershell.Runspace = $Runspace
$Global:AsyncObject = $Global:powershell.BeginInvoke()
$global:currentRunspace = $Runspace.id
do{
[System.Windows.Forms.Application]::DoEvents()
$global:flagJobCompleted = $true
}while(!$AsyncObject.IsCompleted)
if($AsyncObject.IsCompleted){
$global:flagJobCompleted = $false
}
if($global:flagJobCompleted -ne $true -and $Global:jobCancelled -ne $true){
$Global:powershell.EndStop($Global:powershell.BeginStop($null,
$Global:asyncObject))
$thread = Get-Runspace -id $global:currentRunspace
$thread.Close()
$thread.Dispose()
}
enableDisableButtons $true
}
}
}
}
$ButtonCopy_Click = {
if ($labelDestination.Text -eq '...'){
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Select destination!",0,"Alert")
}elseif ($labelComputer.Text -eq '...'){
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Type a computer name!",0,"Alert")
}elseif ($ArrayObjectsToCopy.count -gt 0){
enableDisableButtons $false
$startCopy = (get-date).ToString('T')
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
$RichTextBox1.SelectionColor = 'Green'
$RichTextBox1.AppendText("Copy started at " + $startCopy + $nl)
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
createSession
if($hash.session.State -eq 'Opened'){
$RichTextBox1.AppendText("Creating a log on Event Viewer. $($nl)")
$date = (get-date -Format 'dd/MM/yyyy HH:mm:ss')
addEventViewer $env:COMPUTERNAME $env:USERNAME
($env:USERDNSDOMAIN).ToLower() $date
copyObjects
}else{
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("The session state wasn't opened, please wait. $($nl)")
}
removeSession
enableDisableButtons $true
$endCopy = (get-date).ToString('T')
$timeCopy = NEW-TIMESPAN –Start $startCopy –End $endCopy
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
$RichTextBox1.SelectionColor = 'Green'
$RichTextBox1.AppendText("Copy ended at " + $endCopy + ", it took " + $timeCopy + " to
finish." + $nl)
}else{
$RichTextBox1.ScrollToCaret()
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Nothing was selected!",0,"Alert")
}
}
$ButtonComputer_Click = {
clearVariables
$Global:computerName = [Microsoft.VisualBasic.Interaction]::InputBox("Type the computer's
name.","Alert")
$labelComputer.Text = $Global:computerName
if ([string]::IsNullOrWhitespace($Global:computerName)){
$labelComputer.Text = '...'
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Computer name can't be empty!",0,"Alert")
}else{
if (Test-Connection $Global:computerName -count 1 -Quiet){
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
$start = (get-date).ToString('T')
$RichTextBox1.SelectionColor = 'Green'
$RichTextBox1.AppendText("Script started at " + $start + $nl)
$RichTextBox1.AppendText("--------------------------------------------------------------------
" + $nl)
$RichTextBox1.ScrollToCaret()
$RichTextBox1.AppendText("It was possible to ping $($Global:computerName)
successfuly." + $nl)
if(Test-WSMan -ComputerName $Global:computerName -ErrorAction SilentlyContinue){
$RichTextBox1.AppendText("It was possible to connect remotely to $
($Global:computerName)." + $nl)
createSession
if($hash.session.State -eq 'Opened'){
$RichTextBox1.AppendText("Creating remote tree in $($Global:computerName), please
wait... $($nl)")
$include = @()
($TextBox1.Text).split(",") | % {
if ([string]::IsNullOrWhitespace($_)){
}else{
$_ = [System.Environment]::ExpandEnvironmentVariables($_.Trim())
$_
= $_.Replace('\','\\')
$include += @($_)
}
}
$varnametocompare = '$_
.fullname'
if($HiddenCheckBox.Checked -eq $true){
$query = '$FSObject | Get-ChildItem -force -ErrorAction SilentlyContinue'
}else{
$query = '$FSObject | Get-ChildItem -ErrorAction SilentlyContinue'
}
if([string]::IsNullOrWhitespace($include)){
$filter = $null
}else{
$count = 0
$filter = $null
foreach ($i in $include) {
if($count -eq 0) {
$filter = $([string]::Format('if({0} -match "{1}"', $varnametocompare, $i))
$count++
}else{
$filter = $([string]::Format('{0} -or {1} -match "{2}"', $filter, $varnametocompare,
$i))
}
}
$filter = $([string]::Format('{0}) {{ }}else{{ $_ }}', $filter, $varnametocompare))
}
enableDisableButtons $false
mountRemoteTree $filter $query
enableDisableButtons $true
$RichTextBox1.AppendText("Remote tree was created in $($performance_1.minutes):$
($performance_1.seconds):$($performance_1.milliseconds). $($nl)")
$RichTextBox1.AppendText("Mounting remote tree locally, please wait... $($nl)")
if($hash.SplittedArray.count -gt 0 ){
enableDisableButtons $false
mountLocalTree $Global:computerName
enableDisableButtons $true
$RichTextBox1.AppendText("Remote tree objects were recovered in $
($performance_2.minutes):$($performance_2.seconds):$($performance_2.milliseconds). $
($nl)")
$RichTextBox1.AppendText("Remote tree mounted locally in $
($hash.performance_3.minutes):$($hash.performance_3.Seconds):$
($hash.performance_3.milliSeconds). $($nl)")
}else{
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("Was not possible to assemble the remote tree locally. $
($nl)")
}
}else{
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("The session state wasn't opened, please wait. $($nl)")
}
removeSession
$end = (get-date).ToString('T')
$total = New-TimeSpan -start $start -End $end
$RichTextBox1.AppendText("Time required to create the tree " + $total + "." + $nl)
$RichTextBox1.AppendText("Finished tree at " + $end + "." + $nl)
[void]$Global:Panel1.Controls.AddRange(@($Global:tree))
$Global:tree.Add
_AfterCheck($TV
_AfterCheck)
$RichTextBox1.ScrollToCaret()
}else{
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("The service WinRM is not active." + $nl)
$RichTextBox1.ScrollToCaret()
}
}else{
$labelComputer.Text = '...'
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("Was not possible to establish a connection to the remote host,
check the computer's name, $($Global:computerName)." + $nl)
$RichTextBox1.ScrollToCaret()
}
}
}
$ButtonStop_Click = {
$this.enabled = $false
if($global:flagJobCompleted -eq $true){
$Global:jobCancelled = $true
$RichTextBox1.SelectionColor = 'Red'
$RichTextBox1.AppendText("A job has been interrupted!" + $nl)
$RichTextBox1.ScrollToCaret()
$Global:powershell.EndStop($Global:powershell.BeginStop($null, $Global:asyncObject))
$thread = Get-Runspace -id $global:currentRunspace
$thread.Close()
$thread.Dispose()
}
}
$ButtonDestination
_Click = {
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property
@{RootFolder = 'Desktop'}
$null = $FolderBrowser.ShowDialog()
$Global:folderPath=$FolderBrowser.SelectedPath
if ([string]::IsNullOrWhitespace($Global:folderPath)){
$labelDestination.Text = '...'
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Destination name cannot be empty!",0,"Alert")
}else{
$labelDestination.Text = $Global:folderPath
}
}
$RichTextBox1.AppendText("Click on computer button. $($nl)")
$ButtonComputer.add_Click($ButtonComputer_Click)
$ButtonStop.add_Click($ButtonStop_Click)
$ButtonDestination.add
_Click($ButtonDestination
_Click)
$ButtonCopy.add_Click($ButtonCopy_Click)
[void]$form.Controls.AddRange(@($Global:Panel1, $Panel2, $iconInfoBox, $ButtonCopy,
$ButtonDestination, $ButtonComputer, $ButtonStop, $labelFolder, $TextBox1, $labelExclude ,
$labelOutput, $labelDestination, $labelComputer, $labelProgressBar, $LabelHiddenCheckBox,
$progressBar, $labelProgressBarFile, $progressBarFile, $labelLine, $labelProgressBarText,
$labelProgressBarFileText, $labelFileSize, $labelTotalFileSize, $labelpartialCopyBytes, $labelOf,
$HiddenCheckBox))
[void]$Panel2.Controls.AddRange(@($RichTextBox1))
[void]$form.ShowDialog()
