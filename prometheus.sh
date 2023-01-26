#!/bin/bash
tar -xvf ./otus-linux-basic/prometheus/prometheus-2.41.0.linux-amd64.tar.gz
tar -xvf ./otus-linux-basic/prometheus/node_exporter-1.5.0.linux-amd64.tar.gz
useradd --no-create-home --shell /usr/sbin/nologin prometheus
useradd --no-create-home --shell /bin/false node_exporter
mkdir {/etc,/var/lib}/prometheus
chown -v prometheus: {/etc,/var/lib}/prometheus
rsync -P ./node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/sbin
rsync -P ./prometheus-2.41.0.linux-amd64/prometheus ./prometheus-2.41.0.linux-amd64/promtool /usr/local/sbin
chown -v prometheus: /usr/local/sbin/prometheus
chown -v prometheus: /usr/local/sbin/promtool
chown node_exporter: /usr/local/sbin/node_exporter
cp -v ./otus-linux-basic/prometheus/node_exporter.service /etc/systemd/system
cp -v ./otus-linux-basic/prometheus/prometheus.service /etc/systemd/system
cp -v ./otus-linux-basic/prometheus/prometheus.yml /etc/prometheus/
cp -v -r ./prometheus-2.41.0.linux-amd64/console{_libraries,s}/ /etc/prometheus/
chown -v prometheus: /etc/prometheus
systemctl daemon-reload
systemctl enable --now prometheus.service
systemctl enable --now node_exporter
yum -y install ./otus-linux-basic/prometheus/grafana-9.3.2-1.x86_64.rpm
rsync -P ./otus-linux-basic/prometheus/grafana.db /var/lib/grafana
chown -v grafana: /var/lib/grafana/grafana.db
chmod 600 /var/lib/grafana/grafana.db
systemctl enable --now grafana-server.service