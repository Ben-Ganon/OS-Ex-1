#!/bin/bash

shopt -s xpg_echo
pointsA=50
pointsB=50
ballPos=0
pickA=51
pickB=51
court=()
court[0]=" --------------------------------- "
court[1]=" |       |       #       |       | "
court[2]=" |       |       #       |       | "
court[3]=" |       |       O       |       | "
court[4]=" |       |       #       |       | "
court[5]=" |       |       #       |       | "
court[6]=" --------------------------------- "


printBoard() {
	echo " Player 1: ${pointsA}         Player 2: ${pointsB} "
	for (( i = 0; i < 7; i++ )); do
		echo "${court[i]}"
	done

	while [[ $pickA > 50 || $pickA < 0 ]]; do
		echo "PLAYER 1 PICK A NUMBER: "
		read pickA
		echo $pickA
		if [[ $pickA > 50 || $pickA< 0 ]]; then
			echo "NOT A VALID MOVE !"
		fi
	done

	while [[ $pickB> 50 || $pickB< 0 ]]; do
		echo "PLAYER 2 PICK A NUMBER: "
		read pickB
		if [[ $pickB> 50 || $pickB< 0 ]]; then
			echo "NOT A VALID MOVE !"
		fi
	done
	echo "       Player 1 played: ${pickA}\n       Player 2 played: ${pickB}\n\n"
}


while [[ pointsB > 0 && pointsA > 0 ]]; do
	printBoard
	

done

exit

