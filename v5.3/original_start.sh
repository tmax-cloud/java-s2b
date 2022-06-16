# start.sh
#!/bin/bash
cd /secret

if [ ! -d gitRepo ]; then
    cd /root
    # java : 9, 10, 11, 12, 13, 14, 15, 16, 17
    echo "install java ${JDK_VERSION} . . . "
    echo " "
    apk --no-cache add openjdk${JDK_VERSION} --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community 1>/dev/null
    echo "java ${JDK_VERSION} installation is done"
    echo " " 
    # maven
    echo "install maven ${MVN_VERSION} . . ."
    echo " "
    export MAJ_VERSION=$(echo ${MVN_VERSION} | cut -c 1)
    if [ "${MAJ_VERSION}" == "3" ]; then
        wget -O /root/apache-maven-${MVN_VERSION}.tar.gz https://archive.apache.org/dist/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz -q
        tar -xf /root/apache-maven-${MVN_VERSION}.tar.gz -C /opt 1>/dev/null
        ln -s /opt/apache-maven-${MVN_VERSION} /opt/maven
    elif [ "${MAJ_VERSION}" == "2" ]; then
        wget -O /root/apache-maven-${MVN_VERSION}.tar.gz https://archive.apache.org/dist/maven/maven-2/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
        tar -xf /root/apache-maven-${MVN_VERSION}.tar.gz -C /opt
        ln -s /opt/apache-maven-${MVN_VERSION} /opt/maven
    else    
	wget -O /root/apache-maven-${MVN_VERSION}.tar.gz https://archive.apache.org/dist/maven/maven-1/${MVN_VERSION}/binaries/maven-${MVN_VERSION}.tar.gz
        tar -xf /root/maven-${MVN_VERSION}.tar.gz -C /opt
        ln -s /opt/maven-${MVN_VERSION} /opt/maven
    fi
    echo "maven ${MVN_VERSION} installation is done"
    echo " "
    export M2_HOME=/opt/maven
    export MAVEN_HOME=/opt/maven
    export PATH=${MAVEN_HOME}/bin:${PATH}
    
    #gradle
    echo "install gradle ${GRADLE_VERSION} . . ."
    echo " "
    wget -O /root/gradle-${GRADLE_VERSION}.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -q
    unzip -d /opt /root/gradle-${GRADLE_VERSION}.zip 1>/dev/null
    mv /root/gradle-${GRADLE_VERSION}.zip /secret/gradle-${GRADLE_VERSION}.zip
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle
    echo "gradle ${GRADLE_VERSION} installation is done"
    echo " "
    export GD_HOME=/opt/gradle
    export GRADLE_HOME=/opt/gradle
    export PATH=${GD_HOME}/bin:${PATH}

    # git clone	
    if [ "${GITLAB_TOKEN_NAME}" == "" ] && [ "${GITHUB_ID}" == "" ]; then
        sed -i "s#{GIT_REPO}#${GIT_REPO}#g" /root/usr_build_cmd.sh
    elif [ "${GITLAB_TOKEN_NAME}" == "" ]; then
        sed -i 's/{"git-token":"//g' /secret/usr_secret
        sed -i 's/"}//g' /secret/usr_secret
        base64 -d /secret/usr_secret > /secret/usr_secret_decode
        export USR_SECRET=$( cat /secret/usr_secret_decode )
        export PRIVATE_REPO=$(echo ${GIT_REPO} | sed "s#https://#https://${GITHUB_ID}:${USR_SECRET}@#g")
        sed -i "s#{GIT_REPO}#${PRIVATE_REPO}#g" /root/usr_build_cmd.sh
    else
        sed -i 's/{"git-token":"//g' /secret/usr_secret
        sed -i 's/"}//g' /secret/usr_secret
        base64 -d /secret/usr_secret > /secret/usr_secret_decode
        export USR_SECRET=$( cat /secret/usr_secret_decode )
        export PRIVATE_REPO=$(echo ${GIT_REPO} | sed "s#https://#https://${GITLAB_TOKEN_NAME}:${USR_SECRET}@#g")
        sed -i "s#{GIT_REPO}#${PRIVATE_REPO}#g" /root/usr_build_cmd.sh
    fi

    # user build command
    echo "starting build the project . . ."
    echo " "
    sed -i "s#{USR_BUILD_CMD}#${USR_BUILD_CMD}#g" /root/usr_build_cmd.sh
    /bin/bash /root/usr_build_cmd.sh

    cp -r /root/gitRepo /secret
fi
