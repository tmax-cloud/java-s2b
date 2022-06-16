# Dockerfile_s2b image
FROM alpine:latest

# install some tools
RUN apk add --no-cache wget tar unzip bash procps git 

# copy files from local
COPY start.sh /root/start.sh
COPY usr_build_cmd.sh /root/usr_build_cmd.sh
WORKDIR /root/

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
