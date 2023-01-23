#!/bin/bash
curl -LO "https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz"
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz"
tar -xvf prometheus-2.41.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.5.0.linux-amd64.tar.gz
curl -LO "https://dl.grafana.com/oss/release/grafana-9.3.2-1.x86_64.rpm"
useradd --no-create-home --shell /usr/sbin/nologin prometheus
useradd --no-create-home --shell /bin/false node_exporter
mkdir {/etc,/var/lib}/prometheus
chown -v prometheus: {/etc,/var/lib}/prometheus
rsync -P ./node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/sbin
rsync -P ./prometheus-2.41.0.linux-amd64/prometheus ./prometheus-2.41.0.linux-amd64/promtool /usr/local/sbin
chown -v prometheus: /usr/local/sbin/prometheus
chown -v prometheus: /usr/local/sbin/promtool
chown node_exporter: /usr/local/sbin/node_exporter
cp -v ./node_exporter.service /etc/systemd/system
cp -v ./prometheus.service /etc/systemd/system
cp -v ./prometheus.yml /etc/prometheus/
cp -v -r ./prometheus-2.41.0.linux-amd64/console{_libraries,s}/ /etc/prometheus/
chown -v prometheus: /etc/prometheus
systemctl daemon-reload
systemctl enable --now prometheus.service
systemctl enable --now node_exporter
yum -y install ./grafana-9.3.2-1.x86_64.rpm
systemctl enable --now grafana-server.service