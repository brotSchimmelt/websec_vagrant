# Path to the vagrant folder
$path = ".\websec_ubuntu18"
# hyper-v specific vagrantfile (default)
$vagrantfile = ".\Vagrantfiles\Vagrantfile_hyperv" 

Write-Output "setting up server with Hyper-V ...`n"

Set-Location $path

# select vm provider
$user_input = -1
while (($user_input -lt 1) -or ($user_input -gt 3)) {

    Write-Output "1) Hyper-V`n2) VirtualBox`n3) Parallels`n"
    $user_input = Read-Host "Select a provider"
}

# choose Vagrantfile
switch ($user_input) {

    1 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_hyperv" }
    2 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_vb" }
    3 { $vagrantfile = ".\Vagrantfiles\Vagrantfile_parallel" }
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

    Write-Output "creating new vagrant file ..."

    Copy-Item -Path $vagrantfile -Destination .\Vagrantfile

}
else {
    Write-Output "creating vagrant file ..."

    Copy-Item -Path $vagrantfile -Destination .\Vagrantfile
}


# check if Vagrantfile was succesfully created
If ($file_exits -eq $False) {

    Write-Output "file creation failed!`ncheck the files in '\Vagrantfiles'"
    Set-Location .. # return to script location
    exit
}
else {
    Write-Output "continue with 'vagrant up' command ..."
}


# set up the vm with vagrant
Write-Output "######## VAGRANT UP ########"

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

Write-Output "####### VM SUCESSFULL INITIALIZED #######"

Write-Output "starting first ssh session ..."

vagrant ssh
