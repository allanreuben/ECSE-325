import string
import math
import re

def load_numbers(file_name):
    '''
    file_name (string): the name of the file containing
    the list of numbers to load

    Returns: a set of valid numbers.

    Depending on the size of the number list, this function may
    take a while to finish.
    '''
    in_file = open(file_name, 'r') # in_file: file
    line = in_file.readline()      # line: string
    number_list = line.split()     # word_list: list of strings
    in_file.close()
    return number_list

number_list_x = 'lab2-x.txt'
number_list_y = 'lab2-y.txt'

def find_sum():
    sum = 0
    max_number = 0
    x = load_numbers(number_list_x)
    y = load_numbers(number_list_y)
    i = 0
    while (i < len(x)):
        sum += float(x[i]) * float(y[i])
        i += 1
        if (abs(sum) > max_number):
            max_number = sum
    return max_number
    
print(find_sum())

def find_min_bits(number_list):
    min_bits = 0
    min_dec_bits = 0
    min_int_bits = 0
    for number in load_numbers(number_list):
        num_dec_bits = 0
        float_number = float(number)
        num_int_bits = int(float_number // 2 + 2)
        while((float_number % 1) != 0):
            num_dec_bits += 1
            float_number *= 2
        min_dec_bits = max(min_dec_bits, num_dec_bits)
        min_int_bits = max(min_int_bits, num_int_bits)
    min_bits = min_int_bits + min_dec_bits
    print("Decimal bits: " + str(min_dec_bits) + "\nInteger bits: " + str(min_int_bits) +  "\nTotal bits: " + str(min_bits))
    return min_dec_bits

min_dec_bits_x = find_min_bits(number_list_x)
min_dec_bits_y = find_min_bits(number_list_y)

def to_binary(dec_bits, file, number_list):
    file = open("lab2-" + file + "-fixed-point.txt", 'w+')
    for number in load_numbers(number_list):
        float_number = float(number) * (2**dec_bits)
        bin_number = '{0:010b}'.format(int(float_number))
        if ("-" in bin_number):
            bin_number = twos_complement(bin_number)
        file.write(bin_number + "\n")
    file.close()
    
def twos_complement(number):
    number = list(re.sub("\-", "0", number))
    i = len(number) - 1
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
    

to_binary(min_dec_bits_x, "x", number_list_x)
to_binary(min_dec_bits_y, "y", number_list_y)
