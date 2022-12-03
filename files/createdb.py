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




#establishing the connection
conn = mysql.connector.connect(
   user=user, password=password, host=host, database='mydb')

def createdb():
    cursor = conn.cursor()
    cursor.execute("DROP database IF EXISTS mydb")
    sql = "CREATE database mydb";
    cursor.execute(sql)
    print("List of databases: ")
    cursor.execute("SHOW DATABASES")
    print(cursor.fetchall())
    conn.close()

createdb()