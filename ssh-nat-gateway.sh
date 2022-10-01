#!/bin/bash

while :
do
  ssh -R 7102:localhost:22 root@${1} -t 'top'
  sleep 2
done 
