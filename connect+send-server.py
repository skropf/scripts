import sys
import socket
import string

HOST="192.168.0.1"
PORT=4433
readbuffer=""

s=socket.socket()
s.connect((HOST, PORT))
s.send("CONNECT")

while 1:
    readbuffer=readbuffer+s.recv(1024)
    temp=string.split(readbuffer, "\n")
    readbuffer=temp.pop( )

    for line in temp:
        line=string.rstrip(line)
        line=string.split(line)
        print(line)

