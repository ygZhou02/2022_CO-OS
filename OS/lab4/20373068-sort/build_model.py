import numpy as np  # for transformation
import torch  # PyTorch package
import torch.nn as nn  # basic building block for neural networks
import torch.nn.functional as F  # import convolution functions like ReLU
from torch.optim import SGD

from net import Net

data = np.load("test.npy")  # read data
# label = np.load("correct_result.npy")

data = torch.tensor(data.reshape(-1, 250), dtype=torch.float32)
# label = torch.tensor(label.reshape(-1, 1000), dtype=torch.float32)

net = Net()
print(net)

criterion = nn.MSELoss(size_average=False)
optimizer = SGD(net.parameters(), lr=0.1)

for i in range(data.shape[0]):
    data1 = (data[i]-torch.min(data[i])) / (torch.max(data[i])-torch.min(data[i]))
    tmp = (sorted(zip(data1, range(len(data1)))))
    tmp.sort(key=lambda data1: data1[0])
    label1 = torch.Tensor([data1[1] for data1 in tmp])
    # print(i, data1, label1)
    print(i)
    for epoch in range(10):
        pred_label1 = net(data1)
        loss = criterion(pred_label1, label1)
        # print(epoch, loss.data.item())

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

torch.save(net, "FCnet.pth")
