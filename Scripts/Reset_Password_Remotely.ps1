<#
 Developed in 2019 by Angelo Polatto using Powershell 3.0 supporting previous versions of Powershell.
 In summary this software performs the password reset a an user local account remotely.
 
 As at the time this code was meant to be used in a joined domain computer, while executing this code 
 make sure that the current user has granted access permission on the remote computer.

 Note: as my intention is also demonstrate my evolution over time I decided to keep the code as it was,
 if any request or improved version is necessary, please let know.

 The line #216 has to be changed in order to filter the computers that will populate the array, for the drop down menu.
 Reference: "[void]$arrayComputers.add((Get-ADComputer -Filter 'Name -like "СHANGE_COMPUTER_NAME_FILTER*"' | foreach{($_.name).toUpper()}))"
#>

#Begin
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$ProgressPreference = 'SilentlyContinue'
Import-Module ActiveDirectory -DisableNameChecking

$ShowHelp = {

   Switch ($this.name) {

    "iconInfoBox" {$tip = "Reset Password Remotely`nCreated by Angelo Polatto - 2019`nThis software was developed using Powershell ISE V5,`ncapable of reset local user passwords remotely,`nas long it runs Powershell V2 or more recent versions."}

    "Password" {$tip = "Default password 123."}

    "ButtonStop" {$tip = "Stop current job."}

    "Loop" {$tip = "If unchecked it will not try multiple reset attempts."}

   }

 $tooltip.SetToolTip($this,$tip)

}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '500,280'
$Form.text                       = "Form"
$Form.TopMost                    = $false
$form.MaximizeBox                = $false

$Form.startposition              = "centerscreen"

$Form.FormBorderStyle            = [System.Windows.Forms.FormBorderStyle]::Fixed3D

$Form.Text                       = "Reset Password Remotely"
$toolTip = New-Object System.Windows.Forms.ToolTip

$iconBase64      = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAABbElEQVQ4jaWQS0sCYRSGnynH0SxzzC6KTKS1aNFlp9Eqoh/golbtWhdEv6MfENQ6rF122RTkpiBcW62EEiyE0sTLjDFfi6ComRiks3x5zsN7DvxzJIDtvcPbaHhQ6mSxWCqLrbXlSQDSp5d3osNJn17eAbjs7C3d4Cyb4+WtDqZgITlFTAvbNrEIGk2dnf1jItExQkP9CAEn2Ru8sovV1BIexf2D7/otyFxcE9VieDzK55Mk0EbH8Q+EyZxfOTeo1t4Y9g9imiYt3aBWLdOsPdPbP4LZNpwFcrfEYyFP0NdgSBXMT4M27GL3qECXEnEWuKUGPu8TK4sDP/KoWufVaDkLInKevoDXAob8bZRK3pJbnjiTSKHKFQuoylVmkylnQTA8y7tQMVrfdQ29ybsIoI7MOJ8AEE+sU8jtoMjPAOjtHuKJDTvUXuCSe5iY26ReeQDAF9Bsl78ExVJZHJxl7/+kKFiSYqks/uY7mA8LMaFk+9vjQwAAAABJRU5ErkJggg=='

$iconBytes       = [Convert]::FromBase64String($iconBase64)

$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)

$stream.Write($iconBytes, 0, $iconBytes.Length)

$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)

$Form.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$iconInfoBase64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAAg0lEQVQ4jWP0q9r6n4FMsKnNm5GFgYGBwdbWmmTNhw8fZWBgYGBgItd2GMBrAAcrI/kGcLAyMuQ48xE0BKcBP37/Z5iy9xPDj9/4wxinAX4GXAw5znx4NeM1YNOFbwQ14zWAWEA7A0o8+FFoXIAFl0TPjo+UuYBYQLEBLAwMiIwxIAAA8D8aBR7xJWwAAAAASUVORK5CYII='

$iconInfoBytes  = [Convert]::FromBase64String($iconInfoBase64)

$stream         = New-Object IO.MemoryStream($iconInfoBytes, 0, $iconInfoBytes.Length)

$stream.Write($iconInfoBytes, 0, $iconInfoBytes.Length)

$iconInfoImage  = [System.Drawing.Image]::FromStream($stream, $true)



$iconInfoBox = new-object Windows.Forms.PictureBox

$iconInfoBox.name = "iconInfoBox"

$iconInfoBox.Width = $iconInfoImage.Size.Width

$iconInfoBox.Height = $iconInfoImage.Size.Height

$iconInfoBox.Image = $iconInfoImage

$iconInfoBox.location = New-Object System.Drawing.Point(460,7)

$iconInfoBox.add_MouseHover($ShowHelp)

