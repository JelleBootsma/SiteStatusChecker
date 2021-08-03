#!/bin/bash

cd prometheus/
cat <<'EOF' > prometheus.yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: blackbox
    metrics_path: /probe
    params:
       module: [http_2xx]
    static_configs:
     - targets:
EOF

URLSTRING="${URLS:-"https://www.google.com/"}"

readarray -d ";" -t urlarr <<< "$URLSTRING"

for (( n=0; n < ${#urlarr[*]}; n++ ))  
do  
echo "       - ${urlarr[n]}" >> prometheus.yml
done  

echo "    relabel_configs:" >> prometheus.yml
echo "      - source_labels: [__address__]" >> prometheus.yml
echo "        target_label: __param_target" >> prometheus.yml
echo "      - source_labels: [__param_target]" >> prometheus.yml
echo "        target_label: instance" >> prometheus.yml
echo "      - target_label: __address__" >> prometheus.yml
echo "        replacement: 0.0.0.0:9115 # The blackbox exporter." >> prometheus.yml


cd /
./run.sh &

cd /app/prometheus
./prometheus & 

cd /app/blackbox_exporter
./blackbox_exporter
