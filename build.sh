#!/bin/sh

cat radar.lst | ./source.py > source.pal8
./pal -$ source.pal8

grep -oh '^[0-7][0-7][0-7][0-7][0-7]  [0-7][0-7][0-7][0-7]' radar.lst | sort > old.oct

grep -h '^[ 0-9][ 0-9][ 0-9][ 0-9][ 0-9] [0-7][0-7][0-7][0-7][0-7]  [0-7][0-7][0-7][0-7]' source.lst | cut -c7-17 | sort > new.oct
