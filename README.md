Omnivore [![Picture](/jfrc_grey_180x40.png)](http://www.janelia.org)
========

A collection of tools for streaming video and analog/digital time series to
disk.  Synchronization with time series is insured over long time periods by
either hardware triggering the video frames or saving their timestamps.
Multiple cameras and multiple analog/digital channels can be recorded
simultaneously by spreading the computational load across multiple CPU cores.
Analog/digital output is also supported.  Designed for behavioral and
physiological neuroscience experiments but should generalize.


System Requirements
===================

A Microsoft Windows computer.

Matlab 2013a or newer, plus the Data Acquisition, Image Acquisition, Signal
Processing, and Statistics toolboxes.

Any Matlab-supported camera and data acquisition board.  Tested with Basler
firewire and Pointgrey USB cameras, and M- and X-Series National Instruments
data acquisition boards.


Basic Usage
===========

Functionality is split between several independent modules, each of which has
it's own GUI window and can be run from within the same instance of Matlab.

av_take
-------

Analog input and output synchronized with video input

![screenshot](/av_take.png)

Within each panel the radio button in the upper left corner turns that
input/output on and off.  A separate radio button controls whether to save that
data to disk or not.  All files are saved using the current date and time as
the filename into the specified folder of choice.  The configuration pull-down
menus on the right side of each panel are configured by querying the hardware
of it's capabilities.  All buttons have self-documenting tooltip strings which
can be displayed by hovering over them.

**Analog output**:  Currently only .wav files are supported.  The appropriate
sampling rate is automatically set from that stored in the metadata of the
file.  The display is updated once per second and can be a time series,
spectrum, spectrogram, or, for multi-channel data, an equalizer.  Only one
channel is displayed at a time.

**Analog input**:  The sampling rate must be specified in the text box in the
lower right corner of this panel.  If analog data is also being output, the two
sampling rates must be identical.  Currently data are stored in a custom binary
format, as either 32- or 64-bit floating point numbers or 16-bit integers.  Use
binread() to read it back in, or bin2wav() to convert it to a .wav file.

**Video input**:  The cameras don't have to be the same make and model.  A
different region of interest, video format, file format and file quality can be
specified for each.  They must be identically triggered however, either free
running on their own clock, or hardware triggered by the data acquisition
board.  For the latter, choose a counter output channel and frame rate.

[tempo](https://github.com/JaneliaSciComp/tempo)

di_take
-------

Digital input

h_take
------

Hygrometer input, for use with sensirion's SHT line


Author
======

Ben Arthur, arthurb@hhmi.org  
[Scientific Computing](http://www.janelia.org/research-resources/computing-resources)  
[Janelia Farm Research Campus](http://www.janelia.org)  
[Howard Hughes Medical Institute](http://www.hhmi.org)
