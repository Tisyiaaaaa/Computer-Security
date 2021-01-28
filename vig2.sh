#!/bin/bash
op="+"  


# "Tests"

while getopts edk: flags   
do
  case $flags in
  e)  continue=1;;          
  d)  continue=1; op="-";;  
  k)  key=$(echo "$OPTARG" | tr A-Z a-z | sed s/[^a-z]//g); option=1;;  # Argument is taken as key.
  esac                      # "op" will be used to determine if -k was used and for "error" messages
done

read -t 0 < /dev/stdin  
if [[ "$?" = 0 ]]      
then
  continue=1            # Continue -> 1, as default to indicate to break out from the loop
  pipe=1                # Pipe -> 1
  if [[ -z "$key" ]]
  then
    echo "-k flag with an argument containing at least 1 letter required when piping."  # Error message will be shown if there is pipping
    exit 1              # Exit from the script
  fi
fi


#USER INPUT IN DETERMINING WHETHER THEY WANT TO ENCRYPT OR DECRYPT

while [[ "$continue" != 1 ]]  # Loop will keep moving if the continue is not equal to 1
do
  echo "---------------------------------------"
  echo "ENCODING/DECODING USING VIGENERE CIPHER"
  echo "Encode -> 1"    
  echo "Decode -> 2"  
  echo "---------------------------------------"
  echo "Input choice :: "                  
  read -n 2  choice                       # User input will be read
  echo
  if [[ "$choice" = 2 ]] # When user input 2
  then
    continue=1            # Break the loop
    op="-"                # Moving forward to Decryption
  fi
  if [[ "$choice" = 1 ]] # If 0 was entered (no):
  then
    continue=1            # Break the loop 
    op="+"                # Moving forward to Encryption
  fi
  if [[ "$continue" != 1 ]]     #Check the continue value
  then
    echo "Invalid Input! Please Enter Again : "  #Error message will be shown when user input invalid value
  fi
done


#USER INPUT MESSAGE TO BE ENCODE OR DECODE

if [[ "$pipe" = 1 ]]                                       
then
  read pt < /dev/stdin                                
else
  echo "----------------------------------"
  echo Input Message to be Encode/Decode ::           # Ask user to input message to be encrypt or decrypt          
  read pt                                              # Read the input given by the user 
fi
pt=$(echo "$pt" | tr a-z A-Z | sed s/[^A-Z]//g) # Change all characters to uppercase and remove all spacing


#USER INPUT KEYWORD

while test -z "$key"                                # To check if key is empty
do
  if [[ "$option" = 1 ]]                           
  then
    echo "-k Argument need at least ONE letter"
  fi
  echo "----------------------------------"
  echo Input Key to be Used ::                      # Ask the user to input the key to be used
  read key                                          # Read the input given by the user
  key=$(echo "$key" | tr a-z A-Z | sed s/[^A-Z]//g) # Change all characters to uppercase and remove all spacing
  if [[ -z "$key" ]]                                # The input must have input, or else error message will be shown
  then
    echo "Invalid! Atleast one letter is needed :: "
  fi
done

length=${#key}  # Length of the key
step=0         


# ENCODE / DECODE USING THE KEY GIVEN

while test -n "$pt"                    # While the plaintext is not zero, the loop while keep working
do
  char=${pt:0:1}                       # Set the position of char to 1
  loop=25                                     # Loop set to 25 (representing num of characters)
  for letter in {Z..A}                        # Loop through the letter from Z .. A
  do                                          
    char=$(echo $char | sed s/$letter/$loop/) 
    loop=$((loop-1))                          
  done                                        

  loop=25               # Reset the loop
  shift=${key:$step:1}  
  for letter in {Z..A}  
  do
    shift=$(echo $shift | sed s/$letter/$loop/)
    loop=$((loop-1))
  done
  
  # Step will be increase +1 and will be mod with the length of key
  step=$(($(($step+1))%$length))

 
  code=$(($char$op$shift))  
  if [[ $code -lt 0 ]]      # If the output is < 0
  then
    code=$((code+26))       # will be add 26 so that it will loop
  fi
  if [[ $code -gt 25 ]]     # If result > 25
  then
    code=$((code-26))       # - 26
  fi

  # Convert number -> alphabet
  loop=25
  for letter in {Z..A}
  do
    code=$(echo $code | sed s/$loop/$letter/)
    loop=$((loop-1))
  done

 
  # The encoded / decoded message will be save into message
  message=$message$code
  # Remove the character of plaintext one-by-one
  pt=${pt:1}
done



#SAVE THE ENCODED OR DECODED MESSAGE INTO A TEXTFILE 
#AT THE SAME TIME, THE FREQUENCY ANALYSIS WILL BE DONE
#IF SAVE THE FILE, WE CAN GET THE FREQUENCY ANALYSIS
echo "----------------------------"
echo "Save output into a textfile?"
echo "Yes -> 1"
echo "No -> 2"
read -n 2 save
if [[ "$save" = 2 ]]
 then
   echo "----------------------------"
   echo The Encoded/Decoded Message ::
   echo $message
   echo "Thank You :)) "
   echo "----------------------------"
elif [[ "$save" = 1 ]]
 then 
   echo "----------------------------"
   echo "Enter the Text File Name :: "
   read filename
   if [ -f $filename.txt ]
    then
      echo "--------------------------"
      echo "The file already existed. "
      echo "Overwritting in process..."
      echo $message > $filename.txt
      grep -o . $filename.txt | sort | uniq -c | sort -rn > $filename.txt.tmp
      echo "Done!"
      echo "--------------------------"
   else
     echo $message > $filename.txt
     grep -o . $filename.txt | sort | uniq -c | sort -rn > $filename.txt.tmp
    fi
else 
 echo The Encoded/Decoded Message :: 
 echo $message

fi



