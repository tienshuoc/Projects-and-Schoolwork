from .layer import *

class Network(object):
    # can change to convolution structure
    def __init__(self):

        # self.fc1 = FullyConnected(28*28, 60)
        # self.relu1 = ReLU()

        # self.classifier = FullyConnected(60, 47)
        # self.smce = SoftmaxWithCE()

        self.fc1 = FullyConnected(28*28, 570)
        self.relu1 = ReLU()

        self.fc2 = FullyConnected(570, 415)
        self.relu2 = ReLU()

        self.fc3 = FullyConnected(415, 60)
        self.relu3 = ReLU()

        self.classifier = FullyConnected(60, 47)
        self.smce = SoftmaxWithCE()

    def forward(self, input, target):
        ##example
        h1 = self.fc1.forward(input)
        a1 = self.relu1.forward(h1)
        h2 = self.fc2.forward(a1)
        a2 = self.relu2.forward(h2)
        h3 = self.fc3.forward(a2)
        a3 = self.relu3.forward(h3)
        out = self.classifier.forward(a3)
        pred, loss = self.smce.forward(out, target)

        return pred, loss

    def backward(self):
        ###
        smce_grad = self.smce.backward()
        out_grad = self.classifier.backward(smce_grad)
        a3_grad = self.relu3.backward(out_grad)
        h3_grad = self.fc3.backward(a3_grad)
        a2_grad = self.relu2.backward(h3_grad)
        h2_grad = self.fc2.backward(a2_grad)
        a1_grad = self.relu1.backward(h2_grad)
        self.fc1.backward(a1_grad)

    def update(self, lr, optimizer="SGD", curr_epoch=None):
        ##
        if optimizer == "SGD":
            self.fc1.weight -= lr*self.fc1.weight_grad
            self.fc1.bias -= lr*self.fc1.bias_grad

            self.fc2.weight -= lr*self.fc2.weight_grad
            self.fc2.bias -= lr*self.fc2.bias_grad
            
            self.fc3.weight -= lr*self.fc3.weight_grad
            self.fc3.bias -= lr*self.fc3.bias_grad

            self.classifier.weight -= lr*self.classifier.weight_grad
            self.classifier.bias -= lr*self.classifier.bias_grad

        elif optimizer == "adam":
            if(curr_epoch == None): raise Exception("Provide epochs for Adam Optimizer")
            self.fc1.weight -= self.fc1.adam_weightGrad(iter=curr_epoch)*lr
            self.fc1.bias -= self.fc1.adam_biasGrad(iter=curr_epoch)*lr
            self.fc2.weight -= self.fc2.adam_weightGrad(iter=curr_epoch)*lr
            self.fc2.bias -= self.fc2.adam_biasGrad(iter=curr_epoch)*lr
            self.fc3.weight -= self.fc3.adam_weightGrad(iter=curr_epoch)*lr
            self.fc3.bias -= self.fc3.adam_biasGrad(iter=curr_epoch)*lr
            self.classifier.weight -= self.classifier.adam_weightGrad(iter=curr_epoch)*lr
            self.classifier.bias -= self.classifier.adam_biasGrad(iter=curr_epoch)*lr

        else: raise Exception("Unrecognized Optimizer")


        
        
