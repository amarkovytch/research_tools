#!/bin/bash
echo

count=0
for i in $(objdump -d $1 |grep "^ " |cut -f2)
     do 
        echo -n '\x'$i
        let "count+=1"
     done    

echo
echo
echo "total of $count bytes"
