FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install --no-install-recommends sudo libc6:i386 libstdc++6:i386 libgcc-8-dev:i386 && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/xlinkkaievolution"
ENV INTERFACE_NAME="eth0"
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID xlinkkai && \
	chown -R xlinkkai $DATA_DIR && \
	echo "xlinkkai ALL=(root) NOPASSWD:${DATA_DIR}/kaiengine_x86" >> /etc/sudoers && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
COPY /services /etc/services
COPY /kaiengine.conf ${DATA_DIR}/kaiengine.conf
COPY /kaiengine_x86 ${DATA_DIR}/kaikaiengine_x86
RUN chmod -R 770 /opt/scripts/ && \
	chown -R xlinkkai /opt/scripts

USER xlinkkai

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]