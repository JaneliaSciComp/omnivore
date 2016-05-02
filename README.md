Omnivore
========

A collection of tools for streaming video and analog/digital time series
to disk.  Synchronization with time series is insured over long periods by
either hardware triggering the video frames or saving their timestamps.
Multiple cameras and multiple analog/digital channels can be recorded or
played simultaneously by spreading the computational load across multiple
CPU cores.  Designed for behavioral and physiological neuroscience experiments
but should generalize.


System Requirements
===================

A Microsoft Windows computer with as many CPU cores as video cameras.

Matlab 2013a or newer, plus the Data Acquisition, Image Acquisition, Signal
Processing, and Statistics toolboxes.

Any Matlab-supported camera and data acquisition board.  Tested with Basler
Firewire and Pointgrey USB cameras, and M- and X-Series National Instruments
data acquisition boards.


Basic Usage
===========

Within each panel the radio button in the upper left corner turns that
input or output on and off.  A separate radio button controls whether to
save that data to disk or not.  All files are saved in the chosen folder
using the current date and time as the filename.  The pull-down menus on the
right side of each panel are configured by programmatically querying the
hardware of it's capabilities.  All buttons have self-documenting tooltip
strings which can be displayed by hovering over them.

![screenshot](/analog.png)

**Analog output**:  Currently only .wav files are supported.  The appropriate
sampling rate is automatically set from that stored in the metadata of
the file.  The display is updated once per second and can be a time series,
spectrum, spectrogram, or equalizer.  For all but the last case only one
channel is displayed at a time.

**Analog input**:  The sampling rate must be specified in the main panel
(with the green start button;  see below).  If analog data is also being
output, the two sampling rates must be identical.  Data are stored as 32-bit
floating point numbers in a .wav file.

![screenshot](/digital.png)

**Digital input/output**:  The bidirectional clockable lines on port 0 are
partitioned into a lower and upper range, one of which is all inputs and
the other all outputs.  Sampling rate must match the analog I/O, if any,
and is specified in the main window.  Input and output data are stored in
two separate .wav files as bits in integers.  The displays can be a single
line indicating the value of the integer versus time, a set of lines for
the separate bits, or an equalizer.

![screenshot](/video.png)

**Video input**:  The cameras don't have to be the same make and model.
A different region of interest, video format, file format and file quality
can be specified for each.  They must be identically triggered however,
either freely running on their own clock, or hardware triggered by the
data acquisition board.  For the former, choose "freely running" and "save
timestamps" and set the frame rate in the table; for the latter, choose
a counter output channel and specify a frame rate in the text input box.
The video from the selected channel is displayed in a separate window.

![screenshot](/main.png)

To begin a recording session click the green Start button.  A non-zero entry in
the text box to the right automatically stops the recording after the specified
number of minutes.

Whereas all analog/digital I/O is handled by a single CPU core, a separate
instance of Matlab is automatically spawned to handle each video channel.
This process can take a few seconds per channel, and can be monitored by
hovering over the Matlab icon in the taskbar.  Real-time CPU and RAM usage
are displayed in the upper right corner of the window.

Settings are automatically saved to most\_recent\_omnivore\_config.mat
and re-loaded upon starting again.  One can also save settings to and load
them from a custom configuration file using the buttons in the upper left
of the main window.

Use [tempo](https://github.com/JaneliaSciComp/tempo) to view the resulting data.


Troubleshooting
===============

Sometimes the most\_recent\_omnivore\_config.mat file can become corrupt.  If
strange things happen, particularly when first starting up, quit Matlab, delete
that file, and try again.

If your camera isn't listed in the video panel, go to the Apps tab in the
Matlab window and click on Image Acquisition.  If it doesn't work there, try
the software that came with the camera (e.g. FlyCap for Point Grey).

The drivers for Point Grey cameras must be installed using Matlab.  First, go
to the Windows Control Panels and choose Add / Remove Programs to uninstall any
existing copies of FlyCap.  Then in Matlab type supportPackageInstaller on the
command line to reinstall a compatible version of FlyCap.


Author
======

[Ben Arthur](http://www.janelia.org/people/research-resources-staff/ben-arthur), arthurb@hhmi.org  
[Scientific Computing](http://www.janelia.org/research-resources/computing-resources)  
[Janelia Farm Research Campus](http://www.janelia.org)  
[Howard Hughes Medical Institute](http://www.hhmi.org)

[![Picture](/hhmi_janelia_160px.png)](http://www.janelia.org)
