import mysql.connector
import random
import string
import time
import argparse

#Add Arguments
append = True
parser = argparse.ArgumentParser()
parser.add_argument("--user", type=str,required=True)
parser.add_argument("--password", type=str,required=True)
parser.add_argument("--host", type=str,required=True)
args = parser.parse_args()
user = args.user
password = args.password
host = args.host



conn = mysql.connector.connect(
   user=user, password=password, host=host, database='mydb')


def createtable():
    cursor = conn.cursor()
    cursor.execute("DROP TABLE IF EXISTS USER_DATA")
    sql ='''CREATE TABLE USER(
        ID CHAR(20) NOT NULL,
        Name CHAR(20),
        PhoneNumber INT,
        is_blacklist CHAR(1)
    )'''
    cursor.execute(sql)
    conn.close()

createtable()
