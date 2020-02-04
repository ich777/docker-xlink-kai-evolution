#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Sleep zZz---"
sleep infinity

cd ${DATA_DIR}

while true; do
	sudo ${DATA_DIR}/kaiengine_x86
    echo "---KaiEngine crashed respawning---"
	sleep 5
done