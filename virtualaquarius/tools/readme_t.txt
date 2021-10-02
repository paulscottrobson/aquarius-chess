Turn Word Wrap ON if you're using Notepad.

Tools for use with Virtual Aquarius for Windows95/98, by James the Animal Tamer.

NOTE to ROM IMAGE COLLECTORS:
=============================
Howdy.  I'd prefer you reference my website, rather than putting my files up for download on your site.  These emulators are works in progress, and I will randomly be updating them.  Now, you wouldn't want to have an inferior version on your website, would you?
	Thanks.

HOME PAGE:
==========
www.geocities.com/emucompboy
Home of the Virtual Aquarius

CONTACT:
========
emucompboy@yahoo.com




Okay, here's the goods:

You'll find a few tools here.  They are very much preliminary.  They are so preliminary that I've never run them in RELEASE mode (which is the version collected here).  Use them at your own risk.  If there's a problem, let me know, and maybe I'll fix it.  Then again, maybe I won't.  After all, the debug versions I use work fine for me!

AQ_tapeldprep
=============
Cute utility by a member of the Mattel Aquarius Yahoo Group.  This prepares a binary file for use with the McNamara & Dubois ML Loader program.  This loader incorporates a name, load address, execution address, length of data, the data itself, and a simple two-byte checksum.  Yes, it can be used to make cartridges into tape load images, which would be useful if you have the homebrew RAM expander that puts 16K of RAM at $C000-$FFFF,

AQROMHexPrint
=============
Dump cartridges using Aquarius printer port -> PC serial port.

AQROMSave
=============
Dump cartridges using cassette saving method.

TASM31
======
Everyone's favorite cross assembler.  Don't forget to register (see ORDERFRM.TXT).
(This has been moved to the ML directory)

CLIPWAV.EXE
==========
This is a program which "clips" a wave file.  The input must be 8-bit, mono, 44,100 samples per second, and is presumably a cassette save file which you've digitized.  The wave file must also be symmetrical around its middle.

Why would you want to "clip" a wave?  A wave file so processed zips up a whole lot better than a raw wave file, which means you can put more of them on your website without getting a bandwidth notice from your Internet host.  

To use CLIPWAV, double click the icon.
Click on BROWSE and go find your input WAV file.

The output file is name_C.WAV, if name.WAV was your input file.  It is placed in the same directory as your input file.



CAQ2WAV.EXE
===========
This program converts a .CAQ file to a .WAV file which can be played back to a real Aquarius.  Follow the instructions you see when you run the program.  It'll process for a moment.  The output file's name depends on the options you selected for speed and waveform, e.g. if your CAQ file was named name.CAQ then the output would be:
name_4Q.WAV  and you wanted a 44100 samples/second square wave.
name_2Q.WAV  and you wanted a 22050 samples/second square wave.
NOTE:  sine waves are disabled for the Aquarius, because the real computer didn't like them.

It is placed in the same directory as your input file.
NOTE:  This has been tested only with BASIC programs and arrays.  It has not been tested with LOGO or FILEFORM or FINFORM.  Caveat emptor.

monowav.exe
===========
This program takes a 44100 Hz .WAV 8-bit stereo WAV file and converts it into two mono WAV files.  It saves the new WAV files in the same directory as the original.
The 'Process all WAVs in the browsed directory and all subdirs' option will attempt to convert all WAV files in the same directory as the file chosen... and then will search through all subdirectories for more WAV files to convert.  Don't try this unless you REALLY want to convert all the files in all the subdirectories!


