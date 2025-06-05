from flask import Flask,render_template,request
import requests

#request - Module will help you to use to hit the url and get the data from the self API
#requests = Module will help you to hit other API for some service 

app = Flask(__name__)

@app.route('/')
def home():
    responce = requests.get('http://127.0.0.1:5000/api/teams')
    responce = responce.json()['teams']
    responce = sorted(responce)
    # print(responce.json()['teams'])
    return render_template('index.html',teams = responce)


@app.route('/teamvteam')
def team_vs_team():
    team1 = request.args.get('team1')
    team2 = request.args.get('team2')
    responce = requests.get('http://127.0.0.1:5000/teamvteam?team1={}&team2={}'.format(team1,team2))
    responce = responce.json()
    
    teams = requests.get('http://127.0.0.1:5000/api/teams')
    teams = teams.json()['teams']
    teams = sorted(teams)
    
    return render_template('index.html',result = responce,teams = teams)
    
app.run(debug = True,port=8000)