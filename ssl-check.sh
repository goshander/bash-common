#!/bin/bash

echo "tls check start for [HOSTS]..."

for HOST in ${HOSTS}; do

  META="${HOST}"

  echo "${META}: check..." 1>&2

  # new by request method
  TLS_EXPIRED_DATE=$(openssl s_client -servername ${HOST} -connect ${HOST}:443 2>/dev/null <<< 'q\n' | openssl x509 -noout -enddate | cut -d= -f 2)

  TLS_EXPIRED_DATE=$(date -d "${TLS_EXPIRED_DATE}" +"%Y-%m-%d")
  
  TLS_STARTED_DATE=$(openssl s_client -servername ${HOST} -connect ${HOST}:443 2>/dev/null <<< 'q\n' | openssl x509 -noout -startdate | cut -d= -f 2)

  TLS_STARTED_DATE=$(date -d "${TLS_STARTED_DATE}" +"%Y-%m-%d")

  echo "EXP: ${TLS_EXPIRED_DATE} [${META}] ISS: ${TLS_STARTED_DATE}"
done | sort

echo ""
echo "[done] check completed"
