#!/bin/bash
a=$1
b=$2
touch $b
sed -n '8p' $a > $b
sed -n '32p' $a >> $b
sed -n '128p' $a >> $b
sed -n '512p' $a >> $b
sed -n '1024p' $a >> $b

