function [y,fs]=binread(file)

fid=fopen(file,'r');
version=fread(fid,1,'double');
switch version
    case 1
        fs=fread(fid,1,'double');
        nchan=fread(fid,1,'double');
        y=fread(fid,[nchan inf],'double');
        y=y';
        disp(['binread: version 1 (doubles), fs=' num2str(fs) ', nchan=' num2str(nchan) ', size(y,1)=' num2str(size(y,1))]);
    case 2
        fs=fread(fid,1,'double');
        nchan=fread(fid,1,'double');
        tmp=fread(fid,[2 nchan],'double');
        step=tmp(1,:);
        offset=tmp(2,:);
        y=fread(fid,[nchan inf],'int16');
        y=bsxfun(@times,y',step);
        y=bsxfun(@plus,y,offset);
        disp(['binread: version 2 (int16s), fs=' num2str(fs) ', nchan=' num2str(nchan) ', size(y,1)=' num2str(size(y,1))]);
    otherwise
        error('not a valid .bin file');
end
fclose(fid);
