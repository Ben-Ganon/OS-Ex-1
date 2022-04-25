#!/bin/bash

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
endGame=false

ball=()
ball[0]="O|       |       #       |       | "
ball[1]=" |   O   |       #       |       | "
ball[2]=" |       |   O   #       |       | "
ball[3]=" |       |       O       |       | "
ball[4]=" |       |       #   O   |       | "
ball[5]=" |       |       #       |   O   | "
ball[6]=" |       |       #       |       |O"


getInput() {

	while [[ $pickA -gt $pointsA || $pickA -lt 0 || !($pickA =~ ^[0-9]+$) ]]; do
		echo "PLAYER 1 PICK A NUMBER: "
		read -s pickA
		if [[ $pickA -gt $pointsA ]]; then
			echo "fault"
		fi
		if [[ $pickA -gt $pointsA || $pickA -lt 0 || !($pickA =~ ^[0-9]+$) ]]; then
			echo "NOT A VALID MOVE !"
		fi
	done

	while [[ $pickB -gt $pointsB || $pickB -lt 0 || !($pickB =~ ^[0-9]+$) ]]; do
		echo "PLAYER 2 PICK A NUMBER: "
		read -s pickB
		if [[ $pickB -gt $pointsB || $pickB -lt 0 || !($pickB =~ ^[0-9]+$) ]]; then
			echo "NOT A VALID MOVE !"
		fi
	done
	
}


printBoard() {
	echo -e " Player 1: ${pointsA}         Player 2: ${pointsB} "
	for (( i = 0; i < 7; i++ )); do
		if [[ $i != 3 ]]; then
			echo "${court[i]}"
		fi
		if [[ $i == 3 ]]; then
			case $ballPos in
				-3)echo "${ball[0]}";;
-2)
echo "${ball[1]}";;
-1)
echo "${ball[2]}";;
0)
echo "${ball[3]}";;
1)
echo "${ball[4]}";;
2)
echo "${ball[5]}";;
3)
echo "${ball[6]}";;
esac
fi

done




}

loop() {
	getInput
	pointsA=$(($pointsA - $pickA))
	pointsB=$(($pointsB - $pickB))
	if [[ $pickA -lt $pickB ]]; then
		ballPos=$(($ballPos - 1))
	elif [[ $pickB -lt $pickA ]]; then
		ballPos=$(($ballPos + 1))
	fi

	printBoard

	echo -e "       Player 1 played: ${pickA}\n       Player 2 played: ${pickB}\n\n"
	

	if [[ $ballPos -le -3 ]]; then
		echo "PLAYER 2 WINS !"
		exit
	elif [[ $ballPos -ge 3 ]]; then
		echo "PLAYER 1 WINS !"
		exit
	elif [[ $pointsA -eq 0 && $pointsB -eq 0 ]]; then
		if [[ $ballPos -lt 0 ]]; then
			echo "PLAYER 2 WINS !"
			exit
		elif [[ $ballPos -gt 0 ]]; then
			echo "PLAYER 1 WINS !"
			exit
		else 
			echo "IT'S A DRAW !"
			exit
		fi
	elif [[ $pointsA -eq 0 ]]; then
		echo "PLAYER 2 WINS !"
		exit
	elif [[ $pointsB -eq 0 ]]; then
		echo "PLAYER 1 WINS !"
		exit
		
	fi
	
}

printBoard
while [[ !endGame ]]; do
	loop
	pickA=51
	pickB=51
done
exit

