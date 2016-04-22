<#######################################################################

#>######################################################################
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#Program Constants 
$Desktop = [Environment]::GetFolderPath("Desktop")
$ascii     = $NULL;For ($a=33;$a –le 126;$a++) {$ascii+=,[char][byte]$a }
$Caps      = $NULL;For ($a=65;$a –le  90;$a++) {$Caps      +=,[char][byte]$a }
$LowerCase = $NULL;For ($a=97;$a –le 122;$a++) {$LowerCase +=,[char][byte]$a }
$Numbers   = $NULL;For ($a=48;$a –le  57;$a++) {$Numbers +=,[char][byte]$a }

#GUI design variables
$xForm = 715
$yForm = 530
$GroupBoxTableX = 347
$UsernameWidth = 209
$PwdWidth = 45
$ResetButtonWidth = $xForm/2-14
$CheckboxSpacer = 18

#Initialize the form and design characteristics
$PwdResetForm = New-Object System.Windows.Forms.Form 
$PwdResetForm.Text = "IRM Local Account Password Reset Tool v1.0"
$PwdResetForm.Size = New-Object System.Drawing.Size($xForm,$yForm) 
$PwdResetForm.FormBorderStyle = "FixedSingle"
$PwdResetForm.StartPosition = "CenterScreen"
$PwdResetForm.MinimizeBox = $false
$PwdResetForm.MaximizeBox = $false
$PwdResetForm.ShowIcon = $false
$PwdResetForm.ControlBox = $true
$PwdResetForm.KeyPreview = $True
$PwdResetForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") {$PwdResetForm.Close()}})

$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "Current Status: IRM Local Account Password Reset Tool Loaded."
$StatusLabel.Location = New-Object System.Drawing.Size(5,($yForm-45))
$StatusLabel.Size = New-Object System.Drawing.Size(450,20)
$PwdResetForm.Controls.Add($StatusLabel)

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
$OUGroupBox.text = "Select OU and Wait For [+] Sign to Drill Further.  Double Click target OU to Search for Computers:"
$PwdResetForm.Controls.Add($OUGroupBox)

#OU TreeView used to select which OU
$OUBox = new-object windows.forms.TreeView 
$OUBox.Location = new-object System.Drawing.Size(8,20)   
$OUBox.size = new-object System.Drawing.Size(($xForm-30),150)   
$OUBox.Anchor = "top, left, right"
$OUBox.add_NodeMouseDoubleClick({UpdateOutputBoxes})
$OUGroupBox.Controls.Add($OUBox)

#Admin Table Group Box - For Label
$ComputerGroupBox = New-Object System.Windows.Forms.GroupBox
$ComputerGroupBox.Location = New-Object System.Drawing.Size(5,245)
$ComputerGroupBox.size = New-Object System.Drawing.Size(($GroupBoxTableX),205)
$ComputerGroupBox.text = "Computer Accounts in Selected OU:"
$PwdResetForm.Controls.Add($ComputerGroupBox)

#Admin Table displays all users with description starting with Admin*
$ComputerTable = New-Object System.Windows.Forms.DataGridView
$ComputerTable.Name = "Computer"
$ComputerTable.Location = New-Object System.Drawing.Size(7,18)
$ComputerTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$ComputerTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$ComputerTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$ComputerTable.GridColor = [System.Drawing.Color]::Black
$ComputerTable.RowHeadersVisible = $false
$ComputerTable.AllowUserToAddRows = $false
$ComputerTable.AllowUserToResizeColumns = $true
$ComputerTable.AllowUserToResizeRows = $false
$ComputerTable.ColumnHeadersHeight = 23
$ComputerTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$cScroll = New-Object System.Windows.Forms.VScrollBar
$cScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$cScroll.width = 18
$cScroll.isAccessible = $false
$ComputerTable.Controls.Add($cScroll)                
$ComputerTable.Columns.Add("Name","Computer Name") > $null
$ComputerTable.Columns["Name"].Width = 120
$ComputerTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$ComputerTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$ComputerTable.Columns["Name"].ReadOnly = $true

