FROM ubuntu:latest
MAINTAINER david <david@cninone.com>

RUN apt-get update && apt-get install -y software-properties-common python-software-properties openssh-server supervisor git \
    vim cron curl \
    && apt-get clean && apt-get autoclean && apt-get remove
RUN mkdir /var/run/sshd
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
EXPOSE 22 80

COPY init.sh /
ENTRYPOINT ["/init.sh"]