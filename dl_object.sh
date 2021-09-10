#!/usr/bin/env bash
CONTAINER_NAME="${1}"
ITEM_LOOKING_FOR="${2}"
LOCATION="${2}"

function main () {

    set -- "${@}";

    RES=$(
        if [ "$(./list-containers "${CONTAINER_NAME}" | \
        grep -c "${ITEM_LOOKING_FOR}")" -eq 1 ]; then \
        ./list-containers "${CONTAINER_NAME}" | \
        grep "${ITEM_LOOKING_FOR}" | \
        cut -d '=' -f2 | \
        cut -d ',' -f1 | \
        sed 's/^ //g'; elif \
            [ "$(./list-containers "${CONTAINER_NAME}" | \
        grep -c "${ITEM_LOOKING_FOR}")" -eq 0 ]; then
            printf "ERROR => item '%s' not found\n" "${ITEM_LOOKING_FOR}"; elif \
            [ "$(./list-containers "${CONTAINER_NAME}" | \
        grep -c "${ITEM_LOOKING_FOR}")" -gt 1 ]; then
            printf "ERROR => items corresponding to pattern '%s' are greater than 1. Please looking a more precise pattern\n" "${ITEM_LOOKING_FOR}"; \
        fi
    )
    printf 'found %s\n' "${RES}"

    printf 'Downloading resource ...\n'
    sshpass -p "${OS_TENANT_NAME}.${OS_USERNAME}.${OS_PASSWORD}" scp pca@gateways.storage.gra.cloud.ovh.net:"${CONTAINER_NAME}"/"${RES}" "${LOCATION}"
    mv ${ITEM_LOOKING_FOR} ${ITEM_LOOKING_FOR}.mkv
}

main "${@}"