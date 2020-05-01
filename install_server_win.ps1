# Path to the vagrant folder
$path = ".\websec_ubuntu18"
# hyper-v specific vagrantfile
$vagrantfile = ".\Vagrantfiles\Vagrantfile_hyperv" 

Write-Output "setting up server with Hyper-V ..."

Set-Location $path

# ask for user input 

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


Write-Output "######## VAGRANT UP ########"

vagrant up

Write-Output "waiting 120 seconds for the machine to reboot ..."

Start-Sleep -s 120

Write-Output "####### VM SUCESSFULL INITIALIZED #######"

Write-Output "starting first ssh session ..."

vagrant ssh
