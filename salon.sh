#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "1) Skin care treatement\n2) Massage\n3) Waxing\n4) Hair\n5) Nail\n6) Professional Make UP"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT "Skin care treatement";;
    2) APPOINTMENT "Massage";;
    3) APPOINTMENT "Waxing";;
    4) APPOINTMENT "Hair";;
    5) APPOINTMENT "Nail";;
    6) APPOINTMENT "Professional Make UP";;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}



APPOINTMENT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'" )
  echo $CUSTOMER_ID
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    CUSTOMER_DETAIL_RESULT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'" )
  fi
  CUSTOMER_NAME=$($PSQL "select name from customers where customer_id=$CUSTOMER_ID")
  echo -e "\nWhat time would you like your $1,$CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  if [[ $CUSTOMER_APPOINTMENT_RESULT = 'INSERT 0 1' ]]
  then
    echo -e "\nI have put you down for a $1 at $SERVICE_TIME,$CUSTOMER_NAME.\n"
  fi
}

MAIN_MENU
