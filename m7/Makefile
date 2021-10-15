ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: m7.rom

run: m7.rom
	..$(S)emulator$(S)aqnext m7.rom

m7.rom:	m7.asm
	zasm m7.asm
	

	

