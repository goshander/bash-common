#!/bin/bash

# requred GitHub CLI tool: https://cli.github.com/
# need auth: gh auth login

ORG_LIST="${1}"
BACKUP_FOLDER="./backup"
CURRENT_FOLDER=$(pwd)

for ORG in ${ORG_LIST}; do
    echo ""
    echo "check org: ${ORG}"
    if [ "${ORG}" = "_self_" ]; then
        ORG=""
    fi

    REPO_LIST=$(gh repo list -L 1000 "${ORG}" --json 'sshUrl' --jq '.[] | .sshUrl')

    for REPO in ${REPO_LIST}; do
        REPO_NAME=""
        IFS='/' read -ra REPO_SPLIT <<<"$REPO"
        for SEED in "${REPO_SPLIT[@]}"; do
            REPO_NAME="${SEED}"
        done

        cd "${CURRENT_FOLDER}"
        echo "backup repo: ${REPO_NAME}"

        REPO_FOLDER="${BACKUP_FOLDER}/${REPO_NAME}"
        rm -rf "${REPO_FOLDER}"
        rm -rf "${REPO_FOLDER}.zip"

        git clone "${REPO}" "${REPO_FOLDER}" && cd "${REPO_FOLDER}" && rm -rf .git && zip -r -9 "../${REPO_NAME}.zip" * .[^.]*
        cd "${CURRENT_FOLDER}" && rm -rf "${REPO_FOLDER}"
    done
done

export $(cat .env | grep S3_BUCKET)
export $(cat .env | grep S3_ENDPOINT)
export $(cat .env | grep AWS_ACCESS_KEY_ID)
export $(cat .env | grep AWS_SECRET_ACCESS_KEY)
export $(cat .env | grep AWS_DEFAULT_REGION)

aws --endpoint-url="${S3_ENDPOINT}" s3 sync --delete "${BACKUP_FOLDER}" "s3://${S3_BUCKET}/"
cd "${CURRENT_FOLDER}" && rm -rf "${BACKUP_FOLDER}/*.zip"
