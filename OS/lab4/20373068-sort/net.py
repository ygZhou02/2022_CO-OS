import torch.nn as nn  # basic building block for neural networks
import torch.nn.functional as F  # import convolution functions like ReLU


class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.layer1 = nn.Linear(in_features=250, out_features=250)
        # self.layer2 = nn.Linear(in_features=2000, out_features=2000)

    def forward(self, x):
        x = F.gelu(self.layer1(x))
        # x = F.relu(self.layer2(x))
        return x
