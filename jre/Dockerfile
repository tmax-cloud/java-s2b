# Dockerfile_s2b image
FROM alpine:latest

# install some tools
RUN apk add --no-cache unzip bash procps

# copy files from local
COPY start.sh /root/start.sh
COPY usr_run_cmd.sh /root/usr_run_cmd.sh
WORKDIR /root/

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
