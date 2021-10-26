#!/bin/bash
 
if !(dpkg -s jq)
then
   echo
   echo
   echo "jq library is required for this to run properly, press [Enter] to install!"
   read
   sudo apt-get install jq
fi
$param
pause(){
 read -p "Press [Enter] key to continue..." enterkey
}
 
one(){
   curl -s "wttr.in"
   echo "(The call was made by an API and so the author credits can not be removed - Yash Kale, 2018UIT2619)"
   echo
       pause
}
two(){
   read -p "What country do you want stats for? (Leave Empty for all)" param
   curl -s "https://corona-stats.online/$param"
   echo "(The call was made by an API and so the author credits can not be removed - Yash Kale, 2018UIT2619)"
   echo
       pause
}
$city
three(){
 
   read -p "What place would you like the weather for? " city
   echo
   curl -s "wttr.in/$city"
   echo
   echo "(The call was made by an API and so the author credits can not be removed - Yash Kale, 2018UIT2619)"
       pause
 
}
 
$state
$empty=""
$city
four(){
   read -p "What state would you like to query for? (leave empty for all states)" state
   case $state in
 
       "")
           echo "List of state, active cases and confirmed cases for all states"
           curl -s https://api.covidindiatracker.com/state_data.json | jq ".[]" | jq -c '.state, .active, .confirmed'
           echo "List of state, active cases and confirmed cases for all states"
           ;;
 
       *)
           read -p "What city would you like to query for? (leave empty for all)" city
           case $city in
               "")
                   echo "List of all cities in $state and their confirmed cases"
                   state="\"${state}\""
                   curl -s https://api.covidindiatracker.com/state_data.json | jq ".[]  | select(.state == $state) | .districtData[] | .name, .confirmed"
                   echo "List of all cities in $state and their confirmed cases"
               ;;
               *)
                   echo "Confirmed cases for $city are: "
                   state="\"${state}\""
                   city="\"${city}\""
                   curl -s https://api.covidindiatracker.com/state_data.json | jq ".[]  | select(.state == $state) | .districtData[] | select(.name==$city).confirmed"
               ;;
          
           esac
           ;;
   esac
  
       pause
}
$joke
five(){
 
   joke=$(curl -s https://official-joke-api.appspot.com/jokes/programming/random |jq '.'[0])
   #jq library is used to extract json objects
   echo $joke | jq '.setup'
   echo
   read -p "Press [Enter] for the punchline..."
   echo $joke | jq '.punchline'
   echo
       pause
}
show_menus() {
   clear
   echo "~~~~~~~~~~~~~~~~~~~~~"   
   echo " M A I N - M E N U"
   echo "~~~~~~~~~~~~~~~~~~~~~"
   echo "1. Live Weather Report"
   echo "2. Covid19 Statistics"
   echo "3. Weather Report For Given Place"
   echo "4. Covid For A Given State In India"
   echo "5. Get A Random Programming Joke"
   echo "6. Exit"
}
read_options(){
   local choice
   read -p "Enter choice [ 1 - 6] " choice
   case $choice in
       1) one ;;
       2) two ;;
       3) three ;;
       4) four ;;
       5) five ;;
       6) exit 0;;
      
       *) echo -e "Error..." && sleep 2
   esac
}
trap '' SIGINT SIGQUIT SIGTSTP
while true
do
   show_menus
   read_options
done
