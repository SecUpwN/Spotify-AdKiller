# C compiler
CC = gcc

TARGET = dns-block

all : $(TARGET).so

$(TARGET).so: $(TARGET).o
	$(CC) -shared -fPIC -Wl,-soname -Wl,$@ -ldl -o $@ $^
 
$(TARGET).o: $(TARGET).c
	$(CC) -Wall -fPIC -c $^

.PHONY: clean

clean:
	rm -f $(TARGET).o $(TARGET).so
	
