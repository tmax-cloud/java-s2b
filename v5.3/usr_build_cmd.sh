#!/bin/bash

# git clone
git config --global http.sslVerify false
echo "{GIT_REPO}"
git clone {GIT_REPO} /root/gitRepo
cd /root/gitRepo

# build
{USR_BUILD_CMD}

