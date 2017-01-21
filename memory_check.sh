#!/bin/bash
echo -e "\n"
#Reading of Memory
TOTAL_MEMORY=$( free -m | grep Mem: | awk '{print $2}' )
USED_MEMORY=$( free | grep Mem: | awk '{print $3/$2 *100}' )
USED_MEMORY=${USED_MEMORY%%.*}
#Priiintiing of Memories
echo "Total Memory is $TOTAL_MEMORY MB"
echo "Used Memory is $USED_MEMORY percent"
echo -e "\n"
#Checking for parameters
if [ $# -eq 0 ]
then
	echo -e  "**********************No parameters. Enter the right parameters for Critical (-c) and Warning (-w) Tresholds and also for email (-e). Example, ./memory_check -c 90 -w 80 -e email@email.com errors in the next line are seen because of incomplete parameters. **********************************\n\n\n\n\n"
exit 100
else
while getopts ":c:e:w::" opt; do
 case $opt in
  c) critical="$OPTARG" ;;
  e) email="$OPTARG" ;;
  w) warning=$OPTARG;;
  \?) echo -e "********************Wrong parameter, use -c, -w, and, -e for critical and warning tresholds and also for email.*****************\n\n\n\n ";;
 esac
done
fi
#Checking Criitical and Warniing Tresholds
if [ $warning -lt $critical ]
then 
 if [ $USED_MEMORY -ge $critical ]
 then
 	echo "Status: Critical Treshold********"
	echo "Critical Memory" | mail -v -s "Memory Check" $email
	exit 2
 elif [[ $USED_MEMORY -ge $warning && $USED_MEMORY -lt $critical ]]
  then
	echo "Status: Warning Treshold*********"
	echo  "Warniing Memory"  | mail -v -s "Memory Check" $email
	exit 1
 else
 	echo "Status: Memory is Normal**********"
	echo "Normal Memory" | mail -v -s "Memory Chheck" $email
	exit 0
 fi
else
	echo "Sorry try again, Critical must be greater than the Warning treshold. Use -c for Critical, -w for Warning Threshold and -e for email."
fi
