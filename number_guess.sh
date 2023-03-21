#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"

echo "Enter your username:"
read USERNAME
DBUSERNAME=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'");
if [[ -z $DBUSERNAME ]]
then 
  GAMES=0
  BEST=10000
  USER=$($PSQL "insert into users (username, games_played, best_game) values ('$USERNAME', 1, 10000)");
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else 
  GAMES=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'");
  BEST=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'");
  echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
fi

NUMBER=$(( RANDOM % 1000 ))
TRIES=1
echo $NUMBER
echo "Guess the secret number between 1 and 1000:"
read GUESS

while ! [[ "$GUESS" =~ ^[0-9]+$ ]]
do 
  echo "That is not an integer, guess again:"
  read GUESS
done

#start while
  while ! [[ $GUESS -eq $NUMBER ]]
  do 
    if [[ $GUESS -lt $NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    else 
      echo "It's lower than that, guess again:"
    fi
    (( TRIES++ ))
    read GUESS
  done
  (( GAMES++ ))
  RES=$($PSQL "update users set games_played = $GAMES WHERE username = '$USERNAME'");
  if (( TRIES < BEST ))
  then 
    RES=$($PSQL "update users set best_game = $TRIES WHERE username = '$USERNAME'");
  fi
  echo "You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!"
  #end while
