import streamlit as st
import pandas as pd
from DBHelper import DB
import plotly.graph_objects as go
import plotly.express as px



st.sidebar.title('Flights Analytics')
db = DB()
user_option = st.sidebar.selectbox('Select Here',['Check Flights','Analytics','Information'])

if user_option == 'Check Flights':
    st.title('Check Flights')
    city = db.fetch_city_name()
    
      
    col1,col2 = st.columns(2) 
    with col1:
        source = st.selectbox('Source',sorted(city))
    
    with col2:
        destination = st.selectbox('Destination',sorted(city))
    
    col1,col2 = st.columns(2) 
    with col1:
        date = st.date_input('Date',min_value='2019-01-03',max_value = '2019-12-06')
    with col2:
        time = st.time_input('Time')
    if st.button('Search'):
        flights = db.fetch_flight(source,destination,date)   
        
        #Dataframe view of on a streamlit
        column_config = {1 : "Flight",2 : "Date",3 : "Time",4 : "Price"}
        data = pd.DataFrame(flights,columns = ["Flight","Date","Time","Price"]) 
        
        if data.shape[0] == 0:
            st.write('No Flights Available')
        else:
            st.dataframe(data)
        
elif user_option == 'Analytics':
    col1,col2,col3,col4 = st.columns(4) 
    st.title('Analytics')
    # with col1:
    flight,freq = db.flight_number_Analysis()
    fig = px.pie(flight,values=freq,names = flight)
    st.header('Flight Number Analysis')
    st.plotly_chart(fig)
    # with col2:
    city,freq1 = db.busy_airport()
    fig = px.bar(x = city,y=freq1)
    st.header('Airport Analysis')
    st.plotly_chart(fig)
    # with col3
    date,freq2 = db.daily_frequency()
    fig = px.line(x = date,y=freq2)
    st.header('Daily Analysis')
    st.plotly_chart(fig)
    
        
else:
    st.title('Project Information') 
