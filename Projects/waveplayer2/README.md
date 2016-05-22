Wavefile player for Pipistrello
===============================

This is a project to play wave files on Pipistrello  It's implemented using a Micoblaze_mcs soft processor running at 120 MHz.

The ise directory contains the Xilinx ISE project including Verilog HDL code.
The waveplayer directory contains the software for the wavefile player.

In order to compile the code the Microblaze gcc compiler must be in the path, it can be found here:
<Xilinx_intall>/14.7/ISE_DS/EDK/gnu/microblaze/<platform>/bin

You also need to have Xilinx data2mem in the path:
<Xilinx_intall>/14.7/ISE_DS/ISE/bin/<platform>/data2mem(.exe)

A precompiled bit file is available at waveplayer/waveplayer.bit.  It communicates via a terminal @115200 baud.  Only two commands are inplemented:

Play a song on the sd card:
F<file_to_play>CR
Reply: 0 = success, 1 = file not found, 2 = invalid wave file, 3 = unsupported wave file format

Stop:
S
Reply: always 0

Any other command is insupported and will cause the reply 1


