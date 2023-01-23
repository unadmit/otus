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