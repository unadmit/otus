#!/bin/bash
yum -y install git
git clone https://github.com/unadmit/otus-linux-basic.git
chmod +x otus-linux-basic/*.sh
ssh-keygen