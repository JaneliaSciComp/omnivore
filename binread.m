function [y,fs,nbits]=binread(file)

fid=fopen(file,'r');
version=fread(fid,1,'double');
fs=fread(fid,1,'double');
nchan=fread(fid,1,'double');
switch version
    case 1
        y=fread(fid,[nchan inf],'double');
        y=y';
        nbits=64;
        disp(['binread: version 1 (float64s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', nsamples=' num2str(size(y,1))]);
    case 2
        y=fread(fid,[nchan inf],'single');
        y=y';
        nbits=32;
        disp(['binread: version 2 (float32s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', nsamples=' num2str(size(y,1))]);
    case 3
        tmp=fread(fid,[2 nchan],'double');
        step=tmp(1,:);
        offset=tmp(2,:);
        y=fread(fid,[nchan inf],'int16');
        y=bsxfun(@times,y',step);
        y=bsxfun(@plus,y,offset);
        nbits=16;
        disp(['binread: version 3 (int16s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', nsamples=' num2str(size(y,1))]);
    otherwise
        error('not a valid .bin file');
end
fclose(fid);
