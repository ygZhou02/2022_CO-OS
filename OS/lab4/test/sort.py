import torch
import numpy as np
from net import Net

pthfile = 'FCnet.pth'
net = torch.load(pthfile, map_location=torch.device('cpu'))

data = np.load("test.npy")  # read data
ans = torch.zeros(len(data), dtype=torch.float32)
data = torch.tensor(data.reshape(-1, 1000), dtype=torch.float32)

for i in range(data.shape[0]):
    index = net(data[i])
    tmp = (sorted(zip(index, range(len(index)))))
    tmp.sort(key=lambda v: v[0])
    label = torch.tensor([u[1] for u in tmp], dtype=torch.int32)
    print(i, data[i], label)
    for j in range(1000):
        ans[i * 1000 + label[j]] = data[i][j]

ans = torch.sort(ans)
np.save("result.npy", ans)