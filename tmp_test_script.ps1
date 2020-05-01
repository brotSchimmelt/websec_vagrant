$path = ".\websec_ubuntu18"
Set-Location $path

$file_to_check = ".\Vagrantfile"
$file_exits = Test-Path $file_to_check
If (-Not ($file_exits -eq $True)) {
    Write-Output "cool."
}
else {
    Write-Output "not`n'cool.'"
    Set-Location ..
    exit
}

Set-Location ..