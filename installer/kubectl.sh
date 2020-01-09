#!/bin/bash
# Main installer script

BASE_DIR=~/
LOG_DIR=${BASE_DIR}digikube-logs/
INSTALLER_LOG=${LOG_DIR}digikube-installer.log
DIGI_DIR=${BASE_DIR}digikube/

. ${DIGI_DIR}utility/download-file.sh
. ${DIGI_DIR}utility/parse-yaml.sh

KUBECTL_TARGET_VERSION="1.15"
KUBECTL_BINARY_URL="https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_TARGET_VERSION.0/bin/linux/amd64/kubectl"

KUBECTL_CUR_PATH=$(which kubectl)

if [[ -z ${KUBECTL_CUR_PATH} ]]; then
    #Kubectl not available.  Download and install
    download_file $KUBECTL_BINARY_URL kubectl_binary
    
    if [[ -z ${kubectl_binary} ]]; then
        echo "Not able to get handle on downloaded file."
    else
        echo "Downloaded kubectl binary at $kubectl_binary"
        chmod +x $kubectl_binary
        $kubectl_binary version
    fi
    
else
    echo "Kubectl binary already available. Location: ${KUBECTL_CUR_PATH}"
    eval $(parse_yaml <( kubectl version -o yaml ) "KUBECTL_CUR_")
    f=$KUBECTL_CUR_clientVersion_minor
    t="+"
    s=""
    [ "${f%$t*}" != "$f" ] && n="${f%$t*}$s${f#*$t}"
    KUBECTL_CUR_clientVersion_minor=$n

    KUBECTL_CUR_VERSION=$KUBECTL_CUR_clientVersion_major.$KUBECTL_CUR_clientVersion_minor
    if [[ "$KUBECTL_CUR_VERSION" = "$KUBECTL_TARGET_VERSION" ]]; then
        echo "Kubectl version is ${KUBECTL_CUR_VERSION}.  Skipping kubectl installation."
        echo "7"
        exit 0
    else
        echo "Kubectl version is ${KUBECTL_CUR_VERSION}.  Required version is ${KUBECTL_TARGET_VERSION}.  Aborting kubectl installation.  Please remove the old version and rerun the installation."
        echo "8"
        exit 1
    fi 
fi