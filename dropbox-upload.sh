#!/bin/bash

BEARER_TOKEN="..."

curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: ${BEARER_TOKEN}" \
    --header "Dropbox-API-Arg: {\"path\": \"/dropbox.sh\",\"mode\": \"overwrite\",\"mute\": false,\"strict_conflict\": false}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @${1}
