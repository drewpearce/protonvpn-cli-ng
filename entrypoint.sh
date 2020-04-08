#!/bin/bash

echo "Initializing ProtonVPN..."
protonvpn init -e

if [ -z $MODE ]
then
    echo "Connecting to fastest node..."
    protonvpn c -f
else
    echo "Connecting to fastest $MODE node..."
    protonvpn c "--$MODE"
fi

tail -f .pvpn-cli/pvpn-cli.log
