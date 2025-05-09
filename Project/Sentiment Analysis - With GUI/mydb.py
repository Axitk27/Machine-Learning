import json

class Database:
    
    def add_data(self,name,password,email):
        
        with open('D:\Education\Extra\Machine Learning\Project\Sentiment Analysis - With GUI\db.json','r') as rf:
            database = json.load(rf)
        
        if email in database:
            return 0
        else:
            database[email] = [name,password]
            with open('D:\Education\Extra\Machine Learning\Project\Sentiment Analysis - With GUI\db.json','w') as wf:
                json.dump(database,wf)
            return 1
          
    
    def search(self,email,password):
        with open('D:\Education\Extra\Machine Learning\Project\Sentiment Analysis - With GUI\db.json','r') as rf:
            database = json.load(rf)
            
            if email in database:
                if database[email][1] == password:
                    return 1
                else:
                    return 0
            else:
                return 2
            

