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

def find_min_bits():
    min_bits = 0
    for number in load_numbers(number_list_x):
        num_dec_bits = 0
        float_number = float(number)
        num_int_bits = float_number // 2 + 2
        while((float_number % 1) != 0):
            num_dec_bits += 1
            float_number *= 2
        min_bits_temp = num_int_bits + num_dec_bits
        min_bits = max(min_bits, min_bits_temp)
    return min_bits

#print(find_min_bits(load_numbers(number_list_x)))

def to_binary():
    file = open("lab2-x-fixed-point.txt", 'w+')
    for number in load_numbers(number_list_x):
        float_number = float(number)
        while((float_number % 1) != 0):
            float_number *= 2
        bin_number = '{0:09b}'.format(int(float_number))
        file.write(bin_number + " ")
    file.close()
    
to_binary()
