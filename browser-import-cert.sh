#!/bin/bash

# script installs root.cert.pem to certificate trust store of applications using NSS
# (e.g. Firefox, Thunderbird, Chromium)
# Mozilla uses cert8, Chromium and Chrome use cert9

# requirement: apt install libnss3-tools

# trusted root cert
# sudo mkdir -p /usr/local/share/ca-certificates/extra
# sudo cp $1 /usr/local/share/ca-certificates/extra/
# sudo update-ca-certificates

certfile=$1
certname=$1

# for cert8 (legacy - DBM)
for certDB in $(find ./ -name "cert8.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}
done


# for cert9 (SQL)
for certDB in $(find ./ -name "cert9.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
done 

certutil -A  -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:./.pki/nssdb
