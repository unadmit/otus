#!/bin/bash
targetlist="backup elk prometheus apache-mysql-slave nginx-apache-mysql"
read -p "enter target[backup/elk/prometheus/apache-mysql-slave/nginx-apache-mysql]" target
if echo $targetlist | grep -w $target > /dev/null
then
    setenforce 0
    sed -i "s/=enforcing/=permissive/" /etc/selinux/config
    systemctl stop firewalld
    systemctl disable firewalld
    yum -y install iptables-services.x86_64
    systemctl enable --now iptables.service
    iptables -F
    iptables-restore < ./$target/iptables
    iptables-save
    service iptables save
    yes | cp -rf ./$target/ifcfg-enp0s3_backup /etc/sysconfig/network-scripts/ifcfg-enp0s3
    systemctl restart network
    hostnamectl set-hostname backup
    systemctl reboot
else
    echo "unknown input"
    exit 1
fi