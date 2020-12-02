#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Usage: ./migrate_mongodb.sh [sourceHost sourceDB targetHost mongoversion environment]"
    echo "No variable provided from command line, please enter manually with prompt"
else
    sourceHost=$1
    sourceDB=$2
    targetHost=$3
    mongoversion=$4
    environment=$5
fi

[ -z "$sourceHost" ] && read -p 'Please enter source host:' sourceHost
[ -z "$sourceDB" ] && read -p 'Please enter source DB name:' sourceDB
[ -z "$targetHost" ] && read -p 'Please enter target host:' targetHost
[ -z "$mongoversion" ] && read -p 'Please enter mongo DB version(default 4.0):' mongoversion
[ -z "$environment" ] && read -p 'Please enter development envrionment(default dev):' environment

[ -z "$sourceHost" ] && { echo "source host not given" ; exit 1; }
[ -z "$sourceDB" ] && { echo "source DB name not given" ; exit 1; }
[ -z "$targetHost" ] && { echo "target host not given" ; exit 1; }

mongoversion=${mongoversion:-4.0}
environment=${environment:-dev}

datetime=$(date '+%Y%m%d')
localPath="${environment}backup-${datetime}"
restorePath="${localPath}/${sourceDB}"
targetDB="${sourceDB}-copy-${datetime}"
dump="mongodump -h $sourceHost -d $sourceDB -o $localPath"
restore="mongorestore -h $targetHost -d $targetDB $restorePath"
mongoContainer="sudo docker run --rm -v $(pwd):/workdir/ -w /workdir/ -u $(id -u) mongo:$mongoversion"
echo "$mongoContainer $dump; $restore;"
$mongoContainer $dump; $restore;

echo 'success dump'
