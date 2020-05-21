# Path to the vagrant folder
$path = ".\websec"
# hyper-v specific vagrantfile (default)
$vagrantfile = ".\Vagrantfiles\Vagrantfile_hyperv"
# vagrantfile with ssh user
$ssh_file = ".\resources\ssh_files\Vagrantfile_hyperv_ssh"

Write-Output "starting script ...`n"

Set-Location $path

# select vm provider
$user_input = -1
while (($user_input -lt 1) -or ($user_input -gt 2)) {
    # 1 - 4

    Write-Output "1) Hyper-V [Ubuntu 18]`n2) VirtualBox [Ubuntu 18]`n"
    # Write-Output "3) Hyper-V [Ubuntu 20]`n4) VirtualBox [Ubuntu 20]`n`n"
    $user_input = Read-Host "Select a provider"
}

# choose Vagrantfile
switch ($user_input) {

    1 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_hyperv" }
    1 { $ssh_file = ".\resources\ssh_files\Vagrantfile_hyperv_ssh" }
    2 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_vb" }
    2 { $ssh_file = ".\resources\ssh_files\Vagrantfile_vb_ssh" }
    # 3 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_hyperv_20" }
    # 3 { $ssh_file = ".\Vagrantfiles\Vagrantfile_hyperv_ssh_20" }
    # 4 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_vb_20" }
    # 4 { $ssh_file = = ".\Vagrantfiles\Vagrantfile_vb_ssh_20" }
    default { "Error: No valid provider" }
}

# overwrite existing Vagrantfile if necessary
Write-Output "checking if 'Vagrantfile' already exists ..."

$file_to_check = ".\Vagrantfile"
$file_exits = Test-Path $file_to_check
If ($file_exits -eq $True) {
    Write-Output "`n### CAUTION: existing Vagrantfile will be deleted!`n"

    Write-Output "deleting Vagrantfile ..."

    Remove-Item $file_to_check

    Write-Output "creating new Vagrantfile ..."

    Copy-Item -Path $vagrantfile -Destination .\Vagrantfile

}
else {
    Write-Output "creating Vagrantfile ..."

    Copy-Item -Path $vagrantfile -Destination .\Vagrantfile
}


# check if Vagrantfile was succesfully created
$file_exits = Test-Path $file_to_check
If ($file_exits -eq $False) {

    Write-Output "file creation failed!`ncheck the files in '\Vagrantfiles'"
    Set-Location .. # return to script location
    exit
}
else {
    Write-Output "continue with 'vagrant up' command ..."
}


# set up the vm with vagrant
Write-Output "`n######## VAGRANT UP ########`n"

vagrant up

Write-Output "waiting 120 seconds for the machine to reboot ..."
Start-Sleep -s 20
Write-Output "waiting 100 seconds for the machine to reboot ..."
Start-Sleep -s 20
Write-Output "waiting  80 seconds for the machine to reboot ..."
Start-Sleep -s 20
Write-Output "waiting  60 seconds for the machine to reboot ..."
Start-Sleep -s 20
Write-Output "waiting  40 seconds for the machine to reboot ..."
Start-Sleep -s 20
Write-Output "waiting  20 seconds for the machine to reboot ..."
Start-Sleep -s 15
Write-Output "waiting   5 seconds for the machine to reboot ..."
Start-Sleep -s 5

Write-Output "\n####### VM SUCESSFULL INITIALIZED #######\n\n"

Write-Output "changing ssh user to websec ...\n"

Remove-Item .\Vagrantfile
Copy-Item -Path $ssh_file -Destination .\Vagrantfile

Write-Output "starting first ssh session ..."
vagrant ssh
