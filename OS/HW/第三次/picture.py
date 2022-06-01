import numpy as np
import matplotlib.pyplot as plt

x = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
y1 = np.array([90, 80, 67, 59, 47, 39, 30, 20, 12, 10])
y2 = np.array([90, 80, 70, 56, 52, 42, 29, 17, 14, 10])
y3 = np.array([90, 64, 48, 37, 29, 22, 16, 12, 11, 10])

plt.xlabel("page_frame_size")
plt.ylabel("miss_time")
plt.plot(x, y1, color="green")
plt.plot(x, y2, color="red")
plt.plot(x, y3, color="blue")
plt.legend(["FIFO", "LRU", "OPT"])
plt.show()
plt.imsave("img.png")