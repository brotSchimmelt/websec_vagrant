# Vagrant Setup

## Requirements
### Install Vagrant


---

### Vagrant Commands
[**vagrant init**](https://www.vagrantup.com/docs/cli/init.html) This initializes the current directory to be a Vagrant environment by creating an initial *Vagrantfile* if one does not already exist.

[**vagrant up**](https://www.vagrantup.com/docs/cli/up.html) This command creates and configures guest machines according to your *Vagrantfile*.

[**vagrant halt**](https://www.vagrantup.com/docs/cli/halt.html) This command shuts down the running machine Vagrant is managing.

[**vagrant suspend**](https://www.vagrantup.com/docs/cli/suspend.html) This suspends the guest machine Vagrant is managing, rather than fully shutting it down or destroying it.

[**vagrant resume**](https://www.vagrantup.com/docs/cli/resume.html) 
This resumes a Vagrant managed machine that was previously suspended, perhaps with the suspend command.

[**vagrant ssh**](https://www.vagrantup.com/docs/cli/ssh.html) 
This will SSH into a running Vagrant machine and give you access to a shell. It will either use the default user *vagrant* or the one specified in the *Vagrantfile* wit the parameter `config.ssh.username`. 

[**vagrant reload**](https://www.vagrantup.com/docs/cli/reload.html) 
The equivalent of running a `halt` followed by an `up`. This command is usually required for changes made in the Vagrantfile to take effect.

[**vagrant destroy**](https://www.vagrantup.com/docs/cli/destroy.html) 
This command stops the running machine Vagrant is managing and destroys all resources that were created during the machine creation process. 



---
## Install Scripts
### Windows

To run the install script you need to set an exception from the default windows security settings. This is necessary since the script is loaded from a remote source and has no digital signature.
```
$ powershell -ep RemoteSigned -file install_server_win.ps1
```

### Linux
### macOS 
---
## Post Installation  
---
## Webserver

---