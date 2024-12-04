#from tkinter import ttk
#import tkinter as tk

import customtkinter as ctk

#CLASS#########################################################

#test.mojo calls create() function
class SortGUI:
    #constructor
    def __init__(self):
        self._root = ctk.CTk()

        self.ui_frame : ctk.CTkFrame
        self.canvas: ctk.CTkCanvas
        
        self.alg_menu: ctk.CTkComboBox

        self.size_label: ctk.CTkLabel
        self.max_label: ctk.CTkLabel
        self.min_label: ctk.CTkLabel
        self.speed_label: ctk.CTkLabel

        self.size_slider: ctk.CTkSlider
        self.max_slider: ctk.CTkSlider
        self.min_slider: ctk.CTkSlider
        self.speed_slider: ctk.CTkSlider

        #set flags to false
        self.gen_clicked = False
        self.start_clicked = False
        self.enter_clicked = False
        self.bench_clicked = False

        self.entry: ctk.CTkEntry

        ctk.set_appearance_mode("dark")


#FRAME#########################################################

    #creates the frame that will contain all of our buttons
    def create_frame(self):
        self.ui_frame = ctk.CTkFrame(
            master=self._root, 
            width=220, 
            height=600, 
        )
        self.ui_frame.grid(row=0, column=0)
        self.ui_frame.grid_propagate(0)

#CANVAS#########################################################

    #creates the canvas for the bars
    def create_canvas(self):
        self.canvas = ctk.CTkCanvas(
            self._root, 
            width=680, 
            height=600, 
            #bg='#FFFFFF' #white
            bg = '#65696B'
        )
        self.canvas.grid(row=0, column=1)

#COMBOBOX#########################################################

    #creates the drop down menu for selecting which sorting algorithm
    def create_alg_menu(self):
        
        #add new sorting algorithms to values
        self.alg_menu = ctk.CTkComboBox(
            self.ui_frame,  
            values=['Selection Sort', 'Insertion Sort', 'Bubble Sort', 'Quick Sort']
        )
        self.alg_menu.set("Sorting Algorithm")
        self.alg_menu.grid(row=0, column=0, padx=10, pady=10)

#LABEL AND SLIDER#########################################################

    #Create a label
    def create_label(self, l, r):
        my_label = ctk.CTkLabel(self.ui_frame, text=l)
        my_label.grid(row=r, column=0, padx=5, pady=5)
        return my_label

    #List of update functions for the sliders
    def update_size_slider(self, value):
        self.size_label.configure(text=f"Size: {int(value)}")

    def update_min_slider(self, value):
        self.min_label.configure(text=f"Minimum Value: {int(value)}")

    def update_max_slider(self, value):
        self.max_label.configure(text=f"Maximum Value: {int(value)}")
    
    def update_speed_slider(self, value):
        self.speed_label.configure(text=f"Speed (sec): {value:.1f}")

    #list of getter functions needed because of type mismatch in Mojo
    def get_size(self):
        return int(self.size_slider.get())
    
    def get_min(self):
        return int(self.min_slider.get())
    
    def get_max(self):
        return int(self.max_slider.get())
    
    def get_speed(self):
        return round(float(self.speed_slider.get()), 1)

    #params are the minimum, maximum, row, and function
    def create_slider(self, min, max, r, func):
        my_slider = ctk.CTkSlider(self.ui_frame, from_=min, to=max, command=func)
        my_slider.grid(row=r, column=0, padx=10, pady=5)
        my_slider.set(0)
        return my_slider

#BUTTONS#########################################################

    #function commands for button click
    def gen_click(self):
        self.gen_clicked = True

    def start_click(self):
        self.start_clicked = True
    
    def enter_click(self):
        self.enter_clicked = True

    def bench_click(self):
        self.bench_clicked = True

    #functions for creating buttons
    def create_button(self, choice, func, r):
        button = ctk.CTkButton(self.ui_frame, text=choice, command=func)
        button.grid(row=r, column=0, padx=10, pady=5)

