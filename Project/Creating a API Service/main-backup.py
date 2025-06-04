from flask import Flask,jsonify,request
import ipl

app = Flask(__name__)

@app.route('/')
def home():
    return 'Hello World'

@app.route('/api/teams')
def teams():
    teams = ipl.teamsapi()
    return jsonify(teams)

@app.route('/api/team-record')
def team_record():
    team = request.args.get('team1')
    response = ipl.teamAPI(team)
    return response  


@app.route('/api/batsman-record')
def batsman_record():
    batsman = request.args.get('batsman')
    response = ipl.batsmanAPI(batsman)
    return response


@app.route('/api/bowler-record')
def bowler_record():
    bowler = request.args.get('bowler')
    response = ipl.bowlerAPI(bowler)
    return response

@app.route('/api/record')
def records():
    responce = ipl.Records()
    return responce

app.run(debug = True)
