function [ts fn]=post_process_movie(varargin)

% 1. extract timestamps and frame numbers
% 2. insert blank frames for those skipped
% 3. concat into single avi file

%[ts fn]=sync_test('130425/free_running_2013-04-25-143358');
%[tsT fnT]=sync_test('130425/triggered_2013-04-25-144344');
%sync_test(ts,fn);
%[ts fn]=sync_test('C:\Users\labadmin\Documents\MATLAB\triggered_2013-04-26-110655');

if nargin==1
  [ts fn]=load_data(varargin{1});
  if(isempty(ts))  return;  end
else
  ts=varargin{1};
  fn=varargin{2};
end

disp(['skipped frames: ' num2str(sum(diff(fn)-1))]);

tsD=diff(ts);
find(tsD>64);   tsD(ans)=tsD(ans)-128;
find(tsD<-64);  tsD(ans)=tsD(ans)+128;

figure;
subplot(2,1,1)
plot(tsD);
xlabel('frame number');
ylabel('time difference (s)');
title(['nominally 50 Hz, mean is actually ' num2str(mean(1./tsD)) ' Hz']);
axis tight;

subplot(2,1,2)
hist(1./tsD,100);
axis tight;
xlabel('frame rate (Hz)');


% ---
function [ts fn]=load_data(file)

k=1;  j=1;
ts=zeros(1000,1);  fn=zeros(1000,1);
if(exist([file '.avi'],'dir'))
  error('output file exists');
  ts=[];  fn=[];
  return;
end
%obj_out=VideoWriter([file '.avi'],'Motion JPEG AVI');
obj_out=VideoWriter([file '.avi'],'Grayscale AVI');
%obj_out=VideoWriter([file '.avi'],'Uncompressed AVI');
obj_in=VideoReader([file '-0000.avi']);
obj_out.FrameRate=obj_in.FrameRate;
open(obj_out);
tic
while true
  try
    obj_in=VideoReader([file '-' num2str(j-1,'%04d') '.avi']);
  catch
    break;
  end
  for i=1:obj_in.NumberOfFrames
    if(toc>10)
      disp([num2str(k/obj_in.FrameRate/60,3) 'm']);
      tic;
    end
    %f=read(obj_in,i);
    f=rgb2gray(read(obj_in,i));
    writeVideo(obj_out,f);

    tmp=f(1,1:4);
    second_count=uint16(bitand(tmp(1),254)/2);
    cycle_count= uint16(bitand(tmp(1),1))*2^12 + ...
                 uint16(bitand(tmp(2),255))*2^4 + ...
                 uint16(bitand(tmp(3),128+64+32+16))/2^4;
    cycle_offset=uint16(bitand(tmp(3),8+4+2+1)*2^8) + ...
                 uint16(bitand(tmp(4),255));
    ts(k)=double(second_count) + double(cycle_count)/8000 + 125e-6*double(cycle_offset)/3072;

    tmp=f(1,5:8);
    fn(k)=uint32(tmp(1))*2^24 + uint32(tmp(2))*2^16 + uint32(tmp(3))*2^8 + uint32(tmp(4));

    if(k>1)
      tmp=round((ts(k)-ts(k-1))*obj_in.FrameRate);
      if(tmp>1)
        disp(['filling in ' num2str(tmp-1) ' skipped frames']);
        %writeVideo(obj_out,repmat(f,[1 1 1 tmp-1]));
        writeVideo(obj_out,repmat(f,[1 1 tmp-1]));
      end
    end

    k=k+1;
    if(k==1001)
      %break;
      ts=[ts; zeros(1000,1)];
      fn=[fn; zeros(1000,1)];
    end
  end
  %if(k==1001) break;  end
  j=j+1;
end
ts=ts(1:(k-1));
fn=fn(1:(k-1));
close(obj_out);

csvwrite([file '.csv'],[ts fn]);
