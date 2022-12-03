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



def add_record ():
    for index in range(500):
        def name():
            letters = string.ascii_uppercase
            return  (''.join(random.choice(letters) for i in range(5)))
        name = name()        
        def number():
            letters = string.digits
            return ( ''.join(random.choice(letters) for i in range(10)) )
        number = number()        
        cursor = conn.cursor()
        sql = """
            INSERT INTO USER
            (ID, Name, PhoneNumber, is_blacklist)
            VALUES (%s, %s, %s, %s)
            """
    
        
        data_tuple = (index, name, number, 'Y')
        cursor.execute(sql, data_tuple)
        conn.commit()
    conn.close()

add_record()