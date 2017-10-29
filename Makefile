#******************************************************************************
# Copyright (C) 2017 by Alex Fosdick - University of Colorado
#
# Redistribution, modification or use of this software in source or binary
# forms is permitted as long as the files maintain this copyright. Users are 
# permitted to modify this and use it to learn about the field of embedded
# software. Alex Fosdick and the University of Colorado are not liable for any
# misuse of this material. 
#
#*****************************************************************************

#------------------------------------------------------------------------------
# <Put a Description Here>
#
# Use: make [TARGET] [PLATFORM-OVERRIDES]
#
# Build Targets:
#      <Put a description of the supported targets here>
#
# Platform Overrides:
#      <Put a description of the supported Overrides here
#
#------------------------------------------------------------------------------
include sources.mk
# Architectures Specific Flags
LINKER_FILE =  -T ./msp432p401r.lds
CPU = cortex-m4 
ARCH = armv7e-m
SPECS = nosys.specs

# Compiler Flags and Defines
LD = arm-none-eabi-ld
TARGET  = c1m2
LDFLAGS = -Wl,-Map=$(TARGET).map \
	  -O0     \
	  
          

CFLAGS  := -Wall   \
	  -Werror \
	  -g      \
	  -std=c99
CPPFLAGs = -E
ASFLAGS  = -S

# Platform Overrides
ifeq ($(PLATFORM),HOST)
		CC = gcc
	
	else ifeq ($(PLATFORM),MSP432)
		SOURCES  +=$(SRC_MSP)
		INCLUDES +=$(MSP_INCLUDES)
 		CC = arm-none-eabi-gcc
 		PLATFORM = MSP432  		
		LDFLAGS +=-Xlinker $(LINKER_FILE)		
		CFLAGS +=$(CFLAGS) -mcpu=$(CPU) -march=$(ARCH) -mfloat-abi=hard -mfpu=fpv4-sp-d16 --specs=$(SPECS) -mthumb

	endif

testflags=$(CFLAGS)

OBJS  = $(SOURCES:.c=.o)
%.o : %.c
	$(CC) -c $< $(testflags) -D$(PLATFORM) $(INCLUDES) -o $@

PRES  = $(SOURCES:.c=.i)
%.i : %.c
	$(CC) -E $(INCLUDES) -D$(PLATFORM) $(CLFAGS) $< -o $@
ASMP  = $(PRES:.i=.asm)
%.asm : %.i
	$(CC) -S $(INCLUDES) -D$(PLATFORM) $(CLFAGS) $< -o $@ 
DEP  = $(SOURCES:.c=.d)
%.d : %.c
	$(CC) -M $(INCLUDES) -D$(PLATFORM) $(CLFAGS) $< -o $@ 

.PHONY: compile-all 
compile-all: $(OBJS) 
#
.PHONY: build 
build: $(TARGET).out
$(TARGET).out: $(OBJS) $(DEP)
	$(CC) $(INCLUDES) $(OBJS) $(CFLAGS) -D$(PLATFORM) $(LDFLAGS) -o $@  

.PHONY: clean
clean: 
	rm -f $(OBJS) $(PRES) $(ASMP) $(TARGET).out $(TARGET).map  $(DEP)

