#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

get_inputs() {
    # Prompt for phone number
     read CUSTOMER_PHONE
    # Check if the phone number exists in the customers table
    CUSTOMER_EXIST=$($PSQL "SELECT COUNT(*) FROM customers WHERE phone='$CUSTOMER_PHONE';")
    if [ "$CUSTOMER_EXIST" -eq 0 ]; then
        # If the customer doesn't exist, prompt for name
        read CUSTOMER_NAME

        # Insert the new customer into the customers table
        $PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
    fi

    # Retrieve the customer ID
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

    # Prompt for appointment time
 read SERVICE_TIME

}






while true; do
    SERVICES=$($PSQL "SELECT service_id, name FROM services;" | tr '|' '\t')
    echo "$SERVICES" | while IFS=$'\t' read -r SERVICE_ID NAME
    do
        echo "$SERVICE_ID) $NAME Service"
    done

      read SERVICE_ID_SELECTED

    

    # Check if the selected service ID exists
    if grep -qw "$SERVICE_ID_SELECTED" <<< "$SERVICES"; then
        get_inputs
        break
    else
        echo "Invalid service ID. Please try again."
    fi
done

# Insert the appointment into the appointments table
$PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');"

# Get the service name for the message
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED';")
# Get the customer name for the message
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID';")



echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"

exit 0
