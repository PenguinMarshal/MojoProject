import time
import timeit
import random
from random import seed

#bubble sort
def py_b_sort():
    data = generate()
    for _ in range(len(data)-1):
        for j in range(len(data)-1):
            if data[j] > data[j+1]:
                data[j], data[j+1] = data[j+1], data[j]

#insertion sort
def py_i_sort():
    data = generate()
    for i in range(1, len(data)):
        key = data[i]
        j = i-1
        while j >= 0 and key < data[j]:
            data[j+1] = data[j]
            j = j-1
        data[j+1] = key
      
#selection sort
def py_s_sort():
    data = generate()
    for i in range(len(data)):
        min_idx = i
        for j in range(i+1, len(data)):
            if (data[j] < data[min_idx]):
                min_idx = j
        data[i], data[min_idx] = data[min_idx], data[i]
  
# quick sort
def py_q_sort():
    data = generate()
    quick_sort(data, 0, len(data) - 1)

def quick_sort(data, head, tail):
    if head < tail:
        idx = partition(data, head, tail)
        # Left Partition
        quick_sort(data, head, idx-1,)
        # Right Partition
        quick_sort(data, idx+1, tail)

def partition(data, head, tail):
    border = head
    pivot = data[tail]
    for j in range(head, tail):
        if data[j] < pivot:
            data[border], data[j] = data[j], data[border]
            border += 1
    data[border], data[tail] = data[tail], data[border]
    return border

#generate
def generate():
  random_numbers = []
  min = 1
  max = 100
  size = 1000

  seed()
  for _ in range(size):
    random_number = random.randint(min, max)
    random_numbers.append(random_number)
  return random_numbers

def py_bench_helper(alg):
    if alg == "Selection Sort":
        time = timeit.timeit(py_s_sort, number=1000)
        return time
    elif alg == "Insertion Sort":
        time = timeit.timeit(py_i_sort, number=1000)
        return time
    elif alg == "Bubble Sort":
        time = timeit.timeit(py_b_sort, number=1000)
        return time
    elif alg == "Quick Sort":
        time = timeit.timeit(py_q_sort, number=1000)
        return time
    else:
        return -1
