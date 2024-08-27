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

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mySQL Server is.."

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled mySQL Server is.."

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started mySQL Server is .."

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
mysql -h mysql.daws.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
if [ $? -ne 0 ]
then 
    echo "MySQL Root password is not setup..setting now." &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "setting root pwd for mySQL Server"
else
    echo -e "MYSQL root password is already setup...$Y Skipping $N" | tee -a $LOG_FILE
fi

#idempotency mysql -h localhost -u root -pExpenseApp@1 mysql -h <ipaddressmysql172.1.36.169> -u root -pExpenseApp@1
#mysql -h <ipaddressmysql172.1.36.169> -u root -pExpenseApp@1 -e 'show databases;'
#nslookup 172.9.6.169 - to check dns status
#logging off byeeee











