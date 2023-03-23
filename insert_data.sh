#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $WINNER != "winner" ]]
  then
    #get winner team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    #if winner not found
    if [[ -z $WINNER_ID ]]
    then
      #insert winning team
      INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
      then
        echo Inserted into teams $WINNER
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
    fi
    
    #if loser not found
    if [[ -z $LOSER_ID ]]
    then
      #insert losing team
      INSERT_LOSER_ID=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_LOSER_ID == "INSERT 0 1" ]]
      then
        echo Inserted into teams $OPPONENT
        LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi
    fi
  
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $LOSER_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  echo Inserted game.
  fi
done   