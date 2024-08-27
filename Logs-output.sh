#!/bin/bash
#/var/log/shell-script/Logs-output-<timestamp>.log
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE 
        #tee helps to print few points in console for users and -a is for append not need for >>
        exit 1
    fi
}
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is...$G FAILED $N" | tee -a $LOG_FILE
    fi 
}
USAGE(){
    echo -e "$R USAGE:: $N sudo sh input is empty:"
    exit 1

}
echo "Script started at $(date)" | tee -a $LOG_FILE 
CHECK_ROOT
if [ $# -eq 0]
then
    USAGE
fi

for package in $@ #@ refers to all arg passed to it.
do
    dnf list installed $package &>>$LOG_FILE
    if [ $? -ne 0 ]
    then 
        echo "$package is not installed, going to install it." | tee -a $LOG_FILE 
        dnf install $package -y &>>$LOG_FILE
        VALIDATE $? "Installing $package"
    else
        echo -e "$package $Y is already installed.$N" | tee -a $LOG_FILE 
    fi

done




