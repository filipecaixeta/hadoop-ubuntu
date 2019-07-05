#!/bin/bash
service ssh restart
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts
start-all.sh
hdfs dfsadmin -safemode leave
cd /workspace && jupyter lab --ip=0.0.0.0 --NotebookApp.token='' --allow-root
# if [[ $1 == "-d" ]]; then
#   while true; do sleep 1000; done
# fi

# if [[ $1 == "-bash" ]]; then
#   /bin/bash
# fi
