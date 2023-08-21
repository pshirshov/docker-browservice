FROM ubuntu:jammy
# ARG V_BROWSERVICE

ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update && \
    apt-get -y --no-install-recommends install wget tzdata ca-certificates && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y --no-install-recommends software-properties-common curl && \
    apt-add-repository multiverse && \
    apt-get update && \
    echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections && \
    apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer

ADD localfonts.conf /etc/fonts/local.conf
RUN fc-cache -f -v

RUN apt-get clean -y

ARG V_BROWSERVICE
ENV BROWSERVICE_V=${V_BROWSERVICE}
RUN wget -c https://github.com/ttalvitie/browservice/releases/download/v${BROWSERVICE_V}/browservice-v${BROWSERVICE_V}-x86_64.AppImage -O browservice.appimage && \
    chmod +x ./browservice.appimage && \
    ./browservice.appimage --appimage-extract && \
    rm browservice.appimage && \
    chmod 4755 /squashfs-root/opt/browservice/chrome-sandbox

VOLUME /session

WORKDIR /session



CMD [ "/squashfs-root/AppRun", "--chromium-args=--no-sandbox", "--vice-opt-http-listen-addr=0.0.0.0:80", "--data-dir=/session" ]

