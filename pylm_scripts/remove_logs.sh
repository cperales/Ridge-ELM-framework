if [ -e "nohup.out" ]; then rm honup.out; fi
if [ -e "logs/worker.out" ] ; then rm logs/worker.out; fi
if [ -e "logs/server.out" ] ; then rm logs/server.out; fi
rm logs/client/*.out
