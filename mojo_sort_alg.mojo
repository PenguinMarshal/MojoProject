from random import random_ui64, seed
import benchmark

# Swap function 
@always_inline
fn swap(inout vector: List[Int], a: Int, b: Int):
    vector[a], vector[b] = vector[b], vector[a]

# Insertion Sort  
fn mojo_i_sort(inout vector: List[Int]):
    for i in range(1, len(vector)):
        var key = vector[i]
        var j = i - 1
        # Shift elements to the right to make room for the key
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            j -= 1
        vector[j + 1] = key

# Quick Sort  
fn mojo_q_sort(inout vector: List[Int]):
    _quick_sort(vector, 0, len(vector) - 1)

# Recursive Quick Sort helper  
fn _quick_sort(inout vector: List[Int], low: Int, high: Int):
    if low < high:
        var pi = _partition(vector, low, high)
        _quick_sort(vector, low, pi - 1)
        _quick_sort(vector, pi + 1, high)

# Partition function for Quick Sort  
@always_inline
fn _partition(inout vector: List[Int], low: Int, high: Int) -> Int:
    var pivot = vector[high]
    var i = low - 1
    for j in range(low, high):
        if vector[j] <= pivot:
            i += 1
            swap(vector, i, j)
    swap(vector, i + 1, high)
    return i + 1

# Selection Sort
fn mojo_s_sort(inout vector: List[Int]):
    for i in range(len(vector)):
        var min_idx = i
        for j in range(i + 1, len(vector)):
            if vector[j] < vector[min_idx]:
                min_idx = j
        if min_idx != i:
            swap(vector, i, min_idx)

# Bubble Sort
fn mojo_b_sort(inout vector: List[Int]):
    for i in range(len(vector)):
        for j in range(len(vector) - i - 1):
            if vector[j] > vector[j + 1]:
                swap(vector, j, j + 1)

fn generate() -> List[Int]:
    var minVal:Int= 1
    var maxVal:Int = 100
    var size:Int = 1000
    var dataset = List[Int]()
    
    #generate random numbers
    seed()
    for _ in range(size):
        dataset.append(int(random_ui64(minVal, maxVal+1)))

    return dataset

fn selection_wrapper():
    dataset = generate()
    mojo_b_sort(dataset)

fn insertion_wrapper():
    dataset = generate()
    mojo_b_sort(dataset)

fn bubble_wrapper():
    dataset = generate()
    mojo_b_sort(dataset)

fn quick_wrapper():
    dataset = generate()
    mojo_b_sort(dataset)

def mojo_bench_helper(alg:String):

    if alg == "Selection Sort":
        var report = benchmark.run[selection_wrapper](0, 1000)
        return report.mean() * 1000
    elif alg == "Insertion Sort":
        var report = benchmark.run[insertion_wrapper](0, 1000)
        return report.mean() * 1000    
    elif alg == "Bubble Sort":
        var report = benchmark.run[bubble_wrapper](0, 1000)
        return report.mean() * 1000   
    elif alg == "Quick Sort":
        var report = benchmark.run[quick_wrapper](0, 1000)
        return report.mean() * 1000
    else:
        return -1