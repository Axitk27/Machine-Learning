import pandas as pd
import plotly.graph_objects as go
import plotly.express as px

import dash
from dash import dcc 
from dash import html
from dash.dependencies import Input, Output

gap = px.data.gapminder()
app = dash.Dash()

#heading

fig1 = px.scatter(gap, x="pop", y="gdpPercap")
fig2 = px.box(gap, x="gdpPercap")


app.layout = html.Div([
    html.Div(children=[
        html.H1("My First Dashboard",style={'color':'blue','text-align':'center'})],style={'border':'1px black solid','float':'left','width':'100%','height':'50px'}),
    html.Div(children=[
        dcc.Graph(figure=fig1)],style={'border':'1px black solid','float':'left','width':'49.7%','height':'350px'}),
    html.Div(children=[
        dcc.Graph(figure=fig2)
        ],style={'border':'1px black solid','float':'left','width':'49.7%','height':'350px'})])


if __name__=='__main__':
    app.server.run()

