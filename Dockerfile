FROM node:9-stretch
MAINTAINER Rong Zhou <bachue.shu@gmail.com>

EXPOSE 80
RUN echo 'deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib' > /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -qy --no-install-recommends vim tmux less locales wget sudo && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN useradd -d /home/term -m -s /bin/bash term && \
    adduser term sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo 'term:term' | chpasswd
WORKDIR /home/term
VOLUME /home/term/data
ADD tmux.conf .tmux.conf

ADD wetty /wetty

RUN cd /wetty && npm config set registry https://registry.npm.taobao.org && npm install
CMD ["/bin/bash", "-c", "cd /wetty && node app.js -p 80"]
