#!/usr/bin/env bash

set -e

ARGS=${*}
CONTAINER_NAME="${1}"
ITEM_LOOKING_FOR="${2}"
LOCATION="${3:-.}"

if [ -f bin/list-containers ]; then
    PROJECT_BINARY=bin/list-containers; elif
[ -f bin/list-containers.x86-64 ]; then
    PROJECT_BINARY=bin/list-containers.x86-64
fi

function usage() {
  echo "Script for downloading cloud archive object with OpenStack Swift API"
  echo ""
  echo "USAGE: ./dl_object.sh <CONTAINER_NAME> <ITEM_LOOKING_FOR> <LOCATION>"
  echo "                      [-h=|--help]"
  echo "  Where:"
  echo "    CONTAINER_NAME    The name of cloud archive container. Must be 1st arg"
  echo "    ITEM_LOOKING_FOR  The item object string pattern who you are looking for in container. Must be 2nd arg"
  echo "    LOCATION          The destination of data retrieved. Must be 3rd arg"
  echo "    -h or --help      show help"
  echo " "
  exit
}

function processArgs() {
  if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    usage; else
    for i in $ARGS ; do
      case $i in
      -h|--help)
        usage
        ;;
      esac
    done
  fi
}

function main () {

    set -- "${@}";

    processArgs "${@}"

    RES=$(
        if [ "$(${PROJECT_BINARY} "${CONTAINER_NAME}" | \
        grep -c "${ITEM_LOOKING_FOR}")" -eq 1 ]; then \
        ${PROJECT_BINARY} "${CONTAINER_NAME}" | \
        grep "${ITEM_LOOKING_FOR}" | \
        cut -d '=' -f2 | \
        cut -d ',' -f1 | \
        sed 's/^ //g'; elif \
            [ "$(${PROJECT_BINARY} "${CONTAINER_NAME}" | \
        grep -c "${ITEM_LOOKING_FOR}")" -eq 0 ]; then
            printf "ERROR => item '%s' not found\n" "${ITEM_LOOKING_FOR}"; elif \
            [ "$(${PROJECT_BINARY} "${CONTAINER_NAME}" | \
        grep -c "${ITEM_LOOKING_FOR}")" -gt 1 ]; then
            printf "ERROR => items corresponding to pattern '%s' are greater than 1. Please looking a more precise pattern\n" \
            "${ITEM_LOOKING_FOR}"; \
        fi
    )
    printf 'found %s\n' "${RES}"

    printf 'Downloading resource ...\n'
    sshpass -p "${OS_TENANT_NAME}.${OS_USERNAME}.${OS_PASSWORD}" scp pca@gateways.storage.gra.cloud.ovh.net:"${CONTAINER_NAME}"/"${RES}" "${LOCATION}"
}

main "${@}"