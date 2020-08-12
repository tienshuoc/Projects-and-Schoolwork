import numpy as np

class _Layer(object):
    def __init__(self):
                pass

    def forward(self, *input):
        r"""Define the forward propagation of this layer.

        Should be overridden by all subclasses.
        """
        raise NotImplementedError

    def backward(self, *output_grad):
        r"""Define the backward propagation of this layer.

        Should be overridden by all subclasses.
        """
        raise NotImplementedError

class FullyConnected(_Layer):
    def __init__(self, in_features, out_features):
        
        self.weight = np.random.randn(in_features, out_features) * 0.01 # initialize weights of layer randomly
        self.bias = np.zeros((1, out_features)) # initialize bias as zero

        self.weight_grad = np.zeros((in_features, out_features))
        self.bias_grad = np.zeros((1, out_features))

        self.adam_m_weight = 0
        self.adam_v_weight = 0
        self.adam_m_bias = 0
        self.adam_v_bias = 0

    def adam_weightGrad(self, iter, beta1=0.9, beta2=0.999, epsilon=1e-08):
        self.adam_m_weight = beta1 * self.adam_m_weight + (1 - beta1) * self.weight_grad
        self.adam_v_weight = beta2 * self.adam_v_weight + (1 - beta2) * (self.weight_grad)**2
        m_hat = (self.adam_m_weight / (1 - beta1**iter))
        v_hat = (self.adam_v_weight / (1 - beta2**iter))

        return m_hat / (np.sqrt(v_hat) + epsilon)

    def adam_biasGrad(self, iter, beta1=0.9, beta2=0.999, epsilon=1e-08):
        self.adam_m_bias = beta1 * self.adam_m_bias + (1 - beta1) * self.bias_grad
        self.adam_v_bias = beta2 * self.adam_v_bias + (1 - beta2) * (self.bias_grad)**2
        m_hat = (self.adam_m_bias / (1 - beta1**iter))
        v_hat = (self.adam_v_bias / (1 - beta2**iter))

        return (m_hat / (v_hat**0.5 + epsilon))

    def forward(self, input):
    	###useful at backward
        self._save_for_backward = input

        output = np.dot(input, self.weight) + self.bias
        ######

        return output

    def backward(self, output_grad):
    	###########################
        
        self.weight_grad = np.dot(np.transpose(self._save_for_backward), output_grad) ###########
        self.bias_grad = output_grad.sum(axis=0, keepdims=True)

        input_grad = np.dot(output_grad, np.transpose(self.weight))
        
        return input_grad  ###########################

class ReLU(_Layer):
    def __init__(self):
        pass

    def forward(self, input):
        self._save_for_backward = input

        output = np.maximum(input, 0) # values greater than zero are kept, smaller than zeros are replaced with zeros

        return output

    def backward(self, output_grad):
        input_grad = output_grad.copy()
        input_grad[self._save_for_backward < 0] = 0 # if the original value in same position is smaller than zero, than clear to zero

        return input_grad

class SoftmaxWithCE(_Layer):
    def __init__(self):
        pass

    def forward(self, input, target):
        self._save_for_backward_target = target

        '''Softmax'''
        e_input = np.exp(input - np.max(input)) # shift to largest is zero (avoid overflow), then exponential
        predict = e_input / np.sum(e_input, axis=1, keepdims=True)  # divide by sum to calculate probability (softmax array)

        self._save_for_backward_predict = predict

        '''Average Cross Entropy'''
        ce = float(np.average(np.sum(-target * np.log(predict), axis=1)))

        return predict, ce

    def backward(self):
        #########
        input_grad = self._save_for_backward_predict - self._save_for_backward_target

        return input_grad