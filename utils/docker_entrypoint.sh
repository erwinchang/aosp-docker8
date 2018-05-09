#!/bin/bash
set -e

#https://github.com/kylemanna/docker-aosp/blob/master/utils/docker_entrypoint.sh 

# Reasonable defaults if no USER_ID/GROUP_ID environment variables are set.
if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi

# ccache
export CCACHE_DIR=/mnt/aosp/ccache
export USE_CCACHE=1

msg="docker_entrypoint: Creating user UID/GID [$USER_ID/$GROUP_ID]" && echo $msg
groupadd -g $GROUP_ID -r aosp && \
useradd -u $USER_ID --create-home -r -g aosp aosp
echo "$msg - done"

cp /root/.gitconfig /home/aosp/.gitconfig
chown aosp:aosp /home/aosp/.gitconfig

mkdir -p /mnt/aosp/ccache /aosp
chown aosp:aosp /mnt/aosp/ccache /aosp
export HOME=/home/aosp
export USER=aosp
exec sudo -E -u aosp /bin/bash
