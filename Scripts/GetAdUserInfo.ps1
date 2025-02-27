Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$ProgressPreference = 'SilentlyContinue'
Import-Module ActiveDirectory -DisableNameChecking

# Automatically get the domain name
$domainDN = (Get-ADDomain).DistinguishedName

$ShowHelp = {
   Switch ($this.name) {
    "iconInfoBox" {$tip = "Get LDAP User Info`nCreated by Angelo Polatto - 2019`nThis software retrieves LDAP user information dynamically."}
   }
 $tooltip.SetToolTip($this,$tip)
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '750,560'
$Form.text                       = "Get LDAP User Info"
$Form.TopMost                    = $false
$Form.MaximizeBox                = $false
$Form.StartPosition              = "CenterScreen"
$Form.FormBorderStyle            = [System.Windows.Forms.FormBorderStyle]::Fixed3D

$toolTip = New-Object System.Windows.Forms.ToolTip

$RichTextBoxOutput                        = New-Object system.Windows.Forms.RichTextBox
$RichTextBoxOutput.text                   = "Select a user group.`r`n"
$RichTextBoxOutput.width                  = 730
$RichTextBoxOutput.height                 = 430
$RichTextBoxOutput.location               = New-Object System.Drawing.Point(10,120)
$RichTextBoxOutput.Multiline              = $true
$RichTextBoxOutput.ReadOnly               = $true
$RichTextBoxOutput.BackColor              = "white"
$RichTextBoxOutput.ForeColor              = "black"
$RichTextBoxOutput.Font                   = "Consolas"

$LabelUser                   = New-Object system.Windows.Forms.Label
$LabelUser.text              = "Username:"
$LabelUser.AutoSize          = $true
$LabelUser.location          = New-Object System.Drawing.Point(10,15)
$LabelUser.Font              = 'Microsoft Sans Serif,10'

$TextBoxUser                 = New-Object system.Windows.Forms.TextBox
$TextBoxUser.width           = 100
$TextBoxUser.height          = 20
$TextBoxUser.location        = New-Object System.Drawing.Point(80,10)
$TextBoxUser.Font            = 'Microsoft Sans Serif,8'
$TextBoxUser.MaxLength       = 15

$ButtonGetInfo                         = New-Object system.Windows.Forms.Button
$ButtonGetInfo.text                    = "Get Info"
$ButtonGetInfo.width                   = 80
$ButtonGetInfo.height                  = 29
$ButtonGetInfo.location                = New-Object System.Drawing.Point(660,72)
$ButtonGetInfo.Font                    = 'Microsoft Sans Serif,10'
$ButtonGetInfo.Enabled                 = $true

$TextBoxBase                        = New-Object system.Windows.Forms.TextBox
$TextBoxBase.text                   = "OU=Users,$domainDN"
$TextBoxBase.width                  = 360
$TextBoxBase.height                 = 20
$TextBoxBase.location               = New-Object System.Drawing.Point(100,80)
$TextBoxBase.Font                   = 'Microsoft Sans Serif,8'
$TextBoxBase.MaxLength              = 250

# Function to Get User Info from AD
Function Get-UserInfo {
    param ($Username)

    try {
        $user = Get-ADUser -Filter {SamAccountName -eq $Username} -Properties *
        if ($user) {
            return $user
        } else {
            return $null
        }
    } catch {
        return $null
    }
}

# Function to Get Group Membership
Function Get-UserGroups {
    param ($Username)
    try {
        $userGroups = (Get-ADUser -Identity $Username -Properties MemberOf).MemberOf | ForEach-Object { ($_ -split ',')[0] -replace 'CN=' }
        return $userGroups
    } catch {
        return @()
    }
}

# Function to Retrieve Applied GPOs
Function Get-UserGPOs {
    param ($Username)
    try {
        $userOU = (Get-ADUser -Identity $Username -Properties DistinguishedName).DistinguishedName
        $GPOs = (Get-ADOrganizationalUnit -Identity $userOU).LinkedGroupPolicyObjects
        if ($GPOs) {
            return $GPOs | ForEach-Object { Get-GPO -Guid ($_ -replace '[{}]') } | Select-Object -ExpandProperty DisplayName
        } else {
            return @("No GPOs found")
        }
    } catch {
        return @("Error retrieving GPOs")
    }
}

# Function to Get AD Computers
Function Get-Computers {
    try {
        return Get-ADComputer -Filter "Name -like '*'" | ForEach-Object { $_.Name.ToUpper() }
    } catch {
        return @()
    }
}

# Function to Get AD Groups
Function Get-ADGroups {
    try {
        return Get-ADGroup -Filter "Name -Like '*'" | ForEach-Object { $_.Name.ToUpper() }
    } catch {
        return @()
    }
}

# Button Click Event
$ButtonGetInfo_Click = {
    $username = $TextBoxUser.Text.Trim()

    if (-not $username) {
        $RichTextBoxOutput.SelectionColor = "Red"
        $RichTextBoxOutput.AppendText("Please enter a valid username.`r`n")
    } else {
        $userInfo = Get-UserInfo -Username $username
        $userGroups = Get-UserGroups -Username $username
        $userGPOs = Get-UserGPOs -Username $username

        if ($userInfo) {
            $RichTextBoxOutput.AppendText("User Found: $($userInfo.DisplayName) ($username)`r`n")
            $RichTextBoxOutput.AppendText("Email: $($userInfo.EmailAddress)`r`n")
            $RichTextBoxOutput.AppendText("Department: $($userInfo.Department)`r`n")
            $RichTextBoxOutput.AppendText("Last Logon: $($userInfo.LastLogonDate)`r`n")

            $RichTextBoxOutput.AppendText("📌 Group Memberships:`r`n")
            if ($userGroups.Count -gt 0) {
                $userGroups | ForEach-Object { $RichTextBoxOutput.AppendText("- $_`r`n") }
            } else {
                $RichTextBoxOutput.AppendText("No groups found.`r`n")
            }

            $RichTextBoxOutput.AppendText("🛠️ Applied Group Policies:`r`n")
            if ($userGPOs.Count -gt 0) {
                $userGPOs | ForEach-Object { $RichTextBoxOutput.AppendText("- $_`r`n") }
            } else {
                $RichTextBoxOutput.AppendText("No GPOs applied.`r`n")
            }
        } else {
            $RichTextBoxOutput.SelectionColor = "Red"
            $RichTextBoxOutput.AppendText("User not found in Active Directory.`r`n")
        }
    }
}

$ButtonGetInfo.add_Click($ButtonGetInfo_Click)

# Add Controls to Form
[void]$Form.Controls.AddRange(@($ButtonGetInfo, $TextBoxUser, $RichTextBoxOutput, $LabelUser))
[void]$Form.ShowDialog()
