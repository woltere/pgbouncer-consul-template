FROM ubuntu:14.04

MAINTAINER Wolter Eldering <woltere@xs4all.nl>

RUN (echo "deb http://archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse" > /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list && echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse" >> /etc/apt/sources.list)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install wget && \
    wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get -y install pgbouncer

RUN apt-get update && \
	apt-get install -y curl unzip && \
	curl -o /tmp/consul-template_0.14.0_linux_amd64.zip  https://releases.hashicorp.com/consul-template/0.14.0/consul-template_0.14.0_linux_amd64.zip && \
	unzip /tmp/consul-template_0.14.0_linux_amd64.zip -d /usr/local/bin/ && \
	rm /tmp/consul-template_0.14.0_linux_amd64.zip  && \
    apt-get install -y pgbouncer    

ADD pgbouncer.ini.template /etc/pgbouncer/
ADD users.txt /etc/pgbouncer/

EXPOSE 6432

CMD ["/usr/local/bin/consul-template", "-wait=5s:10s", "-consul=192.168.99.100:8500", "-template=/etc/pgbouncer/pgbouncer.ini.template:/tmp/pgbouncer.ini:/usr/sbin/pgbouncer -d -R -u postgres /tmp/pgbouncer.ini"]
