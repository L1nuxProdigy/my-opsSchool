apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: ${prometheus_consul_private_ip}:9090