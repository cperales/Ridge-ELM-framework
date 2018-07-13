#!/bin/bash

nohup python pylm_scripts/server.py &> logs/server.out&
echo Server up!
counter=0
maxcount=$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l)
#((maxcount--))
while [ $counter -lt $maxcount ]
do
	((counter++))
	nohup python pylm_scripts/worker.py &> logs/worker_$counter.out&
done
echo $counter workers up!
