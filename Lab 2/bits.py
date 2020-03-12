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

x_list = load_numbers("lab2-x.txt")
y_list = load_numbers("lab2-y.txt")

def find_sum(list_1, list_2):
    sum = 0
    max_number = 0
    i = 0
    while (i < len(list_1)):
        sum += float(list_1[i]) * float(list_2[i])
        i += 1
        if (abs(sum) > max_number):
            max_number = sum
    return max_number
    
print(find_sum(x_list, y_list))

def find_min_bits(number_list):
    min_bits = 0
    min_dec_bits = 0
    min_int_bits = 0
    for number in number_list:
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
    return (min_dec_bits, min_bits)
    
print("~~~Full X list~~~")
min_dec_bits_x = find_min_bits(x_list)
print("~~~Full Y list~~~")
min_dec_bits_y = find_min_bits(y_list)

def to_binary(dec_bits, file, number_list):
    file = open("lab2-" + file + "-fixed-point.txt", 'w+')
    for number in number_list:
        float_number = float(number) * (2**dec_bits)
        bin_number = '{0:010b}'.format(int(float_number))
        if ("-" in bin_number):
            bin_number = twos_complement(bin_number)
        file.write(bin_number + "\n")
    file.close()

def to_binary_batch(dec_bits, total_bits, file, batch, number_list):
    file = open("lab2-" + file + "-fixed-point-batch" + batch + ".txt", 'w+')
    for number in number_list:
        float_number = float(number) * (2**dec_bits)
        bin_number = ('{0:0' + total_bits + 'b}').format(int(float_number))
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
    

to_binary(min_dec_bits_x[0], "x", x_list)
to_binary(min_dec_bits_y[0], "y", y_list)

for i in range(5):
    x_batch = []
    y_batch = []
    for j in range(i * 200, 200 + i * 200):
        x_batch.append(x_list[j])
        y_batch.append(y_list[j])
    print(find_sum(x_batch, y_batch))
    print("~~~Batch " + str(i + 1) + " X list~~~")
    min_bits_x = find_min_bits(x_batch)
    print("~~~Batch " + str(i + 1) + " Y list~~~")
    min_bits_y = find_min_bits(y_batch)
    to_binary_batch(min_bits_x[0], str(min_bits_x[1]), "x", str(i + 1), x_batch)
    to_binary_batch(min_bits_y[0], str(min_bits_y[1]), "y", str(i + 1), y_batch)

