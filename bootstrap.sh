#!/bin/bash
service ssh restart
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts
/sbin/start-dfs.sh
/sbin/start-yarn.sh
/sbin/mr-jobhistory-daemon.sh start historyserver

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
