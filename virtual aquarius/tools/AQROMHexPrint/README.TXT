Dump Aquarius ROM cartridges!

Dump Aquarius ROMs using Kenny's Aquarius to PC Serial cable (no unsoldering required).

Preliminary step:
A couple of files are present here in CAQ format that you'll need as WAV files.  You will need to convert
carthexout.CAQ
disabl_BAS.CAQ
to WAV files using CAQ2WAV.  CAQ2WAV is present in the tools directory of the emulator archive.



1.  Hook up your Aquarius to your PC using the Aquarius printer port to PC serial port cable you've made from Kenny's design and which you have already tested as Kenny described (using hyperterminal and LPRINT statements).  If you don't know what I'm talking about, search the internet for the AqEmu website.

2.  Hook up your Aquarius's EAR cable to your PC's sound card's audio output ("line out" or "aux out").

3.  You won't need extra RAM, so remove your RAM expansion cartridge.

4.  If you're dumping an Extended BASIC cartridge or DOS or similar BASIC extension cartridge that you already have plugged in, you'll need to disable it, 'cause most of these use the cartridge scrambler, and we need that to be consistent (arbitrarily using a scrambler of 0).  To do that, load in the disabl_BAS_Q.wav into your Aquarius.  This involves CLOAD on the Aquarius side, and playing the disabl_BAS_Q.wav on the PC side.  Do NOT use Windows Mediaplayer or anything bundled with Windows -- these distort audio.  Instead, use a sound editor like goldwave.  Then RUN the disable program, and press RETURN when prompted to do so.

5.  Load in the carthexout_BAS_Q.wav into your Aquarius.  This involves CLOAD on the Aquarius side, and playing the carthexout_BAS_Q.wav on the PC side.  Do NOT use Windows Mediaplayer or anything bundled with Windows -- these distort audio.  Instead, use a sound editor like goldwave.

6.  Run your terminal program on your PC, as Kenny described.  You need to capture incoming data into a text file.  I've never done this myself, so you'll have to figure it out.  Fortunately you're a genius, so this should be easy.

7.  If you're dumping a game cartridge or some other cartridge that auto-starts and isn't a BASIC extender, jam the cartridge in.  Push it STRAIGHT in.  Don't blow it.  You get only one chance, and the penalty for failure is to possibly fry your Aquarius and your cartridge.  (Note:  I've done this a half dozen times on the Aquarius without frying).

8.  On your Aquarius, type RUN

9.  You'll get a list of choices of what area of memory to save this time.  Pick one of the options.  The program will start sending data to the PC immediately.

10.  Sit back.  This will take a few minutes.

11.  When it's all done, save the text your PC terminal program has buffered.

12.  On your PC, run the AQihextobin.exe program.  Click the Browse button, and select the .txt file you just saved.  It'll take about a second to process (okay, maybe not that quick).  It'll print a message in a messagebox.  If all is good, it'll write a file called AQROM_hexgibberish.bin.  This bin file is the ROM image you wanted!  The hexgibberish is just info about the start address, length, and checksum for the ROM image.  The AQihextobin program checks the checksums automatically.

13.  There is no 13.

14.  Zip the .txt file and mail it to emucompboy@yahoo.com  (hey, I like to look at checksums).

15.  Like I was saying, I've never done this before with a real Aquarius and a real terminal program.  Good luck.


