#!/bin/bash
#if [ `echo $1 | tr [:upper:] [:lower:]` =  "off" ]; then
#if [ "$1" != "off" ]; then
if [ "$1" != "off" ]; then
    echo "Switching to TB config"
    sudo cp /etc/cups/client.conf.SVGD-TB /etc/cups/client.conf
else
    echo "Back to standard config"
    sudo rm /etc/cups/client.conf
fi
sudo /etc/init.d/cups restart