#ENTRY#########################################################

    #need a separate getter function for casting into int
    def get_ui(self):
        user_input = self.entry.get()
        user_arr = [int(x) for x in user_input.split(",")]
        return user_arr
    
    def clear_ui(self):
        self.entry.delete(0, ctk.END)

    def create_entry(self, r):
        self.entry = ctk.CTkEntry(self.ui_frame)
        self.entry.grid(row=r, column=0, padx=10, pady=5)

#CREATE#########################################################

    #primary function that calls the others
    def create(self, res: str):
        self._root.title('Sorting Algorithm Visualization')
        self._root.geometry(res)
        #self._root.config(bg='#FFFFFF')

        self.create_frame()
        self.create_canvas()
        
        #empty_label = self.create_label(" ", 0)
        self.create_alg_menu()

        self.size_label = self.create_label("Size", 1)
        self.size_slider = self.create_slider(5, 50, 2, self.update_size_slider)
        self.min_label = self.create_label("Minimum Value", 3)
        self.min_slider = self.create_slider(1, 10, 4, self.update_min_slider)
        self.max_label = self.create_label("Maximum Value", 5)
        self.max_slider = self.create_slider(10, 100, 6, self.update_max_slider)
        self.speed_label = self.create_label("Speed (sec)", 7)
        self.speed_slider = self.create_slider(0.0, 1.0, 8, self.update_speed_slider)

        self.create_button("Generate", self.gen_click, 9)
        self.create_button("Start", self.start_click, 10)

        input_label = self.create_label("Enter your own data:\n (Integers separated by commas)", 11)
        #input_labe_bottom = self.create_label("(Integers separated by commas)", 13)
        self.create_entry(12)
        self.create_button("Enter", self.enter_click, 13)

        bench_label = self.create_label("Python vs Mojo\n(1000 runs in ms)", 14)
        self.create_button("Benchmark", self.bench_click, 15)

#DRAW#########################################################

    #function that draws the data into bars
    def drawData(self, data, color_array):
        #refresh canvas
        self.canvas.delete("all")
        canv_width = 680
        canv_height = 600
        bar_width = canv_width / (len(data) + 1)
        offset = 5
        #use this to create spaces inbetween bars
        spacing = 5

        #draw the bars
        #this loop gets the bar coordinates in the canvas
        normalized_data = [i / max(data) for i in data]
        for i, height in enumerate(normalized_data):
            x0 = i * bar_width + offset + spacing
            y0 = canv_height - height * 550 
            x1 = (i+1) * bar_width + offset
            y1 = canv_height

            self.canvas.create_rectangle(x0, y0, x1, y1, fill=color_array[i])
            self.canvas.create_text(x0+3, y0, anchor=ctk.SW, text=str(data[i]), font=('', '10'), fill='#ffffff')

        #update    
        self._root.update_idletasks()

    
    def drawDataBench(self, data, color_array):
        self.canvas.delete("all")
        canv_width = 680
        canv_height = 600
        bar_width = canv_width / (len(data) + 1)
        offset = 60
        #use this to create spaces inbetween bars
        spacing = 60

        temp = float(data[0])
        data[0] = temp
        
        #this loop gets the bar coordinates in the canvas
        normalized_data = [i / max(data) for i in data]
        for i, height in enumerate(normalized_data):
            x0 = i * bar_width + offset + spacing
            y0 = canv_height - height * 550 
            x1 = (i+1) * bar_width + offset
            y1 = canv_height

            self.canvas.create_rectangle(x0, y0, x1, y1, fill=color_array[i])
            self.canvas.create_text(x0+3, y0, anchor=ctk.SW, text=str(data[i]), font=('', '10'), fill='#ffffff')

        #update    
        self._root.update_idletasks()


#UPDATE#########################################################

    def update(self):
        self._root.update()