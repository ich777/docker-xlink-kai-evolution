#!/bin/bash
while true
do
	if ! pgrep kaiengine >/dev/null ; then
		kill "$(pidof tail)"
		exit 0
	fi
	sleep 5
done