#!/bin/bash

a=$1
b=$2
c=$3
sed "s/$b/$c/g" $a > a
cat a > $a
rm a
