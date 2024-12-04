from python import Python
from python import PythonObject

from collections import List
from random import random_ui64, seed
from time import sleep

from mojo_sort_alg import mojo_bench_helper
import benchmark

#GET COLORS#########################################################

#functions to get color lists
def get_colors(n:Int, color:String) -> PythonObject:
    #var app_g = Python.import_module("sortapp")

    var color_list : PythonObject = []
    for _ in range(n):
        color_list.append(color)
    return color_list

#overloaded function
def get_colors(n:Int, i:Int, j:Int) -> PythonObject:
    #var app_b = Python.import_module("sortapp")

    var color_list : PythonObject = []
    for x in range (n):
        if x == j:
            color_list.append('#ffc907') #yellow
        elif x < i:
            color_list.append('#51f052') #green
        else:
            color_list.append('#c62027') #red

    return color_list

#not overloaded because function is specifically for quick sort
def get_colors_quick(data_len:Int, low:Int, high:Int, bound:Int, cur_idx:Int, isSwap = False) -> PythonObject:
    var colorArray : PythonObject = []
    for x in range(data_len):
        if x >= low and x <= high:
            colorArray.append('#6fa8dc') #light blue - subarray being processed
        else:
            colorArray.append('#ffffff') #white - subarray not being processed

        if x == high:
            colorArray[x] = '#0b2973' #blue
        elif x == bound:
            colorArray[x] = '#c62027' #red
        elif x == cur_idx:
            colorArray[x] = '#ffc907' #yellow

        if isSwap:
            if x == bound or x == cur_idx:
                colorArray[x] = '#51f052' #green
    return colorArray


#SORTING#########################################################


#Selection Sort
def selection_sort(app : PythonObject, data : PythonObject):
    #every function that uses the Python app object
    #needs this placeholder variable to load module
    #app_ss is never used
    var app_ss = Python.import_module("sortapp")

    var n = len(data)
    #sort logic
    for i in range(n):
        var min_idx = i
        for j in range(i + 1, n):
            if data[j] < data[min_idx]:
                min_idx = j

            #call Python App class draw function
            app.drawData(data, get_colors(n, i, j))
            #get speed
            var speed = app.get_speed()
            var s_speed: Float64 = speed.to_float64()
            sleep(s_speed)

        if min_idx != i:
            data[i], data[min_idx] = data[min_idx], data[i]

#Insertion Sort
def insertion_sort(app : PythonObject, data : PythonObject):
    #dummy var to import module
    var app_is = Python.import_module("sortapp")

    var n = len(data)
    for i in range(1, n):
        var key = data[i]
        var j = i -1

        # Shift elements to the right to make room for the key
        while j >= 0 and key < data[j]:
            app.drawData(data, get_colors(n, 0, j))
            var speed = app.get_speed()
            var i_speed: Float64 = speed.to_float64()
            sleep(i_speed)

            data[j + 1] = data[j]
            j -= 1
        data[j + 1] = key

#Bubble Sort
def bubble_sort(app : PythonObject, data : PythonObject):
    #dummy var to import module
    var app_bs = Python.import_module("sortapp")

    var n = len(data)
    for i in range(n):
        for j in range(n - i - 1):
            if data[j] > data[j + 1]:
                data[j], data[j+1] = data[j+1], data[j]
                app.drawData(data, get_colors(n, i, j))
                var speed = app.get_speed()
                var b_speed: Float64 = speed.to_float64()
                sleep(b_speed)
    app.drawData(data, get_colors(n, '#51f052')) #green


#Quick Sort
def quick_sort(app : PythonObject, data : PythonObject):
    _quick_sort_helper(app, data, 0, len(data) - 1)

# Recursive Quick Sort helper
def _quick_sort_helper(app : PythonObject, data : PythonObject, low : Int, high : Int):
    if low < high:
        var pi = _partition(app, data, low, high)
        _quick_sort_helper(app, data, low, pi - 1)
        _quick_sort_helper(app, data, pi + 1, high)

