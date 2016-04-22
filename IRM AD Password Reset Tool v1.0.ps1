<#######################################################################

Title: 
IRM Password Reset Tool

Description: 
This GUI tool was created for distribution to POST admins to be
able to centrally reset account passwords to a randomly generated value,
unique to each account.  An output file is created on the desktop for
after each run.

Author:
DNH

Date:
11/6/2015

Version:
1.0

#>######################################################################
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#Program Constants 
$Desktop = [Environment]::GetFolderPath("Desktop")
$ascii     = $NULL;For ($a=33;$a –le 126;$a++) {$ascii+=,[char][byte]$a }
$Caps      = $NULL;For ($a=65;$a –le  90;$a++) {$Caps      +=,[char][byte]$a }
$LowerCase = $NULL;For ($a=97;$a –le 122;$a++) {$LowerCase +=,[char][byte]$a }
$Numbers   = $NULL;For ($a=48;$a –le  57;$a++) {$Numbers +=,[char][byte]$a }

$NOT_DELEGATED = 1048576
$SMARTCARD_REQUIRED = 262144

#GUI design variables
$xForm = 1245
$yForm = 500
$GroupBoxTableX = 242
$UsernameWidth = 163
$PwdWidth = 45
$ResetButtonWidth = 233

#Initialize the form and design characteristics
$PwdResetForm = New-Object System.Windows.Forms.Form 
$PwdResetForm.Text = "IRM AD Account Password Reset Tool v1.0"
$PwdResetForm.Size = New-Object System.Drawing.Size($xForm,$yForm) 
$PwdResetForm.FormBorderStyle = "FixedSingle"
$PwdResetForm.StartPosition = "CenterScreen"
$PwdResetForm.MinimizeBox = $false
$PwdResetForm.MaximizeBox = $false
$PwdResetForm.ShowIcon = $false
$PwdResetForm.ControlBox = $true
$PwdResetForm.KeyPreview = $True
$PwdResetForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") {$PwdResetForm.Close()}})

#Domain Group Box - For Label
$DomainGroupBox = New-Object System.Windows.Forms.GroupBox 
$DomainGroupBox.Location = New-Object System.Drawing.Size(5,5)
$DomainGroupBox.size = New-Object System.Drawing.Size(($xForm-16),50)
$DomainGroupBox.text = "Select a Domain From the Drop Down Menu:"
$PwdResetForm.Controls.Add($DomainGroupBox)

#Domain Combo Box used to select which domain
$DomainBox = New-Object System.Windows.Forms.ComboBox
$DomainBox.Location = New-Object System.Drawing.Point(8,17)
$DomainBox.Size = New-Object System.Drawing.Size(($xForm-30), 100)
$forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$forest.domains | % {$DomainBox.Items.add($_) | Out-Null}
$DomainBox.add_SelectedValueChanged({UpdateOUBox})
$DomainGroupBox.Controls.Add($DomainBox)

#OU Group Box - For Label
$OUGroupBox = New-Object System.Windows.Forms.GroupBox
$OUGroupBox.Location = New-Object System.Drawing.Size(5,60)
$OUGroupBox.size = New-Object System.Drawing.Size(($xForm-16),180)
$OUGroupBox.text = "Select OU and Wait For [+] Sign to Drill Further.  Double Click target OU to Search for Users):"
$PwdResetForm.Controls.Add($OUGroupBox)

#OU TreeView used to select which OU
$OUBox = new-object windows.forms.TreeView 
$OUBox.Location = new-object System.Drawing.Size(8,20)   
$OUBox.size = new-object System.Drawing.Size(($xForm-30),150)   
$OUBox.Anchor = "top, left, right"
$OUBox.add_NodeMouseDoubleClick({UpdateOutputBoxes})
$OUGroupBox.Controls.Add($OUBox)

#Admin Table Group Box - For Label
$AdminGroupBox = New-Object System.Windows.Forms.GroupBox
$AdminGroupBox.Location = New-Object System.Drawing.Size(5,245)
$AdminGroupBox.size = New-Object System.Drawing.Size($GroupBoxTableX,225)
$AdminGroupBox.text = "Admin Accounts:"
$PwdResetForm.Controls.Add($AdminGroupBox)

