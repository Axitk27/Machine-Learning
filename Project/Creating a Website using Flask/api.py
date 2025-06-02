import nlpcloud

client = nlpcloud.Client("finetuned-llama-3-70b", "1d290956892d79df1c637cc822a9e50d2c49548e", gpu=True)

def text_summary(text):
    x = client.entities(
    text,
    searched_entity="programming languages"
)
    return x
