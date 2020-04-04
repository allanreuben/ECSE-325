import string
import math
import re

def load_numbers(file_name):
    in_file = open(file_name, 'r') # in_file: file
    line = in_file.readline()      # line: string
    number_list = line.split()     # word_list: list of strings
    in_file.close()
    return number_list


def find_output_bits(list_1, list_2):
    sum = 0         # The intermediate sum
    max_sum = (0, 0)     # The maximum number of digits in the binary representation of the sum
    i = 0
    while (i < len(list_1)):
        x = float(list_1[i])
        y = float(list_2[i])
        sum += x * y                    # Perform the MAC operation
        i += 1
        temp = find_min_bits(sum)
        if (temp[1] > max_sum[1]):
            max_sum = temp
    print("Integer bits: " + str(max_sum[1] - max_sum[0]) + "\nDecimal Bits: " + \
        str(max_sum[0]) + "\nTotal bits: " + str(max_sum[1])) # Print the two maximums
    return


def find_min_bits(number):
    num_dec_bits = 0
    float_number = float(number)
    num_int_bits = find_min_int_bits(float_number)
        
    # Since multiplying a number by 2 shifts it to the left by one in binary, we keep track
    # of how many times we need to shift it until it becomes an integer. The number of
    # shifts is equal to the number of bits required to represent the decimal portion.
    while((float_number % 1) != 0):                 
        num_dec_bits += 1
        float_number *= 2
    min_bits = num_int_bits + num_dec_bits
    return (num_dec_bits, min_bits)

# This function finds the minimum number of bits required to represent the integer portion of
# the number
def find_min_int_bits(num):
    if (num > 0):
        if (num < 1):
            return 1
        else:
            # By taking log_2, we get the number of bits we need for unsigned representation
            # minus one, so we add 2 to make up for it.
            return int(math.floor(math.log(num, 2)) + 2) 
    else:
        if (abs(num) <= 1):
            return 1
        else:
            return int(math.floor(math.log(abs(num), 2)) + 2)


def find_min_bits_list(number_list):
    min_bits = 0        # Minimum bits to represent the whole number
    min_dec_bits = 0    # Minimum bits to represent the decimal portion
    min_int_bits = 0    # Minimum bits to represent the integer portion
    for number in number_list:
        num_dec_bits = 0
        float_number = float(number)
        num_int_bits = find_min_int_bits(float_number)
        
        # Since multiplying a number by 2 shifts it to the left by one in binary, we keep track
        # of how many times we need to shift it until it becomes an integer. The number of
        # shifts is equal to the number of bits required to represent the decimal portion.
        while((float_number % 1) != 0):                 
            num_dec_bits += 1
            float_number *= 2
        min_dec_bits = max(min_dec_bits, num_dec_bits)
        min_int_bits = max(min_int_bits, num_int_bits)
    min_bits = min_int_bits + min_dec_bits
    print("Integer bits: " + str(min_int_bits) + "\nDecimal bits: " + \
        str(min_dec_bits) + "\nTotal bits: " + str(min_bits))
    return (min_dec_bits, min_bits)
    
    
def to_binary(dec_bits, total_bits, file, number_list):
    file = open("lab2-" + file + "-fixed-point.txt", 'w+') # Create a new file
    for number in number_list:
        # Shift the number the appropriate number of decimal places
        float_number = float(number) * (2**dec_bits)
        
        # This line converts the integer to an unsigned binary representation
        bin_number = ('{0:0' + total_bits + 'b}').format(int(float_number))
        
        # If the number is negative, it will not be formatted properly. Needs to be fixed.
        if ("-" in bin_number):
            bin_number = twos_complement(bin_number)
        file.write(bin_number + "\n") # Write the number on a new line in the file
    file.close()


# This function is very similar to to_binary(), the only difference being the naming scheme
def to_binary_batch(dec_bits, total_bits, file, batch, number_list):
    file = open("lab2-" + file + "-fixed-point-batch" + batch + ".txt", 'w+')
    for number in number_list:
        float_number = float(number) * (2**dec_bits)
        bin_number = ('{0:0' + total_bits + 'b}').format(int(float_number))
        if ("-" in bin_number):
            bin_number = twos_complement(bin_number)
        file.write(bin_number + "\n")
    file.close()
    
# This function turns the given number into 2's complement, removing any other unwanted symbols.
def twos_complement(number):
    number = list(re.sub("\-", "0", number)) # Remove '-' symbols
    i = len(number) - 1
    
    # The following is an algorithm for turning a positive binary number into its negative 2's
    # complement version: starting at the end of the string, copy all 0s until a 1 is reached.
    # Copy that 1, then flip all the bits after that.
    while (number[i] == '0'):
        i -= 1
    i -= 1
    while (i >= 0):
        if (number[i] == '0'):
            number[i] = '1'
        else:
            number[i] = '0'
        i -= 1
    return "".join(number)


# ~~~~~~~PROGRAM STARTS HERE~~~~~~~~

# Load the two files in as lists
x_list = load_numbers("lab2-x.txt")
y_list = load_numbers("lab2-y.txt")

# Find the minimum number of bits to represent the numbers for list x
print("~~~Full X list~~~")
min_dec_bits_x = find_min_bits_list(x_list)

# Find the minimum number of bits to represent the numbers for list y
print("~~~Full Y list~~~")
min_dec_bits_y = find_min_bits_list(y_list)

# Find the minimum number of bits to represent the numbers for the ouput
print("~~~Full list output~~~")
find_output_bits(x_list, y_list)

# Convert the two lists to binary in two's complement, and store them in a new file
to_binary(min_dec_bits_x[0], str(min_dec_bits_x[1]), "x", x_list)
to_binary(min_dec_bits_y[0], str(min_dec_bits_y[1]), "y", y_list)

# Repeat the above process but for batches of 200 items each
for i in range(5):
    x_batch = []
    y_batch = []
    for j in range(i * 200, 200 + i * 200):
        x_batch.append(x_list[j])
        y_batch.append(y_list[j])
    print("~~~Batch " + str(i + 1) + " X list~~~")
    min_bits_x = find_min_bits_list(x_batch)
    print("~~~Batch " + str(i + 1) + " Y list~~~")
    min_bits_y = find_min_bits_list(y_batch)
    print("~~~Batch " + str(i + 1) + " output~~~")
    find_output_bits(x_batch, y_batch)
    to_binary_batch(min_bits_x[0], str(min_bits_x[1]), "x", str(i + 1), x_batch)
    to_binary_batch(min_bits_y[0], str(min_bits_y[1]), "y", str(i + 1), y_batch)

