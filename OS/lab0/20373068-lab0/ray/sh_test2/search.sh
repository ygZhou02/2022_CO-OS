#!bin/bash
#First you can use grep (-n) to find the number of lines of string.
#Then you can use awk to separate the answer.

a=$1
b=$2
c=$3
touch $c
grep -n $b $a | cut -f1 -d: > $c



