#!/bin/bash

# Set the input field separator (IFS) to a comma
IFS=','
csv_file=data.csv

clear

# Function to process a single user
process_user() {
    MatricNo="$1"
    Password="$2"
    Hostel="$3"

    echo -e "[+] Preparing to Ballot For ${MatricNo} [+]\n"

    echo -e "\n[+] Logging In for '"$MatricNo"'\n"

    # Create a variable that stores the amount of retries made by the request
    retry_count=0

    while [ "$retry_count" -lt 3 ]; do
        login=$(curl -s --location 'https://studentportalbeta.unilag.edu.ng/users/login' \
            --header 'Content-Type: application/x-www-form-urlencoded' \
            --header 'Cookie: ASP.NET_SessionId=xlsn30xn2pkqqiulmr0zp52q' \
            --data-urlencode 'MatricNo='"$MatricNo"'' \
            --data-urlencode 'Password='"$Password"''
        )

        # Extract Access Token:-
        AccessToken=$(echo "$login" | jq -r '.Data.Token')
        login_success=$(echo "$login" | jq -r '.Success')


        if [ -z "$AccessToken" ] || [ "$AccessToken" == "null" ]; then
            echo "AccessToken is empty. Authentication failed."
            retry_count=$((retry_count+1))
            sleep 1 
        else
            break
        fi

    done

    if [ "$login_success" == "false" ]; then
        echo -e "\n[+] Could Not Login For '"$MatricNo"', Moving On...\n"

        continue
    fi

    echo -e "==> AccessToken:-\n ----------------- \n $AccessToken\n"

    #Extract User Full Name:-
    FullName=$(echo "$login" | jq -r '.Data.Student.FullName')
    echo -e "==> User Full Name:-\n ------------- \n $FullName\n\n"

    echo "+---------------------------------+"
    echo -e "| Logged In successfully after $retry_count retries. |"
    echo "+---------------------------------+"


    echo "*** Saving Accomodation Reservation for $FullName, Please Wait ***"

    # if ["$Hostel "]; then 
    #     echo -e "\n[+] Invalid Hostel Name - '"$Hostel"' Selected for '"$MatricNo"', Moving On...\n"

    #     continue
    # fi

    retry_count=0
    hall_info='{"HallId":"'$Hostel'"}'

    while [ "$retry_count" -lt 100 ]; do
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

        echo "$accommodation_reservation, $FullName"

        success=$(echo "$accommodation_reservation" | jq -r '.Success')
        message=$(echo "$accommodation_reservation" | jq -r '.Message')


        if [ "$message" == "The accomodation reserved has already been granted to the student" ]; then
            break
        else
            retry_count=$((retry_count+1))
            sleep 1  
        fi
    done

    if [ "$message" == "The accomodation reserved has already been granted to the student" ]; then
        echo "+---------------------------------+"
        echo -e "Accommodation Reservation Successful after $retry_count retries. $FullName"
        echo "+---------------------------------+"

        retry_count=0

        while [ "$retry_count" -lt 3 ]; do
            # Send the POST request with the form data
            accomodation_confirmation=$(curl -s 'https://studentportalbeta.unilag.edu.ng/accomodation/accomodationConfirmation' \
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
            )

            success=$(echo "$accomodation_confirmation" | jq -r '.Success')


            if [ "$success" == "true" ]; then
                break
            else
                retry_count=$((retry_count+1))
                sleep 1  
            fi
        done

    else
        echo "Accommodation Reservation failed after 100 retries."
    fi

    echo "+---------------------------------+"
    echo -e "| Finished processing '$MatricNo'    |"
    echo "+---------------------------------+"
}

# Read the CSV file line by line
while read -r MatricNo Password Hostel; do
    # Skip the header line
    if [ "$MatricNo" == "MatricNo" ]; then
        continue
    fi

    # Start processing a user in the background
    process_user "$MatricNo" "$Password" "$Hostel" &

    # Count the number of background processes
    process_count=$(jobs | wc -l)

    # If there are already 3 background processes, wait for one to finish
    if [ $process_count -ge 8 ]; then
        wait
    fi
done < "$csv_file"

# Wait for any remaining background processes to complete
wait
