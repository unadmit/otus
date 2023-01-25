@echo off
for %%x in (
    nginx-apache-mysql
    apache-mysql-slave
    prometheus
    elk
    backup
    ) do (
        echo "poweroff %%x"
        C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe controlvm "%%x" poweroff
        timeout 5 > NUL
        echo "delete %%x"
        C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe unregistervm "%%x" --delete
        timeout 5 > NUL
        echo "clone %%x"
        C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe clonevm "Clean CentOS" --mode all --name="%%x" --basefolder "C:\temp\VirtualBoxVMs" --register
    )
C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe modifyvm "elk" --memory 4096
C:\Progra~1\PuTTY\psftp root@192.168.1.100 -i c:\temp\id_rsa.ppk -b c:\Temp\otus-linux-basic\psftp-commands.txt
for %%x in (
    backup
    elk
    prometheus
    nginx-apache-mysql
    apache-mysql-slave
    ) do (
        echo "start %%x"
        C:\Progra~1\Oracle\VirtualBox\VBoxManage.exe startvm "%%x"
        timeout 25 > NUL
        echo "run remote bash script on %%x"
        C:\Progra~1\PuTTY\plink.exe 192.168.1.100 -l root -i c:\temp\id_rsa.ppk -batch /root/otus-linux-basic/prepare.sh -t %%x
        C:\Progra~1\PuTTY\putty.exe 192.168.1.100 -ssh -l root -i c:\temp\id_rsa.ppk
    )