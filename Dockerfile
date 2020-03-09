FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install --no-install-recommends sudo libc6:i386 libstdc++6:i386 libgcc-8-dev:i386 curl && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/xlinkkaievolution"
ENV INTERFACE_NAME="eth0"
ENV EXTRA_PARAMS=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="xlinkkai"


RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	echo "$USER ALL=(root) NOPASSWD:${DATA_DIR}/kaiengine" >> /etc/sudoers && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
COPY /services /etc/services
RUN chmod -R 770 /opt/scripts/

EXPOSE 34522

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]