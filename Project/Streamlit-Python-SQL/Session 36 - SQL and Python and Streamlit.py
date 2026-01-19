import numpy as np
import pandas as pd
import streamlit as st
import mysql.connector

#this will be bridge on a database
import mysql.connector

try:
    conn = mysql.connector.connect(
    host="127.0.0.1",   # or just "localhost"
    user="root",        # default in XAMPP
    password="",        # leave empty if you didn’t set one
    database="flights",  # change to your database
    port=3306           # XAMPP default MySQL port
        )
    mycursor = conn.cursor()
    print('Connection established')    
except:
    print('Connection Error')
    
