!/usr/bin/env bash

# This sshs into all machines and runs the update script

for i in {1..24}; do
    if [ $i -eq 2 ]
    then
        echo "no thinkpad-2"
    else
        ssh root@thinkpad-$i 'bash -s' < update.sh
    fi
done
