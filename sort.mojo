from python import Python as imported_python
from time import sleep

# Swap function with visualization
@always_inline
fn swap(inout vector: List[Int], a: Int, b: Int):
    vector[a], vector[b] = vector[b], vector[a]
    # Print the current state of the array after swapping
    print("Current Array: [", end="")
    for i in range(len(vector)):
        if i > 0:
            print(", ", end="")
        print(vector[i], end="")
    print("]")
    sleep(0.5)  # Delay for visualization

# Insertion Sort with visualization
fn insertion_sort(inout vector: List[Int]):
    for i in range(1, len(vector)):
        var key = vector[i]
        var j = i - 1

        # Shift elements to the right to make room for the key
        while j >= 0 and key < vector[j]:
            vector[j + 1] = vector[j]
            print("Current Array: [", end="")
            for k in range(len(vector)):
                if k > 0:
                    print(", ", end="")
                print(vector[k], end="")
            print("]")
            sleep(0.5)  # Delay for visualization
            j -= 1
        vector[j + 1] = key

        # Print current state after inserting the key
        print("Current Array: [", end="")
        for k in range(len(vector)):
            if k > 0:
                print(", ", end="")
            print(vector[k], end="")
        print("]")
        sleep(0.5)  # Delay for visualization

# Quick Sort with visualization
fn quick_sort(inout vector: List[Int]):
    _quick_sort(vector, 0, len(vector) - 1)

# Recursive Quick Sort helper with visualization
fn _quick_sort(inout vector: List[Int], low: Int, high: Int):
    if low < high:
        var pi = _partition(vector, low, high)
        _quick_sort(vector, low, pi - 1)
        _quick_sort(vector, pi + 1, high)

# Partition function for Quick Sort with visualization
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

# Selection Sort with visualization
fn selection_sort(inout vector: List[Int]):
    for i in range(len(vector)):
        var min_idx = i
        for j in range(i + 1, len(vector)):
            if vector[j] < vector[min_idx]:
                min_idx = j
        if min_idx != i:
            swap(vector, i, min_idx)

# Main application loop
fn main() raises:
    # Import Python built-in functions
    var input = imported_python.import_module("builtins").input
    var int_fn = imported_python.import_module("builtins").int

    while True:
        # Get user input
        print("Enter numbers separated by commas (e.g., 42,23,85,19): ")
        var user_input = input()

        # Handle empty input
        if len(user_input) == 0:
            print("No input provided. Exiting.")
            return

        # Parse input into a list of integers
        var nums = user_input.split(",")
        var arr = List[Int]()
        for num in nums:
            var cleaned_num = num.strip()  # Remove leading and trailing whitespaces
            try:
                var parsed_num = int_fn(cleaned_num)  # Convert to integer
                arr.append(parsed_num)
            except:
                print("Invalid input: '" + cleaned_num + "'. Skipping.")
                continue

        # Handle case where no valid numbers are provided
        if len(arr) == 0:
            print("No valid numbers entered. Exiting.")
            return

        # Display sorting algorithm menu
        print("Choose a sorting algorithm:")
        print("1. Quick Sort")
        print("2. Insertion Sort")
        print("3. Selection Sort")
        print("4. Blank Sort (not implemented yet)")
        print("5. Blank Sort (not implemented yet)")
        print("Enter the number corresponding to your choice: ")

        var choice = input()
        var parsed_choice: Int

        try:
            parsed_choice = int_fn(choice)
        except:
            print("Invalid choice. Exiting.")
            return

        # Execute the chosen sorting algorithm with visualization
        if parsed_choice == 1:
            print("Sorting using Quick Sort...")
            quick_sort(arr)
        elif parsed_choice == 2:
            print("Sorting using Insertion Sort...")
            insertion_sort(arr)
        elif parsed_choice == 3:
            print("Sorting using Selection Sort...")
            selection_sort(arr)
        else:
            print("The selected sorting algorithm is not implemented yet. Exiting.")
            return

        # Print the final sorted array
        print("Final Sorted Array: [", end="")
        for i in range(len(arr)):
            if i > 0:
                print(", ", end="")
            print(arr[i], end="")
        print("]")

        # Ask user if they want to go again
        print("Do you want to sort another array? (yes/no): ")
        var go_again = input().strip().lower()

        if go_again != "yes":
            print("Exiting program. Goodbye!")
            break
