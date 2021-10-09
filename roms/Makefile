ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: 
	ruby romconvert.rb
	ruby scancodes.rb
	cat aliens_bas.caq aliens_a.caq >aliens.cqc
	

	