$ComputerTable.Columns.Add("Ping","Ping Status") > $null
$ComputerTable.Columns["Ping"].Width = 68
$ComputerTable.Columns["Ping"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$ComputerTable.Columns["Ping"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$ComputerTable.Columns["Ping"].ReadOnly = $true

$ComputerTable.Columns.Add("Pwd","Password Reset Status") > $null
$ComputerTable.Columns["Pwd"].Width = 125
$ComputerTable.Columns["Pwd"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$ComputerTable.Columns["Pwd"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$ComputerTable.Columns["Pwd"].ReadOnly = $true

#$ComputerTable.add_CellMouseDoubleClick({GetLocalAccounts})
$ComputerGroupBox.Controls.Add($ComputerTable)



#Admin Table Group Box - For Label
$LocalAccountsGroupBox = New-Object System.Windows.Forms.GroupBox
$LocalAccountsGroupBox.Location = New-Object System.Drawing.Size(357,245)
$LocalAccountsGroupBox.size = New-Object System.Drawing.Size($GroupBoxTableX,205)
$LocalAccountsGroupBox.text = "Local Admin Accounts Found On Selected Computer(s):"
$PwdResetForm.Controls.Add($LocalAccountsGroupBox)

#Admin Table displays all users with description starting with Admin*
$LocalAccountsTable = New-Object System.Windows.Forms.DataGridView
$LocalAccountsTable.Name = "LocalAccounts"
$LocalAccountsTable.Location = New-Object System.Drawing.Size(7,18)
$LocalAccountsTable.Size = New-Object System.Drawing.Size(($GroupBoxTableX-13),178)
$LocalAccountsTable.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::Single
$LocalAccountsTable.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::Single
$LocalAccountsTable.GridColor = [System.Drawing.Color]::Black
$LocalAccountsTable.RowHeadersVisible = $false
$LocalAccountsTable.AllowUserToAddRows = $false
$LocalAccountsTable.AllowUserToResizeColumns = $true
$LocalAccountsTable.AllowUserToResizeRows = $false
$LocalAccountsTable.ColumnHeadersHeight = 23
$LocalAccountsTable.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::CellSelect
$LOcalAccountsTable.add_CellValueChanged({ValidatePasswordInput})
$lScroll = New-Object System.Windows.Forms.VScrollBar
$lScroll.Dock = [System.Windows.Forms.DockStyle]::Right
$lScroll.width = 18
$lScroll.isAccessible = $false
$LocalAccountsTable.Controls.Add($lScroll)                
$LocalAccountsTable.Columns.Add("Name","Username") > $null
$LocalAccountsTable.Columns["Name"].Width = 160
$LocalAccountsTable.Columns["Name"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$LocalAccountsTable.Columns["Name"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleLeft
$LocalAccountsTable.Columns["Name"].ReadOnly = $true

$LocalAccountsTable.Columns.Add("Password","Set Password") > $null
$LocalAccountsTable.Columns["Password"].Width = 153
$LocalAccountsTable.Columns["Password"].HeaderCell.Style.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$LocalAccountsTable.Columns["Password"].DefaultCellStyle.Alignment = [System.Windows.Forms.DataGridViewContentAlignment]::MiddleCenter
$LocalAccountsTable.Columns["Password"].ReadOnly = $false
$LocalAccountsGroupBox.Controls.Add($LocalAccountsTable)

#Reset button to initiate reset password on all selected accounts
$ScanComputerButton = New-Object System.Windows.Forms.Button 
$ScanComputerButton.Location = New-Object System.Drawing.Size(5,($yForm-78))
$ScanComputerButton.Size = New-Object System.Drawing.Size(348,29)
$ScanComputerButton.Text = "Scan Selected Computer(s) for Local Admin Accounts"
$ScanComputerButton.Enabled = $false
$ScanComputerButton.add_Click({ScanAccounts})
$PwdResetForm.Controls.Add($ScanComputerButton)

#Reset button to initiate reset password on all selected accounts
$ChangePwdButton = New-Object System.Windows.Forms.Button 
$ChangePwdButton.Location = New-Object System.Drawing.Size(357,($yForm-78))
$ChangePwdButton.Size = New-Object System.Drawing.Size(348,29)
$ChangePwdButton.Text = "Reset Password for ALL Local Admin Accounts"
$ChangePwdButton.Enabled = $false
$ChangePwdButton.add_Click({ResetAccounts})
$PwdResetForm.Controls.Add($ChangePwdButton)

function UpdateOUBox{
#Updates the OU Box with children objects based on what is selected for enumeration.  Note this only shows objectClass=OrganizationalUnit
    $StatusLabel.Text = "Current Status: Enumerating Objects..."
    $OUBox.Nodes.Clear()
    $ComputerTable.Rows.Clear()
    $LocalAccountsTable.Rows.Clear()

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
    $StatusLabel.Text = "Current Status: Objects Enumerated."
}

function UpdateOutputBoxes{
#Updates the four different tables with users from the selected OU to include username and password age.
    
    $StatusLabel.Text = "Current Status: Scanning Selected OU..."
    
    $ComputerTable.Rows.Clear()
    $LocalAccountsTable.Rows.Clear()

    $computerlist = New-Object System.Collections.ArrayList

    try{
        $SelectedOURoot = $OUBox.SelectedNode.Text
        $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$SelectedOURoot")
        $objSearcher.PageSize = 500
        $objSearcher.Filter = "(&(objectCategory=computer)(!userAccountControl:1.2.840.113556.1.4.803:=2))"
        $objSearcher.PropertiesToLoad.Add("name") > $null
        $objSearcher.SearchScope = "Subtree"

        $colResults = $objSearcher.FindAll()

        foreach ($objResult in $colResults)
        {
            $ComputerName = $objResult.Properties.name[0]
            #$ComputerTable.Rows.Add($ComputerName)
            $computerlist.Add($ComputerName) > $null
        }
    }catch{}
    
    $jobs = New-Object System.Collections.ArrayList
    $MaxThread = 25
    $intCount = 0

    While ($computerlist.count -gt 0 -or $jobs.count -gt 0) {
        If ($jobs.count -le $MaxThread) {
            $addjobs = ($MaxThread - $jobs.count)
            Foreach ($InputVar in ($computerlist | Select -first $addjobs)) {
            
                [VOID]$jobs.Add((Start-Job -InputObject $InputVar -ScriptBlock {
                    #=======================================
                    #  Multithreading here $Input pass var
                    #=======================================
	                $CN = @($Input)[0]
	                
                    $PingStatus = Gwmi Win32_PingStatus -Filter "Address = '$CN'" | Select-Object StatusCode
                    If ($PingStatus.StatusCode -eq 0){
                         $CN,"Online"
                    }else{
                        $CN,"OFFLINE"
                    }
            
                    #=======================================
			    }).Id)
			    $computerlist.Remove($InputVar)
            } 
        }
    
        $Clean = @()
    
        Foreach ($J in $jobs) {
            $JobStatus = (Get-Job -id $j -ErrorAction SilentlyContinue).JobStateInfo.state
		    if ($JobStatus -eq 'Completed') {
                #=======================================
                #  Return results from job and process
                #=======================================
                $output = Receive-Job -id $j
                $ComputerTable.Rows.Add($output[0],$output[1],"N/A")
                if($output[1] -eq "OFFLINE"){$ComputerTable.Rows[$intCount].DefaultCellStyle.BackColor = [System.Drawing.Color]::Red}
                $intCount++               

                #=======================================
			    remove-job -id $j
                $clean += $j 
            }
		    if ($JobStatus -eq 'Failed'){
			    Remove-Job -Id $j
			    $clean += $j
		    }
        }
        Foreach ($c in $Clean) {
            $jobs.remove($c)
        }  
    }
    $StatusLabel.Text = "Current Status: Scanning Complete."  
    if($ComputerTable.Rows.Count -gt 0){
        $ScanComputerButton.Enabled = $true
    }
}

function ResetAccounts{
    $StatusLabel.Text = "Current Status: Resetting Local Admin Passwords on Selected Computer(s)..."    
    #$timestamp = get-date -f yyyy_MM_dd_HHmmss
    $timestamp = get-date -f yyyy_MM

    for ($i=0; $i -lt $ComputerTable.SelectedRows.Count; $i++){
        $ComputerName = $ComputerTable.SelectedRows[$i].Cells[0].Value
        $logfilename = "$Desktop\LocalAccountReset-$timestamp.log"
        $centralLog = "\\llog.appservices.state.sbu\LocalAccounts\LocalAccountReset#$ComputerName#$timestamp.log"

        for ($j=0; $j -lt $LocalAccountsTable.Rows.Count; $j++){
            $UserName = $LocalAccountsTable.Rows[$j].Cells[0].Value 
            $Password = $LocalAccountsTable.Rows[$j].Cells[1].Value
        
            $objUser = [adsi]"WinNT://$ComputerName/$UserName,user"
            try
            {
                $objUser.SetPassword($Password)
                Add-Content $logfilename "UP`t$ComputerName`t$UserName"
                Add-Content $centralLog $UserName
            }
            catch
            {
                Add-Content $logfilename "DN`t$ComputerName`t$UserName"
            }
        }

        $ComputerTable.SelectedRows[$i].Cells[2].Value = "Passwords Changed"
        $ComputerTable.SelectedRows[$i].DefaultCellStyle.BackColor = [System.Drawing.Color]::Green
    }

    [System.Windows.Forms.MessageBox]::Show("Local Admin Account Passwords have been changed.  A log file for each computer account has been created on your desktop.","Log File Generated")
    $StatusLabel.Text = "Current Status: Reset Complete."
}

function ScanAccounts{
    $LocalAccountsTable.Rows.Clear()
    $StatusLabel.Text = "Current Status: Scanning selected computer objects for local admin accounts..."

    $AccountArray = @()
    $computerlist = New-Object System.Collections.ArrayList
    $jobs = New-Object System.Collections.ArrayList
    $MaxThread = 10
    $intCount = 0

    for ($i=0; $i -lt $ComputerTable.SelectedRows.Count; $i++){$computerlist.Add($ComputerTable.SelectedRows[$i].Cells[0].Value) > $null}
    While ($computerlist.count -gt 0 -or $jobs.count -gt 0) {
        If ($jobs.count -le $MaxThread) {
            $addjobs = ($MaxThread - $jobs.count)
            Foreach ($InputVar in ($computerlist | Select -first $addjobs)) {
            
                [VOID]$jobs.Add((Start-Job -InputObject $InputVar -ScriptBlock {
                    #=======================================
                    #  Multithreading here $Input pass var
                    #=======================================
	                $CN = @($Input)[0]
                    $TempAccountArray = @()
	                try{
                        $AllLocalAdminAccounts = Get-WmiObject -Query "Associators of {Win32_Group.Domain='$CN',Name='Administrators'} where Role=GroupComponent" -ComputerName $CN
                        foreach($Account in $AllLocalAdminAccounts){
                            if($Account.Domain -eq $CN){
                                $UserName = $Account.Name
                                $TempAccountArray += $UserName
                            }
                        }
                        $TempAccountArray
                    }catch{
                        "ERROR"
                    }
            
                    #=======================================
			    }).Id)
			    $computerlist.Remove($InputVar)
            } 
        }
    
        $Clean = @()
    
        Foreach ($J in $jobs) {
            $JobStatus = (Get-Job -id $j -ErrorAction SilentlyContinue).JobStateInfo.state
		    if ($JobStatus -eq 'Completed') {
                #=======================================
                #  Return results from job and process
                #=======================================
                $output = Receive-Job -id $j
                if($output -eq "ERROR"){
                    write-host "ERROR connecting to WMI"
                }else{
                    foreach($Account in $output){
                        if($AccountArray -notcontains $Account){
                            $AccountArray += $Account
                        }
                    }
                }               

                #=======================================
			    remove-job -id $j
                $clean += $j 
            }
		    if ($JobStatus -eq 'Failed'){
			    Remove-Job -Id $j
			    $clean += $j
		    }
        }
        Foreach ($c in $Clean) {
            $jobs.remove($c)
        }  
    }       
        
    foreach($Account in $AccountArray){
        $LocalAccountsTable.Rows.Add($Account,"")
    }
    $StatusLabel.Text = "Current Status: Scanning Complete."
}

function ValidatePasswordInput{
    $Ready = $true
    for ($i=0; $i -lt $LocalAccountsTable.Rows.Count; $i++){
        $Password = $LocalAccountsTable.Rows[$i].Cells[1].Value
        if(($Password -eq "") -or ($Password -eq $null)){
            $Ready = $false
        }
     }
     if($Ready -eq $false){
        $ChangePwdButton.Enabled = $false
     }else{
        $ChangePwdButton.Enabled = $true
     }
}

function PasswordGenerator(){
    For ($loop=1; $loop –le 15; $loop++) 
    {$Password+=($ascii | GET-RANDOM)}
    return $Password
}




$PwdResetForm.Add_Shown({$PwdResetForm.Activate()})
[void] $PwdResetForm.ShowDialog()