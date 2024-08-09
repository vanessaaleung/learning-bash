#!/bin/zsh

counter=1;

while true
do
	response=$(./magic-numbers.sh);
	((counter++));
	if [ "$response" != "Everything went according to plan" ]; then
		echo "Num runs: $counter";
		break
	fi
	
done
