#!/bin/sh

DRIVE_PATH=/mnt/gdrive
PUID=${PUID:-0}
PGID=${PGID:-0}

if [ -e "/config/gdrive" ]; then
	echo "existing google-drive-ocamlfuse config found"
else
	if [ -z "${CLIENT_ID}" ]; then
	    echo "no CLIENT_ID found -> EXIT"
	    exit 1
	elif [ -z "${CLIENT_SECRET}" ]; then
	    echo "no CLIENT_SECRET found -> EXIT"
	    exit 1
	elif [ -z "$VERIFICATION_CODE" ]; then
	    echo "no VERIFICATION_CODE found -> EXIT"
	    exit 1
	else
		echo "initilising google-drive-ocamlfuse..."
		echo "${VERIFICATION_CODE}" | \
			s6-setuidgid ${PUID}:${PGID} google-drive-ocamlfuse -headless -id "${CLIENT_ID}.apps.googleusercontent.com" -secret "${CLIENT_SECRET}" -config /config/gdrive
	fi
fi

echo "mounting at ${DRIVE_PATH}"
s6-setuidgid ${PUID}:${PGID} google-drive-ocamlfuse "${DRIVE_PATH}" -config /config/gdrive
tail -f /dev/null & wait