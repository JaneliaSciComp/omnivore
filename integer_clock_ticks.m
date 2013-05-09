function [clock_rate, clock_ticks, actual_sampling_rate]=integer_clock_ticks(desired_sampling_rate, timing_resolution)

% given the desired sampling rate (Hz) and timing resolution (seconds) of the DAQ board,
% compute the clock rate, the corresponding integer number of clock ticks and the actual sampling rate

clock_rate=1/timing_resolution;
clock_ticks=round(1/(desired_sampling_rate*timing_resolution));
actual_sampling_rate=1/(clock_ticks*timing_resolution);
