# !bin/bash

IPS=$(nmap -sn -n $1 | grep 'report for' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
IFS='
'
count=0
for IP in $IPS
do
  echo "IP: $IP"
  eval $2
done

# example
# net-scan-eval.sh 192.168.0.0/24 "sshpass -p password ssh -o \"StrictHostKeyChecking no\" user@\$IP"
