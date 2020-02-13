#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

LAT_V="$(curl -s curl -s https://www.teamxlink.co.uk/connector/versionQuery.php?plain | grep version | cut -d '=' -f2)"
CUR_V="$(find ${DATA_DIR} -name installedv_* | cut -d "_" -f2)"
DL_URL="$(curl -s https://www.teamxlink.co.uk/connector/versionQuery.php?plain | grep platform-linux-x86-localconf | cut -d '=' -f2)"

echo "---Checking if XLink Kai is installed and up-to-date---"
if [ ! -f ${DATA_DIR}/kaiengine ]; then
	echo "---XLink Kai not installed, downloading---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll "$DL_URL" ; then
		echo "---Successfully downloaded XLink Kai---"
	else
		echo "---Can't download XLink Kai, putting server into sleep mode...---"
        sleep infinity
	fi
else
	
fi

echo "---Checking if 'kaiengine.conf' is present---"
if [ ! -f ${DATA_DIR}/kaiengine.conf ]; then
	echo "---Configuration file not found, downloading---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/docker-xlink-kai-evolution/raw/master/kaiengine.conf ; then
		echo "---Successfully downloaded 'kaiengine.conf'---"
	else
		echo "---Can't download 'kaiengine.conf', putting server into sleep mode...---"
        sleep infinity
	fi
fi

echo "---Setting interface to: ${INTERFACE_NAME}---"
sed -i '/kaiAdapter=/c\kaiAdapter='${INTERFACE_NAME}'' "${DATA_DIR}/kaiengine.conf"

echo "---Preparing Server---"
chmod -R 777 ${DATA_DIR}

echo "---Starting XLink Kai---"
cd ${DATA_DIR}
while true; do
	sudo ${DATA_DIR}/kaiengine
    echo "---KaiEngine crashed respawning---"
	sleep 5
done