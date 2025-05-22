from nltk.sentiment import SentimentIntensityAnalyzer
import nlpcloud

class API:
    def __init__(self):
        pass
    
    def sentiment_analysis(self,text):        
        sia = SentimentIntensityAnalyzer()
        responce = sia.polarity_scores(text)
        return responce
    
    def namedEntity_analysis(self,text,searched_text):
        client = nlpcloud.Client("finetuned-llama-3-70b", "c1677dc6dbd8be3d3ddcec2d2e301d5947666389", gpu=True)
        responce = client.entities(text,searched_entity=searched_text)
        return responce
    
    