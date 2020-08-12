import numpy as np


x_train = np.genfromtxt('train.csv', delimiter=',')

x_train = np.delete(x_train, 0, 0)
x_train = np.delete(x_train, 0, 1)

row_sums = x_train.sum(axis=1)
x_train = x_train / row_sums[:, np.newaxis]

y = x_train[:,8]
x_train = np.delete(x_train, 8, 1)


print("\nTarget loss = 0.014701415304516179")

for LEARNIN_RATE in [0.1, 0.005, 0.002, 0.001, 0.0009, 0.0006, 0.0001]:
    for ITER_TIMES in [100000, 1000000, 5000000, 10000000, 50000000]:
        w = np.ones(len(x_train[0]))
        for i in range(ITER_TIMES):
            x_data = np.copy(x_train)
            y_data = np.copy(y) 
            
            y_pred = np.matmul(x_data, w)
            targetDiff = np.subtract(y_data, y_pred)
            loss = (targetDiff)**2
            gradient = np.multiply(np.matmul(np.transpose(x_data), targetDiff), -2)
            w -= LEARNIN_RATE * gradient 
        print("LEARNING RATE: " + str(LEARNIN_RATE) + " ITER: " + str(i) + " , loss = " + str(np.sum(loss)))

