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

# Platform Overrides
PLATFORM = arm-none-eabi-gcc
ifeq ($(PLATFORM),HOST)
		CC = gcc
		
	else
		CC = arm-none-eabi-gcc
		-mcpu=cortex-m4
		-mthumb
		-march=armv7e-m
		-mfloat-abi=hard
		-mfpu=fpv4-sp-d16
		--specs=nosys.specs

	endif
# Architectures Specific Flags
LINKER_FILE =  -T msp432p401r.lds
CPU = 
ARCH = 
SPECS = 

# Compiler Flags and Defines
CC = 
LD = 
LDFLAGS = 
CFLAGS = 
CPPFLAGs = 

