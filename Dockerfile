FROM ubuntu:14.10
MAINTAINER Vytautas Astrauskas "vastrauskas@gmail.com"

RUN apt-get update && \
    apt-get install -y wget build-essential byacc && \
    apt-get install -y tk tcl graphviz

RUN wget -c http://spinroot.com/spin/Src/spin643.tar.gz -O /tmp/spin.tar.gz && \
    mkdir -p /tmp/spin_src && \
    tar -xvf /tmp/spin.tar.gz -C /tmp/spin_src && \
    cd /tmp/spin_src/Spin/Src* && make && cp spin /usr/bin/ && \
    cd /tmp/spin_src/Spin/iSpin && /bin/sh install.sh && \
    cd /home && \
    apt-get clean && \
    rm -rf /tmp/*

RUN mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/bin/ispin
