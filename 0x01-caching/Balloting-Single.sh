#!/bin/bash

clear

read -p 'Enter your Matric Number: ' MatricNo
read -p 'Enter your Password: ' Password
read -p 'Enter your gender (male/female): ' gender

case $gender in
  "male")
    echo "You selected Male."
    echo "Choose an option:"
    select option in "JAJA" "ENI-NJOKU HALL" "PROFESSOR SABURI BIOBAKU HALL" "Quit"
    do
      case $option in
        "JAJA")
          selected_option="JAJA"
          echo "You selected $selected_option."
          break
          ;;
        "ENI-NJOKU HALL")
          selected_option="ENI-NJOKU HALL"
          echo "You selected $selected_option."
          break
          ;;
        "PROFESSOR SABURI BIOBAKU HALL")
          selected_option="PROFESSOR SABURI BIOBAKU HALL"
          echo "You selected $selected_option."
          break
          ;;
        "Quit")
          echo "Exiting."
          exit
          ;;
        *)
          echo "Invalid option. Please select a valid option."
          ;;
      esac
    done
    ;;

  "female")
    echo "You selected Female."
    echo "Choose an option for females:"
    select option in "ALIYU MAKAMA BIDA HALL" "FAGUNWA HALL" "HONOURS HALL" "QUEEN AMINA HALL" "MOREMI HALL" "Quit"
    do
      case $option in
        "ALIYU MAKAMA BIDA HALL")
          selected_option="ALIYU MAKAMA BIDA HALL"
          echo "You selected $selected_option."
          break
          ;;
        "FAGUNWA HALL")
          selected_option="FAGUNWA HALL"
          echo "You selected $selected_option."
          break
          ;;
        "HONOURS HALL")
          selected_option="HONOURS HALL"
          echo "You selected $selected_option."
          break
          ;;
        "QUEEN AMINA HALL")
          selected_option="QUEEN AMINA HALL"
          echo "You selected $selected_option."
          break
          ;;
        "MOREMI HALL")
          selected_option="MOREMI HALL"
          echo "You selected $selected_option."
          break
          ;;
        "Quit")
          echo "Exiting."
          exit
          ;;
        *)
          echo "Invalid option. Please select a valid option."
          ;;
      esac
    done
    ;;
  *)
    echo "Invalid gender choice. Please enter 'male' or 'female'."
    ;;
esac

echo "$option"

for i in $(seq 1 20000)
do
    if [ $i -eq 1 ]
    then
        echo -e "\n[+] Balloting for for 1st Time [+]\n"
    elif [ $i -eq 2 ]
    then
        echo -e "[+] Preparing for 2nd Ballot [+]\n"
    elif [ $i -eq 3 ]
    then
        echo -e "[+] Preparing for 3rd Ballot [+]\n"
    else
        echo -e "\n\n[+] Preparing for ${i}th Ballot [+]"
        echo -e "---------------------------------"
    fi
    echo -e "\n[+] Grabbing JWT Access Token of '"$MatricNo"'\n"

    #To login:
    # Define your form data as a string
    form_data="MatricNo=$MatricNo&Password=$Password"

    retry_count=0

    while [ "$retry_count" -lt 10000 ]; do
        # Send the POST request with the form data
        login=$(curl -s 'http://studentportalbeta.unilag.edu.ng/users/login' \
            -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0' \
            -H 'Accept: application/json, text/plain, */*' \
            -H 'Accept-Language: en-US,en;q=0.5' \
            -H 'Content-Type: application/x-www-form-urlencoded;charset=UTF-8' \
            -H 'Origin: http://studentportal.unilag.edu.ng' \
            -H 'Connection: keep-alive' \
            -H 'Referer: http://studentportal.unilag.edu.ng' \
            -H 'Pragma: no-cache' \
            -H 'Cache-Control: no-cache' \
            -H 'TE: Trailers' \
            -d "$form_data"
        )

        # Extract Access Token:-
        AccessToken=$(echo "$login" | jq -r '.Data.Token')

        if [ -z "$AccessToken" ] || [ "$AccessToken" == "null" ]; then
            echo "AccessToken is empty. Authentication failed."
            retry_count=$((retry_count+1))
            sleep 1 
        else
            break
        fi

    done

    #Extract Access Token:-
    AccessToken=$(echo "$login" | jq -r '.Data.Token')
    echo -e "==> AccessToken:-\n ----------------- \n $AccessToken\n"

    #Extract User Full Name:-
    UserId=$(echo "$login" | jq -r '.Data.Student.FullName')
    echo -e "==> User Full Name:-\n ------------- \n $UserId\n\n"

    echo "+---------------------------------+"
    echo -e "| JWT Token verified successfully |"
    echo "+---------------------------------+"

   
    echo "*** Saving Accomodation Reservation, Please Wait ***"

    retry_count=0
    hall_info='{"HallId":"'$selected_option'"}'

    while [ "$retry_count" -lt 10000 ]; do
        # Send the POST request with the form data
        accommodation_reservation=$(curl -s 'https://studentportalbeta.unilag.edu.ng/accomodation/saveAccommodationReservation' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36' \
        -H 'Accept: application/json, text/plain, */*' \
        -H "Authorization: Bearer $AccessToken" \
        -H 'Accept-Language: en-US,en;q=0.5' \
        -H 'Content-Type: application/json' \
        -H 'Origin: http://studentportal.unilag.edu.ng' \
        -H 'Connection: keep-alive' \
        -H 'Referer: http://studentportal.unilag.edu.ng' \
        -H 'Pragma: no-cache' \
        -H 'Cache-Control: no-cache' \
        -H 'TE: Trailers' \
        -d "$hall_info"
        )

        echo "$accommodation_reservation"

        success=$(echo "$accommodation_reservation" | jq -r '.Success')

        if [ "$success" == "true" ]; then
            break
        else
            retry_count=$((retry_count+1))
            sleep 1  # Optional: Add a delay between retries (e.g., 1 second)
        fi
    done

    if [ "$success" == "true" ]; then
        echo "Accommodation Reservation Successful after $retry_count retries."
    else
        echo "Accommodation Reservation failed after 10,000 retries."
    fi

    # retry_count=0

    # while [ "$retry_count" -lt 10000 ]; do
    #     # Send the POST request with the form data
    #     accomodation_confirmation=$(curl -s 'https://studentportalbeta.unilag.edu.ng/accomodation/accomodationConfirmation' \
    #     -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36' \
    #     -H 'Accept: application/json, text/plain, */*' \
    #     -H "Authorization: Bearer $AccessToken" \
    #     -H 'Accept-Language: en-US,en;q=0.5' \
    #     -H 'Content-Type: application/json' \
    #     -H 'Origin: http://studentportal.unilag.edu.ng' \
    #     -H 'Connection: keep-alive' \
    #     -H 'Referer: http://studentportal.unilag.edu.ng' \
    #     -H 'Pragma: no-cache' \
    #     -H 'Cache-Control: no-cache' \
    #     -H 'TE: Trailers' \
    #     )

    #     echo "$accomodation_confirmation"

    #     success=$(echo "$accomodation_confirmation" | jq -r '.Success')

    #     if [ "$success" == "true" ]; then
    #         break
    #     else
    #         retry_count=$((retry_count+1))
    #         sleep 1  # Optional: Add a delay between retries (e.g., 1 second)
    #     fi
    # done

    # if [ "$success" == "true" ]; then
    #     echo "Accommodation Confirmation Successful after $retry_count retries."
    # else
    #     echo "Accommodation Confirmation failed after 10,000 retries."
    # fi

    echo -e "\n-----------------------------------------------------X----------------------------------------------\n"
done

