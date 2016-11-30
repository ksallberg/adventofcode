#!/bin/bash

egrep -o -n 'cats: 7|children: 3|samoyeds: 2|pomeranians: 3|goldfish: 5|trees: 3|cars: 2|perfumes: 1' input.txt | cut -d ":" -f 1 | awk ' { tot[$0]++ } END { for (i in tot) print tot[i],i } ' | sort | grep "3 "
