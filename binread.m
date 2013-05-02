function [y,fs]=binread(file)

fid=fopen(file,'r');
version=fread(fid,1,'double');
if(version~=1)  error('not a valid .bin file');  end
fs=fread(fid,1,'double');
nchan=fread(fid,1,'double');
y=fread(fid,[nchan inf],'double');
fclose(fid);
