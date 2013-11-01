function [ts,mtsf]=tsread(file, fps)
% read timestamps 
% return mean interval between skipped frames in units of frames

fid=fopen(file,'r');
ts=fread(fid,'double');
fclose(fid);

mtsf = length(ts)/((ts(end)-(length(ts)-1)/fps)*fps);

%plot(ts/60,(ts'-(0:length(ts)-1)./fps)*fps)
%xlabel('time (min)')
%ylabel('total # skipped frames')