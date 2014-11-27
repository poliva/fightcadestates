#!/bin/bash
errors=0
for f in `ls *.fs` ; do
	name=`echo $f |cut -f1 -d "_"`
	rom=`dd if=${f} skip=28 count=100 bs=1 2>/dev/null |strings -n2 |head -n1`
	echo -n "$name : $rom : "
	if [ "$name" != "$rom" ]; then
		echo "ERROR"
		errors=$(( $errors + 1 ))
	else
		echo "OK"
	fi
done

if [ $errors -eq 0 ]; then
	echo -n "UPDATING INDEX... "
	./filesha256.py *.fs > index.json
	echo "DONE"
else
	echo "$errors ERRORS FOUND :("
fi
