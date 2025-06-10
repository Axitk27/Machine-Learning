import streamlit as st
import pandas as pd

df = pd.read_csv('Resources\startup_funding.csv')

st.sidebar.title('Startup Funding Analysis')
option = st.sidebar.selectbox('Select one',['Overall Analysis','StartUp','Investor'])


####################################################
#finding the unique name in the company data       
df = pd.read_csv('Resources\startup_funding.csv')
company_data = sorted(df['Startup Name'].unique())
# L = []
# # for item in data:
# #     L.append(item.strip().replace('"',''))
    
# # L.remove('1mg (Healthkartplus)')
# # L[0] = "Byju's"
#data cleaning not part right now but will do 
###################################################


###################################################
#Investor data

df['Investors Name'] = df['Investors Name'].fillna('Undisclosed')
investor_data = sorted(df['Investors Name'].unique())

###################################################

if option == 'Overall Analysis':
    st.title('Overall Analysis')
elif option == 'StartUp':
    st.sidebar.selectbox('Select Startup',company_data)
    st.title('Startup Analysis')
    btn1 = st.sidebar.button('Find Startup Details')
elif option == 'Investor':
    st.sidebar.selectbox('Select Investor',investor_data)
    st.title('Investor Analysis')
    btn2 = st.sidebar.button('Find Investor Details')