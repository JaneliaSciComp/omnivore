function av_video_callback(evt,src,vi,FPS,fid,verbose,current,timestamps)

persistent time0 skipped0

tic;

if verbose>0
  disp('entering video_callback');
end

try
  [data,time,~]=getdata(vi,FPS);
catch
  [data,time,~]=getdata(vi);
end

if timestamps == 3
  nframes=size(data,4);
  time=nan(1,nframes);
  %fn=nan(1,nframes);
  for i=1:nframes
    %f=rgb2gray(data(:,:,:,i));

    tmp=data(1,1:4,1,i);
    second_count=uint16(bitand(tmp(1),254)/2);
    cycle_count= uint16(bitand(tmp(1),1))*2^12 + ...
                 uint16(bitand(tmp(2),255))*2^4 + ...
                 uint16(bitand(tmp(3),128+64+32+16))/2^4;
    cycle_offset=uint16(bitand(tmp(3),8+4+2+1)*2^8) + ...
                 uint16(bitand(tmp(4),255));
    time(i)=double(second_count) + double(cycle_count)/8000 + 125e-6*double(cycle_offset)/3072;

%       tmp=data(1,5:8,1,i);
%       fn(i)=uint32(tmp(1))*2^24 + uint32(tmp(2))*2^16 + uint32(tmp(3))*2^8 + uint32(tmp(4));
  end
end

if timestamps>1
  fwrite(fid,time,'double');
end

skipped=round((time(end)-time(1))*FPS)+1-length(time);
if(isempty(skipped0))  skipped0=0;  end
skipped0=skipped0+skipped;

if current
  if(~isempty(time0))
    assignin('base','FPSAchieved',round(length(time)/(time(end)-time0)));
  end
  assignin('base','FramesAvailable',get(vi,'FramesAcquired')-get(vi,'DiskLoggerFrameCount'));
  assignin('base','FramesSkipped',skipped0);
end

time0=time(end);
  
if verbose>0
  disp(['exiting  video_callback:  ' ...
        num2str(toc/(size(data,4)/FPS),3) 'x real time is ' ...
        num2str(toc,3) 's to process ' ...
        num2str(size(data,4)/FPS,3) 's of data']);
end