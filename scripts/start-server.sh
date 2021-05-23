#!/bin/bash
LAT_V="$(curl -s https://teamxlink.co.uk/api/v1/releases/legacy | jq '.' | grep 'version' | cut -d '"' -f4)"
CUR_V="$(find ${DATA_DIR} -name installedv_* | cut -d "_" -f2)"
DL_URL="$(curl -s https://teamxlink.co.uk/api/v1/releases/legacy | jq '.platforms.linux' | grep "headless.debian.armhf.tar.gz" | cut -d '"' -f4)"

echo "---Checking if XLink Kai is installed and up-to-date---"
if [ -z $DL_URL ]; then
	if [ -f ${DATA_DIR}/kaiengine ]; then
		echo "---'kaiengine' found but can't get download URL, continuning...---"
	else
    	echo "---Can't get download URL, putting server into sleep mode---"
		sleep infinity
	fi
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
        tar -C ${DATA_DIR} --strip-components=1 -xvf ${DATA_DIR}/kaiengine.tar.gz
		rm ${DATA_DIR}/kaiengine.tar.gz
		touch ${DATA_DIR}/installedv_$LAT_V
        CUR_V="$(find ${DATA_DIR} -name installedv_* | cut -d "_" -f2)"
	else
		if [ ! -z $LAT_V ]; then
			if [ "$LAT_V" != "$CUR_V" ]; then
		    	echo "---Version missmatch currently installed: v$CUR_V, installing: v$LAT_V---"
                rm ${DATA_DIR}/README
                rm ${DATA_DIR}/kaiengine
                rm ${DATA_DIR}/runforever.sh
                rm ${DATA_DIR}/installedv_*
                cd ${DATA_DIR}
          		if wget -q -nc --show-progress --progress=bar:force:noscroll -O kaiengine.tar.gz "$DL_URL" ; then
					echo "---Successfully downloaded XLink Kai---"
				else
					echo "---Can't download XLink Kai, putting server into sleep mode...---"
	        		sleep infinity
				fi
                tar -C ${DATA_DIR} --strip-components=1 -xvf ${DATA_DIR}/kaiengine.tar.gz
				rm ${DATA_DIR}/kaiengine.tar.gz
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
	echo "---Configuration file not found, creating---"
	cd ${DATA_DIR}
	${DATA_DIR}/kaiengine --writedefaultconfig
	sleep 2
	if [ ! -f ${DATA_DIR}/kaiengine.conf ]; then
		echo "---Can't create 'kaiengine.conf' putting server into sleep mode---"
		sleep infinity
	else
		echo "---Sucessfully created 'kaiengine.conf'---"
	fi
fi

echo "---Setting interface to: ${INTERFACE_NAME}---"
sed -i '/kaiAdapter=/c\kaiAdapter='${INTERFACE_NAME}'' "${DATA_DIR}/kaiengine.conf"

echo "---Setting UDP Port to: ${UDP_PORT}---"
sed -i '/kaiPort=/c\kaiPort='${UDP_PORT}'' "${DATA_DIR}/kaiengine.conf"

echo "---Preparing Server---"
echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;
chmod -R ${DATA_PERM} ${DATA_DIR}
screen -wipe 2&>/dev/null

echo "+-------------------------------------------------------------"
echo "|"
echo "| This container for ARM is deprecated and is no"
echo "| longer actively maintained or further developed!"
echo "|"
echo "|  Container will start in 60 seconds!"
echo "|"
echo "+-------------------------------------------------------------"
sleep 60

echo "---Starting XLink Kai---"
cd ${DATA_DIR}
screen -S XLinkKai -L -Logfile ${DATA_DIR}/masterLog.0 -d -m sudo ${DATA_DIR}/kaiengine --configfile ${DATA_DIR}/kaiengine.conf
sleep 2
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -f ${DATA_DIR}/masterLog.0