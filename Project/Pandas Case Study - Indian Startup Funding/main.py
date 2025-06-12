import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

st.set_page_config(layout = 'wide',page_title = 'Startup Analysis')
st.sidebar.title('Startup Funding Analysis')
option = st.sidebar.selectbox('Select one',['Overall Analysis','StartUp','Investor'])

####################################################
#finding the unique name in the company data       
df = pd.read_csv('Resources\startup_cleaned.csv')
df['Date'] = pd.to_datetime(df['Date'],errors='coerce')
df['Year'] = df['Date'].dt.year   
df['Month'] = df['Date'].dt.month
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
        # st.dataframe(big_series)
        fig,ax = plt.subplots(figsize=(7, 6))
        ax.bar(big_series.index,big_series.values)
        st.pyplot(fig)
    
    with col2:   
        verticle_series = df[df['Investors'].str.contains(investor)].groupby('Vertical')['Amount'].sum().head(5)
        st.subheader('Sector Investments')
        fig1,ax1 = plt.subplots(figsize=(5, 4))
        ax1.pie(verticle_series,labels = verticle_series.index,autopct="%0.01f%%")
        st.pyplot(fig1)

    col3,col4 = st.columns(2)
    
    with col3:   
        city_series = df[df['Investors'].str.contains(investor)].groupby('City')['City'].count().sort_values(ascending = False).head(5)
        st.subheader('Investments as per City')
        # st.dataframe(big_series)
        fig2,ax2 = plt.subplots(figsize=(4, 3))
        ax2.pie(city_series,labels = city_series.index,autopct="%0.01f%%")
        st.pyplot(fig2)
    
    with col4:   
        round_series = df[df['Investors'].str.contains(investor)].groupby('Round')['Round'].count().sort_values(ascending = False).head(5)
        st.subheader('Investments Round')
        # st.dataframe(big_series)
        fig3,ax3 = plt.subplots(figsize=(8, 6))
        ax3.pie(round_series,labels = round_series.index,autopct="%0.01f%%")
        st.pyplot(fig3)
    
    col5,col6 = st.columns(2)
    
    with col5:      

        yoy_series = df[df['Investors'].str.contains(investor)].groupby('Year')['Amount'].sum()
        st.subheader('Year on Year Investment in Cr')
        # st.dataframe(big_series)
        fig4,ax4 = plt.subplots(figsize=(8, 6))
        ax4.plot(yoy_series.index,yoy_series.values)
        st.pyplot(fig4)
    
####################################################
#for overall Analysis 

def load_overall_analysis():
    st.title('Overall Analysis')
    
    col1,col2,col3,col4 = st.columns(4)
    with col1:
        total = round(df['Amount'].sum())
        st.metric('Total',str(total) + ' cr')
    
    with col2:
        max_fund =df.groupby('Startup')['Amount'].sum().sort_values(ascending = False).head(1).values[0]
        st.metric('Max',str(max_fund) + ' cr')

    with col3:
        avg_funding = round(df.groupby('Startup')['Amount'].sum().mean())
        st.metric('Average',str(avg_funding) + ' cr')
           
    with col4:
        total_startup = df['Startup'].nunique()
        st.metric('Total Startup',total_startup)
        
    st.header('Month on Month Graph on Startup Investment')
    selected_option = st.selectbox('Select Type',['Total','Count'])
    
    if selected_option == 'Count':
        temp_df = df.groupby(['Year','Month'])['Startup'].count().reset_index()
        temp_df['x_axis'] = temp_df['Month'].astype('str') + "-" + temp_df['Year'].astype('str')
        fig5,ax5 = plt.subplots(figsize=(8, 6))
        ax5.plot(temp_df['x_axis'],temp_df['Startup'])
        st.pyplot(fig5)
    elif selected_option == 'Total':
        temp_df = df.groupby(['Year','Month'])['Amount'].sum().reset_index()
        temp_df['x_axis'] = temp_df['Month'].astype('str') + "-" + temp_df['Year'].astype('str')
        fig5,ax5 = plt.subplots(figsize=(8, 6))
        ax5.plot(temp_df['x_axis'],temp_df['Amount'])
        st.pyplot(fig5)
            

####################################################
if option == 'Overall Analysis':
    load_overall_analysis()
elif option == 'StartUp':
    st.sidebar.selectbox('Select Startup',company_data)
    st.title('Startup Analysis')
    btn1 = st.sidebar.button('Find Startup Details')
elif option == 'Investor':
    selected_investor = st.sidebar.selectbox('Select Investor',investor_data)
    btn2 = st.sidebar.button('Find Investor Details')
    
    if btn2 :
        load_investor_details(selected_investor)
        