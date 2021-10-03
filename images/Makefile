ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: 
	ruby imagebuilder.rb
	$(CCOPY) *.cqc ..$(S)emulator$(S)storage
	

	

