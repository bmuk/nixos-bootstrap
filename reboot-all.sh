!/usr/bin/env bash

# This reboots all machines, including this one

for i in {1..24}; do
    if [ $i -eq 2 ]
    then
        echo "no thinkpad-2"
    else
        ssh root@thinkpad-$i 'reboot'
    fi
done
reboot
