# SiteStatusChecker
Site Status Checker is a simple Docker application for monitoring the current up state of specified sites\
It is run though a combination of [Grafana](https://grafana.com/), [Prometheus](https://prometheus.io/) and the [Prometheus blackbox exporter](https://github.com/prometheus/blackbox_exporter)
## Usage
Using the Site Status Checker is easy, and is done through a docker container

1. Install Docker
2. Create a persistant volume (here we will call it grafana-var)
3. Run the Docker image using: `docker run -v grafana-var:/var/lib/grafana -p 3000:3000/tcp --env URLS="https://github.com/;https://prometheus.io" jellebootsma/sitestatuschecker`
4. You can now access the grafana dashboard through http://localhost:3000. This can then be setup as desired. Settings will persist, as these are stored in /var/lib/grafana
