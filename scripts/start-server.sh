#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

LAT_V="$(curl -s curl -s https://www.teamxlink.co.uk/connector/versionQuery.php?plain | grep version | cut -d '=' -f2)"
CUR_V="$(find ${DATA_DIR} -name installedv_* | cut -d "_" -f2)"
DL_URL="$(curl -s https://www.teamxlink.co.uk/connector/versionQuery.php?plain | grep platform-linux-x86-localconf | cut -d '=' -f2)"

echo "---Checking if XLink Kai is installed and up-to-date---"
if [ -z $DL_URL ]; then
	echo "---Can't get download URL, putting server into sleep mode---"
    sleep infinity
else
	if [ ! -f ${DATA_DIR}/kaiengine ]; then
		echo "---XLink Kai not installed, downloading---"
		cd ${DATA_DIR}
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O kaiengine.tar.gz "$DL_URL" ; then
			echo "---Successfully downloaded XLink Kai---"
		else
			echo "---Can't download XLink Kai, putting server into sleep mode...---"
	        sleep infinity
		fi
        tar -xvf ${DATA_DIR}/kaiengine.tar.gz
        cd kaiEngine-*
        mv ${DATA_DIR}/kaiEngine-*/* ${DATA_DIR}/
        cd ${DATA_DIR}
		rm ${DATA_DIR}/kaiengine.tar.gz
        rm -R ${DATA_DIR}/kaiEngine-*
		touch ${DATA_DIR}/installedv_$LAT_V
        CUR_V="$(find ${DATA_DIR} -name installedv_* | cut -d "_" -f2)"
	else
		if [ ! -z $LAT_V ]; then
			if [ "$LAT_V" != "$CUR_V" ]; then
		    	echo "---Version missmatch currently installed: v$CUR_V, installing: v$LAT_V---"
                rm ${DATA_DIR}/README
                rm ${DATA_DIR}/kaiengine
                rm ${DATA_DIR}/runvorever.sh
                rm ${DATA_DIR}/installedv_*
                cd ${DATA_DIR}
          		if wget -q -nc --show-progress --progress=bar:force:noscroll -O kaiengine.tar.gz "$DL_URL" ; then
					echo "---Successfully downloaded XLink Kai---"
				else
					echo "---Can't download XLink Kai, putting server into sleep mode...---"
	        		sleep infinity
				fi
                tar -xvf ${DATA_DIR}/kaiengine.tar.gz
            	cd kaiEngine-*
            	mv ${DATA_DIR}/kaiEngine-*/* ${DATA_DIR}/
            	cd ${DATA_DIR}
				rm ${DATA_DIR}/kaiengine.tar.gz
            	rm -R ${DATA_DIR}/kaiEngine-*
				touch ${DATA_DIR}/installedv_$LAT_V
			else
            	echo "---You are currently running the latest version: v$LAT_V---"
			fi
		else
        	echo "---Can't get the latest version number, continuing...---"
		fi
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