This is only a very small subset of the
Telemark Cross Assembler package, but it's what's
needed to work with the z80.

goasm.bat is a sample batch file for assembling
a source file to object (binary) for the z80.
Without modification, it assembles the testasm.txt
file.
tasm -80 -b testasm.txt
invokes the tasm assembler
-b specifies binary (obj) output
     (this can be loaded into the emulator using
     the Util/Load Binary File)
testasm.txt is the file to be assembled. 

ORDERFRM.TXT is an order form for
registering the Telemark Assembler
(thereby getting the full package,
support, and updates).

TASM.EXE is the Telemark Assembler program.

TASM80.TAB is the table file used by the
Telemark Assembler program when assembling
z80 assembly language files.

TASMAN.HTM is the manual for the
Telemark Cross Assembler package.

testasm.txt is a short assembly language
file for the z80 -- but, it's intended
for the S2 ROM version of the Aquarius
with a miniexpander
(this is the emulator's default mode);
the .obj file output could be renamed
to .CAQ and then loaded and run
as if it were a BASIC program,
or use CAQ2WAV to convert it for
use with a real S2 Aquarius with
miniexpander.
