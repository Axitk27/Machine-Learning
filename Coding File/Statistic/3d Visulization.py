import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0,10,0.1)
f1 = np.sin(x)
f2 = x

plt.plot(x,f1)
plt.plot(x,f2)
plt.legend('Non Linear',"linear")
plt.grid("True")
plt.show()