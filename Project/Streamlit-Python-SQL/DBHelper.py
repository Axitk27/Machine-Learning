import mysql.connector

class DB :
    
    def __init__(self):
        #Connecting with the database
        try:
            self.conn = mysql.connector.connect(
            host="127.0.0.1",   # or just "localhost"
            user="root",        # default in XAMPP
            password="",        # leave empty if you didn’t set one
            database="practise",  # change to your database
            port=3306           # XAMPP default MySQL port
                )
            self.mycursor = self.conn.cursor()
    
        except:
            print('Connection Error') 
        
    def fetch_city_name(self):
        self.mycursor.execute('''SELECT DISTINCT(Source) FROM flights
               UNION
               SELECT DISTINCT(Destination) FROM flights                                                     
                              ''')
        data = self.mycursor.fetchall()
        
        city = []
        for item in data:
            city.append(item[0])
        
        return city
    
    def fetch_flight(self,source,destination,date):
        
        self.mycursor.execute('''SELECT Airline,Date_of_Journey,Dep_time,Price  FROM flights 
                                WHERE Destination = '{}' AND Source = '{}' AND Date_of_Journey = '{}'
                              '''.format(destination,source,date))
        data = self.mycursor.fetchall()
        return data
    
    def flight_number_Analysis(self):
        
        self.mycursor.execute('''
                              SELECT Airline,COUNT(*) FROM flights
                              GROUP BY Airline
                              ORDER BY COUNT(*) DESC ;
                              ''')
        data  = self.mycursor.fetchall()
        
        airline = []
        frequency = []
        
        for item in data:
            airline.append(item[0])
            frequency.append(item[1])
        
        return airline,frequency
    
    def busy_airport(self):
        self.mycursor.execute('''
                              
                              SELECT Source,COUNT(*) FROM (SELECT Source FROM flights UNION ALL SELECT Destination FROM flights)t 
                              GROUP BY t.Source ORDER BY COUNT(*);
                              
                              ''')
        data = self.mycursor.fetchall()
        
        city = []
        frequency = []
        
        for item in data:
            city.append(item[0])
            frequency.append(item[1])
        
        return city,frequency
    
    
    
    def daily_frequency(self):
        self.mycursor.execute('''SELECT Date_of_Journey,COUNT(*) FROM flights
                            GROUP BY Date_of_Journey''')
        data = self.mycursor.fetchall()
        date = []
        frequency = []
        
        for item in data:
            date.append(item[0])
            frequency.append(item[1])
        return date,frequency