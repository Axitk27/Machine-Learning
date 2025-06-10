import streamlit as st
import pandas as pd
import time

#this is a library created on top of react of Java for more functanality like a Flask

st.title('Startup Dashboard')

#heading
st.header('I am Learning Streamlit')

#sub heading
st.subheader('and I am Loving it')

#normal Text
st.write('I am axit Kakadiya and Learning a Machine Learning and wants to be good in this field')

#this will create a heading and a list
st.markdown("""
           ### My Fevourite Movies
            - Shawshank Redemption
            - Malamal Weekly
            """)

#to show a code

st.code("""
        
        def foo(i):
            pass
            
        foo()
        """)

#to the formula

st.latex('int(x^2)+ y^2 = 0')

#show dataframe

df = pd.DataFrame({
    'Name':['Anupam','Raghav'],
    'Marks':[100,90],
    'Placement':['Yes','No']
})

st.dataframe(df)


#show matrix

st.metric('Revenue','Rs 3L','-3')

#JSON output

st.json({
    'Name':['Anupam','Raghav'],
    'Marks':[100,90],
    'Placement':['Yes','No']
})

#to show a image and video and audio

# st.image('Resources\Background.jpg')
# st.video('')
# st.audio()

#what is react
# javascript is a language for frontand and backend

#this is the code of the sidebar
st.sidebar.title('Sidebar')

#working row vise
col1,col2,col3 = st.columns(3)
with col1:
    st.image('Resources\Background.jpg')
with col2:
    st.image('Resources\Background.jpg')
with col3:
    st.image('Resources\Background.jpg')

#success and failure message
st.error('Failed')
st.success('Done')
st.info('Done')
st.warning('Done')

#progress bar

# bar = st.progress(0)

# for i in range(0,100):
#     time.sleep(0.01)
#     bar.progress(i) #this should have a range between o to 100


#take input data from the user

email = st.text_input('Enter your Email')
age = st.number_input('Enter your age')
date = st.date_input('Enter your date')

#buttons


email = st.text_input('Email')
password = st.text_input('Password')

gender = st.selectbox('Gender',['Male','Female','Other'])
btn = st.button('Login')


if btn:
    if email == 'axit.kakadiya@outlook.com' and password =='1234':
        st.success('Login Successful')
        st.balloons()
        st.write(gender)
    else:
        st.error('Email or Password might be wrong')
    
    