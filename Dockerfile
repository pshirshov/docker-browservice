FROM ubuntu:hirsute
#RUN pacman -Sy
#RUN pacman -S --noconfirm wget



ENV DEBIAN_FRONTEND noninteractive

#RUN echo "APT::Acquire::Queue-Mode "access"; APT::Acquire::Retries 3; " > /etc/apt/apt.conf.d/99parallel && \


RUN apt-get update && apt-get -y --no-install-recommends install build-essential cmake wget tzdata ca-certificates
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

RUN wget -c https://github.com/ttalvitie/browservice/archive/refs/tags/v0.9.2.0.tar.gz -O - | tar -xz
WORKDIR browservice-0.9.2.0

RUN ./download_cef.sh
RUN apt-get install -y --no-install-recommends xauth xvfb libpango1.0-dev python fakeroot libxcursor-dev libjpeg-turbo8-dev libcups2-dev libnss3-dev libxrandr-dev libxcursor-dev libxss-dev libxcomposite-dev libgtk2.0-dev libpoco-dev libgtkglext1-dev libcups2-dev libatk-bridge2.0-dev libasound2-dev libatspi2.0-dev  libxkbcommon-dev
RUN apt-get clean -y

RUN ./setup_cef.sh

RUN make -j8

RUN chown root:root release/bin/chrome-sandbox && chmod 4755 release/bin/chrome-sandbox

RUN apt-get install -y --no-install-recommends software-properties-common curl
RUN apt-add-repository multiverse
RUN apt-get update
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
ADD localfonts.conf /etc/fonts/local.conf
RUN fc-cache -f -v

RUN useradd browser -m
USER browser

CMD ["release/bin/browservice", "--vice-opt-http-listen-addr=0.0.0.0:8080", "--data-dir=/session"]

