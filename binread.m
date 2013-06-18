function [y,fs]=binread(file)

fid=fopen(file,'r');
version=fread(fid,1,'double');
switch version
    case 1
        fs=fread(fid,1,'double');
        nchan=fread(fid,1,'double');
        y=fread(fid,[nchan inf],'double');
    case 2
        fs=fread(fid,1,'double');
        nchan=fread(fid,1,'double');
        tmp=fread(fid,[nchan 2],'double');
        step=tmp(:,1);
        offset=tmp(:,2);
        y=fread(fid,[nchan inf],'int16');
%         y=bsxfun(@times,y,step);
%         y=bsxfun(@plus,y,offset);
    otherwise
        error('not a valid .bin file');
end
fclose(fid);
