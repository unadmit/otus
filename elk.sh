#!/bin/bash
yum -y install rsync
yes | rsync -zvra root@192.168.1.200:/root/data /root
yum -y install java-openjdk-devel java-openjdk
rpm -i ./data/*.rpm
cp -v ./data/jvm.options /etc/elasticsearch/jvm.options.d/
systemctl enable --now elasticsearch.service
curl -X PUT "http://127.0.0.1:9200/mytest_index"
yes | cp -vf ./data/kibana.yml /etc/kibana/
systemctl enable --now kibana
yes | cp -vf ./data/logstash.yml /etc/logstash/
cp -v ./data/logstash-nginx-es.conf /etc/logstash/conf.d/
systemctl enable --now logstash.service
yes | cp -vf ./data/filebeat.yml /etc/filebeat/
systemctl enable --now filebeat