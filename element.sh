#!/bin/bash
# Script for the freeCodeCamp Periodic Table Database project
# Usage: ./element.sh <atomic_number|symbol|name>

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Determine input type
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number=$1"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  CONDITION="symbol='$1'"
else
  CONDITION="name='$1'"
fi

RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE $CONDITION")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read NUM NAME SYMBOL TYPE MASS MP BP <<< "$RESULT"
  echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
fi
