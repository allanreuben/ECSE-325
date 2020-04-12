import string
import math
import re

from sklearn.metrics import mean_squared_error
from math import sqrt

def load_numbers(file_name):
    in_file = open(file_name, 'r') # in_file: file
    line = in_file.readline()      # line: string
    number_list = line.split()     # word_list: list of strings
    number_list_float = [float(i) for i in number_list]
    in_file.close()
    return number_list

def load_numbers_many_lines(file_name):
    in_file = open(file_name, 'r')
    number_list = [float(line.strip()) for line in in_file]
    return number_list


def to_binary(dec_bits, total_bits, file, number_list):
    file = open("lab3-" + file + "-fixed-point.txt", 'w+') # Create a new file
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

def to_decimal(dec_bits, total_bits, file, number_list):
    file = open("lab3-" + file + "-decimal.txt", 'w+') #create a new file
    for number in number_list:
        dec_number = convert_2com_to_decimal(number, dec_bits) / (2**dec_bits)
        file.write(str(dec_number) + "\n")
    file.close()


def RMSE(number_list_1, number_list_2):
    sum = 0
    output = 0
    length = len(number_list_1)
    for i in range(length):
        sum += (float(number_list_1[i]) - float(number_list_2[i]))**2
    output = sqrt((sum / length))
    return output

def convert_2com_to_decimal(bin, digit):
        while len(bin)<digit :
            bin = '0'+bin
        if bin[0] == '0':
            return int(bin, 2)
        else:
            return -1 * (int(''.join('1' if x == '0' else '0' for x in bin), 2) + 1)

# ~~~~~~~PROGRAM STARTS HERE~~~~~~~~


# Load the two files in as lists
#in_list = load_numbers("lab3-in.txt")
#weights_list = load_numbers("lab3-coef.txt")
#to_binary(15, "16", "in", in_list)
#to_binary(15, "16", "weights", weights_list)

# TRYING RMSE

to_binary(15, "17", "out-test", "out.txt_scaled.txt")
to_decimal(15, "17", "out-decimal-test", "lab3-out-test-fixed-point.txt")

print(RMSE(load_numbers("out.txt_scaled.txt"), load_numbers_many_lines("lab3-out-decimal.txt")))

#to_decimal(15, 17, "out", load_numbers_many_lines("lab3-out.txt"))

#print(twosCom_binDec("00000000000110011", 17) / 2**15)


#print(int("10", base = 2))
#to_binary(15, "17", "correct", load_numbers("out.txt_scaled.txt"))
rmse = sqrt(mean_squared_error(load_numbers("out.txt_scaled.txt"), load_numbers_many_lines("lab3-out-decimal-test.txt")))
print(rmse)

