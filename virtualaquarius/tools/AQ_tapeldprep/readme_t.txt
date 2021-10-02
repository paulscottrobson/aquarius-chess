AQ_tapeldprep
=============
Cute utility by a member of the Mattel Aquarius Yahoo Group.  This prepares a binary file for use with the McNamara & Dubois ML Loader program.  This loader incorporates a name, load address, execution address, length of data, the data itself, and a simple two-byte checksum.  Yes, it can be used to make cartridges into tape load images, which would be useful if you have the homebrew RAM expander that puts 16K of RAM at $C000-$FFFF,

There's an example binary in this folder.
To make the _A.CAQ file, execute the AQ_tapeldprep.exe program.  As input file, choose
Yie_Ar_Kung_Fu.bin
Set the load address and execute address to $4000
Set the internal name to 
YAKF music
Click the "do it" button.

To see the results of your work, use the emulator.  Quicktype the YAKF_Loader_BAS.txt file.  Read the instructions.  When prompted to start the tape, don't.  Wait until you get the Loading... screen and the border turns cyan again, before using the "play cassette file" and setting the file Yie_Ar_Kung_Fu_A.CAQ to playing.

==
This utility can be used to make tape loadable images of cartridge binary files too, assuming you have the homebrew RAM cartridge that puts 16K of RAM at $C000.
For 16K cartridges, set the load address to $C000 and the execute address to $0000.  I have tested this with AD&D.  
For 8K, and smaller, cartridges, set the load address to $E000 and the execute address to $0000.  I have tested this with ZEROIN.
Note:  If this doesn't work, you might try making a duplicate image that's 16K long, and has the same info at $C000 as it does at $E000, simulating the hardware's normal ROM echo.

Once you have the cartridge itself working, you can edit the BASIC loader program (you've been using the YAKF_Loader_BAS program to load your prepared binary files, right?).
Change the first instruction page screen at line 310-375.
You can add in additional instruction pages between lines 400 and 998, starting each instruction page with
gosub 4000
and ending each instruction page with
gosub 3000


==
I learned that you have to wait a bit before attempting to load the array portion.  If it doesn't load the first try, it will load on the second.  I'm used to the other loaders, which accept the array immediately.
