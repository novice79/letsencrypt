FROM ubuntu:latest
MAINTAINER david <david@cninone.com>

RUN apt-get update && apt-get install -y software-properties-common python-software-properties openssh-server supervisor git
RUN mkdir /var/run/sshd /letsencrypt
RUN echo 'root:freego' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN cd /letsencrypt && git clone https://github.com/letsencrypt/letsencrypt && letsencrypt/letsencrypt-auto

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22

CMD ["/usr/bin/supervisord"]