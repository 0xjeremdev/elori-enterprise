#!/bin/bash

case "$1" in 
serve)
   pm2 serve build 8084 --name "elroi" --spa
   ;;
start)
   pm2 start "elroi"
   ;;
stop)
   pm2 stop "elroi"
   ;;
delete)
   pm2 delete "elroi"
   ;;
*)
   echo "Usage: $0 {serve|start|stop|delete}"
esac

exit 0 
