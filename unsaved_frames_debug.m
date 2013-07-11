vi=videoinput('pointgrey',1);
set(vi,'FramesPerTrigger',inf,'TriggerRepeat',1);
triggerconfig(vi, 'immediate', 'none', 'none');
vifile=VideoWriter(tempname,'grayscale avi');
set(vi,'LoggingMode','disk','DiskLogger',vifile);
%open(vifile);
start(vi);  pause(1);  stop(vi);
while (vi.DiskLoggerFrameCount ~= vi.FramesAcquired)
  vi.DiskLoggerFrameCount
  vi.FramesAcquired
end
close(vifile);
