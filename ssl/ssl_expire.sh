#!/bin/bash
#Checks SSL expiration dates
for i in $(cat domains)
  do
    echo $i >> ssl
    echo | openssl s_client -connect $i:443 2>/dev/null | openssl x509 -noout -dates >> ssl
    echo "" >> ssl
  done