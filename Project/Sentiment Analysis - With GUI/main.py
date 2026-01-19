from tkinter import *
from mydb import Database
from myapi import API
from tkinter import messagebox

class NLPAPP:
    def __init__(self):
        
        #Create a Database object 
        self.dbo = Database()
        self.apio = API()
        
        #login hum add kr shakte he
        self.root = Tk()
        self.root.title('NLPApp')
        self.root.iconbitmap('recources/favicon.ico')#it will change the icon on the GUI. You need to convert that image to favicon formate 
        self.root.geometry('350x600')#change the size of the opening window
        self.root.configure(bg = '#302e30' ) #you can add teh color to the window
        
        #creating a GUI Function for Login
        self.login_gui()
        
        self.root.mainloop() #it will hold the GUI
    
    
    def login_gui(self):
        self.clear()
        #Enter heading as a text
        heading = Label(self.root,text='NLPApp',bg = '#302e30',fg = 'white' ) #add the text 
        heading.pack(pady = (30,30))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading.configure(font=('verdana',24,'bold'))#changing the configuration 
        
        #Enter Email as a text
        label1 = Label(self.root,text='Enter Email',bg = '#302e30',fg = 'white')
        label1.pack(pady = (10,10))
        
        #Input a Email 
        self.email_input = Entry(self.root,width = 30)
        self.email_input.pack(pady=(5,10),ipady = 3)
       
        #Enter Email as a text
        label2 = Label(self.root,text='Enter Password',bg = '#302e30',fg = 'white')
        label2.pack(pady = (10,10))#gap is not from a top sondarn from the last element
        
        #Input a Email 
        self.password_input = Entry(self.root,width = 30,show='*')
        self.password_input.pack(pady=(5,10),ipady = 3)
        
        #add a Button
        login_button = Button(self.root,text='Login',width = 30, height= 2,command = self.login )
        login_button.pack(pady=(10,10))
        
        
         #Enter Email as a text
        label3 = Label(self.root,text='Not a member?',bg = '#302e30',fg = 'white')
        label3.pack(pady = (20,10))#gap is not from a top sondarn from the last element
        
        #add a Button
        redirect_button = Button(self.root,text='Register Now',width = 15, height= 1,command = self.register_gui)
        redirect_button.pack(pady=(10,10))
    
    #clearnign the screen
    def clear(self):
        for item in self.root.pack_slaves():
            item.destroy()
    
    def register_gui(self):
        #clearnign a GUI first
        self.clear()
        
        #Enter heading as a text
        heading = Label(self.root,text='NLPApp',bg = '#302e30',fg = 'white' ) #add the text 
        heading.pack(pady = (30,30))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading.configure(font=('verdana',24,'bold'))#changing the configuration 
        
        #Enter Email as a text
        label0 = Label(self.root,text='Enter Name',bg = '#302e30',fg = 'white')
        label0.pack(pady = (10,10))
        
        #Input a Email 
        self.name_input = Entry(self.root,width = 30)
        self.name_input.pack(pady=(5,10),ipady = 3)
        
        #Enter Email as a text
        label1 = Label(self.root,text='Enter Email',bg = '#302e30',fg = 'white')
        label1.pack(pady = (10,10))
        
        #Input a Email 
        self.email_input = Entry(self.root,width = 30)
        self.email_input.pack(pady=(5,10),ipady = 3)
       
        #Enter Email as a text
        label2 = Label(self.root,text='Enter Password',bg = '#302e30',fg = 'white')
        label2.pack(pady = (10,10))#gap is not from a top sondarn from the last element
        
        #Input a Email 
        self.password_input = Entry(self.root,width = 30,show='*')
        self.password_input.pack(pady=(5,10),ipady = 3)
        
        #add a Button
        register_button = Button(self.root,text='Register',width = 20, height= 1, command = self.perform_registeration)
        register_button.pack(pady=(10,10))
        
        
         #Enter Email as a text
        label3 = Label(self.root,text='Already a member?',bg = '#302e30',fg = 'white')
        label3.pack(pady = (20,10))#gap is not from a top sondarn from the last element
        
        #add a Button
        redirect_button = Button(self.root,text='Login now',width = 15, height= 1,command = self.login_gui)
        redirect_button.pack(pady=(10,10))
    
    
    def perform_registeration(self):
        #fetch data from the GUI
        name = self.name_input.get()
        email = self.email_input.get()
        password = self.password_input.get()
        
        responce = self.dbo.add_data(name,password,email)
        
        if responce:
            messagebox.showinfo('Success','Registeration Successful. You can Login now')
        else:
            messagebox.showerror('Error','Email Exist')
            
    def login(self):
        #fethch the data 
        email = self.email_input.get()
        password = self.password_input.get()
        
        responce = self.dbo.search(email,password)
        
        if responce == 2:
            messagebox.showerror('Error','Entered Email is Wrong')
        elif responce == 0:
            messagebox.showerror('Error','Password is wrong')
        else:
            messagebox.showinfo('Success','Login Successful.')
            self.home_gui()
            
    def home_gui(self):
        self.clear()
        
        heading = Label(self.root,text='NLPApp',bg = '#302e30',fg = 'white' ) #add the text 
        heading.pack(pady = (30,30))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading.configure(font=('verdana',24,'bold'))#changing the configuration 
        
        sentiment_button = Button(self.root,text='Sentiment Analysis',width = 40, height= 3, command = self.sentiment_gui)
        sentiment_button.pack(pady=(10,10))
        ner_button = Button(self.root,text='Name Entity Recognition Analysis',width = 40, height= 3, command = self.ner_gui)
        ner_button.pack(pady=(10,10))
        emotion_button = Button(self.root,text='Emotion Prediction',width = 40, height= 3, command = self.emotion_gui)
        emotion_button.pack(pady=(10,10))
        login_button = Button(self.root,text='Logout',width = 30, height= 2,command = self.login_gui)
        login_button.pack(pady=(20,10))

        
        
    def sentiment_gui(self):
        self.clear()
        heading = Label(self.root,text='NLPApp',bg = '#302e30',fg = 'white' ) #add the text 
        heading.pack(pady = (30,30))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading.configure(font=('verdana',24,'bold'))#changing the configuration 
        
        heading2 = Label(self.root,text='Sentiment Analysis',bg = '#302e30',fg = 'white' ) #add the text 
        heading2.pack(pady = (10,20))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading2.configure(font=('verdana',12))#changing the configuration 
        
        #Enter Email as a text
        label1 = Label(self.root,text='Enter the Text',bg = '#302e30',fg = 'white')
        label1.pack(pady = (10,10))#gap is not from a top sondarn from the last element
        
        #Input a Sentiment data 
        self.sentiment_input = Entry(self.root,width = 50)
        self.sentiment_input.pack(pady=(5,10),ipady = 5)
        
        #add a Button
        sentiment_button = Button(self.root,text='Analyze Sentiment',width = 15, height= 1,command = self.do_sentiment_analysis)
        sentiment_button.pack(pady=(10,10))
        
        self.sentiment_result = Label(self.root,text = '',bg = '#302e30',fg = 'white')
        self.sentiment_result.pack(pady=(5,10))
        self.sentiment_result.configure(font=('verdana',16))#changing the configuration 
        
        #add a Button
        goback_button = Button(self.root,text='Home Page',width = 15, height= 1,command=self.home_gui)
        goback_button.pack(pady=(10,10))
    
    def ner_gui(self):
        self.clear()
        heading = Label(self.root,text='NLPApp',bg = '#302e30',fg = 'white' ) #add the text 
        heading.pack(pady = (30,30))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading.configure(font=('verdana',24,'bold'))#changing the configuration 
        
        heading2 = Label(self.root,text=' Name Entity Recognition Analysis',bg = '#302e30',fg = 'white' ) #add the text 
        heading2.pack(pady = (10,20))#apply the data on the screen also give space 30 from top and 30 from bottom
        heading2.configure(font=('verdana',12))#changing the configuration 
        
        #Enter data as a text
        label1 = Label(self.root,text='Enter the Text',bg = '#302e30',fg = 'white')
        label1.pack(pady = (10,10))#gap is not from a top sondarn from the last element
        
        #Input a Sentiment data 
        self.ner_input = Entry(self.root,width = 50)
        self.ner_input.pack(pady=(5,10),ipady = 5)
        
        #Enter data as a text
        label2 = Label(self.root,text='Enter the search Entity',bg = '#302e30',fg = 'white')
        label2.pack(pady = (10,10))#gap is not from a top sondarn from the last element
        
        #Input a Sentiment data 
        self.ner_searched_input = Entry(self.root,width = 50)
        self.ner_searched_input.pack(pady=(5,10),ipady = 5)
        
        #add a Button
        ner_button = Button(self.root,text='Entity Analyze ',width = 15, height= 1,command = self.do_ner_analysis)
        ner_button.pack(pady=(10,10))
        
        self.ner_result = Label(self.root,text = '',bg = '#302e30',fg = 'white')
        self.ner_result.pack(pady=(5,10))
        self.ner_result.configure(font=('verdana',16))#changing the configuration 
        
        #add a Button
        goback_button = Button(self.root,text='Home Page',width = 15, height= 1,command=self.home_gui)
        goback_button.pack(pady=(10,10))
    
        
        
    def do_sentiment_analysis(self):
        text = self.sentiment_input.get()
        responce = self.apio.sentiment_analysis(text)
        # print(responce)
        txt = ''
        for item in responce:
            txt = txt + item + '->' + str(responce[item]) +'\n'

        self.sentiment_result['text'] = txt
        
        
    def do_ner_analysis(self):
        text = self.ner_input.get()
        searched_text = self.ner_searched_input.get()
        responce = self.apio.namedEntity_analysis(text,searched_text)
        print(responce)
        
        # txt = ''
        
        # for item in responce:
        #     txt = txt + item + '->' + str(responce[item]) +'\n'

        # self.sentiment_result['text'] = txt
        
        
    def emotion_gui(self):
        pass
            
nlp = NLPAPP()
        
        
        
# axit.kakadiya@gmail.com