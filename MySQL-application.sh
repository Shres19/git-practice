#!/bin/bash
#/var/log/shell-script/Logs-output-<timestamp>.log
LOGS_FOLDER="/var/log/expenseapplication"
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

dnf install mysql-server -y 
VALIDATE $? "Installing mySQL Server"

systemctl enable mysqld
VALIDATE $? "Enabled mySQL Server"

systemctl stat mysqld
VALIDATE $? "Started mySQL Server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "completed setting root pwd for mySQL Server"







