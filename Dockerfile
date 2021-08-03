FROM grafana/grafana:8.0.6

##RUN apt-get update

##RUN apt-get upgrade

##RUN apt-get install -y adduser libfontconfig1 wget


##RUN mkdir /usr/share/ca-certificates/letsencrypt.org

##WORKDIR /usr/share/ca-certificates/letsencrypt.org

##RUN wget https://letsencrypt.org/certs/isrgrootx1.pem

##RUN update-ca-certificates

USER 0

WORKDIR /app

RUN wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.19.0/blackbox_exporter-0.19.0.linux-amd64.tar.gz && \
    tar -zxvf blackbox_exporter-0.19.0.linux-amd64.tar.gz && \
    mv blackbox_exporter-0.19.0.linux-amd64 blackbox_exporter && \
    rm -f blackbox_exporter-0.19.0.linux-amd64.tar.gz && \
    wget https://github.com/prometheus/prometheus/releases/download/v2.28.1/prometheus-2.28.1.linux-amd64.tar.gz && \
    tar -zxvf prometheus-2.28.1.linux-amd64.tar.gz && \
    mv prometheus-2.28.1.linux-amd64 prometheus && \
    rm -f prometheus-2.28.1.linux-amd64.tar.gz && \
    rm -f /app/prometheus/prometheus.yml


COPY . .

RUN chown -R "grafana:$GF_GID_NAME" /app

RUN chmod -R 777 /app

EXPOSE 3000

USER "$GF_UID"

ENTRYPOINT [ "/app/run.sh" ]