#!/bin/bash
targetlist="backup elk prometheus apache-mysql-slave nginx-apache-mysql"
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--target) target="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done
echo "Target: $target"
if echo $targetlist | grep -w $target > /dev/null
then
    setenforce 0
    sed -i "s/=enforcing/=permissive/" /etc/selinux/config
    systemctl stop firewalld
    systemctl disable firewalld
    yum -y install iptables-services.x86_64
    systemctl enable --now iptables.service
    iptables -F
    iptables-restore < ./otus-linux-basic/$target/iptables
    iptables-save
    service iptables save
    rsync -vrp -e "ssh -i $HOME/.ssh/id_rsa -o StrictHostKeyChecking=no" root@192.168.1.200:/root/otus-linux-basic/$target /root/otus-linux-basic 
    /bin/bash ./otus-linux-basic/$target.sh
    yes | cp -rf ./otus-linux-basic/$target/ifcfg-enp0s3 /etc/sysconfig/network-scripts/ifcfg-enp0s3
    systemctl restart network
    hostnamectl set-hostname $target
    shutdown -r 1
else
    echo "unknown input"
    exit 1
fi