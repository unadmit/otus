@echo off
for %%x in (
    nginx-apache-mysql
    apache-mysql-slave
    prometheus
    elk
    backup
    ) do (
        C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe clonevm "Clean CentOS" --mode all --name="%%x" --basefolder "C:\temp\VirtualBoxVMs" --register
    )
C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe modifyvm "elk" --memory 4096
C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe startvm "backup"
C:\Progra~1\PuTTY\psftp root@192.168.1.100 -b c:\Temp\otus-linux-basic\psftp-commands.txt
C:\Progra~1\PuTTY\putty.exe 192.168.1.100 -ssh -l root -i c:\temp\id_rsa.ppk