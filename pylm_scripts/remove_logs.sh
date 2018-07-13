if [ -d "nohup.out" ]; then rm honup.out; fi
if [ -d "logs/worker.out" ] ; then rm logs/worker.out; fi
if [ -d "logs/server.out" ] ; then rm logs/server.out; fi
rm logs/client/*.out