$RichTextBoxOutput                        = New-Object system.Windows.Forms.RichTextBox
$RichTextBoxOutput.text                   = 'Type a computer name.'
$RichTextBoxOutput.width                  = 460
$RichTextBoxOutput.height                 = 160
$RichTextBoxOutput.location               = New-Object System.Drawing.Point(19,100)
$RichTextBoxOutput.Multiline              = $true

$RichTextBoxOutput.ReadOnly               = $true
$RichTextBoxOutput.BackColor              = "white"

$RichTextBoxOutput.ForeColor              = "black"

$LabelComputer                   = New-Object system.Windows.Forms.Label
$LabelComputer.text              = "Computer:"
$LabelComputer.AutoSize          = $true
$LabelComputer.location          = New-Object System.Drawing.Point(18,10)
$LabelComputer.Font              = 'Microsoft Sans Serif,10'

$LabelUser                   = New-Object system.Windows.Forms.Label
$LabelUser.text              = "User:"
$LabelUser.AutoSize          = $true
$LabelUser.width             = 25
$LabelUser.height            = 10
$LabelUser.location          = New-Object System.Drawing.Point(18,40)
$LabelUser.Font              = 'Microsoft Sans Serif,10'

$LabelPassword                   = New-Object system.Windows.Forms.Label
$LabelPassword.text              = "Password:"
$LabelPassword.name              = "Password"
$LabelPassword.AutoSize          = $true
$LabelPassword.width             = 25
$LabelPassword.height            = 10
$LabelPassword.location          = New-Object System.Drawing.Point(18,70)
$LabelPassword.Font              = 'Microsoft Sans Serif,10'
$LabelPassword.add_MouseHover($ShowHelp)

$TextBoxComputer                       = New-Object system.Windows.Forms.TextBox
$TextBoxComputer.Text                   = 'localhost'
$TextBoxComputer.width                 = 120
$TextBoxComputer.height                = 20
$TextBoxComputer.AutoSize              = $false
$TextBoxComputer.location              = New-Object System.Drawing.Point(88,10)
$TextBoxComputer.Font                  = 'Microsoft Sans Serif,10'
$TextBoxComputer.AutoCompleteMode      = 'SuggestAppend'

$TextBoxComputer.AutoCompleteSource    = 'CustomSource'
$TextBoxComputer.MaxLength             = 13

$TextBoxUser                        = New-Object system.Windows.Forms.TextBox
$TextBoxUser.Text                   = 'Administrador'
$TextBoxUser.width                  = 120
$TextBoxUser.height                 = 20
$TextBoxUser.AutoSize               = $false
$TextBoxUser.location               = New-Object System.Drawing.Point(88,40)
$TextBoxUser.Font                   = 'Microsoft Sans Serif,10'
$TextBoxUser.MaxLength              = 15

$TextBoxPassword                        = New-Object system.Windows.Forms.TextBox
$TextBoxPassword.text                   = '123'
$TextBoxPassword.PasswordChar           = '*'
$TextBoxPassword.width                  = 120
$TextBoxPassword.height                 = 20
$TextBoxPassword.AutoSize               = $false
$TextBoxPassword.location               = New-Object System.Drawing.Point(88,70)
$TextBoxPassword.Font                   = 'Microsoft Sans Serif,10'
$TextBoxPassword.MaxLength              = 15
$TextBoxPassword.Name                   = 'Password'
$TextBoxPassword.add_MouseHover($ShowHelp)


$ButtonStop = New-Object System.Windows.Forms.Button

$ButtonStop.text = "Stop"
$ButtonStop.width = 88
$ButtonStop.height = 29
$ButtonStop.location = New-Object System.Drawing.Point(300,62)
$ButtonStop.Font = 'Microsoft Sans Serif,8'

$ButtonStop.Enabled = $false
$ButtonStop.name = 'ButtonStop'
$ButtonStop.add_MouseHover($ShowHelp)

$ButtonReset                         = New-Object system.Windows.Forms.Button
$ButtonReset.text                    = "Reset"
$ButtonReset.width                   = 88
$ButtonReset.height                  = 29
$ButtonReset.location                = New-Object System.Drawing.Point(390,62)
$ButtonReset.Font                    = 'Microsoft Sans Serif,10'
$ButtonReset.name                    = 'ButtonReset'
$ButtonReset.add_MouseHover($ShowHelp)

$LabelLoop                   = New-Object system.Windows.Forms.Label
$LabelLoop.text              = "loop"
$LabelLoop.AutoSize          = $true
$LabelLoop.width             = 25
$LabelLoop.height            = 10
$LabelLoop.location          = New-Object System.Drawing.Point(230,15)
$LabelLoop.Font              = 'Microsoft Sans Serif,10'
$LabelLoop.name              = 'Loop'
$LabelLoop.add_MouseHover($ShowHelp)

$CheckBoxLoop = New-Object System.Windows.Forms.CheckBox

