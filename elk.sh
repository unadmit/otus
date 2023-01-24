#!/bin/bash
yum -y install rsync
yum -y install java-openjdk-devel java-openjdk
rpm -i ./otus-linux-basic/elk/*.rpm
cp -v ./otus-linux-basic/elk/jvm.options /etc/elasticsearch/jvm.options.d/
systemctl enable --now elasticsearch.service
curl -X PUT "http://127.0.0.1:9200/mytest_index"
yes | cp -vf ./otus-linux-basic/elk/kibana.yml /etc/kibana/
systemctl enable --now kibana
yes | cp -vf ./otus-linux-basic/elk/logstash.yml /etc/logstash/
cp -v ./otus-linux-basic/elk/logstash-nginx-es.conf /etc/logstash/conf.d/
systemctl enable --now logstash.service
yes | cp -vf ./otus-linux-basic/elk/filebeat.yml /etc/filebeat/
systemctl enable --now filebeat