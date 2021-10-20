ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: m7.dat

kernel:
	make -B -C ..$(S)m7
	cp ..$(S)m7$(S)m7.rom .

run: m7.dat
	..$(S)emulator$(S)aqnext m7.rom run

m7.dat:	
	ruby ..$(S)m7$(S)tom7.rb test.m7
	

	

