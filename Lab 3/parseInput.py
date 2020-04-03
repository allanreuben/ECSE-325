import string
import math
import re

def load_numbers(file_name):
    in_file = open(file_name, 'r') # in_file: file
    line = in_file.readline()      # line: string
    number_list = line.split()     # word_list: list of strings
    in_file.close()
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


# ~~~~~~~PROGRAM STARTS HERE~~~~~~~~


# Load the two files in as lists
in_list = load_numbers("lab3-in.txt")
weights_list = load_numbers("lab3-coef.txt")
to_binary(15, "16", "in", in_list)
to_binary(15, "16", "weights", weights_list)

