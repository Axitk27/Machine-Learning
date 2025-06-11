import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

st.set_page_config(layout = 'wide',page_title = 'Startup Analysis')
st.sidebar.title('Startup Funding Analysis')
option = st.sidebar.selectbox('Select one',['Overall Analysis','StartUp','Investor'])

####################################################
#finding the unique name in the company data       
df = pd.read_csv('Resources\startup_cleaned.csv')
company_data = sorted(df['Startup'].unique())
# L = []
# # for item in data:
# #     L.append(item.strip().replace('"',''))
    
# # L.remove('1mg (Healthkartplus)')
# # L[0] = "Byju's"
#data cleaning not part right now but will do 
###################################################
###################################################


###################################################
#Investor data

investor_data = sorted(set(df['Investors'].str.split(',').sum()))
investor_data.remove('')
invesror_data = df['Investors'].str.strip(" ")

###################################################


# Function for investor
####################################################
def load_investor_details(investor):
    st.title(selected_investor)
    #load the top 5 data of the investor 
    last5_df = df[df['Investors'].str.contains('investor')].head(5)[['Date','Startup','Vertical','City','Round','Amount']]
    st.subheader('Most Recent Investment')
    st.dataframe(last5_df)

        #biggest investment
    col1,col2 = st.columns(2)
    with col1:   
        big_series = df[df['Investors'].str.contains(investor)].groupby('Startup')['Amount'].sum().sort_values(ascending = False).head(5)
        st.subheader('Biggest Investments')
        st.dataframe(big_series)
    # fig,ax = plt.subplots()
    # st.pyplot(big_series.plot(kind = 'bar'))

####################################################
if option == 'Overall Analysis':
    st.title('Overall Analysis')
elif option == 'StartUp':
    st.sidebar.selectbox('Select Startup',company_data)
    st.title('Startup Analysis')
    btn1 = st.sidebar.button('Find Startup Details')
elif option == 'Investor':
    selected_investor = st.sidebar.selectbox('Select Investor',investor_data)
    btn2 = st.sidebar.button('Find Investor Details')
    
    if btn2 :
        load_investor_details(selected_investor)
        