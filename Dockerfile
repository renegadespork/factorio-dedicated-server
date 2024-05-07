FROM ubuntu:latest

LABEL maintainer="thekraken8him"

ENV TIMEZONE=America/Los_Angeles \
    PUID=0 \
    PGID=0 \
    MAP_NAME=new-map \
    SERVER_NAME="Jellie Frontier Server" \
    DESCRIPTION="This is a containerized Factorio server deployed from the Jellie Frontier." \
    PUBLIC=true \
    STEAM=true \
    LAN=true \
    MAX_PLAYERS=0 \
    PASSWORD= \
    WHITELIST=false

EXPOSE 34197/udp

RUN apt-get update
RUN apt-get install software-properties-common apt-transport-https curl -y

RUN mkdir /server
RUN mkdir /saves
RUN mkdir /config

# Download / Install latest dedicated server binary
RUN curl -L --max-redirs 1 "https://factorio.com/get-download/stable/headless/linux64" -o /server/factorio-dedicated-server.tar.xz && \
    tar -xf /server/factorio-dedicated-server.tar.xz -C /server && \
    rm /server/factorio-dedicated-server.tar.xz

# Organize config files
RUN sed -i 's/__PATH__executable__\/..\/..\/config/\/config/g' /server/factorio/config-path.cfg
RUN cp /server/factorio/data/server-settings.example.json /config/server-settings.json

COPY server.sh server.sh
COPY configure-server.sh configure-server.sh
COPY logo.txt logo.txt

RUN chmod +x server.sh
RUN chmod +x configure-server.sh

CMD ["/bin/bash", "server.sh"]