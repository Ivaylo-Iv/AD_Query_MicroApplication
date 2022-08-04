# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms

$DefaultSaveLocation = ($env:USERPROFILE + "\Documents")

# Create a new form
$SearchAD = New-Object System.Windows.Forms.Form

# Define the size, title and background color
$SearchAD.ClientSize = '400,300'
$SearchAD.text = "Search through Active Directory"
$SearchAD.BackColor = "#ffffff"
$SearchAD.StartPosition = "CenterScreen"
$SearchAD.MaximumSize = $SearchAD.Size
$SearchAD.MinimumSize = $SearchAD.Size
$SearchAD.MaximizeBox = $false

#Define the user radio button and its properties
$UserRadioButton = New-Object System.Windows.Forms.RadioButton
$UserRadioButton.Text = "User"
$UserRadioButton.Location = "25, 150"
$UserRadioButton.Size = "200, 20"
$UserRadioButton.Checked = $true

$GroupRadioButton = New-Object System.Windows.Forms.RadioButton
$GroupRadioButton.Text = "Group"
$GroupRadioButton.Location = "25,170"
$GroupRadioButton.Size = "200, 20"

#Define the location text box and its properties
$locationBox = New-Object System.Windows.Forms.TextBox
$locationBox.Location = "25,55"
$locationBox.Size = "200,50"
$locationBox.Text = $DefaultSaveLocation
$locationBox.ReadOnly = $true

#Define the search text box and its properties
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Location = "25,105"
$inputBox.Size = "200,50"
$inputBox.Text = ""

#Define the Search label and its properties
$SearchLabel = New-object System.Windows.Forms.Label
$SearchLabel.Location = "25,85"
$SearchLabel.Size = "250,20"
$SearchLabel.ForeColor = "Black"
$SearchLabel.Text = "Enter a name or a group!"

#Define the Location Label and its properties
$locationLabel = New-Object System.Windows.Forms.Label
$locationLabel.Location = "25,25"
$locationLabel.Size = "250,20"
$locationLabel.ForeColor = "Black"
$locationLabel.Text = "Choose a locationto store the query output"

#Define the radio button Label and its properties
$RadioLabel = New-Object System.Windows.Forms.Label
$RadioLabel.Location = "25,130"
$RadioLabel.Size = "250,20"
$RadioLabel.ForeColor = "Black"
$RadioLabel.Text = "Search by:"

#Define the error Label and its properties
$ErrorLabel = New-Object System.Windows.Forms.Label
$ErrorLabel.Location = "25,190"
$ErrorLabel.Size = "250,20"
$ErrorLabel.ForeColor = "Red"
$ErrorLabel.Text = "test"

#Define the location button and its properties
$button = New-Object System.Windows.Forms.Button
$button.Location = "250,55"
$button.Size = "110,20"
$button.Text = "Choose Location"
$button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

#Define the search button and its properties
$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Location = "250, 105"
$SearchButton.Size = "110,20"
$SearchButton.Text = "Search"
$SearchButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

#Add components to the form (Main window)
$SearchAD.Controls.Add($ErrorLabel)
$SearchAD.Controls.Add($RadioLabel)
$SearchAD.Controls.Add($UserRadioButton)
$SearchAD.Controls.Add($GroupRadioButton)
$SearchAD.Controls.Add($SearchLabel)
$SearchAD.Controls.Add($locationLabel)
$SearchAD.Controls.Add($inputBox);
$SearchAD.Controls.Add($locationBox);
$SearchAD.Controls.Add($button);
$SearchAD.Controls.Add($SearchButton);

$file = New-Object System.Windows.Forms.FolderBrowserDialog

$button.Add_Click({
    $file.ShowDialog()
    if ($file.Selectedpath -ne ""){
        $locationBox.Text = $file.Selectedpath;
    }

})

$SearchButton.Add_Click({
    if($inputBox.Text -eq ""){
        $ErrorLabel.Text = "Please search a name or a group!"
    } else {
        $text = $inputBox.Text
        if($UserRadioButton.Checked -eq "True"){
            $Givvenname = (Get-ADUser -Filter "name -eq '$text'").GivenName;
            $ErrorLabel.Text = $Givvenname
            $gr = Get-ADPrincipalGroupMembership $Givvenname | Select-Object name
            For ($i=0; $i -lt $gr.Length; $i++) {
                $ErrorLabel.Text = $gr[$i]
                }
            
        } else{
            $groupMembers = Get-ADGroupMember "$text"
            $ErrorLabel.Text = "Group selected"
        }
    }
   
 
});

# Display the form
[void]$SearchAD.ShowDialog()