$CheckBoxLoop.Location = New-Object System.Drawing.Point(215,12)

$CheckBoxLoop.Checked = $true

$CheckBoxLoop.add_MouseHover($ShowHelp)

$CheckBoxLoop.Enabled = $true
$CheckBoxLoop.name    = 'Loop'

$arrayComputers = [System.Collections.ArrayList]@()
$global:currentRunspace = ''

$Global:powershell = ''

$Global:asyncObject = ''

$global:flagJobCompleted= $false

$Global:jobCancelled = $false
$Global:session = $null
$nl = "`r`n"

# Populate the array with computers, change the filter here
[void]$arrayComputers.add((Get-ADComputer -Filter 'Name -like "СHANGE_COMPUTER_NAME_FILTER*"' | foreach{($_.name).toUpper()}))
$arrayComputers = $arrayComputers | Sort-Object -Descending 
$TextBoxComputer.AutoCompleteCustomSource.AddRange($arrayComputers)

function enableDisable($flag){
   if($flag -eq $true){
      $TextBoxComputer.Enabled = $true
      $TextBoxUser.Enabled = $true
      $TextBoxPassword.Enabled = $true
      $ButtonReset.Enabled = $true
      $CheckBoxLoop.Enabled = $true
      $ButtonStop.Enabled = $false
   }else{
      $TextBoxComputer.Enabled = $false
      $TextBoxUser.Enabled = $false
      $TextBoxPassword.Enabled = $false
      $ButtonReset.Enabled = $false
      $CheckBoxLoop.Enabled = $false
      $ButtonStop.Enabled = $true
   }
}

$RichTextBoxOutput.AppendText($nl)

