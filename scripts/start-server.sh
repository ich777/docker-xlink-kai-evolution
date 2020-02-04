#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Sleep zZz---"
sleep infinity

cd ${DATA_DIR}
wget -q -nc --show-progress --progress=bar:force:noscroll "${DL_URI}"
tar -xvf kaiEngine*
rm -R kaiEngine*.tar.gz
cd kaiEngine*
mv * ${DATA_DIR}
cd ${DATA_DIR}
rm -R kaiEngine-*

while true; do
	${DATA_DIR}/kaiengine
    echo "---KaiEngine crashed respawning---"
	sleep 5
done