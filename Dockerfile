FROM ubuntu:trusty-20180112
MAINTAINER Erwin "m9207216@gmail.com"

#RUN linux32 sed -i 's/archive.ubuntu.com/ubuntu.stu.edu.tw/g' /etc/apt/sources.list
RUN linux32 sed -i 's/archive.ubuntu.com/free.nchc.org.tw/g' /etc/apt/sources.list

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends

#https://source.android.com/setup/build/initializing
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y git-core gnupg flex bison \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gperf build-essential zip \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl zlib1g-dev gcc-multilib g++-multilib \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y lib32z-dev ccache \ 
 && DEBIAN_FRONTEND=noninteractive apt-get install -y libgl1-mesa-dev libxml2-utils xsltproc unzip

#i.MX_Android_Extended_Codec_Release_Notes.pdf
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y uuid uuid-dev \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y liblz-dev \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y liblzo2-2 liblzo2-dev \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y lzop \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y u-boot-tools \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mtd-utils \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y android-tools-fsutils \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y device-tree-compiler \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gdisk

#build patch
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y vim.tiny \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y python \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bsdiff\
 && DEBIAN_FRONTEND=noninteractive apt-get install -y libswitch-perl \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bc \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y rsync

#install openjdk
RUN mkdir -p /opt/tmp
ADD openjdk-8-jre_8u45-b14-1_amd64.deb /opt/tmp
ADD openjdk-8-jdk_8u45-b14-1_amd64.deb /opt/tmp
ADD openjdk-8-jre-headless_8u45-b14-1_amd64.deb /opt/tmp

#..openjdk-8-jre-headless_8u45-b14-1_amd64.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libnss3 libnspr4 libnss3-nssdb openssl ca-certificates ca-certificates-java java-common libcups2 liblcms2-2 libjpeg8 libfreetype6 libpcsclite1 libxi6 x11-common libxrender1 libxtst6
RUN dpkg -i /opt/tmp/openjdk-8-jre-headless_8u45-b14-1_amd64.deb

#..openjdk-8-jre_8u45-b14-1_amd64.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libatk1.0-data  libatk1.0-0 libpixman-1-0 libxcb-shm0 libcairo2 libjasper1 libjbig0 libtiff5 libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0 libpixman-1-0 libxcb-shm0 libcairo2 libgraphite2-3 libharfbuzz0b fontconfig libthai-data libdatrie1 libthai0 libpango-1.0-0 libpangoft2-1.0-0 libpangoft2-1.0-0 libgtk2.0-common libxcomposite1 libxcursor1 libxinerama1 libxrandr2 shared-mime-info libgtk2.0-0 libatk-wrapper-java  libatk-wrapper-java-jni libpangocairo-1.0-0 libasound2 libgif4 libasound2-data
RUN dpkg -i /opt/tmp/openjdk-8-jre_8u45-b14-1_amd64.deb

RUN dpkg -i /opt/tmp/openjdk-8-jdk_8u45-b14-1_amd64.deb

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /opt/tmp

#for zlib.so.1
# && DEBIAN_FRONTEND=noninteractive apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 \
#kernel mkimage
# && rm -rf /var/lib/apt/lists/*
#fix zconf.h error
#RUN ln -s /usr/include/x86_64-linux-gnu/zconf.h /usr/include
# All builds will be done by user aosp

COPY gitconfig /root/.gitconfig
COPY ssh_config /root/.ssh/config

#bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
VOLUME ["/mnt/aosp", "/mnt/ssd1", "/mnt/ssd2"]
WORKDIR /mnt/aosp
COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
RUN chmod +x /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
