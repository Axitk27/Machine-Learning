class mera_Lr:
    
    def __init__(self):
        self.m = None
        self.b = None
    def fit(self,x_train,y_train):
        length = len(x_train)
        num = 0
        den = 0
        x_mean = x_train.mean()
        y_mean = y_train.mean()
        for i in range(length):
            num = num (x_train[i] - x_mean)* (y_train[i] - y_mean)
            den += (x_train[i] - x_mean)*(x_train[i] - x_mean)

        self.m = num/den
        
        self.b = y_mean - x_mean*self.m
        
        return self.m,self.b
            
    def predict(self,x_test):
        return 