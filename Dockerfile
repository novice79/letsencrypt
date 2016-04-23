FROM ubuntu:latest
MAINTAINER david <david@cninone.com>
# for build nghttp2
RUN apt-get update && apt-get install -y g++ make binutils autoconf automake autotools-dev libtool pkg-config \
    zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev \
    libjemalloc-dev cython python3-dev python-setuptools
RUN cd / && git clone https://github.com/nghttp2/nghttp2.git && cd nghttp2 \
    && autoreconf -i && automake && autoconf && ./configure && make && make install && make clean
    
RUN  apt-get install -y software-properties-common python-software-properties openssh-server supervisor git \
    vim cron curl squid3 \
    && apt-get clean && apt-get autoclean && apt-get remove
RUN mkdir /var/run/sshd /var/log/lep
RUN echo 'root:freego' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN cd / && git clone https://github.com/letsencrypt/letsencrypt && letsencrypt/letsencrypt-auto --help
# Add crontab file in the cron directory
ADD crontab /etc/cron.d/gc-cron
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/gc-cron \
    && touch /var/log/cron.log

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY squid.conf /etc/squid3/squid.conf
EXPOSE 22 80 443

COPY init.sh /
ENTRYPOINT ["/init.sh"]