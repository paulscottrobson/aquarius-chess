ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: m7.rom

run: m7.rom
	ruby tom7.rb test.m7
	..$(S)emulator$(S)aqnext m7.rom run

m7.rom:	m7.asm
	cd vocabulary && ruby builder.rb
	zasm -u m7.asm
	

	

