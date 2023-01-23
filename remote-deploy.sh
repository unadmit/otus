#!/bin/bash
ssh-copy-id root@192.168.1.100
rsync -zvra -e "ssh -i $HOME/.ssh/id_rsa" /root/otus-linux-basic root@192.168.1.100:/root