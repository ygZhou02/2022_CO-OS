import queue


page_frame = 1
page_list = []
fifo_pointer = 0
lru_record = {}
now_time = 0

query_list = [0, 9, 8, 4, 4, 3, 6, 5, 1, 5, 0, 2, 1, 1, 1, 1, 8, 8, 5,
              3, 9, 8, 9, 9, 6, 1, 8, 4, 6, 4, 3, 7, 1, 3, 2, 9, 8, 6, 2, 9, 2, 7, 2, 7, 8, 4, 2, 3, 0, 1, 9, 4,
              7, 1, 5, 9, 1, 7, 3, 4, 3, 7, 1, 0, 3, 5, 9, 9, 4, 9, 6, 1, 7, 5, 9, 4, 9, 7, 3, 6, 7, 7, 4, 5, 3, 5, 3,
              1, 5, 6, 1,
              1, 9, 6, 6, 4, 0, 9, 4, 3]


def create_page_list():
    for i in range(page_frame):
        page_list.append(-1)


def clear_page_list():
    for i in range(page_frame):
        page_list[i] = -1


def opt_replace(i):
    future_list = query_list[(i + 1):]
    future_times = []
    for item in page_list:
        q = 0
        while q < len(future_list):
            if future_list[q] == item:
                break
            q += 1
        future_times.append(q)  # find the one latest used
    max_time = max(future_times)
    for q in range(len(future_times)):
        if future_times[q] == max_time:
            break  # find the max subscript
    page_list[q] = query_list[i]
    return


def fifo_replace(i):
    global fifo_pointer
    page_list[fifo_pointer] = query_list[i]
    fifo_pointer += 1
    fifo_pointer %= page_frame


def lru_replace(i):
    global now_time
    index = min(lru_record, key=lambda x: lru_record[x])
    lru_record.pop(index)
    for j in range(len(page_list)):
        if page_list[j] == index:
            break
    page_list[j] = query_list[i]
    lru_record[query_list[i]] = now_time
    # print(lru_record)


def go_through(func):
    miss_time = 0
    total_time = 0
    clear_page_list()
    global fifo_pointer
    global now_time
    for i in range(len(query_list)):
        flag = 0
        total_time += 1
        now_time += 1
        for j in page_list:
            if j == query_list[i]:
                flag = 1  # page list hits
                break
        if flag == 0:  # page list misses
            miss_time += 1
            # print("miss! at the {} query, for page {}".format(i, query_list[i]))
            # print(page_list)
            for j in range(page_frame):
                if page_list[j] == -1:
                    flag = 1
                    lru_record[query_list[i]] = now_time
                    break  # there's still some empty pages
            if flag == 0:
                func(i)  # do replacement
            else:
                page_list[j] = query_list[i]
                fifo_pointer = (j+1) % page_frame
        else:
            lru_record[query_list[i]] = now_time
            # print(lru_record)
    return miss_time


def main():
    create_page_list()
    global page_frame
    global page_list
    miss_rate_list = []
    for page_frame in range(1, 11):
        page_list = []
        create_page_list()
        clear_page_list()
        miss_rate = go_through(fifo_replace)  # choose replace algorithm
        miss_rate_list.append(miss_rate)
    print("fifo:", miss_rate_list)


if __name__ == "__main__":
    main()
