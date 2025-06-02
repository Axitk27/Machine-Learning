#Hello WOrl Wab Application

from flask import Flask
from flask import render_template
from flask import request
from flask import redirect
from flask import session
from db import Database
from api import text_summary
app = Flask(__name__)
dbo = Database()
# __name__ willl give me the name of the file

@app.route('/')
def index():
    return render_template('login.html')

@app.route('/register')
def register():
    return render_template('register.html')

@app.route('/perform_registration',methods=['post'])
def perform_registration():
    name = request.form.get('user_ka_name')
    email = request.form.get('user_ka_email')
    password = request.form.get('user_ka_password')
    responce = dbo.insert(name,email,password)
    
    if responce == 1:
        
        return render_template('login.html',message = 'Registration Successfull. Please Login')
    else:
        return render_template('register.html',message = "Email already exist")


@app.route('/perform_login',methods=['post'])
def perform_login():
    email = request.form.get('user_ka_email')
    password = request.form.get('user_ka_password')
    responce = dbo.search(email,password)
    print(email,password)
    if responce == 1:
        return redirect('/profile')
    else:
        return 'Incorrect Email/Password'
    
@app.route('/profile')
def profile():
    return render_template('/profile.html')

        
@app.route('/ner')
def ner():
    return render_template('/ner.html')

        
@app.route('/perform_ner',methods=['post'])
def perform_ner():
    text = request.form.get("ner_text")
    ans = text_summary(text)
    return render_template('/ner.html')

app.run(debug = True)

