# start.sh
#!/bin/bash

echo "running the project . . ."
echo " "
apk --no-cache add openjdk${JDK_VERSION} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community 1>/dev/null

#gradle
unzip -q -d /root /secret/gradle-${GRADLE_VERSION}.zip
ln -s /root/gradle-${GRADLE_VERSION} /root/gradle
export GD_HOME=/root/gradle
export GRADLE_HOME=/root/gradle
export PATH=${GD_HOME}/bin:${PATH}

# user run command
sed -i "s#{USR_RUN_CMD}#${USR_RUN_CMD}#g" /root/usr_run_cmd.sh
/bin/bash /root/usr_run_cmd.sh

