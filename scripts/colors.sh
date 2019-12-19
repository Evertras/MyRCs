#!/bin/bash

fg() {
	echo "\033[38;5;${1}m"
}

bg() {
	echo "\033[48;5;${1}m"
}

for i in {0..7}
do
	for j in {0..31}
	do
		let num=$i*32+$j
		echo -ne "$(fg ${num})$(printf %03d ${num}) "
	done
	echo
done

for i in {0..7}
do
	for j in {0..31}
	do
		let num=$i*32+$j
		echo -ne "$(fg ${num})$(bg ${num})$(printf %03d ${num}) "
	done
	echo -e "\033[0m"
done

echo -e "\033[0m"