#Admin Table displays all users with description starting with Admin*
$AdminTable = New-Object System.Windows.Forms.DataGridView
$AdminTable.Name = "Admin"
$AdminTable.Location = New-Object System.Drawing.Size(7,18)
$AdminTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$AdminTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$AdminTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$AdminTable.GridColor = [System.Drawing.Color]::Black
$AdminTable.RowHeadersVisible = $false
$AdminTable.AllowUserToAddRows = $false
$AdminTable.AllowUserToResizeColumns = $true
$AdminTable.AllowUserToResizeRows = $false
$AdminTable.ColumnHeadersHeight = 23
$AdminTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$aScroll = New-Object System.Windows.Forms.VScrollBar
$aScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$aScroll.width = 18
$aScroll.isAccessible = $false
$AdminTable.Controls.Add($aScroll)                
$AdminTable.Columns.Add("Name","UserName") > $null
$AdminTable.Columns["Name"].Width = $UsernameWidth
$AdminTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$AdminTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$AdminTable.Columns["Name"].ReadOnly = $true
$AdminTable.Columns.Add("PwdLastSet","PwdAge") > $null
$AdminTable.Columns["PwdLastSet"].Width = $PwdWidth
$AdminTable.Columns["PwdLastSet"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$AdminTable.Columns["PwdLastSet"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$AdminTable.Columns["PwdLastSet"].ReadOnly = $true
$AdminGroupBox.Controls.Add($AdminTable)

#Reset button to initiate reset password on all selected accounts
$ResetAdminButton = New-Object System.Windows.Forms.Button 
$ResetAdminButton.Location = New-Object System.Drawing.Size(5,200)
$ResetAdminButton.Size = New-Object System.Drawing.Size($ResetButtonWidth,20)
$ResetAdminButton.Text = "Reset Admin Account(s) Password"
$ResetAdminButton.add_Click({resetAccounts "Admin" $AdminTable})
$AdminGroupBox.Controls.Add($ResetAdminButton)


#Service Table Group Box - For Label
$ServiceGroupBox = New-Object System.Windows.Forms.GroupBox
$ServiceGroupBox.Location = New-Object System.Drawing.Size(($GroupBoxTableX+10),245)
$ServiceGroupBox.size = New-Object System.Drawing.Size($GroupBoxTableX,225)
$ServiceGroupBox.text = "Service Accounts:"
$PwdResetForm.Controls.Add($ServiceGroupBox)

#Service Table displays all users with description starting with Service*
$ServiceTable = New-Object System.Windows.Forms.DataGridView
$ServiceTable.Name = "Service"
$ServiceTable.Location = New-Object System.Drawing.Size(7,18)
$ServiceTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$ServiceTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$ServiceTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$ServiceTable.GridColor = [System.Drawing.Color]::Black
$ServiceTable.RowHeadersVisible = $false
$ServiceTable.AllowUserToAddRows = $false
$ServiceTable.AllowUserToResizeColumns = $true
$ServiceTable.AllowUserToResizeRows = $false
$ServiceTable.ColumnHeadersHeight = 23
$ServiceTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$sScroll = New-Object System.Windows.Forms.VScrollBar
$sScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$sScroll.width = 18
$sScroll.isAccessible = $false
$ServiceTable.Controls.Add($sScroll)           
$ServiceTable.Columns.Add("Name","UserName") > $null
$ServiceTable.Columns["Name"].Width = $UsernameWidth
$ServiceTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$ServiceTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$ServiceTable.Columns["Name"].ReadOnly = $true
$ServiceTable.Columns.Add("PwdLastSet","PwdAge") > $null
$ServiceTable.Columns["PwdLastSet"].Width = $PwdWidth
$ServiceTable.Columns["PwdLastSet"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$ServiceTable.Columns["PwdLastSet"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$ServiceTable.Columns["PwdLastSet"].ReadOnly = $true
$ServiceGroupBox.Controls.Add($ServiceTable)

#Reset button to initiate reset password on all selected accounts
$ResetServiceButton = New-Object System.Windows.Forms.Button 
$ResetServiceButton.Location = New-Object System.Drawing.Size(5,200)
$ResetServiceButton.Size = New-Object System.Drawing.Size($ResetButtonWidth,20)
$ResetServiceButton.Text = "Reset Service Account(s) Password"
$ResetServiceButton.add_Click({resetAccounts "Service" $ServiceTable})
$ServiceGroupBox.Controls.Add($ResetServiceButton)


#User Table Group Box - For Label
$UserGroupBox = New-Object System.Windows.Forms.GroupBox
$UserGroupBox.Location = New-Object System.Drawing.Size(($GroupBoxTableX*2+15),245)
$UserGroupBox.size = New-Object System.Drawing.Size($GroupBoxTableX,225)
$UserGroupBox.text = "User Accounts:"
$PwdResetForm.Controls.Add($UserGroupBox)

#User Table displays all users with description starting with User*
$UserTable = New-Object System.Windows.Forms.DataGridView
$UserTable.Name = "User"
$UserTable.Location = New-Object System.Drawing.Size(7,18)
$UserTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$UserTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$UserTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$UserTable.GridColor = [System.Drawing.Color]::Black
$UserTable.RowHeadersVisible = $false
$UserTable.AllowUserToAddRows = $false
$UserTable.AllowUserToResizeColumns = $true
$UserTable.AllowUserToResizeRows = $false
$UserTable.ColumnHeadersHeight = 23
$UserTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$uScroll = New-Object System.Windows.Forms.VScrollBar
$uScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$uScroll.width = 18
$uScroll.isAccessible = $false
$UserTable.Controls.Add($uScroll)        
$UserTable.Columns.Add("Name","UserName") > $null
$UserTable.Columns["Name"].Width = $UsernameWidth
$UserTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$UserTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$UserTable.Columns["Name"].ReadOnly = $true
$UserTable.Columns.Add("PwdLastSet","PwdAge") > $null
$UserTable.Columns["PwdLastSet"].Width = $PwdWidth
$UserTable.Columns["PwdLastSet"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$UserTable.Columns["PwdLastSet"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$UserTable.Columns["PwdLastSet"].ReadOnly = $true
$UserGroupBox.Controls.Add($UserTable)

#Reset button to initiate reset password on all selected accounts
$ResetUserButton = New-Object System.Windows.Forms.Button 
$ResetUserButton.Location = New-Object System.Drawing.Size(5,200)
$ResetUserButton.Size = New-Object System.Drawing.Size($ResetButtonWidth,20)
$ResetUserButton.Text = "Reset User Account(s) Password"
$ResetUserButton.add_Click({resetAccounts "User" $UserTable})
$UserGroupBox.Controls.Add($ResetUserButton)


#Mailbox Table Group Box - For Label
$MailboxGroupBox = New-Object System.Windows.Forms.GroupBox
$MailboxGroupBox.Location = New-Object System.Drawing.Size(($GroupBoxTableX*3+20),245)
$MailboxGroupBox.size = New-Object System.Drawing.Size($GroupBoxTableX,225)
$MailboxGroupBox.text = "Mailbox Accounts:"
$PwdResetForm.Controls.Add($MailboxGroupBox)

#Mailbox Table displays all users that do not have User*, Service*, or Admin* in description
$MailboxTable = New-Object System.Windows.Forms.DataGridView
$MailboxTable.Name = "Mailbox"
$MailboxTable.Location = New-Object System.Drawing.Size(7,18)
$MailboxTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$MailboxTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$MailboxTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$MailboxTable.GridColor = [System.Drawing.Color]::Black
$MailboxTable.RowHeadersVisible = $false
$MailboxTable.AllowUserToAddRows = $false
$MailboxTable.AllowUserToResizeColumns = $true
$MailboxTable.AllowUserToResizeRows = $false
$MailboxTable.ColumnHeadersHeight = 23
$MailboxTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$mScroll = New-Object System.Windows.Forms.VScrollBar
$mScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$mScroll.width = 18
$mScroll.isAccessible = $false
$MailboxTable.Controls.Add($mScroll)             
$MailboxTable.Columns.Add("Name","UserName") > $null
$MailboxTable.Columns["Name"].Width = $UsernameWidth
$MailboxTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$MailboxTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$MailboxTable.Columns["Name"].ReadOnly = $true
$MailboxTable.Columns.Add("PwdLastSet","PwdAge") > $null
$MailboxTable.Columns["PwdLastSet"].Width = $PwdWidth
$MailboxTable.Columns["PwdLastSet"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$MailboxTable.Columns["PwdLastSet"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$MailboxTable.Columns["PwdLastSet"].ReadOnly = $true
$MailboxGroupBox.Controls.Add($MailboxTable)

#Reset button to initiate reset password on all selected accounts
$ResetMailboxButton = New-Object System.Windows.Forms.Button 
$ResetMailboxButton.Location = New-Object System.Drawing.Size(5,200)
$ResetMailboxButton.Size = New-Object System.Drawing.Size($ResetButtonWidth,20)
$ResetMailboxButton.Text = "Reset Mailbox Account(s) Password"
$ResetMailboxButton.add_Click({resetAccounts "Mailbox" $MailboxTable})
$MailboxGroupBox.Controls.Add($ResetMailboxButton)


#Other Table Group Box - For Label
$OtherGroupBox = New-Object System.Windows.Forms.GroupBox
$OtherGroupBox.Location = New-Object System.Drawing.Size(($GroupBoxTableX*4+25),245)
$OtherGroupBox.size = New-Object System.Drawing.Size($GroupBoxTableX,225)
$OtherGroupBox.text = "Other Accounts:"
$PwdResetForm.Controls.Add($OtherGroupBox)

#User Table displays all users that do not have User*, Service*, or Admin* in description
$OtherTable = New-Object System.Windows.Forms.DataGridView
$OtherTable.Name = "Other"
$OtherTable.Location = New-Object System.Drawing.Size(7,18)
$OtherTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$OtherTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$OtherTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$OtherTable.GridColor = [System.Drawing.Color]::Black
$OtherTable.RowHeadersVisible = $false
$OtherTable.AllowUserToAddRows = $false
$OtherTable.AllowUserToResizeColumns = $true
$OtherTable.AllowUserToResizeRows = $false
$OtherTable.ColumnHeadersHeight = 23
$OtherTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$oScroll = New-Object System.Windows.Forms.VScrollBar
$oScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$oScroll.width = 18
$oScroll.isAccessible = $false
$OtherTable.Controls.Add($oScroll)             
$OtherTable.Columns.Add("Name","UserName") > $null
$OtherTable.Columns["Name"].Width = $UsernameWidth
$OtherTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$OtherTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$OtherTable.Columns["Name"].ReadOnly = $true
$OtherTable.Columns.Add("PwdLastSet","PwdAge") > $null
$OtherTable.Columns["PwdLastSet"].Width = $PwdWidth
$OtherTable.Columns["PwdLastSet"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$OtherTable.Columns["PwdLastSet"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$OtherTable.Columns["PwdLastSet"].ReadOnly = $true
$OtherGroupBox.Controls.Add($OtherTable)

#Reset button to initiate reset password on all selected accounts
$ResetOtherButton = New-Object System.Windows.Forms.Button 
$ResetOtherButton.Location = New-Object System.Drawing.Size(5,200)
$ResetOtherButton.Size = New-Object System.Drawing.Size($ResetButtonWidth,20)
$ResetOtherButton.Text = "Reset Other Account(s) Password"
$ResetOtherButton.add_Click({resetAccounts "Other" $OtherTable})
$OtherGroupBox.Controls.Add($ResetOtherButton)

#Label to show current status of actions
$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "******LABEL********"
$StatusLabel.AutoSize = $True
$StatusLabel.Location = New-Object System.Drawing.Size(5,50)
$StatusLabel.BringToFront()
$OUGroupBox.Controls.Add($StatusLabel)


function UpdateOUBox{
#Updates the OU Box with children objects based on what is selected for enumeration.  Note this only shows objectClass=OrganizationalUnit
    $OUBox.Nodes.Clear()
    $AdminTable.Rows.Clear()
    $ServiceTable.Rows.Clear()
    $UserTable.Rows.Clear()
    $MailboxTable.Rows.Clear()
    $OtherTable.Rows.Clear()

    $root = [ADSI]"LDAP://$($DomainBox.SelectedItem.ToString())"
    $TNRoot = new-object System.Windows.Forms.TreeNode("Root") 
    $TNRoot.Name = $root.name 
    $TNRoot.Text = $root.distinguishedName 
    $TNRoot.tag = "NotEnumerated" 
    $OUBox.add_AfterSelect({ 
        if ($this.SelectedNode.tag -eq "NotEnumerated") { 
            $de = new-object system.directoryservices.directoryEntry("LDAP://$($this.SelectedNode.text)") 
            $de.get_Children() |  
            foreach { 
                if($_.objectclass -eq "organizationalUnit"){
                    $TN = new-object System.Windows.Forms.TreeNode 
                    $TN.Name = $_.name 
                    $TN.Text = $_.distinguishedName 
                    $TN.tag = "NotEnumerated" 
                    $this.SelectedNode.Nodes.Add($TN) 
                }
            } 
            $this.SelectedNode.tag = "Enumerated" 
        } 
    })
    [void]$OUBox.Nodes.Add($TNRoot)
}

function UpdateOutputBoxes{
#Updates the four different tables with users from the selected OU to include username and password age.
    $AdminTable.Rows.Clear()
    $ServiceTable.Rows.Clear()
    $UserTable.Rows.Clear()
    $MailboxTable.Rows.Clear()
    $OtherTable.Rows.Clear()

    try{
        $SelectedOURoot = $OUBox.SelectedNode.Text
        $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$SelectedOURoot")
        $objSearcher.PageSize = 500
        $objSearcher.Filter = "(&(objectCategory=user)(|(description=Admin*)(description=ISSO*)))"
        $objSearcher.PropertiesToLoad.Add("samaccountname") > $null
        $objSearcher.PropertiesToLoad.Add("pwdlastset") > $null
        $objSearcher.SearchScope = "Subtree"

        $colResults = $objSearcher.FindAll()

        foreach ($objResult in $colResults)
        {
            $username = $objResult.Properties.samaccountname[0]
            $pwdset = [datetime]::fromfiletime($objResult.properties.item("pwdLastSet")[0])
              $age = (New-TimeSpan $pwdset).Days
            $AdminTable.Rows.Add($username,$age)
        }
    }catch{}

    try{
        $objSearcher1 = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher1.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$SelectedOURoot")
        $objSearcher1.PageSize = 500
        $objSearcher1.Filter = "(&(objectCategory=user)(description=Service*))"
        $objSearcher1.PropertiesToLoad.Add("samaccountname") > $null
        $objSearcher1.PropertiesToLoad.Add("pwdlastset") > $null
        $objSearcher1.SearchScope = "Subtree"

        $colResults1 = $objSearcher1.FindAll()

        foreach ($objResult1 in $colResults1)
        {
            $username = $objResult1.Properties.samaccountname[0]
            $pwdset = [datetime]::fromfiletime($objResult1.properties.item("pwdLastSet")[0])
              $age = (New-TimeSpan $pwdset).Days
            $ServiceTable.Rows.Add($username,$age)
        }
    }catch{}

    try{
        $objSearcher2 = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher2.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$SelectedOURoot")
        $objSearcher2.PageSize = 500
        $objSearcher2.Filter = "(&(objectCategory=user)(|(description=User*)(description=Secondary*)))"
        $objSearcher2.PropertiesToLoad.Add("samaccountname") > $null
        $objSearcher2.PropertiesToLoad.Add("pwdlastset") > $null
        $objSearcher2.SearchScope = "Subtree"

        $colResults2 = $objSearcher2.FindAll()

        foreach ($objResult2 in $colResults2)
        {
            $username = $objResult2.Properties.samaccountname[0]
            $pwdset = [datetime]::fromfiletime($objResult2.properties.item("pwdLastSet")[0])
              $age = (New-TimeSpan $pwdset).Days
            $UserTable.Rows.Add($username,$age)
        }
    }catch{}

    try{
        $objSearcher3 = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher3.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$SelectedOURoot")
        $objSearcher3.PageSize = 500
        $objSearcher3.Filter = "(&(objectCategory=user)(!(|(description=User*)(description=Service*)(description=Admin*)(description=Mailbox*)(description=ISSO*)(description=Secondary*))))"
        $objSearcher3.PropertiesToLoad.Add("samaccountname") > $null
        $objSearcher3.PropertiesToLoad.Add("pwdlastset") > $null
        $objSearcher3.SearchScope = "Subtree"

        $colResults3 = $objSearcher3.FindAll()

        foreach ($objResult3 in $colResults3)
        {
            $username = $objResult3.Properties.samaccountname[0]
            $pwdset = [datetime]::fromfiletime($objResult3.properties.item("pwdLastSet")[0])
              $age = (New-TimeSpan $pwdset).Days
            $OtherTable.Rows.Add($username,$age)
        }
    }catch{}

    try{
        $objSearcher4 = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher4.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$SelectedOURoot")
        $objSearcher4.PageSize = 500
        $objSearcher4.Filter = "(&(objectCategory=user)(description=Mailbox*))"
        $objSearcher4.PropertiesToLoad.Add("samaccountname") > $null
        $objSearcher4.PropertiesToLoad.Add("pwdlastset") > $null
        $objSearcher4.SearchScope = "Subtree"

        $colResults4 = $objSearcher4.FindAll()

        foreach ($objResult4 in $colResults4)
        {
            $username = $objResult4.Properties.samaccountname[0]
            $pwdset = [datetime]::fromfiletime($objResult4.properties.item("pwdLastSet")[0])
              $age = (New-TimeSpan $pwdset).Days
            $MailboxTable.Rows.Add($username,$age)
        }
    }catch{}
}

function resetAccounts{
    Param([string]$accountType,[System.Windows.Forms.DataGridView]$tableType)
    
    $timestamp = get-date -f yyyy_MM_dd_HHmmss
    $logfilename = "$Desktop\$accountType-AccountReset-$TimeStamp.csv"

    Add-Content $logfilename "$accountType Account Reset on $Timestamp"
    Add-Content $logfilename ""
    Add-Content $logfilename "Username,Password"

    for ($i=0; $i -lt $tableType.SelectedRows.Count; $i++){
        $Username = $tableType.SelectedRows[$i].Cells[0].Value
        $FindUser = New-Object System.DirectoryServices.DirectorySearcher([ADSI]("LDAP://$($OUBox.SelectedNode.text)"),"(&(objectCategory=user)(samaccountname=$username))",@("distinguishedname"))
        $FindUser.FindOne() | % {
            $RandomGeneratedPassword = PasswordGenerator
            try{
                $UserToBeReset = [ADSI]"LDAP://$($_.Properties."distinguishedname")"
                if(($UserToBeReset.userAccountControl[0] -band $SMARTCARD_REQUIRED) -ne 0){
                    $UserToBeReset.userAccountControl[0] -= $SMARTCARD_REQUIRED
                    $UserToBeReset.CommitChanges()
                    $UserToBeReset.psbase.invoke("SetPassword", $RandomGeneratedPassword)
                    $UserToBeReset.CommitChanges()
                    $UserToBeReset.userAccountControl[0] += $SMARTCARD_REQUIRED
                    $UserToBeReset.CommitChanges()
                }else{
                    $UserToBeReset.psbase.invoke("SetPassword", $RandomGeneratedPassword)
                    $UserToBeReset.CommitChanges()
                }
                if(($accountType -ne "Service") -and ($accountType -ne "Mailbox")){$UserToBeReset.psbase.invokeSet("pwdLastSet", 0); $UserToBeReset.CommitChanges()}
                
                Add-Content $logfilename "$Username,`"$RandomGeneratedPassword`""
                Add-Content "\\adlog.appservices.state.sbu\ADAccounts\$($DomainBox.SelectedItem.ToString())#$Username#$timestamp.log" "0"
            }catch{
                Add-Content $logfilename "$Username,ERROR: Could not set password"
            }
            
        }
    }
    Add-Content $logfilename ""
    Add-Content $logfilename "End of File."
    [System.Windows.Forms.MessageBox]::Show("$accountType Account Passwords have been changed.  A log file has been created with the new passwords:`n`n $logfilename","Log File Generated")
}


Function PasswordGenerator(){
    For ($loop=1; $loop –le 15; $loop++) 
    {$Password+=($ascii | GET-RANDOM)}
    return $Password
}


$PwdResetForm.Add_Shown({$PwdResetForm.Activate()})
[void] $PwdResetForm.ShowDialog()