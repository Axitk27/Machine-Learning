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


@app.route('/api/teamvteam')
def teamvteam():
    team1 = request.args.get('team1')
    team2 = request.args.get('team2')
    response = ipl.team_vs_teamapi(team1,team2)
    print(response)
    return jsonify(response)


@app.route('/api/team-record')
def team_record():
    team = request.args.get('team1')
    response = ipl.allRecord(team)
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

app.run(debug = True)
