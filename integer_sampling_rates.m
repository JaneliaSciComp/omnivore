function [sub_rates,factors]=integer_sampling_rates(timing_resolution)

% given the timing resolution of the DAQ board in seconds (e.g. 10e-9),
% calculate the available sampling rates which are integers, and hence
% can be represented exactly.  drift is zero for these rates

precision=1;
clock_rate=precision/timing_resolution;
factors=factor(clock_rate);
for i=1:(2^length(factors))
  sub_rates(i)=clock_rate;
  for j=1:length(factors)
    if bitand(i-1,2^(j-1))>0
      sub_rates(i)=sub_rates(i)/factors(j);
    end
  end
end
sub_rates=unique(sub_rates)/precision;
