FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

ENV DATA_DIR="/xlinkkaievolution"
EVN DL_URI="https://cdn.teamxlink.co.uk/binary/kaiEngine-7.4.34-rev789.headless.el6.i686.tar.gz"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID xlinkkai && \
	chown -R xlinkkai $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R xlinkkai /opt/scripts

USER xlinkkai

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]