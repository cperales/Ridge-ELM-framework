#!/usr/bin/env bash
sudo kill $(ps aux | grep 'pylm_scripts/worker.py' | awk '{print $2}')
sudo kill $(ps aux | grep 'pylm_scripts/server.py' | awk '{print $2}')
sudo kill $(ps aux | grep 'pylm_scripts/client.py' | awk '{print $2}')
sudo kill $(ps aux | grep 'MATLAB' | awk '{print $2}')
