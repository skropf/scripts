#!/usr/bin/python

from collections import deque
import random

hint_str = "18 K 10 & 12 F ) M / 8 V 20 G S F 14 H G V 5 D 15 % B Y 19 E J A S M 1 13 X"
hint_array = hint_str.split(' ')

alphabet = [ 'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M',
            'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z']

decode_array = [
    ['S', '11', 'Y'], ['V', '10'], ['5', 'J'], ['14'], ['13', 'H', 'Q', '20'],
    ['N', 'P'], [')'], ['D', 'C', '16'], ['K', '12', 'E'], ['I', '6'], ['Z', '0'],
    ['R'], ['15', 'Q', 'X'], ['&', '10'], ['A', '17', '19'], ['/', '$'], ['L'],
    ['4', '§', '2'], ['T'], ['W', '('], ['!'],
    #added 10 missing chars from hint_str to fill alphabet
]

while 1:
    pattern = deque([ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 ])
    #random.shuffle(pattern)
    #print(pattern)

    decode_map = {}
    ###map decode_array to alphabet
    for decode in decode_array:
        decode_map[alphabet[pattern.popleft()]] = decode

    result=""
    check = 0
    for hint in hint_array:
        for value in decode_map.values():
            if hint in value:
                result = result + list(decode_map.keys())[list(decode_map.values()).index(value)]
                check = 1
                break
        if check == 0: result = result + hint
        check = 0

    print(result)
