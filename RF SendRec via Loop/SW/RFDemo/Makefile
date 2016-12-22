#
TARGET = RFDemo
OBJ = obj/startram.o obj/sgdma_dispatcher.o obj/main.o

#
ALT_DEVICE_FAMILY = soc_cv_av
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall  -I ${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include -D$(ALT_DEVICE_FAMILY)
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)gcc
ARCH= arm

CFLAGS += -I./inc

build: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS)   $^ -o $@ 

obj/%.o : src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJ) *.a *.o *~