#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Sleep zZz---"
sleep infinity

echo "---Checking if XLink Kai is installed---"
if [ ! -f ${DATA_DIR}/kaiengine_x86 ]; then
	echo "---XLink Kai not installed, downloading---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll "${DL_URI}" ; then
		echo "---Successfully downloaded XLink Kai---"
	else
		echo "---Can't download XLink Kai, putting server into sleep mode...---"
        sleep infinity
	fi
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



echo "---Preparing Server---"
chmod -R 777 ${DATA_DIR}

echo "---Starting XLink Kai---"
cd ${DATA_DIR}
while true; do
	sudo ${DATA_DIR}/kaiengine_x86
    echo "---KaiEngine crashed respawning---"
	sleep 5
done