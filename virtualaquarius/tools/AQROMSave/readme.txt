Dump Aquarius ROM cartridges!

Dump Aquarius ROMs using the Aquarius's Save-to-tape routines (no unsoldering required).

Preliminary step:
A couple of files are present here in CAQ format that you'll need as WAV files.  You will need to convert
saver.CAQ
disabl_BAS.CAQ
to WAV files using CAQ2WAV.  CAQ2WAV is present in the tools directory of the emulator archive.

1.  You'll need an S2 Aquarius for this trick.  If you don't have one, visit EBay.  If the auction doesn't say, well, usually these come bundled with a cassette with Mad Mould and five other games.  (I'm not responsible for anything you do or don't get from EBay).

2.  Hook up your Aquarius to your VCR using your antenna switchbox and channel 3.  If your switchbox and your VCR don't match, you may need a 300ohm->75ohm converter (visit Radio Shack).

3.  Hook up your VCR's audio out to your PC's sound card's audio in.  NOTE:  use your PC's sound card's "audio in" or "aux in" or "line in."  Do NOT use "microphone."

4.  Hook up your Aquarius cassette cable input to your PC.  You need to load programs from PC WAV files into your Aquarius, so hook up your cassette cable "ear" to your PC's sound card's "line out."  This might be time for another Radio Shack trip.  You won't find what you need in one package, so get a mini female -> mini female adapter (stereo or mono, doesn't matter);  this looks like a gold cylinder with knurls.  Also get a mini male -> RCA female adapter (the one I got is mini plug male -> 2 RCA female).  Stick 'em all together (cassette mini male -> adapter's female;  adapter's other female to mini plug male;  RCA female to the male RCA plug on your audio card's line out cable).

5.  You won't need extra RAM, so remove your RAM expansion cartridge.

6.  If you're dumping an Extended BASIC cartridge or DOS or similar BASIC extension cartridge that you already have plugged in, you'll need to disable it, 'cause most of these change the start-of-BASIC pointer, and we need that to be consistent with the S2 norm.  To do that, load in the disabl_BAS_Q.wav into your Aquarius.  This involves CLOAD on the Aquarius side, and playing the disabl_BAS_Q.wav on the PC side.  Do NOT use Windows Mediaplayer or anything bundled with Windows -- these distort audio.  Instead, use a sound editor like goldwave.  Then RUN the disable program, and press RETURN when prompted to do so.

7.  Load in the saver_Q.wav into your Aquarius.  This involves CLOAD on the Aquarius side, and playing the saver_Q.wav on the PC side.  Do NOT use Windows Mediaplayer or anything bundled with Windows -- these distort audio.  Instead, use a sound editor like goldwave.

8.  If you're dumping a game cartridge or some other cartridge that auto-starts and isn't a BASIC extender, jam the cartridge in.  Push it STRAIGHT in.  Don't blow it.  You get only one chance, and the penalty for failure is to possibly fry your Aquarius and your cartridge.  (Note:  I've done this a half dozen times on the Aquarius without frying).

9.  On your Aquarius, type RUN

10.  You'll get an informational screen about what areas of memory the cartridge occupies, then a list of choices of what area of memory to save this time.  Pick one of the options.  The program will take a couple of seconds to think about it, then it'll prompt you with a Press RECORD and RETURN key message.

11.  On your PC's sound editor (I use the Creative Wave Studio that came with my sound card), start recording.  Remember, 44,100 Hz 8 bit mono.  Press the RETURN key on your Aquarius.

12.  Sit back.  This will take a few minutes.  About 5 minutes.  You'd better have about 1G of hard drive space available to work with the resulting file.

13.  There is no 13.

14.  When it's all done, stop recording on your sound editor and save the WAV file.  Make a note of the dim statement that saver_Q thoughtfully printed on the Aquarius screen.

15.  Start Virtual Aquarius.  Check its memory configuration to see that it's using the +16K RAM option.  Type the dim statement you noted above, then the cload array statement:
dima(4116)
cload*a
From Virtual Aquarius's File menu, use Play Cassette File, and look for files of type WAV (instead of the default CAQ).  Choose the WAV file you'd just saved.

16.  Eventually, Virtual Aquarius will print an OK message, signifying that the array was loaded.  From the File menu, select SAVE RAM.

17.  This creates a ram.bin file somewhere, usually in the same directory from which you ran Virtual Aquarius.

18.  On your PC, run the AQRomExtract.exe program.  Click the Browse button, and select the ram.bin file.  It'll take about a second to process (depends on the speed of your hard drive, doesn't it?).  It'll print a message in a messagebox.  If all is good, it'll write a file called AQROM_hexgibberish.bin.  This bin file is the ROM image you wanted!  The hexgibberish is just info about the start address, length, and checksums for the ROM image.  The AQRomExtract program checks the checksums automatically.

19.  Zip the ram.bin and mail it to emucompboy@yahoo.com  (hey, I just like to be sure of the checksum).

20.  You may want to rename AQROM_hexgibberish.bin to something more descriptive of the cartridge you just dumped.
