<#
The purpose of this script is to allow quick and easy installation of RSAT modules.  Select the module, click install, wait until the process completes.
Author:JDTMH
Date: 01/10/2023
To do: 
Add self elevation to remove the need to run as admin. - DONE
#>


# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

#Allow coloring of progrss bar
Add-Type -AssemblyName System.Drawing

# Kill WSUS and reset to download from Microsoft Website
function KillWSUS {
Stop-Service wuauserv
Remove-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\*' -recurse -force
Start-Service wuauserv
}

# Set Install Options
function Install-SelectedOptions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string[]] $Options
    )

    # Loop through the options
    foreach ($option in $Options) {
        # Check which option was selected
        switch ($option) {
            "Active Directory Management Tools" {

                # Write message to Label   
                $ProgressBar.Tag = "Installing Active Directory Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh()    

                # Install the Active Directory Tools
                Try { 
					Install-ActiveDirectoryTools
                    $InstallationSuccess = $True
				}   
				Catch { 
                    $Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False
				}
			}
            "DNS Management Tools" {
             
                # Write message to Label  
                $ProgressBar.Tag = "Installing DNS Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the DNS Management Tools
                Try { 
					Install-DnsManagementTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False
				} 
			}
            "File Services" {

                # Write message to Label    
                $ProgressBar.Tag = "Installing File Services"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the File Services
                Try { 
					Install-FileServices
                    $InstallationSuccess = $True
				}   
				Catch { 
						$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Group Policy Management Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Group Policy Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Group Policy Management Tools
                Try { 
					Install-GroupPolicyManagementTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "IPAM Client Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing IPAM Client Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the IPAM Client Tools
                Try { 
					Install-IpamClientTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "LLDP" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing LLDP Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the LLDP tools
                Try { 
					Install-Lldp
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Network Controller Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Network Controller Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Network Controller Tools
                Try { 
					Install-NetworkControllerTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Network Load Balancing Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Network Load Balancing Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Network Load Balancing Tools
                Try { 
					Install-NetworkLoadBalancingTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Bit Locker Recovery Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Bit Locker Recovery Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Bit Locker Recovery Tools
                Try { 
					Install-BitLockerRecoveryTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False
				} 
			}
            "Certificate Services" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Certificate Services"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Certificate Services
                Try { 
					Install-CertificateServices
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "DHCP Management Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing DHCP Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the DHCP Management Tools
                Try { 
					Install-DhcpManagementTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Fail Over Cluster Management Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Fail Over Cluster Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Fail Over Cluster Management Tools
                Try { 
					Install-FailOverClusterManagementTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Remote Access Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Remote Access Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Remote Access Tools
                Try { 
					Install-RemoteAccessTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Remote Desktop Services" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Remote Desktop Services"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Remote Desktop Services
                Try { 
					Install-RemoteDesktopServices
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Server Manager" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Server Manager"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Server Manager
                Try { 
					Install-ServerManager
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Shileded VM Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Shileded VM Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Shileded VM Tools
                Try { 
					Install-ShilededVmTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Storage Migration Service Management Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Storage Migration Service Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Storage Migration Service Management Tools
                Try { 
					Install-StorageMigrationServiceManagementTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Storage Replica Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Storage Replica Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Storage Replica Tools
                Try { 
					Install-StorageReplicaTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "System Insights Management Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing System Insights Management Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the System Insights Management Tools
                Try { 
					Install-SystemInsightsManagementTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            "Volume Activation Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing Volume Activation Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the Volume Activation Tools
                Try { 
					Install-VolumeActivationTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False
				} 
			}
            "WSUS Tools" {
                
                # Write message to Label    
                $ProgressBar.Tag = "Installing WSUS Tools"
                $Label.ForeColor = "Black"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh() 

                # Install the WSUS Tools
                Try { 
					Install-WsusTools
                    $InstallationSuccess = $True
				}   
				Catch { 
					$Label.Text = "Installation failed: " + $_.Exception.Message
				    # Set the flag to indicate that the installation failed 
                    $InstallationSuccess = $False 
				} 
			}
            default {
                # Option is not recognized
                $ProgressBar.Tag = "Invalid option: $option"
                $Label.ForeColor = "Red"
                $Label.Text = $ProgressBar.Tag
                $Label.Refresh()
            }
        }

    }
    # Increment the progress bar by 1 step
    $ProgressBar.PerformStep()

    # Check the value of the flag to determine the outcome of the installation
if ($InstallationSuccess) {
    # Display a success message
    $ProgressBar.ForeColor = "Green"
    $ProgressBar.Tag = "Installation completed successfully!"
    $Label.ForeColor = "Green"
    $Label.Text = $ProgressBar.Tag
    $Label.Refresh()
}
else {
    # Display an error message
    $ProgressBar.ForeColor = "Red"
    $ProgressBar.Tag = "Installation failed: " + $_.Exception.Message
    $Label.ForeColor = "Red"
    $Label.Text = $ProgressBar.Tag
    $Label.Refresh()
}
}

function Install-ActiveDirectoryTools {
    # Install the Active Directory Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
}

function Install-DnsManagementTools {
    # Install the DNS Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.DNS.Tools~~~~0.0.1.0
}

function Install-FileServices {
    # Install the File Services
    DISM.exe /Online /add-capability /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0
}

function Install-GroupPolicyManagementTools {
    # Install the Group Policy Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
}

function Install-IpamClientTools {
    # Install the IPAM Client Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0
}

function Install-Lldp {
    # Install the LLDP tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0
}

function Install-NetworkControllerTools {
    # Install the Network Controller Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0
}

function Install-NetworkLoadBalancingTools {
    # Install the Network Load Balancing Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0
}

function Install-BitLockerRecoveryTools {
    # Install the Bit Locker Recovery Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0
}

function Install-CertificateServices {
    # Install the Certificate Services
    DISM.exe /Online /add-capability /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0
}

function Install-DhcpManagementTools {
    # Install the DHCP Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0
}

function Install-FailOverClusterManagementTools {
    # Install the Fail Over Cluster Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0
}

function Install-RemoteAccessTools {
    # Install the Remote Access Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0
}

function Install-RemoteDesktopServices {
    # Install the Remote Desktop Services
    DISM.exe /Online /add-capability /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0
}

function Install-ServerManager {
    # Install the Server Manager
    DISM.exe /Online /add-capability /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0
}

function Install-ShilededVmTools {
    # Install the Shiled VM Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0
}
function Install-StorageMigrationServiceManagementTools {
    # Install the Storage Migration Service Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0
}
function Install-StorageReplicaTools {
    # Install the Storage Replica Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0
}
function Install-SystemInsightsManagementTools {
    # Install the System Insights Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
}
function Install-VolumeActivationTools {
    # Install the Volume Activation Management Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0
}
function Install-WsusTools {
    # Install the Wsus Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0
}
function Install-AllOptions {
    # Install all of the available Tools
    DISM.exe /Online /add-capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0
    DISM.exe /Online /add-capability /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0
}

# Create a new form
$form = New-Object System.Windows.Forms.Form

# Set the form properties
$form.Text = "RSAT Installer"
$form.Size = New-Object System.Drawing.Size(800,780)
$Form.StartPosition = "CenterScreen"

# Create a progress bar and add it to the form
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Maximum = 100
$ProgressBar.Minimum = 0
$ProgressBar.Step = 100
$ProgressBar.Value = 0
$ProgressBar.Style = "Continuous"
$ProgressBar.Location = New-Object System.Drawing.Size(10,610)
$ProgressBar.Size = New-Object System.Drawing.Size(760,30)
$Form.Controls.Add($ProgressBar)

# Create a label to display the status message
$Label = New-Object System.Windows.Forms.Label
$Label.Location = New-Object System.Drawing.Size(250,700)
$Label.Size = New-Object System.Drawing.Size(300,30)
$Form.Controls.Add($Label)

# Create a list box for the options
$listBox = New-Object System.Windows.Forms.ListBox
$listbox.SelectionMode = "MultiSimple"
$listBox.Location = New-Object System.Drawing.Size(10,10)
$listBox.Size = New-Object System.Drawing.Size(760,600)
$listBox.MultiColumn = $false

# Add the options to the list box
$listBox.Items.Add("Active Directory Management Tools")
$listBox.Items.Add("DNS Management Tools")
$listBox.Items.Add("File Services")
$listBox.Items.Add("Group Policy Management Tools")
$listBox.Items.Add("IPAM Client Tools")
$listBox.Items.Add("LLDP")
$listBox.Items.Add("Network Controller Tools")
$listBox.Items.Add("Network Load Balancing Tools")
$listBox.Items.Add("Bit Locker Recovery Tools")
$listBox.Items.Add("Certificate Services")
$listBox.Items.Add("DHCP Management Tools")
$listBox.Items.Add("Fail Over Cluster Management Tools")
$listBox.Items.Add("Remote Access Tools")
$listBox.Items.Add("Remote Desktop Services")
$listBox.Items.Add("Server Manager")
$listBox.Items.Add("Shileded VM Tools")
$listBox.Items.Add("Storage Migration Service Management Tools")
$listBox.Items.Add("Storage Replica Tools")
$listBox.Items.Add("System Insights Management Tools")
$listBox.Items.Add("Volume Activation Tools")
$listBox.Items.Add("WSUS Tools")
$listBox.Items.Add("Install ALL Options Listed")

# Add the list box to the form
$form.Controls.Add($listBox)

# Create a button to install the selected options
$InstallButton = New-Object System.Windows.Forms.Button
$InstallButton.Location = New-Object System.Drawing.Size(50,650)
$InstallButton.Size = New-Object System.Drawing.Size(300,30)
$InstallButton.Text = "Install Selected Options"

# Set the button's click event handler
$InstallButton.Add_Click({

    $ProgressBar.Value = 0
    $Label.Text = $ProgressBar.Tag

    # Get the selected items
    $selectedItems = $listBox.SelectedItems

        # Check if the "Install ALL Options Listed" option is selected
    if ($listBox.SelectedItems.Count -eq 0) {
        # No options selected, display error message on the label
        $ProgressBar.Tag = "Error: Please select at least one option to install"
        $Label.ForeColor = "Red"
        $Label.Text = $ProgressBar.Tag
        $Label.Refresh()
    }
    elseif ($selectedItems -contains "Install ALL Options Listed") {
        # Install all options
        KillWSUS
        Install-AllOptions
    }
    else {
        # Install the selected options
        KillWSUS
        Install-SelectedOptions -Options $selectedItems
    }
})

# Create a new button and add it to the form
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(420,650)
$CancelButton.Size = New-Object System.Drawing.Size(300,30)
$CancelButton.Text = "Cancel"
$Form.Controls.Add($CancelButton)

# Add an event handler for the button's click event
$CancelButton.Add_Click({
    # Close the form
    $Form.Close()
})

# Add the button to the form
$form.Controls.Add($InstallButton)

# Add the cancel button to the form
$form.Controls.Add($CancelButton)

# Show the form
$form.ShowDialog()

# Set a flag to indicate whether the installation was successful
$InstallationSuccess = $True