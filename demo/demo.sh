#!/bin/bash

if [ ! -e "spam.txt" ]
then
	touch spam.txt	
fi
if [ ! -e "ham.txt" ]
then
	touch ham.txt	
fi

clear
for f in email*
do
	echo -e "PROCESSING $f\n\n"
	cat $f
	echo -e "\n\nANALYZING $f\n\n"
	./spammyham.perl $f
	clear
done
