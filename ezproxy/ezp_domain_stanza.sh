#!/bin/bash
for i in $(cat domains)
  do
    echo "Title "$i >> new
    #echo "URL "$i >> new
    #echo "URL www."$i >> new
    echo "URL http://"$i >> new
    #echo "URL https://"$i >> new
    #echo "URL http://www."$i >> new
    #echo "URL https://www."$i >> new
    echo "Domain "$i >> new
    echo "" >> new
  done