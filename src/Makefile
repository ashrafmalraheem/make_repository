#******************************************************************************
# Copyright (C) 2017 by Alex Fosdick - University of Colorado
#
# Redistribution, modification or use of this software in source or binary
# forms is permitted as long as the files maintain this copyright. Users are 
# permitted to modify this and use it to learn about the field of embedded
# software. Alex Fosdick and the University of Colorado are not liable for any
# misuse of this material. 
# 
# Modified by Ashraf Abubaker for Coursera Course in Embedded software design
# Oct 2018
#*****************************************************************************

#------------------------------------------------------------------------------
# This is a make build file to generate different files (assembly,objects,EXE) 
# for different PLATFORM.
# (Commented out-Not implemented) Default PLATFORM will be the HOST machine it self
# Second option PLATFORM is the MSP432 platform
# Use: make [TARGET] [PLATFORM-OVERRIDES]
#
# Build Targets:
#      <FILE>.o - Builds <FILE>.o object file
#      <FILE>.d - Builds <FILE>.d dependancy file
#      <FILE>.i - Builds <FILE>.i preprocessed file
#      <FILE>.asm - Builds <FILE>.asm assembly file
#      <FILE>.dump - Builds <FILE>.dump assembly file using the GNU BIN utilities
#      c1m2.out - output file and size for every output file using GNU Bin utility
#      build - Builds and links all source files
#      compile-all - build all files without linking
#      clean - removes all generated files
# Platform Overrides:
#      PLATFORM -  The platform for the output file to executre (HOST, MSP432)
#
#------------------------------------------------------------------------------
include sources.mk
# Architectures Specific Flags
LINKER_FILE =  -T ../msp432p401r.lds
CPU = cortex-m4
ARCH = armv7e-m
SPECS = nosys.specs

# Compiler Flags and Defines
LD = arm-none-eabi-ld
TARGET  = c1m2
LDFLAGS = -Wl,-Map=$(TARGET).map\
	  -O0\
	  
          

CFLAGS  := -Wall  \
	  -Werror \
	  -g      \
	  -std=c99
CPPFLAGs = -E
ASFLAGS  = -S
# Default Platform
# PLATFORM = HOST # Remove the comment to make the default platform is host!
# Platform Overrides
ifeq ($(PLATFORM),HOST)
		CC = gcc
		AS = x86_64-linux-gnu-objdump
		SIZEUTIL = x86_64-linux-gnu-size
	else ifeq ($(PLATFORM),MSP432)
		SOURCES  +=$(SRC_MSP)
		INCLUDES +=$(MSP_INCLUDES)
 		CC = arm-none-eabi-gcc
		LDFLAGS +=-Xlinker $(LINKER_FILE)
		CFLAGS +=-mcpu=$(CPU) -march=$(ARCH) -mfloat-abi=hard -mfpu=fpv4-sp-d16 --specs=$(SPECS) -mthumb
		AS = arm-none-eabi-objdump
		SIZEUTIL = arm-none-eabi-size
	endif

OBJS  := $(SOURCES:.c=.o)
%.o : %.c
	$(CC) -c $< $(CFLAGS) -D$(PLATFORM) $(INCLUDES) -o $@
	$(SIZEUTIL) -Btd $@ 
PRES  := $(SOURCES:.c=.i)
%.i : %.c
	$(CC) -E $(INCLUDES) -D$(PLATFORM) $(CLFAGS) $< -o $@
ASMP  := $(PRES:.i=.asm)
%.asm : %.i
	$(CC) -S $(INCLUDES) -D$(PLATFORM) $(CLFAGS) $< -o $@
ASMBDUMP := $(OBJS:.o=.dump)
%.dump : %.o
	$(AS) --disassemble -s $< > $@
DEP   := $(SOURCES:.c=.d)
%.d : %.c
	$(CC) -MM $(INCLUDES) -D$(PLATFORM) $(CLFAGS) $< -o $@ 

.PHONY: compile-all 
compile-all: $(OBJS) 

.PHONY: build 
build: $(TARGET).out
$(TARGET).out: $(OBJS) $(DEP)
	$(CC) $(INCLUDES) $(OBJS) $(CFLAGS) -D$(PLATFORM) $(LDFLAGS) -o $@  
	$(SIZEUTIL) -Btd $@ $(OBJS)

.PHONY: clean
clean: 
	rm -f $(OBJS) $(PRES) $(ASMP)  $(ASMBDUMP) $(TARGET).out $(TARGET).map  $(DEP) ./-MD
	ls -la

