import requests

url = "https://twinword-twinword-bundle-v1.p.rapidapi.com/sentiment_analyze/"

payload = { "text": "great value in its price range!" }
headers = {
	"x-rapidapi-key": "47ccbde18dmsh4905a8fe3502b22p12ed60jsn38c7319a4c74",
	"x-rapidapi-host": "twinword-twinword-bundle-v1.p.rapidapi.com",
	"Content-Type": "application/x-www-form-urlencoded"
}

response = requests.post(url, data=payload, headers=headers)

print(response.json())