$ButtonReset_Click = {  
   enableDisable $false
   if([string]::IsNullOrWhitespace($TextBoxComputer.text)){ 
      $RichTextBoxOutput.SelectionColor = 'Red'
      $RichTextBoxOutput.AppendText("Enter a valid computer name." + $nl)
   }elseif ([string]::IsNullOrWhitespace($TextBoxUser.text)){
      $RichTextBoxOutput.SelectionColor = 'Red'
      $RichTextBoxOutput.AppendText("Enter a valid username." + $nl)
   }elseif ([string]::IsNullOrWhitespace($TextBoxPassword.text)){
      $RichTextBoxOutput.SelectionColor = 'Red'
      $RichTextBoxOutput.AppendText("Enter a valid password." + $nl)
   }else{
      $startCopy = (get-date).ToString('T')

      $RichTextBoxOutput.AppendText("--------------------------------------------------------------------" + $nl)

      $RichTextBoxOutput.SelectionColor = 'Green'
      $RichTextBoxOutput.AppendText("Script has started at " + $startCopy + $nl)

      $RichTextBoxOutput.AppendText("--------------------------------------------------------------------" + $nl)
      $computerName = ($TextBoxComputer.text).Trim()

      $Runspace = [runspacefactory]::CreateRunspace()

      $Runspace.ThreadOptions = "ReuseThread"

      $Runspace.Open()

      $SyncHash = [hashtable]::Synchronized(@{TextBox = $RichTextBoxOutput; TextBoxComputer = $TextBoxComputer; TextBoxUser = $TextBoxUser; TextBoxPassword = $TextBoxPassword; CheckBoxLoop = $CheckBoxLoop})

      $Runspace.SessionStateProxy.SetVariable("SyncHash", $SyncHash)          



      $Global:powershell = [PowerShell]::Create().AddScript({
         param($computerName, $nl)

         Function createSession($computerName){

            try{

               $Global:session = New-PSSession -ComputerName $computerName -ErrorAction SilentlyContinue

               $SyncHash.TextBox.AppendText("The remote session $($Global:session) to $($computerName) was successfuly created." + $nl)

               $SyncHash.TextBox.ScrollToCaret()

            }catch{

               $SyncHash.TextBox.SelectionColor = 'Red'

               $SyncHash.TextBox.AppendText("Wasn't possible to create a session." + $nl)

               $SyncHash.TextBox.ScrollToCaret()

            }

         }



         Function removeSession($computerName){

            try{

               Remove-PSSession -session $global:session -ErrorAction SilentlyContinue

               $SyncHash.TextBox.AppendText("The remote session $($global:session) to $($computerName) was successfuly removed." + $nl)

               $SyncHash.TextBox.ScrollToCaret()

            }catch{

               $SyncHash.TextBox.SelectionColor = 'Red'

               $SyncHash.TextBox.AppendText("Wasn't possible to remove active session." + $nl)

               $SyncHash.TextBox.ScrollToCaret()

            }

         }
           
         Function testComputerConnectivity($computer){
            if (Test-Connection $computer -count 1 -Quiet){
               $SyncHash.TextBox.AppendText("It was possible to ping $($computer) successfuly." + $nl)
               if(Test-WSMan -ComputerName $computer -ErrorAction SilentlyContinue){
                  $SyncHash.TextBox.AppendText("It was possible to connect remotely to $($computer)." + $nl) 
                  return $true   
               }else{

                  $SyncHash.TextBox.SelectionColor = 'Red'

                  $SyncHash.TextBox.AppendText("The service WinRM is not active." + $nl)

                  $SyncHash.TextBox.ScrollToCaret()

                  return $false

              }   
            }else{

               $SyncHash.TextBox.SelectionColor = 'Red'

               $SyncHash.TextBox.AppendText("Was not possible to establish a connection to the remote host, check the computer's name, $($computer)." + $nl)

               $SyncHash.TextBox.ScrollToCaret()
               return $false 
            }
         }   
         
         Function ChangePassword($Password, $userName){
            Invoke-Command -Session $Global:session -ArgumentList($Password, $userName) -ScriptBlock {
            param($Password, $userName)      
            try{
               $version = $PSVersionTable.PSVersion.Major
               $OSbuild = [System.Environment]::OSVersion.Version.Build
               if($version -gt 2 -and $OSbuild -gt 16070){
                  $Password = ConvertTo-SecureString $Password -AsPlainText -Force -ErrorAction Stop
                  $UserAccount = Get-LocalUser -Name $userName -ErrorAction Stop 
                  $UserAccount | Set-LocalUser -Password $Password -ErrorAction Stop 
               }else{
                  Get-WmiObject -ComputerName localhost -Class Win32_UserAccount -Filter "LocalAccount=True" | `
                  ForEach-Object{
                     if($userName -eq $_.name){
                        ([ADSI]"WinNT://localhost/$($userName),user").SetPassword($Password)
                        break
                     }
                  }
               }
               return $Null
            }Catch{
               try{
                  if(net user $userName $Password){
                     return $Null
                  }else{
                     return $Error
                  }
               }catch{
                  return $Error
               }
            }
            } | % {`
               if($_.exception -eq $null){
                  $SyncHash.TextBox.SelectionColor = 'DarkCyan'
                  $SyncHash.TextBox.AppendText("Password was changed successfully, for the user $($username)." + $nl)  
               }else{ 
                  $SyncHash.TextBox.SelectionColor = 'Red'
                  $SyncHash.TextBox.AppendText("Wasn't possible to change the password, " + $_ + $nl) 
               }
            }
         }

         Function executeChange{
            $flag = testComputerConnectivity $computerName
            if($flag -eq $true){
               createSession $computerName
               changePassword $SyncHash.TextBoxPassword.text $SyncHash.TextBoxUser.text
               removeSession $computerName
            }else{
               if($SyncHash.CheckBoxLoop.Checked -eq $true){
                  executeChange
               }
            }
         }
         executeChange
      }).AddArgument($computername).AddArgument($nl)

      $Global:powershell.Runspace = $Runspace

      $Global:AsyncObject =  $Global:powershell.BeginInvoke()

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

         $RichTextBoxOutput.AppendText("--------------------------------------------------------------------" + $nl)

         $RichTextBoxOutput.SelectionColor = 'Green'

         $RichTextBoxOutput.AppendText("Reset password job has been completed!" + $nl)

         $RichTextBoxOutput.AppendText("--------------------------------------------------------------------" + $nl)

      }

      $EndCopy = (get-date).ToString('T')

      $RichTextBoxOutput.AppendText("--------------------------------------------------------------------" + $nl)

      $RichTextBoxOutput.SelectionColor = 'Green'
      $RichTextBoxOutput.AppendText("Script has ended at " + $EndCopy + $nl)
      $RichTextBoxOutput.AppendText("--------------------------------------------------------------------" + $nl)
   }
   enableDisable $true
}

$ButtonStop_Click = {

   $this.enabled = $false

   if($global:flagJobCompleted -eq $true){

      $Global:jobCancelled = $true

      $RichTextBoxOutput.SelectionColor = 'Red'

      $RichTextBoxOutput.AppendText("A job has been interrupted!" + $nl)

      $RichTextBoxOutput.ScrollToCaret()

      $Global:powershell.EndStop($Global:powershell.BeginStop($null, $Global:asyncObject))

      $thread = Get-Runspace -id $global:currentRunspace

      $thread.Close()

      $thread.Dispose()

   }

}

$ButtonReset.add_Click($ButtonReset_Click)
$ButtonStop.add_Click($ButtonStop_Click)

[void]$Form.controls.AddRange(@($iconInfoBox,$RichTextBoxOutput,$LabelComputer,$TextBoxComputer,$TextBoxUser,$TextBoxPassword,$ButtonStop,$ButtonReset,$LabelPassword,$LabelUser,$LabelLoop,$CheckBoxLoop))
[void]$form.ShowDialog()
#EOF
