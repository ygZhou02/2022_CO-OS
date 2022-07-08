import numpy as np
import torch

from net import Net

pthfile = 'FCnet.pth'
net = torch.load(pthfile, map_location=torch.device('cpu'))

data = np.load("test.npy")  # read data
ans = data
data = torch.tensor(data.reshape(-1, 250), dtype=torch.float32)

for i in range(int(data.shape[0]/3)):
    index = net(data[i])
    tmp = (sorted(zip(index, range(len(index)))))
    tmp.sort(key=lambda v: v[0])
    label = torch.tensor([u[1] for u in tmp], dtype=torch.int32)
    # print(i, data[i], label)
    # print(i)
    for j in range(250):
        ans[i * 250 + label[j]] = data[i][j]

ans, indices = torch.sort(torch.Tensor(ans))
# print(ans.shape, ans[534], ans[13415])
np.save("result.npy", ans)
