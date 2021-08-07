# SiteStatusChecker
Site Status Checker is a simple Docker application for monitoring the current up state of specified sites\
It is run though a combination of [Grafana](https://grafana.com/), [Prometheus](https://prometheus.io/) and the [Prometheus blackbox exporter](https://github.com/prometheus/blackbox_exporter)

The reason I build this docker image, is that I needed a easy to maintain and setup system to check the status of many sites.
This was the setup I had experience with, and though this would be the perfect reason to finally dockerize an application.

## Usage
Using the Site Status Checker is easy, and is done through a docker container

1. Install Docker
2. Create a persistant volume (here we will call it grafana-var)
3. Run the Docker image using: `docker run -v grafana-var:/var/lib/grafana -p 3000:3000/tcp --env URLS="https://github.com/;https://prometheus.io" jellebootsma/sitestatuschecker`
4. You can now access the grafana dashboard through http://localhost:3000. This can then be setup as desired. Settings will persist, as these are stored in /var/lib/grafana
5. To read the data from grafana, you need to add a prometheus datasource with the address localhost:9090.


## Suggested grafana setup

After adding the datasource, a dashboard is still required.\
I suggest creating a new dashboard, with a single fullscreen panel of the `stat` type.\
Then you should set the query to `probe_success`, which should result in the sites set up in the `URLS` environment variable, showing up in the panel. Here a 1 indicates a successful connection, and a zero indicating a failure to connect. \
When looking in the 'Stat styles' submenu in the options, you can change the colour mode to 'Background', so that the entire rectangle belonging to a site indicates the status.\
Under 'Thresholds', you should set the upper threshold to 1, and change its colour to green, while changing the base colour to red.

Finally, under the 'Transform' tab, you should add two transformations. First a 'Labels to fields' transformation, with the value set to `instance`.\
The other transformation is a Rename by regex. Here you can add regex to transform the text shown with the status.

Regex to select subdomain: Match : `.*//([^\.]+)\..+`; Replace : `$1`   (e.g. https://hub.docker.com -> hub)\
Regex to remove http or https: Match : `.*//(.+)`; Replace : `$1`       (e.g. https://hub.docker.com -> hub.docker.com)


## Further steps:
Grafana is a very powerful monitoring system, and there are too many options to go over in a short README. One of the useful systems which I quickly want to mention is alerts, as getting notified when one of your sites goes down can be extremely useful. [Read more on the grafana website](https://grafana.com/docs/grafana/latest/alerting/).\
As this container is based on the Grafana-8.0.6 container, guides for that container should translate 1-to-1. If you encounter a situation where this is not the case, you can always open an [issue](https://github.com/JelleBootsma/SiteStatusChecker/issues)

## Note:
After startup, it could take a short while before grafana starts recieving data from prometheus. This is normal, and should resolve itself after about a minute.
