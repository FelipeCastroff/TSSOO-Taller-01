#!/bin/bash

carpeta0=('find . -name "*.txt" -print | sort | grep execution')

#Parte 1

for i in ${carpeta0[]};
	do cat $i | tail -n +2 | awk -F ":"


