@echo off
for %%x in (
    nginx-apache-mysql
    apache-mysql-slave
    prometheus
    elk
    ) do (
        C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe clonevm "Clean CentOS" --mode all --name="%%x" --basefolder "C:\temp\VirtualBoxVMs" --register
    )
C:\Progra~1\PuTTY\psftp root@192.168.1.200 -b c:\Temp\otus-linux-basic\psftp-commands.txt