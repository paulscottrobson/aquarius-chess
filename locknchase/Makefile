ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: m7.dat

run: m7.dat
	cp ..$(S)m7$(S)m7.rom .
	..$(S)emulator$(S)aqnext m7.rom run

m7.dat:	
	ruby ..$(S)m7$(S)tom7.rb test.m7
	

	