# Partition function for Quick Sort with visualization
def _partition(app : PythonObject, data : PythonObject, low : Int, high : Int) -> Int:
    var app_qs = Python.import_module("sortapp")

    var n = len(data)
    var pivot = data[high]
    var i = low - 1

    app.drawData(data, get_colors_quick(n, low, high, i, i))
    var speed = app.get_speed()
    var q_speed: Float64 = speed.to_float64()
    sleep(q_speed)

    for j in range(low, high):
        if data[j] <= pivot:
            app.drawData(data, get_colors_quick(n, low, high, i, j, True))
            speed = app.get_speed()
            q_speed = speed.to_float64()
            sleep(q_speed)

            i += 1
            data[i], data[j] = data[j], data[i]

        app.drawData(data, get_colors_quick(n, low, high, i, j))
        speed = app.get_speed()
        q_speed = speed.to_float64()
        sleep(q_speed)
    
    app.drawData(data, get_colors_quick(n, low, high, i, high, True))
    speed = app.get_speed()
    q_speed = speed.to_float64()
    sleep(q_speed)
    data[i+1], data[high] = data[high], data[i+1]
    return i + 1


#GENERATE RANDOM NUMBERS#########################################################


#Function to generate random numbers
#Called when user clicks Generate button
def generate(app : PythonObject, data : PythonObject):
    #app3 dummy variable to load module
    var app1 = Python.import_module("sortapp")

    #clear any previous values
    #for when you want to generate new values
    data.clear()

    #gets the values from the sliders in the GUI
    var minVal = int(app.get_min())
    var maxVal = int(app.get_max())
    var size = int(app.get_size())
    
    #generate random numbers
    seed()
    for _ in range(size):
        #need to cast to int type
        data.append(int(random_ui64(minVal, maxVal+1)))

    #all bars are just red in the beginning
    #Call Python function
    app.drawData(data, get_colors(len(data), '#c62027')) #red



#START THE SORTING########################################################


#Function to start sorting
#Called when user clicks Start button
def start_algorithm(app : PythonObject, data : PythonObject):
    #import Python module
    var app2 = Python.import_module("sortapp")

    #if data is empty, then can't sort so return
    if not data: return

    #get the choice from the drop down menu in the GUI
    if app.alg_menu.get() == 'Selection Sort':
        #call sorting function
        selection_sort(app, data)
    elif app.alg_menu.get() == 'Insertion Sort':
        insertion_sort(app, data)
    elif app.alg_menu.get() == 'Bubble Sort':
        bubble_sort(app, data)
    elif app.alg_menu.get() == 'Quick Sort':
        quick_sort(app, data)

    app.drawData(data, get_colors(len(data), '#51f052')) #green



#PROCESS USER INPUT########################################################


def draw_user_input(app : PythonObject, data : PythonObject):
    #app3 dummy variable to load module
    var app3 = Python.import_module("sortapp")

    #clear any previous values
    #for when you want new values
    data.clear()

    var user_in : PythonObject = app.get_ui()
    for i in user_in:
        data.append(i)

    app.drawData(data, get_colors(len(data), '#c62027')) #red
    app.clear_ui()


#BENCHMARK TEST########################################################


def benchmark_test(app : PythonObject, data : PythonObject):
    var app4 = Python.import_module("sortapp")
    var psa = Python.import_module("py_sort_alg")

    data.clear()

    py_alg = app.alg_menu.get()
    var mojo_alg:String = ""

    if py_alg == "Selection Sort":
        mojo_alg = "Selection Sort"
    elif py_alg == "Insertion Sort":
        mojo_alg = "Insertion Sort"
    elif py_alg == "Bubble Sort":
        mojo_alg = "Bubble Sort"
    elif py_alg == "Quick Sort":
        mojo_alg = "Quick Sort"

    var mojo_result = mojo_bench_helper(mojo_alg)
    var py_result = psa.py_bench_helper(py_alg)

    var py_container: PythonObject = mojo_result.__str__()
    data.append(py_container)
    data.append(py_result)

    var color_list : PythonObject = ['#c62027', '#0b2973']

    app.drawDataBench(data, color_list)



#MAIN########################################################


def main():
    Python.add_to_path(".")
    app = Python.import_module("sortapp").SortGUI()

    #the dimensions of the GUI
    app.create("900x600")

    #we want data as a Python object because we pass it to a Python function
    var data : PythonObject = []

    while True:
        try:
            #use this instead of root.mainloop()
            app.update()
        except:
            print('Error!')
            break

        #flag for when Generate button is clicked
        if app.gen_clicked:
            generate(app, data)
            app.gen_clicked = False
        #flag for when Start button is clicked
        if app.start_clicked:
            start_algorithm(app, data)
            app.start_clicked = False
        #flag for when Enter button is clicked
        if app.enter_clicked:
            draw_user_input(app, data)
            app.enter_clicked = False
        #flag for when Benchmark button is clicked
        if app.bench_clicked:
            benchmark_test(app, data)
            app.bench_clicked = False
