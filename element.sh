#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else
  ELEMENT=""

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type 
              FROM elements AS e LEFT JOIN properties AS p ON e.atomic_number = p.atomic_number
              LEFT JOIN types AS t ON p.type_id = t.type_id
              WHERE e.atomic_number = $1")
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
  then
    ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type 
              FROM elements AS e LEFT JOIN properties AS p ON e.atomic_number = p.atomic_number
              LEFT JOIN types AS t ON p.type_id = t.type_id
              WHERE e.symbol = '$1'")
  else
    ELEMENT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type 
              FROM elements AS e LEFT JOIN properties AS p ON e.atomic_number = p.atomic_number
              LEFT JOIN types AS t ON p.type_id = t.type_id
              WHERE e.name = '$1'")
  fi

  if [[ ! -z $ELEMENT ]]
  then
    read NUM BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE <<< $ELEMENT
    echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  else
    echo I could not find that element in the database.
  fi
fi
