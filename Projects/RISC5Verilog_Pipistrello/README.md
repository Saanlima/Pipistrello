Oberon RISC5 for Pipistrello
============================

This is a port of the Oberon RISC5 system for the Pipistrello LX45 FPGA board.

The original files can be found at the [Project Oberon page](http://www.projectoberon.com/).
Original Project Oberon design and source code copyright © 1991–2015 Niklaus Wirth (NW) and Jürg Gutknecht (JG)

For further information see the [Pipistrello Wiki page](http://pipistrello.saanlima.com/index.php?title=Welcome_to_Pipistrello).

Changes from the original code
------------------------------

- Video-out via HDMI
- The SRAM interface changed to multiplexed address bus
- Fast multiplier used (Multiplier1.v)
- SD card activity LED added
- Due to pin limitation some functions are reduced or eliminated (only 4 LEDs, no GPIO, no DIP switch, only one button)

Binaries are available in the ISE folder.
