from flask import Flask,jsonify,request,render_template
import ipl

max = 2

app = Flask(__name__)

@app.route('/')
def login():
    return render_template('login.html')

@app.route('/service')
def service():
    return render_template('service.html')

@app.route('/team-analysis')
def team_analysis():
    return render_template('team-analysis.html')


@app.route('/api/team-record')
def team_record():
    team = request.args.get('user_ka_team')
    print(team)
    responce = ipl.teamAPI(team)
    return responce

@app.route('/batsman-analysis')
def batsman_analysis():
    return render_template('batsman-analysis.html')

@app.route('/api/batsman-record')
def batsman_record():
    batsman = request.args.get('batsman_ka_name')
    response = ipl.batsmanAPI(batsman)
    return response

@app.route('/bowler-analysis')
def bowler_analysis():
    return render_template('bowler-analysis.html')

@app.route('/api/bowler-record')
def bowler_record():
    bowler = request.args.get('bowler_ka_name')
    response = ipl.bowlerAPI(bowler)
    return response

@app.route('/record-analysis')
def record_analysis():
    return render_template('record-analysis.html')

@app.route('/api/record')
def records():
    responce = ipl.Records()
    return responce

app.run(debug = True)
