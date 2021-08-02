FROM debian:10-slim

RUN apt-get update

RUN apt-get upgrade

RUN apt-get install -y adduser libfontconfig1 wget


RUN mkdir /usr/share/ca-certificates/letsencrypt.org

WORKDIR /usr/share/ca-certificates/letsencrypt.org

RUN wget https://letsencrypt.org/certs/isrgrootx1.pem

RUN update-ca-certificates

WORKDIR /app

COPY . .

RUN dpkg -i grafana_8.0.6_amd64.deb



EXPOSE 3000

CMD [ "./run.sh" ]