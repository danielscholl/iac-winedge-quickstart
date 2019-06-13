#!/usr/bin/env bash
#
#  Purpose: Initialize the environment
#  Usage:
#    deploy.sh

###############################
## ARGUMENT INPUT            ##
###############################
usage() { echo "Usage: deploy.sh <hub> <device>" 1>&2; exit 1; }

if [ -z $1 ] ; then usage; else IOT_HUB=$1; fi
if [ -z $2 ] ; then usage; else DEVICE=$2; fi
if [ -z $3 ] ; then MANIFEST='deployment.json'; else MANIFEST=$3; fi

echo "Deploying modules to ${DEVICE}"

az iot edge set-modules \
  --device-id ${DEVICE} \
  --hub-name ${IOT_HUB} \
  --content ${MANIFEST}
