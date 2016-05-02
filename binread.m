function [y,fs,nbits]=binread(file,varargin)
% varargin can either be ommitted entirely,
% or be a 2-vector of a sample range ([start stop]) to return.
% e.g. binread('foo.bin',[0 100]);

if nargin>1
    start=varargin{1}(1);
    len=diff(varargin{1});
else
    start=0;
    len=inf;
end

fid=fopen(file,'r');
version=fread(fid,1,'double');
fs=fread(fid,1,'double');
nchan=fread(fid,1,'double');
switch version
    case 1
        fseek(fid,8*start*nchan,'cof');
        y=fread(fid,[nchan len],'double');
        y=y';
        nbits=64;
        disp(['binread: version 1 (float64s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', nsamples=' num2str(size(y,1))]);
    case 2
        fseek(fid,4*start*nchan,'cof');
        y=fread(fid,[nchan len],'single');
        y=y';
        nbits=32;
        disp(['binread: version 2 (float32s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', nsamples=' num2str(size(y,1))]);
    case 3
        tmp=fread(fid,[2 nchan],'double');
        step=tmp(1,:);
        offset=tmp(2,:);
        fseek(fid,2*start*nchan,'cof');
        y=fread(fid,[nchan len],'int16');
        y=bsxfun(@times,y',step);
        y=bsxfun(@plus,y,offset);
        nbits=16;
        disp(['binread: version 3 (int16s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', nsamples=' num2str(size(y,1))]);
    otherwise
        error('not a valid .bin file');
end
fclose(fid);
