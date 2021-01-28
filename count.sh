#!/bin/bash

if [ $# != 1 ]
then
	echo "Usage: $0 <txtfile>"
else
	echo "" > $1.tmp

for i in {A..Z}
do 
	echo -n "$i " >> $1.tmp
	echo `cat $1 | tr [:lower:] [:upper:] | grep -o $i | wc -l` >> $1.tmp
done

sort -n -r -k 2 $1.tmp -o $1.tmp
fi 
