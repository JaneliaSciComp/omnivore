function varargout = av_take(varargin)
% PREFERENCE_TAKE MATLAB code for av_take.fig
%      PREFERENCE_TAKE, by itself, creates a new PREFERENCE_TAKE or raises the existing
%      singleton*.
%
%      H = PREFERENCE_TAKE returns the handle to a new PREFERENCE_TAKE or the handle to
%      the existing singleton*.
%
%      PREFERENCE_TAKE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREFERENCE_TAKE.M with the given input arguments.
%
%      PREFERENCE_TAKE('Property','Value',...) creates a new PREFERENCE_TAKE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before av_take_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to av_take_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help av_take

% Last Modified by GUIDE v2.5 19-Apr-2013 14:49:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @av_take_OpeningFcn, ...
                   'gui_OutputFcn',  @av_take_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% ---
function handles=initialize(handles)

handles.analog.out.on=0;
handles.analog.out.maxn=nan;
handles.analog.out.n=nan;
handles.analog.out.curr=nan;
handles.analog.out.play=[];
handles.analog.out.file={};
handles.analog.out.fs=[];
handles.analog.out.y={};
handles.analog.out.idx=[];
handles.analog.out.style=1;
handles.analog.out.autoscale=0;
handles.analog.out.logscale=0;
handles.analog.out.onepercent=0;
handles.analog.out.lowfreq=nan;
handles.analog.out.highfreq=nan;
handles.analog.out.nfft=1;
handles.analog.out.range=1;
handles.analog.in.on=0;
handles.analog.in.maxn=nan;
handles.analog.in.n=nan;
handles.analog.in.curr=nan;
handles.analog.in.record=0;
handles.analog.in.directory='';
handles.analog.in.fs=nan;
handles.analog.in.style=1;
handles.analog.in.autoscale=0;
handles.analog.in.logscale=0;
handles.analog.in.onepercent=0;
handles.analog.in.lowfreq=nan;
handles.analog.in.highfreq=nan;
handles.analog.in.nfft=1;
handles.analog.in.range=1;
handles.analog.in.terminal_configuration=1;
handles.analog.in.fileformat=4;  % .wav
handles.video.on=0;
handles.video.syncpulseonly=0;
handles.video.maxn=nan;
handles.video.n=nan;
handles.video.curr=nan;
handles.video.save=0;
handles.video.directory={};
handles.video.samedirectory=0;
handles.video.sameroi=0;
handles.video.preview=0;
%handles.video.adaptor='winvideo';
%handles.video.format='Mono8_1280x960';  % flea3
%handles.video.adaptor='dcam';
%handles.video.format='Y8_1024x768';  % basler 622f
handles.video.adaptor='';
handles.video.devicename={};
handles.video.deviceid='';
handles.video.formatlist={};
handles.video.formatvalue=nan;
handles.video.ROI={};
handles.video.FPS=nan;
handles.video.ncounters=0;
handles.video.counter=1;
handles.video.timestamps=1;
handles.video.fileformat=1;
handles.video.filequality=nan;
handles.video.params={};
handles.running=0;
handles.filename='';
handles.timelimit=0;
handles.verbose=0;


% ---
function handles=load_configuration_file(filename,handles)

handles_saved=load(filename);
handles_saved=handles_saved.handles;
handles.analog.out.on=handles_saved.analog.out.on;
handles.analog.out.maxn=handles_saved.analog.out.maxn;
handles.analog.out.n=handles_saved.analog.out.n;
handles.analog.out.curr=handles_saved.analog.out.curr;
handles.analog.out.play=handles_saved.analog.out.play;
handles.analog.out.file=handles_saved.analog.out.file;
handles.analog.out.y=handles_saved.analog.out.y;
handles.analog.out.fs=handles_saved.analog.out.fs;
handles.analog.out.idx=handles_saved.analog.out.idx;
handles.analog.out.style=handles_saved.analog.out.style;
handles.analog.out.autoscale=handles_saved.analog.out.autoscale;
handles.analog.out.logscale=handles_saved.analog.out.logscale;
handles.analog.out.onepercent=handles_saved.analog.out.onepercent;
handles.analog.out.lowfreq=handles_saved.analog.out.lowfreq;
handles.analog.out.highfreq=handles_saved.analog.out.highfreq;
handles.analog.out.nfft=handles_saved.analog.out.nfft;
handles.analog.out.range=handles_saved.analog.out.range;
handles.analog.in.on=handles_saved.analog.in.on;
handles.analog.in.maxn=handles_saved.analog.in.maxn;
handles.analog.in.n=handles_saved.analog.in.n;
handles.analog.in.curr=handles_saved.analog.in.curr;
handles.analog.in.record=handles_saved.analog.in.record;
handles.analog.in.directory=handles_saved.analog.in.directory;
handles.analog.in.fs=handles_saved.analog.in.fs;
handles.analog.in.style=handles_saved.analog.in.style;
handles.analog.in.autoscale=handles_saved.analog.in.autoscale;
handles.analog.in.logscale=handles_saved.analog.in.logscale;
handles.analog.in.onepercent=handles_saved.analog.in.onepercent;
handles.analog.in.lowfreq=handles_saved.analog.in.lowfreq;
handles.analog.in.highfreq=handles_saved.analog.in.highfreq;
handles.analog.in.nfft=handles_saved.analog.in.nfft;
handles.analog.in.range=handles_saved.analog.in.range;
handles.analog.in.terminal_configuration=handles_saved.analog.in.terminal_configuration;
handles.analog.in.fileformat=handles_saved.analog.in.fileformat;
handles.video.on=handles_saved.video.on;
handles.video.syncpulseonly=handles_saved.video.syncpulseonly;
handles.video.maxn=handles_saved.video.maxn;
handles.video.n=handles_saved.video.n;
handles.video.curr=handles_saved.video.curr;
handles.video.save=handles_saved.video.save;
handles.video.directory=handles_saved.video.directory;
handles.video.samedirectory=handles_saved.video.samedirectory;
handles.video.sameroi=handles_saved.video.sameroi;
handles.video.preview=handles_saved.video.preview;
handles.video.adaptor=handles_saved.video.adaptor;
handles.video.devicename=handles_saved.video.devicename;
handles.video.deviceid=handles_saved.video.deviceid;
handles.video.formatlist=handles_saved.video.formatlist;
handles.video.formatvalue=handles_saved.video.formatvalue;
handles.video.ROI=handles_saved.video.ROI;
handles.video.FPS=handles_saved.video.FPS;
handles.video.ncounters=handles_saved.video.ncounters;
handles.video.counter=handles_saved.video.counter;
handles.video.timestamps=handles_saved.video.timestamps;
handles.video.fileformat=handles_saved.video.fileformat;
handles.video.filequality=handles_saved.video.filequality;
handles.video.params=handles_saved.video.params;
handles.running=0;
handles.filename=handles_saved.filename;
handles.timelimit=handles_saved.timelimit;
handles.verbose=handles_saved.verbose;
        
        
% ---
function update_figure(handles)

set(handles.AnalogOutPlay,'enable','off');
set(handles.AnalogOutNumChannels,'enable','off');
set(handles.AnalogOutChannel,'enable','off');
set(handles.AnalogOutRange,'enable','off');
set(handles.AnalogOutAutoScale,'enable','off');
set(handles.AnalogOutLogScale,'enable','off');
set(handles.AnalogOutOnePercent,'enable','off');
set(handles.AnalogOutHighFreq,'enable','off');
set(handles.AnalogOutLowFreq,'enable','off');
set(handles.AnalogOutNFFT,'enable','off');
set(handles.AnalogOutFile,'enable','off');
set(handles.AnalogOutStyle,'enable','off');
if(handles.analog.out.on && (handles.analog.out.maxn>0))
  set(handles.AnalogOutNumChannels,'string',handles.analog.out.n);
  set(handles.AnalogOutChannel,'string',[1:handles.analog.out.n]);
  set(handles.AnalogOutChannel,'value',handles.analog.out.curr);
  set(handles.AnalogOutRange,'value',handles.analog.out.range);
  set(handles.AnalogOutAutoScale,'value',handles.analog.out.autoscale);
  set(handles.AnalogOutLogScale,'value',handles.analog.out.logscale);
  set(handles.AnalogOutOnePercent,'value',handles.analog.out.onepercent);
  set(handles.AnalogOutHighFreq,'string',handles.analog.out.highfreq);
  set(handles.AnalogOutLowFreq,'string',handles.analog.out.lowfreq);
  set(handles.AnalogOutNFFT,'string',handles.analog.out.nfft);
  set(handles.AnalogOutFile,'string',handles.analog.out.file{handles.analog.out.curr});
  find([handles.analog.out.play],1,'first');
  set(handles.AnalogOutFs,'string',num2str(handles.analog.out.fs(ans)));
  if(handles.analog.out.play(handles.analog.out.curr))
    set(handles.AnalogOutFile,'enable','on');
    set(handles.AnalogOutPlay,'value',1);
  else
    set(handles.AnalogOutFile,'enable','off');
    set(handles.AnalogOutPlay,'value',0);
  end
  set(handles.AnalogOutStyle,'value',handles.analog.out.style);
  if(~handles.running)
    set(handles.AnalogOutPlay,'enable','on');
    set(handles.AnalogOutNumChannels,'enable','on');
    set(handles.AnalogOutRange,'enable','on');
  end
  set(handles.AnalogOutChannel,'enable','on');
  set(handles.AnalogOutFile,'enable','on');
  set(handles.AnalogOutStyle,'enable','on');
  if(handles.analog.out.style==1)
    set(handles.AnalogOutAutoScale,'enable','on');
  else
    set(handles.AnalogOutLogScale,'enable','on');
  end
  if(handles.analog.out.style==3)
    set(handles.AnalogOutOnePercent,'enable','on');
    set(handles.AnalogOutNFFT,'enable','on');
  end
  if(ismember(handles.analog.out.style,[2 3]))
    set(handles.AnalogOutHighFreq,'enable','on');
    set(handles.AnalogOutLowFreq,'enable','on');
  end
end

set(handles.AnalogInRecord,'enable','off');
set(handles.AnalogInNumChannels,'enable','off');
set(handles.AnalogInChannel,'enable','off');
set(handles.AnalogInFs,'enable','off');
set(handles.AnalogInRange,'enable','off');
set(handles.AnalogInTerminalConfiguration,'enable','off');
set(handles.AnalogInFileFormat,'enable','off');
set(handles.AnalogInAutoScale,'enable','off');
set(handles.AnalogInLogScale,'enable','off');
set(handles.AnalogInOnePercent,'enable','off');
set(handles.AnalogInHighFreq,'enable','off');
set(handles.AnalogInLowFreq,'enable','off');
set(handles.AnalogInNFFT,'enable','off');
set(handles.AnalogInDirectory,'enable','off');
set(handles.AnalogInStyle,'enable','off');
if(handles.analog.in.on && (handles.analog.in.maxn>0))
  set(handles.AnalogInNumChannels,'string',handles.analog.in.n);
  set(handles.AnalogInChannel,'string',[1:handles.analog.in.n]);
  set(handles.AnalogInChannel,'value',handles.analog.in.curr);
  set(handles.AnalogInRange,'value',handles.analog.in.range);
  set(handles.AnalogInTerminalConfiguration,'value',handles.analog.in.terminal_configuration);
  set(handles.AnalogInFileFormat,'value',handles.analog.in.fileformat);
  set(handles.AnalogInDirectory,'string',handles.analog.in.directory);
  set(handles.AnalogInFs,'string',num2str(handles.analog.in.fs));
  set(handles.AnalogInAutoScale,'value',handles.analog.in.autoscale);
  set(handles.AnalogInLogScale,'value',handles.analog.in.logscale);
  set(handles.AnalogInOnePercent,'value',handles.analog.in.onepercent);
  set(handles.AnalogInHighFreq,'string',handles.analog.in.highfreq);
  set(handles.AnalogInLowFreq,'string',handles.analog.in.lowfreq);
  set(handles.AnalogInNFFT,'string',handles.analog.in.nfft);
  if(handles.analog.in.record)
    set(handles.AnalogInDirectory,'enable','on');
    set(handles.AnalogInRecord,'value',1);
  else
    set(handles.AnalogInDirectory,'enable','off');
    set(handles.AnalogInRecord,'value',0);
  end
  set(handles.AnalogInStyle,'value',handles.analog.in.style);
  if(~handles.running)
    set(handles.AnalogInRecord,'enable','on');
    set(handles.AnalogInNumChannels,'enable','on');
    set(handles.AnalogInChannel,'enable','on');
    set(handles.AnalogInFs,'enable','on');
    set(handles.AnalogInTerminalConfiguration,'enable','on');
    set(handles.AnalogInRange,'enable','on');
    if(handles.analog.in.record)
      set(handles.AnalogInFileFormat,'enable','on');
    end
  end
  set(handles.AnalogInChannel,'enable','on');
  set(handles.AnalogInDirectory,'enable','on');
  set(handles.AnalogInStyle,'enable','on');
  if(handles.analog.in.style==4)
    set(handles.AnalogInChannel,'enable','off');
  else
    set(handles.AnalogInChannel,'enable','on');
  end
  if(handles.analog.in.style==1)
    set(handles.AnalogInAutoScale,'enable','on');
  else
    set(handles.AnalogInLogScale,'enable','on');
  end
  if(handles.analog.in.style==3)
    set(handles.AnalogInOnePercent,'enable','on');
    set(handles.AnalogInNFFT,'enable','on');
  end
  if(ismember(handles.analog.in.style,[2 3]))
    set(handles.AnalogInHighFreq,'enable','on');
    set(handles.AnalogInLowFreq,'enable','on');
  end
end

set(handles.VideoSave,'enable','off');
set(handles.VideoSyncPulseOnly,'enable','off');
set(handles.VideoSameDirectory,'enable','off');
set(handles.VideoSameROI,'enable','off');
set(handles.VideoFormat,'enable','off');
set(handles.VideoTimeStamps,'enable','off');
set(handles.VideoROI,'enable','off');
set(handles.VideoFPS,'enable','off');
set(handles.VideoNumChannels,'enable','off');
set(handles.VideoTrigger,'enable','off');
set(handles.VideoFileFormat,'enable','off');
set(handles.VideoFileQuality,'enable','off','tooltipstring','');
set(handles.VideoParams,'enable','on');
set(handles.VideoHistogram,'enable','off');
set(handles.VerboseLevel,'enable','off');
set(handles.VideoChannel,'enable','off');
set(handles.VideoParams,'enable','off');
if(handles.video.on && (handles.video.maxn>0))
  set(handles.VideoSyncPulseOnly,'value',handles.video.syncpulseonly);
  set(handles.VideoFPS,'string',handles.video.FPS);
  set(handles.VideoROI,'string',num2str(handles.video.ROI{handles.video.curr},'%d,%d,%d,%d'));
  set(handles.VideoNumChannels,'string',handles.video.n);
  set(handles.VideoChannel,'string',...
      cellfun(@(n,s) [num2str(n) ' ' s], num2cell(1:handles.video.n),...
      handles.video.devicename(1:handles.video.n),'uniformoutput',false));
  set(handles.VideoChannel,'value',handles.video.curr);
  set(handles.VideoDirectory,'string',handles.video.directory(handles.video.curr));
  set(handles.VideoFormat,'string',handles.video.formatlist{handles.video.curr},...
      'value',handles.video.formatvalue(handles.video.curr));
  tmp={};
  if(handles.video.ncounters>0)
    tmp=arrayfun(@(x) sprintf('trigger %d',x),0:(handles.video.ncounters-1),'uniformoutput',false);
  end
  set(handles.VideoTrigger,'string',{'free running' tmp{:}});
  set(handles.VideoTrigger,'value',handles.video.counter);
  if(handles.video.save(handles.video.curr))
    set(handles.VideoDirectory,'enable','on');
    set(handles.VideoSave,'value',1);
  else
    set(handles.VideoDirectory,'enable','off');
    set(handles.VideoSave,'value',0);
  end
  set(handles.VideoSameDirectory,'value',handles.video.samedirectory);
  set(handles.VideoSameROI,'value',handles.video.sameroi);
  set(handles.VideoTimeStamps,'value',handles.video.timestamps);
  set(handles.VideoFileFormat,'value',handles.video.fileformat);
  set(handles.VideoFileQuality,'string',handles.video.filequality);
  set(handles.VideoParams,'data',handles.video.params{handles.video.curr});
  if ~handles.running
    if handles.video.ncounters>1
      set(handles.VideoSyncPulseOnly,'enable','on');
      set(handles.VideoTrigger,'enable','on');
    end
    if handles.video.counter>1
      set(handles.VideoFPS,'enable','on');
    end
  end
  if ~handles.video.syncpulseonly
    set(handles.VideoParams,'enable','on');
    set(handles.VideoChannel,'enable','on');
    if ~handles.running
      set(handles.VideoSave,'enable','on');
      if handles.video.n>1
        set(handles.VideoSameDirectory,'enable','on');
        set(handles.VideoSameROI,'enable','on');
      end
      set(handles.VideoFormat,'enable','on');
      set(handles.VideoROI,'enable','on');
      set(handles.VideoNumChannels,'enable','on');
      if(handles.video.save(handles.video.curr))
        set(handles.VideoTimeStamps,'enable','on');
        set(handles.VideoFileFormat,'enable','on');
        set(handles.VideoFileQuality,'enable','on');
        switch(handles.video.fileformats_available{handles.video.fileformat})
          case {'Motion JPEG AVI','MPEG-4'}
            set(handles.VideoFileQuality,'enable','on','tooltipstring','quality (1-100)');
          case 'Motion JPEG 2000'
            set(handles.VideoFileQuality,'enable','on','tooltipstring','compression ratio (>1)');
        end
      end
    else
      set(handles.VideoHistogram,'enable','on');
    end
  end
end

set(handles.AnalogOutOnOff,'enable','off','value',handles.analog.out.on);
set(handles.AnalogInOnOff,'enable','off','value',handles.analog.in.on);
set(handles.VideoOnOff,'enable','off','value',handles.video.on);
set(handles.TimeLimit,'enable','off','string',num2str(handles.timelimit));
set(handles.VerboseLevel,'enable','off','value',handles.verbose+1);
if(~handles.running)
  if(handles.analog.in.maxn>0)
    set(handles.AnalogInOnOff,'enable','on');
  end
  if(handles.analog.out.maxn>0)
    set(handles.AnalogOutOnOff,'enable','on');
  end
  if(handles.video.maxn>0)
    set(handles.VideoOnOff,'enable','on');
  end
  set(handles.TimeLimit,'enable','on');
  set(handles.VerboseLevel,'enable','on');
end

set(handles.StartStop,'enable','off');
if(handles.analog.out.on || handles.analog.in.on || handles.video.on)
  set(handles.StartStop,'enable','on');
end
if(~handles.running)
  set(handles.StartStop,'string','start','backgroundColor',[0 1 0]);
else
  set(handles.StartStop,'string','stop','backgroundColor',[1 0 0]);
end

colormap(handles.figure1,gray);


% ---
function handles=configure_analog_output_channels(handles)

i=1;
while i<=length(handles.analog.session.Channels)
  if strcmp(class(handles.analog.session.Channels(i)),'daq.ni.AnalogOutputVoltageChannel')
    handles.analog.session.removeChannel(i);
  else
    i=i+1;
  end
end

if handles.analog.out.on && (handles.analog.out.n>0)
  [~,idx]=handles.analog.session.addAnalogOutputChannel(handles.daqdevices.ID,0:(handles.analog.out.n-1),'voltage');
  [handles.analog.session.Channels(idx).Range]=deal(handles.analog.out.ranges_available(handles.analog.out.range));
end

if(length(handles.analog.out.play)~=handles.analog.out.n)
  handles.analog.out.play=zeros(1,handles.analog.out.n);
  handles.analog.out.file=cell(1,handles.analog.out.n);
  handles.analog.out.fs=nan(1,handles.analog.out.n);
  handles.analog.out.y=cell(1,handles.analog.out.n);
  handles.analog.out.idx=ones(1,handles.analog.out.n);
end

  
% ---
function handles=configure_analog_input_channels(handles)

i=1;
while i<=length(handles.analog.session.Channels)
  if strcmp(class(handles.analog.session.Channels(i)),'daq.ni.AnalogInputVoltageChannel')
    handles.analog.session.removeChannel(i);
  else
    i=i+1;
  end
end

if(handles.analog.in.on) && (handles.analog.in.n>0)
  [~,idx]=handles.analog.session.addAnalogInputChannel(handles.daqdevices.ID,0:(handles.analog.in.n-1),'voltage');
  [handles.analog.session.Channels(idx).Range]=deal(handles.analog.in.ranges_available(handles.analog.in.range));
  [handles.analog.session.Channels(idx).TerminalConfig]=...
      deal(handles.analog.in.terminal_configurations_available{handles.analog.in.terminal_configuration});
end


% ---
function set_video_param(obj,event,handles)

data=get(handles.VideoParams,'data');
handles.video.params{handles.video.curr}=data;
guidata(obj, handles);

row=event.Indices(1);

if ~handles.running || strcmp(data{row,4},'always')  return;  end

if strcmp(data{row,4},'whileRunning')
  invoke(handles.video.actx(handles.video.curr), 'Execute', ...
      'stop(vi);');
end
  
handles.video.actx(handles.video.curr).PutWorkspaceData('tmp','base',data{row,2});
invoke(handles.video.actx(handles.video.curr), 'Execute', ...
    ['set(vi.Source,''' data{row,1} ''',tmp)']);

if strcmp(data{row,4},'whileRunning')
  invoke(handles.video.actx(handles.video.curr), 'Execute', ...
      'start(vi);');
end


% ---
function handles=configure_video_channels(handles)

if(~isfield(handles.analog,'session'))  return;  end

i=1;
while i<=length(handles.analog.session.Channels)
  if strcmp(class(handles.analog.session.Channels(i)),'daq.ni.CounterOutputPulseGenerationChannel')
    handles.analog.session.removeChannel(i);
    break;
  else
    i=i+1;
  end
end

if(handles.video.on && (handles.video.n>0) && handles.video.counter>1 && ~isnan(handles.video.FPS))
  h=handles.analog.session.addCounterOutputChannel(...
      handles.daqdevices.ID,handles.video.counter-2,'PulseGeneration');
  set(h,'Frequency',handles.video.FPS);
end
 

% ---
function handles=query_hardware(handles)

try
  % next two lines only needed for roian's rig
  daq.reset;
  daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);
  daq.getDevices;
  handles.daqdevices=ans(1);
catch
  uiwait(warndlg('no digitizer found'));
end

try
  handles.videoadaptors=imaqhwinfo;
catch
  uiwait(warndlg('no camera found'));
end

if(isfield(handles,'daqdevices'))
  handles.analog.session=daq.createSession('ni');

  idx=find(cellfun(@(x) strcmp(x,'AnalogOutput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  handles.analog.out.ranges_available=handles.daqdevices.Subsystems(idx).RangesAvailable;
  set(handles.AnalogOutRange,'String', ...
      arrayfun(@char,handles.analog.out.ranges_available,'uniformoutput',false));
  handles.analog.out.range=min(handles.analog.out.range,length(handles.analog.out.ranges_available));
  handles.analog.out.maxn=handles.daqdevices.Subsystems(idx).NumberOfChannelsAvailable;
  handles.analog.out.n=min(handles.analog.out.n,handles.analog.out.maxn);
  handles.analog.out.curr=min(handles.analog.out.curr,handles.analog.out.maxn);
  handles=configure_analog_output_channels(handles);

  idx=find(cellfun(@(x) strcmp(x,'AnalogInput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  tmp=handles.daqdevices.Subsystems(idx).TerminalConfigsAvailable;
  if(~iscell(tmp)) tmp={tmp};  end
  handles.analog.in.terminal_configurations_available=tmp;
  set(handles.AnalogInTerminalConfiguration,'String', ...
      handles.analog.in.terminal_configurations_available);
  handles.analog.in.terminal_configuration=...
      min(handles.analog.in.terminal_configuration,length(handles.analog.in.terminal_configurations_available));
  handles.analog.in.ranges_available=handles.daqdevices.Subsystems(idx).RangesAvailable;
  set(handles.AnalogInRange,'String', ...
      arrayfun(@char,handles.analog.in.ranges_available,'uniformoutput',false));
  handles.analog.in.range=min(handles.analog.in.range,length(handles.analog.in.ranges_available));
  handles.analog.in.maxn=handles.daqdevices.Subsystems(idx).NumberOfChannelsAvailable;
  handles.analog.in.n=min(handles.analog.in.n,handles.analog.in.maxn);
  handles.analog.in.curr=min(handles.analog.in.curr,handles.analog.in.maxn);
  handles=configure_analog_input_channels(handles);

  idx=find(cellfun(@(x) strcmp(x,'CounterOutput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  handles.video.ncounters=0;
  if(~isempty(idx))
      handles.video.ncounters=handles.daqdevices.Subsystems(idx).NumberOfChannelsAvailable;
  end
else
  set(handles.AnalogOutOnOff,'enable','off');
  set(handles.AnalogInOnOff,'enable','off');
end

if(isfield(handles,'videoadaptors'))
  tmp=VideoWriter(tempname);
  tmp=tmp.getProfiles;
  [handles.video.fileformats_available{1:length(tmp)}]=deal(tmp.Name);
  handles.video.fileformat=min(handles.video.fileformat,length(handles.video.fileformats_available));
  set(handles.VideoFileFormat,'String',handles.video.fileformats_available);

  %tmp=[];
  maxn=0;  adaptor={};  deviceid=[];  devicename={};  formatlist={};  params={};
  for currAdaptor=handles.videoadaptors.InstalledAdaptors
    if strcmp(char(currAdaptor),'winvideo')  continue;  end  
    info=imaqhwinfo(char(currAdaptor));
    if(~isempty(info.DeviceIDs))
      tmp=length(info.DeviceIDs);
      maxn=maxn+tmp;
      adaptor=[adaptor repmat(currAdaptor,1,tmp)];
      deviceid=[deviceid info.DeviceIDs{:}];
      devicename=[devicename {info.DeviceInfo.DeviceName}];
      formatlist={formatlist{:} info.DeviceInfo.SupportedFormats};
      for currDevice=1:tmp
        vi=videoinput(char(currAdaptor),num2str(info.DeviceIDs{currDevice}));
        
        ss = getselectedsource(vi);
        a = get(ss);
        c = fieldnames(a);

        data={}; j = 1;
        %ignore properties: parent, selected, tag, type, frameTimeout,
        for i = 1:length(c)
            if strcmpi(c{i},'parent')|strcmpi(c{i},'selected')|strcmpi(c{i},'tag')|...
               strcmpi(c{i},'type')|strcmpi(c{i},'NormalizedBytesPerPacket')|...
               strcmpi(c{i},'FrameTimeout')
                continue
            end
            data{j,1} = c{i}; data{j,2} = eval(['a.',c{i}]); 

            pinfo=propinfo(ss,c{i});

            switch pinfo.Constraint
                case 'none'
                    data{j,3} = pinfo.ConstraintValue;
                case 'bounded'
                    tmp =  pinfo.ConstraintValue;
                    data{j,3} = ['  [',num2str(tmp(1)),' ',num2str(tmp(2)),']'];
                case 'enum'
                    str = '';
                    for i = 1:length(pinfo.ConstraintValue)
                        str = [str,', ',pinfo.ConstraintValue{i}];
                    end
                    str(1:2) = ' ';
                    data{j,3} = str;
            end

            data{j,4}=pinfo.ReadOnly;

            j = j+1;
        end

        % a hack to turn >1 numbers into string
        tmp=find([cellfun(@(x) isnumeric(x) & (numel(x)>1),data)]);
        for i=1:length(tmp)
          foo=data(tmp);
          data{tmp}=num2str([foo{1}]);
        end

        params{currDevice}=data;

        delete(vi);
      end
    end
  end
  if((handles.video.maxn~=maxn) || ~isequal(handles.video.adaptor,adaptor) || ...
        ~isequal(handles.video.deviceid,deviceid) || ~isequal(handles.video.devicename,devicename) || ...
        ~all(cellfun(@(x,y) isequal(x,y), handles.video.formatlist, formatlist)))
    handles.video.maxn=maxn;
    handles.video.n=maxn;
    handles.video.adaptor=adaptor;
    handles.video.deviceid=deviceid;
    handles.video.devicename=devicename;
    handles.video.formatlist=formatlist;
    handles.video.formatvalue=ones(1,maxn);
    handles.video.curr=1;
    handles.video.save=zeros(1,maxn);
    handles.video.directory=cell(1,maxn);
    handles.video.ROI=cell(1,maxn);
    handles.video.FPS=1;
    handles.video.params=params;
  end
  handles=configure_video_channels(handles);
else
  set(handles.VideoOnOff,'enable','off');
end


% --- Executes just before av_take is made visible.
function av_take_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to av_take (see VARARGIN)

handles.rcfilename = 'most_recent_av_config.mat';
if(exist(handles.rcfilename)==2)
  handles=load_configuration_file(handles.rcfilename,handles);
else
  handles=initialize(handles);
end

handles=query_hardware(handles);

%delete(timerfind);

javaaddpath(fullfile(fileparts(mfilename('fullpath')),'javasysmon-0.3.4.jar'));
import com.jezhumble.javasysmon.JavaSysMon.*
handles.system_monitor.object=com.jezhumble.javasysmon.JavaSysMon();
handles.system_monitor.timer=timer('Name','system_monitor','Period',1,'ExecutionMode','fixedRate',...
    'TimerFcn',@(hObject,eventdata)system_monitor_callback(hObject,eventdata,handles));
warning('off','MATLAB:Java:ConvertFromOpaque');
start(handles.system_monitor.timer);

% Choose default command line output for av_take
handles.output = hObject;

set(hObject,'CloseRequestFcn',@figure_CloseRequestFcn);

update_figure(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes av_take wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ---
function system_monitor_callback(obj,src,handles)

persistent last_cpu

if handles.verbose>1
  disp('entering audio/video system_monitor_callback');
  tic
end

next_cpu=handles.system_monitor.object.cpuTimes();
mem=handles.system_monitor.object.physical();
if(~isempty(last_cpu))
  %disp(['cpu: ' num2str(last_cpu.getCpuUsage(next_cpu)) ', mem=' num2str(mem.getFreeBytes()/mem.getTotalBytes())]);
  set(handles.SystemMonitor,'string',[num2str(round(100*last_cpu.getCpuUsage(next_cpu))) '% cpu, ' ...
      num2str(round(100*(mem.getTotalBytes()-mem.getFreeBytes())/mem.getTotalBytes())) '% mem']);
  drawnow
end
last_cpu=next_cpu;

if handles.verbose>1
  disp(['exiting  audio/video system_monitor_callback:    ' num2str(toc) 's']);
end


% ---
function save_config_file(handles,filename)

tmp=fieldnames(handles);
for(i=1:length(tmp))
  if(isnumeric(handles.(tmp{i})) && (numel(handles.(tmp{i}))==1)&& (handles.(tmp{i})>0) && ishandle(handles.(tmp{i})))
    handles=rmfield(handles,tmp{i});
  end
end

fields_to_remove={
    'daqdevices'
    'videoadaptors'
    'listenerAnalogIn'
    'listenerAnalogOut'
    'timer'};
for i = 1:length(fields_to_remove)
  if isfield(handles, fields_to_remove{i})
      handles = rmfield(handles, fields_to_remove{i});
  end
end
if isfield(handles.analog, 'session')
  handles.analog = rmfield(handles.analog, 'session');
end
if isfield(handles.analog.out, 'ranges_available')
  handles.analog.out = rmfield(handles.analog.out, 'ranges_available');
end
if isfield(handles.analog.in, 'ranges_available')
  handles.analog.in = rmfield(handles.analog.in, 'ranges_available');
end
if isfield(handles.analog.in, 'terminal_configurations_available')
  handles.analog.in = rmfield(handles.analog.in, 'terminal_configurations_available');
end
if isfield(handles.video, 'actx')
  handles.video = rmfield(handles.video, 'actx');
end
save(filename,'handles');


% ---
function figure_CloseRequestFcn(hObject, eventdata)

handles=guidata(hObject);

stop(handles.system_monitor.timer);
delete(handles.system_monitor.timer);
handles.system_monitor=[];

if(handles.running)
  if(strcmp('no',questdlg('a recording is in progress.  force quit?','','yes','no','no')))
    return;
  end
end
tmp=timerfind;
if(~isempty(tmp))
  stop(tmp);  delete(tmp);
end
save_config_file(handles,handles.rcfilename);
delete(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = av_take_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- 
function analog_plot(haxis, data, hanalog)

fs=nanmax(hanalog.fs);

switch hanalog.style
  case 1
    plot(haxis,(1:size(data,1))./fs,data(:,hanalog.curr),'k-');
    axis(haxis,'tight');
    if(~hanalog.autoscale)
      v=axis(haxis);
      axis(haxis,[v(1) v(2) ...
          hanalog.ranges_available(hanalog.range).Min ...
          hanalog.ranges_available(hanalog.range).Max]);
    end
    xlabel(haxis,'time (sec)');
    ylabel(haxis,'pressure (volts)');
  case 2
    [pxx f]=pwelch(data(:,hanalog.curr),[],[],[],fs);
    if(hanalog.logscale)
      pxx=log10(pxx);
    end
    x_txt='frequency (Hz)';
    if(f(end)>10e3)
      f=f./1000;
      x_txt='frequency (kHz)';
    end
    idx=find((f>nanmax(hanalog.lowfreq,0)) & (f<nanmin(hanalog.highfreq,fs/2)));
    plot(haxis,f(idx),pxx(idx),'k-');
    axis(haxis,'tight');
    xlabel(haxis,x_txt);
    ylabel(haxis,'intensity (dB)');
  case 3
    nfft=2^nextpow2(round(hanalog.nfft/1000*fs));
    [~,f,t,p]=spectrogram(data(:,hanalog.curr),nfft,[],[],fs,'yaxis');
    fidx=find((f>nanmax(hanalog.lowfreq,0)) & (f<nanmin(hanalog.highfreq,fs/2)));
    tmp=abs(p(fidx,:));
    if(hanalog.logscale)
      tmp=log10(tmp);
    end
    if(hanalog.onepercent)
      tmp4=reshape(tmp,1,prod(size(tmp)));
      tmp2=prctile(tmp4,1);
      tmp3=prctile(tmp4,99);
      idx=find(tmp<tmp2);  tmp(idx)=tmp2;
      idx=find(tmp>tmp3);  tmp(idx)=tmp3;
    end
    y_txt='frequency (Hz)';
    if(f(end)>10e3)
      f=f./1000;
      y_txt='frequency (kHz)';
    end
    surf(haxis,t,f(fidx),tmp,'EdgeColor','none');
    %h=surf(t+left-0.025,f-f(2)/2,tmp,'EdgeColor','none');
    %uistack(h,'bottom');
    view(haxis,2);
    axis(haxis,'tight');
    xlabel(haxis,'time (sec)');
    ylabel(haxis,y_txt);
  case 4
    tmp=[];
    for(i=1:hanalog.n)
      foo=mean(data(:,i));
      tmp(i)=mean((data(:,i)-foo).^2);
    end
    if(hanalog.logscale)
      tmp=log10(tmp);
    end
    bar(haxis,1:hanalog.n,tmp,'k');
    axis(haxis,'tight');
    xlabel(haxis,'channel #');
    ylabel(haxis,'RMS power');
end


% --- 
function analog_out_callback(src,evt,hObject)

handles=guidata(hObject);

if handles.verbose>0
  disp('entering analog_out_callback');
  tic
end

out=zeros(max(1024,max(round(handles.analog.session.Rate))),handles.analog.out.n); 
for i=1:handles.analog.out.n
  if(handles.analog.out.play(i))
    tmp=handles.analog.out.idx(i)+round(handles.analog.session.Rate)-1;
    idx=min(tmp,length(handles.analog.out.y{i}));
    idx2=tmp-idx;
    out(:,i)=[handles.analog.out.y{i}(handles.analog.out.idx(i):idx); handles.analog.out.y{i}(1:idx2)];
    handles.analog.out.idx(i)=idx2+1;
    if(idx2==0)
      handles.analog.out.idx(i)=idx+1;
    end
  end
end

analog_plot(handles.AnalogOutPlot, out, handles.analog.out);

handles.analog.session.queueOutputData(out);

guidata(hObject, handles);

if handles.verbose>0
  disp(['exiting  analog_out_callback: ' ...
        num2str(toc/(length(out)/handles.analog.out.fs(1)),3) 'x real time is ' ...
        num2str(toc,3) 's to process ' ...
        num2str(length(out)/handles.analog.out.fs(1),3) 's of data']);
end


% --- 
function analog_in_callback(src,evt,hObject)

persistent last_timestamp

handles=guidata(hObject);

if handles.verbose>0
  disp('entering analog_in_callback');
  tic
end

if(handles.analog.in.record)
    switch(handles.analog.in.fileformat)
      case 1
        fwrite(handles.analog.in.fid,evt.Data','float64');
      case 2
        fwrite(handles.analog.in.fid,evt.Data','float32');
      case 3
        d=bsxfun(@minus,evt.Data,handles.analog.in.offset);
        d=bsxfun(@rdivide,d,handles.analog.in.step);
        fwrite(handles.analog.in.fid,d','int16');
      case 4
        data_length = numel(evt.Data) * 4;

        fseek(handles.analog.in.fid,4,'bof');
        chunk_size = fread(handles.analog.in.fid, 1, 'uint32', 0, 'ieee-le');
        fseek(handles.analog.in.fid,4,'bof');
        fwrite(handles.analog.in.fid,chunk_size + data_length,'uint32', 0, 'ieee-le'); 

        fseek(handles.analog.in.fid,42,'bof');
        subchunk_size = fread(handles.analog.in.fid, 1, 'uint32', 0, 'ieee-le');
        fseek(handles.analog.in.fid,42,'bof');
        fwrite(handles.analog.in.fid,subchunk_size + data_length, 'uint32', 0, 'ieee-le');

        fseek(handles.analog.in.fid,0,'eof');
        fwrite(handles.analog.in.fid, ...
            evt.Data ./ handles.analog.in.ranges_available(handles.analog.in.range).Max, ...
            'single', 0, 'ieee-le');
    end
end

if(~isempty(last_timestamp))
  tmp=round((evt.TimeStamps(1)-last_timestamp)*handles.analog.in.fs);
  if(tmp~=1)
    disp(['warning:  skipped ' num2str(tmp) ' analog input samples']);
  end
end
last_timestamp=evt.TimeStamps(end);

analog_plot(handles.AnalogInPlot, evt.Data, handles.analog.in);

%axis(handles.AnalogInPlot,'tight');
%axis(handles.AnalogInPlot,'off');

if handles.verbose>0
  disp(['exiting  analog_in_callback:  ' ...
        num2str(toc/(length(evt.Data)/handles.analog.in.fs),3) 'x real time is ' ...
        num2str(toc,3) 's to process ' ...
        num2str(length(evt.Data)/handles.analog.in.fs,3) 's of data']);
end


% ---
function handles=video_thread(handles)

switch(handles.video.fileformats_available{handles.video.fileformat})
  case {'Motion JPEG AVI','MPEG-4'}
    quality=[',''quality'',' num2str(handles.video.filequality)];
%    handles.video.extension='.jpg';
  case 'Motion JPEG 2000'
    quality=[',''compressionratio'',' num2str(handles.video.filequality)];
%    handles.video.extension='.jp2';
  otherwise
    
    quality='';
end

for i=1:handles.video.n
  handles.video.actx(i) = actxserver('Matlab.Application.Single');
%   handles.video.actx(i).Visible=0;
%   handles.video.actx(i).MinimizeCommandServer;
  invoke(handles.video.actx(i), 'Execute', ...
      ['cd(''' pwd ''');  '...
      'imaqmem(1e10);  '...
      'vi=videoinput(''' handles.video.adaptor{i} ''',' num2str(handles.video.deviceid(i)) ',''' ...
          handles.video.formatlist{i}{handles.video.formatvalue(i)} ''');']);

  if(~isempty(handles.video.ROI{i}))
    invoke(handles.video.actx(i), 'Execute', ...
        ['set(vi,''ROIPosition'',[' num2str(handles.video.ROI{i}) ']);']);
  end
  
  if(handles.video.counter==1)
    invoke(handles.video.actx(i), 'Execute', ...
        ['set(vi,''FramesPerTrigger'',inf,''TriggerRepeat'',0);  '...
        'triggerconfig(vi, ''immediate'', ''none'', ''none'');']);
  else
    invoke(handles.video.actx(i), 'Execute', ...
        ['set(vi,''FramesPerTrigger'',1,''TriggerRepeat'',inf);  '...
        'triggerconfig(vi, ''hardware'', ''fallingEdge'', ''externalTriggerMode0-Source0'');']);
  end
  
  invoke(handles.video.actx(i), 'Execute', ...
      ['roiPos = get(vi, ''ROIPosition'');  ' ...
      'nBands = get(vi, ''NumberOfBands'');']);
  roiPos = handles.video.actx(i).GetVariable('roiPos','base');
  nBands = handles.video.actx(i).GetVariable('nBands','base');
  invoke(handles.video.actx(i), 'Execute', ...
      ['fig=figure(''units'',''pixels'',''position'',[' num2str(roiPos) '],''numbertitle'',''off'',''menubar'',''none'',''visible'',''off'');  '...
      'ax=axes(''position'',[0 0 1 1],''parent'',fig);  '...
      'im = image(zeros(' num2str(roiPos(4)) ',' num2str(roiPos(3)) ',' num2str(nBands) '),''parent'',ax);']);

  data=handles.video.params{i};
  for j=1:size(data,1)
    if strcmp(data{j,4},'always')  continue;  end
    handles.video.actx(i).PutWorkspaceData('tmp','base',data{j,2});
    invoke(handles.video.actx(i), 'Execute', ...
        ['set(vi.Source,''' data{j,1} ''',tmp)']);
  end

  if(handles.video.save(i))
    filename=[handles.filename 'v'];
    if(handles.video.n>1)
      filename=[filename num2str(i)];
    end
    invoke(handles.video.actx(i), 'Execute', ...
        ['vifile=VideoWriter(''' ...
            fullfile(handles.video.directory{i}, filename) ''',''' ...
            handles.video.fileformats_available{handles.video.fileformat} ''');  '...
        'set(vifile,''FrameRate'',' num2str(handles.video.FPS) quality ');']);
    if handles.video.timestamps==1
      invoke(handles.video.actx(i), 'Execute', ...
          ['fid=[];']);
    else
      invoke(handles.video.actx(i), 'Execute', ...
          ['fid=fopen(''' fullfile(handles.video.directory{i}, [filename '.ts']) ''',''w'');']);
    end
    invoke(handles.video.actx(i), 'Execute', ...
        ['set(vi,''LoggingMode'',''disk&memory'',''DiskLogger'',vifile); '...
        'set(vi,''FramesAcquiredFcnCount'',' num2str(handles.video.FPS+i) ','...
            '''FramesAcquiredFcn'',@(hObject,eventdata)av_video_callback(hObject,eventdata,vi,' ...
            num2str(handles.video.FPS) ',fid,' num2str(handles.verbose) ',' ...
            num2str(handles.video.curr==i) ',' num2str(handles.video.timestamps) '));']);
  end
end


% ---
function display_callback(src,evt,handles)

if handles.verbose>1
  disp('entering audio/video display_callback');
  tic
end

if(isfield(handles,'triggertime'))
  str='';
  tmp=etime(clock,handles.triggertime);
  tmp2=floor(tmp/60/60/24);
  if(tmp2>0)
    str=[str num2str(tmp2) 'd '];
    tmp=tmp-tmp2*60*60*24;
  end
  tmp2=floor(tmp/60/60);
  if(tmp2>0)
    str=[str num2str(tmp2) 'h '];
    tmp=tmp-tmp2*60*60;
  end
  tmp2=floor(tmp/60);
  if(tmp2>0)
    str=[str num2str(tmp2) 'm '];
    tmp=tmp-tmp2*60;
  end
  str=[str num2str(round(tmp)) 's '];
  set(handles.TimeElapsed,'string',str);
end

if(handles.analog.out.on)
  set(handles.AnalogOutBuffer,'string',num2str(handles.analog.session.ScansQueued));
end

if handles.video.on && handles.video.save(handles.video.curr)
  try
    set(handles.VideoFPSAchieved,'string',...
        num2str(handles.video.actx(handles.video.curr).GetVariable('FPSAchieved','base')));
    set(handles.VideoFramesAvailable,'string',...
        num2str(handles.video.actx(handles.video.curr).GetVariable('FramesAvailable','base')));
    if handles.video.counter>1
      set(handles.VideoFramesSkipped,'string',...
          num2str(handles.video.actx(handles.video.curr).GetVariable('FramesSkipped','base')));
    end
  catch
  end
end

drawnow('expose');

if handles.verbose>1
  disp(['exiting  audio/video display_callback:    ' num2str(toc) 's']);
end


% --- Executes on button press in StartStop.
function StartStop_Callback(hObject, eventdata, handles)
% hObject    handle to StartStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.verbose>1
  disp('entering startstop_callback');
  tic
end

set(handles.StartStop,'enable','off');  drawnow;

if(~handles.running)
  if(sum(handles.analog.out.play)>0)
    if(sum(diff([handles.analog.out.fs(logical([handles.analog.out.play]))]))>0)
      uiwait(errordlg('analog output sampling rates must be equal'));
      set(handles.StartStop,'enable','on');  drawnow('expose');
      return;
    end
  end
  if(handles.analog.out.on && (sum(handles.analog.out.play)>0) && handles.analog.in.record)
    find([handles.analog.out.play],1,'first');
    if(handles.analog.out.fs(ans) ~= handles.analog.in.fs)
      uiwait(warndlg('analog input and output sampling rate must be equal'));
      set(handles.StartStop,'enable','on');  drawnow('expose');
    return;
    end
  end
  
  handles.filename=datestr(now,30);
  if handles.analog.out.on
    find([handles.analog.out.play],1,'first');
    rate=handles.analog.out.fs(ans);
  elseif handles.analog.in.on
    rate=handles.analog.in.fs;
  else
    rate=handles.video.FPS;
  end
  
  if(handles.analog.out.on || handles.analog.in.on || ...
        (handles.video.on && handles.video.counter>1))
    if(isnan(rate) || isempty(rate) || (rate<1))
      uiwait(errordlg('sampling rate must be a positive integer'));
      set(handles.StartStop,'enable','on');  drawnow('expose');
      return;
    else
      handles.analog.session.Rate=rate;
    end
  end

  handles.running=1;
  
  if(handles.analog.in.on)
    clear analog_in_callback
    handles.analog.in.fid = nan;
    if(handles.analog.in.record)
      switch(handles.analog.in.fileformat)
        case 1  % version#=1, sample rate, nchan, (doubles)
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']),'w');
          fwrite(handles.analog.in.fid,[1 handles.analog.in.fs handles.analog.in.n],'double');
        case 2  % version#=2, sample rate, nchan, (singles)
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']),'w');
          fwrite(handles.analog.in.fid,[2 handles.analog.in.fs handles.analog.in.n],'double');
        case 3  % version#=3, sample rate, nchan, step, offset, (int16s = round((doubles-offset)/step))
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']),'w');
          fwrite(handles.analog.in.fid,[3 handles.analog.in.fs handles.analog.in.n],'double');
          if(handles.analog.out.on)
            analog_out_callback(hObject, eventdata, handles.figure1);
          end
          handles.analog.in.step=[];
          handles.analog.in.offset=[];
          data=handles.analog.session.startForeground;
          for i=1:size(data,2)
            handles.analog.in.step(i)=min(diff([nan; unique(data(:,i))]));
            handles.analog.in.offset(i)=mean(mod(data(:,i),handles.analog.in.step(i)));
            fwrite(handles.analog.in.fid,[handles.analog.in.step(i) handles.analog.in.offset(i)],'double');
          end
          questdlg({['steps: ' num2str(handles.analog.in.step,3)],['offsets: ' num2str(handles.analog.in.offset,3)]},...
              'double to int16 conversion','proceed','cancel','proceed');
          if(strcmp(ans,'cancel'))
              fclose(handles.analog.in.fid);
              delete(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']));
              handles.running=0;
              update_figure(handles);
              return;
          end
        case 4
          % the one extra (zero valued) sample tic at the beginning
          % introduces a time shift of 1/Fs
          wavwrite(zeros(1,handles.analog.in.n), handles.analog.in.fs, 32, ...
              fullfile(handles.analog.in.directory,[handles.filename 'a.wav']));
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.wav']),'r+');
      end
    end
    handles.listenerAnalogIn=handles.analog.session.addlistener('DataAvailable',...
        @(hObject,eventdata)analog_in_callback(hObject,eventdata,handles.figure1));
  end

  if(handles.analog.out.on)
    handles.analog.out.idx(logical(handles.analog.out.play))=1;
    guidata(hObject, handles);
    for(i=1:5)  analog_out_callback(hObject, eventdata, handles.figure1);  end
    handles=guidata(hObject);
    handles.listenerAnalogOut=handles.analog.session.addlistener('DataRequired',...
        @(hObject,eventdata)analog_out_callback(hObject,eventdata,handles.figure1));
  end

  tmp=[];
  if(handles.analog.in.record)
    tmp=handles.analog.in.directory;
  else
    for i=1:handles.video.n
      if handles.video.save(i)
        tmp=handles.video.directory{i};
        break;
      end
    end
  end
  if(~isempty(tmp))
    save_config_file(handles,fullfile(tmp,[handles.filename 'c.mat']));
  end
  
  if handles.video.on && ~handles.video.syncpulseonly
    clear av_video_callback
    handles=video_thread(handles);
    %update_video_params(handles);
    handles=video_setup_preview(handles);
    for i=1:handles.video.n
      try
        invoke(handles.video.actx(i), 'Execute', ...
           'start(vi);');
      catch
        warning(['trouble starting vi of channel' num2str(i)]);
      end
    end
  end

%   guidata(hObject, handles);  % necessary??

  if(handles.analog.out.on || handles.analog.in.on || ...
        (handles.video.on && (handles.video.counter>1)))
    handles.analog.session.NotifyWhenDataAvailableExceeds=round(handles.analog.session.Rate);
    handles.analog.session.NotifyWhenScansQueuedBelow=5*round(handles.analog.session.Rate);
    handles.analog.session.IsContinuous=true;
    handles.analog.session.startBackground;
  end
  handles.triggertime=clock;

  handles.timer.update_display=timer('Name','update display','Period',1,'ExecutionMode','fixedRate',...
      'TimerFcn',@(hObject,eventdata)display_callback(hObject,eventdata,handles));
  start(handles.timer.update_display);

%   guidata(hObject, handles);  % necessary??

elseif(handles.running)
  if(handles.analog.out.on || handles.analog.in.on || (handles.video.on && (handles.video.counter>1)))
    handles.analog.session.stop();
    handles.analog.session.IsContinuous=false;
  end

  if(handles.analog.out.on)
    delete(handles.listenerAnalogOut);
  end
  
  if(handles.analog.in.on)
    delete(handles.listenerAnalogIn);
    if(handles.analog.in.record)
      fclose(handles.analog.in.fid);
    end
  end

  if(isvalid(handles.timer.update_display))
    stop(handles.timer.update_display);
    delete(handles.timer.update_display);
  end

  if handles.video.on && ~handles.video.syncpulseonly
    for i=1:handles.video.n
      try
        invoke(handles.video.actx(i), 'Execute', ...
            'stop(vi);');
      catch
        warning(['trouble stopping vi of channel' num2str(i)]);
      end
    end
    handles=video_takedown_preview(handles);
    for i=1:handles.video.n
      if handles.video.save(i)
        try
          invoke(handles.video.actx(i), 'Execute', ...
              ['tic; '...
              'while(((vi.DiskLoggerFrameCount~=vi.FramesAcquired) && (toc<10)) || (vi.FramesAvailable>0)) '...
                'if(vi.FramesAvailable>0) ' ...
                    'av_video_callback([],[],vi,' ...
                    num2str(handles.video.FPS) ',fid,' num2str(handles.verbose) ',' ...
                    num2str(handles.video.curr==i) ',' num2str(handles.video.timestamps) '); ' ...
                'else ' ...
                  'pause(0.1); ' ...
                'end; ' ...
              'end; ' ...
              'not_saved = vi.FramesAcquired - vi.DiskLoggerFrameCount;']);
          not_saved=handles.video.actx(i).GetVariable('not_saved','base');
          if(not_saved>0)
            warndlg([num2str(not_saved) ' frames have not been saved for camera ' num2str(i)]);
          end
          invoke(handles.video.actx(i), 'Execute', ...
              'close(vifile);');
  %            'vifile=close(vi.DiskLogger)');
          if handles.video.timestamps>1
            invoke(handles.video.actx(i), 'Execute', ...
                'fclose(fid);');
          end
        catch
          warning(['trouble saving last few frames of channel ' num2str(i)]);
        end
      end
      try
        invoke(handles.video.actx(i), 'Execute', ...
            'delete(vi);');
      catch
        warning(['trouble deleting vi of channel ' num2str(i)]);
      end
      try
        handles.video.actx(i).Quit;
      catch
        warning(['trouble quitting actx of channel ' num2str(i)]);
      end
    end
  end

  handles.running=0;
end

update_figure(handles);
guidata(hObject, handles);

if handles.verbose>1
  disp(['exiting  startstop_callback:    ' num2str(toc) 's']);
end

if((handles.timelimit>0) && handles.running)
  pause(60*handles.timelimit);
  StartStop_Callback(hObject, eventdata, handles);
end


function TimeLimit_Callback(hObject, eventdata, handles)
% hObject    handle to TimeLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeLimit as text
%        str2double(get(hObject,'String')) returns contents of TimeLimit as a double

handles.timelimit=str2num(get(handles.TimeLimit,'string'));
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TimeLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

persistent directory
if isempty(directory)  directory=pwd;  end

[file,directory]=uigetfile(fullfile(directory,'*.mat'),'Select configuration file to open');
if(isnumeric(file) && isnumeric(directory) && (file==0) && (directory==0))  return;  end
handles=load_configuration_file(fullfile(directory,file),handles);
handles=configure_analog_output_channels(handles);
handles=configure_analog_input_channels(handles);
handles=configure_video_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

persistent directory
if isempty(directory)  directory=pwd;  end

[file,directory]=uiputfile(fullfile(directory,'*.mat'),'Select file to save configuration to');
if(isnumeric(file) && isnumeric(directory) && (file==0) && (directory==0))  return;  end
save_config_file(handles,fullfile(directory,file));


% --------------------------------------------------------------------
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

questdlg('Reset configuration to default?','','Yes','No','No');
if(strcmp(ans,'No'))  return;  end
handles=initialize(handles);
handles=query_hardware(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes on button press in AnalogOutOnOff.
function AnalogOutOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutOnOff

handles.analog.out.on=~handles.analog.out.on;
handles=configure_analog_output_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes on selection change in AnalogOutChannel.
function AnalogOutChannel_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogOutChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogOutChannel

handles.analog.out.curr=get(hObject,'value');
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function AnalogOutAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.analog.out.autoscale=~handles.analog.out.autoscale;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutAutoScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AnalogOutLogScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutLogScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.analog.out.logscale=~handles.analog.out.logscale;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutLogScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutLogScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AnalogOutOnePercent_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutOnePercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.analog.out.onepercent=~handles.analog.out.onepercent;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutOnePercent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutOnePercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function AnalogOutLowFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutLowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutLowFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutLowFreq as a double

handles.analog.out.lowfreq=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutLowFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutLowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalogOutHighFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutHighFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutHighFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutHighFreq as a double

handles.analog.out.highfreq=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutHighFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutHighFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalogOutNFFT_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutNFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutNFFT as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutNFFT as a double

handles.analog.out.nfft=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutNFFT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutNFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in AnalogOutStyle.
function AnalogOutStyle_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogOutStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogOutStyle

handles.analog.out.style=get(hObject,'value');
update_figure(handles);
guidata(hObject, handles);


% --- Executes on button press in AnalogOutPlay.
function AnalogOutPlay_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutPlay

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);

channel=handles.analog.out.curr;

if(get(handles.AnalogOutPlay,'value'))
  [filename,directory,~]=uigetfile(fullfile(directory,'*.wav'),['Select analog out channel' num2str(channel) 'file']);
  if(filename~=0)
    handles.analog.out.play(channel)=1;
    handles.analog.out.file{channel}=fullfile(directory,filename);
    [handles.analog.out.y{channel},handles.analog.out.fs(channel),~]=...
        wavread(handles.analog.out.file{channel});
    handles.analog.out.idx(channel)=1;
    set(handles.AnalogOutFile,'string',handles.analog.out.file(channel),'enable','on');
  else
    set(handles.AnalogOutPlay,'value',0);
  end
else
  handles.analog.out.play(channel)=0;
  set(handles.AnalogOutFile,'enable','off');
end

guidata(hObject,handles);



function AnalogOutNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutNumChannels as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutNumChannels as a double

tmp=str2num(get(hObject,'String'));
if(tmp>handles.analog.out.maxn)
  tmp=handles.analog.out.maxn;
  set(hObject,'String',tmp);
end
handles.analog.out.n=tmp;
handles.analog.out.curr = min(handles.analog.out.curr, handles.analog.out.n);
handles=configure_analog_output_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutNumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AnalogOutRange.
function AnalogOutRange_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogOutRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogOutRange

handles.analog.out.range=get(hObject,'value');
handles=configure_analog_output_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogOutRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in AnalogInOnOff.
function AnalogInOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInOnOff

handles.analog.in.on=~handles.analog.in.on;
handles=configure_analog_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


function AnalogInFs_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInFs as text
%        str2double(get(hObject,'String')) returns contents of AnalogInFs as a double

handles.analog.in.fs=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalogInLowFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInLowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInLowFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogInLowFreq as a double

handles.analog.in.lowfreq=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInLowFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInLowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalogInHighFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInHighFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInHighFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogInHighFreq as a double

handles.analog.in.highfreq=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInHighFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInHighFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalogInNFFT_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInNFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInNFFT as text
%        str2double(get(hObject,'String')) returns contents of AnalogInNFFT as a double

handles.analog.in.nfft=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInNFFT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInNFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AnalogInNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInNumChannels as text
%        str2double(get(hObject,'String')) returns contents of AnalogInNumChannels as a double

tmp=str2num(get(hObject,'String'));
if(tmp>handles.analog.in.maxn)
  tmp=handles.analog.in.maxn;
  set(hObject,'String',tmp);
end
handles.analog.in.n=tmp;
handles.analog.in.curr = min(handles.analog.in.curr, handles.analog.in.n);
handles=configure_analog_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInNumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in AnalogInStyle.
function AnalogInStyle_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInStyle

handles.analog.in.style=get(hObject,'value');
update_figure(handles);
guidata(hObject, handles);


% --- Executes on selection change in AnalogInChannel.
function AnalogInChannel_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInChannel

handles.analog.in.curr=get(handles.AnalogInChannel,'value');
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function AnalogInAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.analog.in.autoscale=~handles.analog.in.autoscale;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AnalogInAutoScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AnalogInLogScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInLogScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.analog.in.logscale=~handles.analog.in.logscale;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AnalogInLogScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInLogScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AnalogInOnePercent_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInOnePercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.analog.in.onepercent=~handles.analog.in.onepercent;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AnalogInOnePercent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInOnePercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in AnalogInRecord.
function AnalogInRecord_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInRecord

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);

if(get(handles.AnalogInRecord,'value'))
  tmp=uigetdir(directory,'Select analog input directory');
  if(tmp~=0)
    handles.analog.in.record=1;
    handles.analog.in.directory=tmp;
    set(handles.AnalogInDirectory,'string',handles.analog.in.directory,'enable','on');
    set(handles.AnalogInFileFormat,'enable','on');
    directory=tmp;
  else
    set(handles.AnalogInRecord,'value',0);
  end
else
  handles.analog.in.record=0;
  set(handles.AnalogInDirectory,'enable','off');
  set(handles.AnalogInFileFormat,'enable','off');
end

guidata(hObject,handles);


% --- Executes on selection change in AnalogInFileFormat.
function AnalogInFileFormat_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInFileFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInFileFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInFileFormat

handles.analog.in.fileformat=get(hObject,'value');
guidata(hObject, handles);


% --- Executes on selection change in AnalogInRange.
function AnalogInRange_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInRange

handles.analog.in.range=get(hObject,'value');
handles=configure_analog_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AnalogInTerminalConfiguration.
function AnalogInTerminalConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInTerminalConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInTerminalConfiguration contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInTerminalConfiguration

handles.analog.in.terminal_configuration=get(hObject,'value');
handles=configure_analog_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AnalogInTerminalConfiguration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInTerminalConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VideoOnOff.
function VideoOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to VideoOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoOnOff

handles.video.on=~handles.video.on;
handles=configure_video_channels(handles);
update_figure(handles);
guidata(hObject,handles);


% --- Executes on button press in VideoSave.
function VideoSameDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSave

handles=guidata(hObject);
if get(handles.VideoSameDirectory,'Value')
  questdlg('Copy directory to all other channels?','','Yes','No','No');
  if(strcmp(ans,'No'))
    handles.video.samedirectory=0;
    set(hObject,'Value',0);
    return;
  end
  handles.video.samedirectory=1;
  handles.video.save=repmat(handles.video.save(handles.video.curr), 1, handles.video.n);
  handles.video.directory=repmat(handles.video.directory(handles.video.curr), 1, handles.video.n);
  guidata(hObject,handles);
else
  handles.video.samedirectory=0;
end
guidata(hObject,handles);


% --- Executes on button press in VideoSave.
function VideoSave_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSave

persistent directory2
if(isempty(directory2))  directory2=pwd;  end

handles=guidata(hObject);
if(get(handles.VideoSave,'value'))
  tmp=uigetdir(directory2,'Select video directory');
  if(tmp~=0)
    handles.video.save(handles.video.curr)=1;
    handles.video.directory{handles.video.curr}=tmp;
    if handles.video.samedirectory==1
      handles.video.save=repmat(handles.video.save(handles.video.curr), 1, handles.video.n);
      handles.video.directory=repmat(handles.video.directory(handles.video.curr), 1, handles.video.n);
    end
    set(handles.VideoDirectory,'string',handles.video.directory{handles.video.curr});
    set(handles.VideoDirectory,'enable','on');
    set(handles.VideoTimeStamps,'enable','on');
    set(handles.VideoFileFormat,'enable','on');
    set(handles.VideoFileQuality,'enable','on');
    directory2=tmp;
  else
    set(handles.VideoSave,'value',0);
  end
else
  handles.video.save(handles.video.curr)=0;
  set(handles.VideoDirectory,'enable','off');
  set(handles.VideoTimeStamps,'enable','off');
  set(handles.VideoFileFormat,'enable','off');
  set(handles.VideoFileQuality,'enable','off');
end
guidata(hObject,handles);



% --- Executes on selection change in VideoTimeStamps.
function VideoSyncPulseOnly_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTimeStamps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoTimeStamps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoTimeStamps

handles.video.syncpulseonly=get(handles.VideoSyncPulseOnly,'value');
if handles.video.syncpulseonly && (handles.video.counter==1)
  handles.video.counter=2;
  set(handles.VideoTrigger,'value',2)
end
update_figure(handles);
guidata(hObject,handles);


% --- Executes on selection change in VideoTimeStamps.
function VideoTimeStamps_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTimeStamps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoTimeStamps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoTimeStamps

handles.video.timestamps=get(handles.VideoTimeStamps,'value');
update_figure(handles);
guidata(hObject,handles);


% --- Executes on selection change in VideoFormat.
function VideoFormat_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoFormat

handles.video.formatvalue(handles.video.curr)=get(handles.VideoFormat,'value');
%handles.video.params{handles.video.curr}=[];
update_figure(handles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function VideoFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in VideoSave.
function VideoSameROI_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSave

handles=guidata(hObject);
if get(handles.VideoSameROI,'Value')
  questdlg('Copy ROI to all other channels?','','Yes','No','No');
  if(strcmp(ans,'No'))
    handles.video.sameroi=0;
    set(hObject,'Value',0);
    return;
  end
  handles.video.sameroi=1;
  handles.video.ROI=repmat(handles.video.ROI(handles.video.curr), 1, handles.video.n);
  guidata(hObject,handles);
else
  handles.video.sameroi=0;
end
guidata(hObject,handles);


function VideoROI_Callback(hObject, eventdata, handles)
% hObject    handle to VideoROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoROI as text
%        str2double(get(hObject,'String')) returns contents of VideoROI as a double

handles.video.ROI{handles.video.curr}=str2num(get(hObject,'String'));
if handles.video.sameroi==1
  handles.video.ROI=repmat(handles.video.ROI(handles.video.curr), 1, handles.video.n);
end
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function VideoROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function VideoFPS_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoFPS as text
%        str2double(get(hObject,'String')) returns contents of VideoFPS as a double

handles.video.FPS=str2num(get(hObject,'String'));
handles=configure_video_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function VideoFPS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoFPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function VideoNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to VideoNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoNumChannels as text
%        str2double(get(hObject,'String')) returns contents of VideoNumChannels as a double

tmp=str2num(get(hObject,'String'));
if(tmp>handles.video.maxn)
  tmp=handles.video.maxn;
  set(hObject,'String',tmp);
end
handles.video.n=tmp;
handles.video.curr = min(handles.video.curr, handles.video.n);
handles=configure_video_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function VideoNumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ---
function handles=video_setup_preview(handles)

try
  invoke(handles.video.actx(handles.video.curr), 'Execute', ...
      'set(fig,''visible'',''on'');  preview(vi,im);');
catch
  warning(['trouble setting up video preview of channel ' num2str(handles.video.curr)]);
end


% ---
function handles=video_takedown_preview(handles)

try
  invoke(handles.video.actx(handles.video.curr), 'Execute', ...
      'stoppreview(vi);  set(fig,''visible'',''off'');');
catch
  warning(['trouble taking down video preview of channel ' num2str(handles.video.curr)]);
end
  

% --- Executes on selection change in VideoChannel.
function VideoChannel_Callback(hObject, eventdata, handles)
% hObject    handle to VideoChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoChannel

if handles.running
  handles=video_takedown_preview(handles);
end
handles.video.curr=get(handles.VideoChannel,'value');
if handles.running
  handles=video_setup_preview(handles);
end
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function VideoChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VideoTrigger.
function VideoTrigger_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoTrigger

if handles.video.syncpulseonly && (get(handles.VideoTrigger,'value')==1)
  set(handles.VideoTrigger,'value',2)
end
handles.video.counter=get(handles.VideoTrigger,'value');
handles=configure_video_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes on button press in VideoHistogram.
function VideoHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to VideoHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoHistogram

figure;

invoke(handles.video.actx(handles.video.curr), 'Execute', ...
    'im_cdata = get(im,''cdata'');');
im_cdata=handles.video.actx(handles.video.curr).GetVariable('im_cdata','base');
invoke(handles.video.actx(handles.video.curr), 'Execute', ...
    'nbands = vi.NumberOfBands;');
nbands=handles.video.actx(handles.video.curr).GetVariable('nbands','base');

if nbands == 1
    n = hist(im_cdata(:),0:255);
    for j = 1:256
        h=patch([-.5 .5 .5 -.5]+j, [0 0 1 1]*n(j), 'b','edgecolor','none');
        if j==1
            set(h,'xdata',[-5 .5 .5 -5],'facecolor','r');
        end
        if j==256
            set(h,'xdata',[-.5 5 5 -.5]+255,'facecolor','r');
        end
    end
    set(gca,'ylim',[0 1.05*max(n)]);
else %if RGB image
    maxval = 0;
    c = 'rgb';
    for i = 1:3
        temp = im_cdata(:,:,i);
        n = hist(temp(:),0:255);
        for j = 1:256
            h=patch([-.5 .5 .5 -.5]+j, [0 0 1 1]*n(j), c(i),'edgecolor','none');
            if j==1
                set(h,'xdata',[-5 .5 .5 -5],'facecolor',modc);
            end
            if j==256
                set(h,'xdata',[-.5 5 5 -.5]+255,'facecolor',modc);
            end
        end
        maxval = max([maxval,max(n)]);
        switch i
            case 1; modc = [1 .8 .8];
            case 2; modc = [.8 1 .8];
            case 3; modc = [.8 .8 1];
        end
        set(gca,'nextplot','add')
    end
    set(gca,'ylim',[0 1.05*maxval]);
end
set(gca,'xtick',[],'ytick',[],'xscale','linear','xlim',[-5 260],'box','on');

guidata(hObject, handles);


% --- Executes on button press in VideoTrigger.
function VideoFileFormat_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoTrigger

handles.video.fileformat=get(handles.VideoFileFormat,'value');
update_figure(handles);
guidata(hObject, handles);


function VideoFileQuality_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFileQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoFileQuality as text
%        str2double(get(hObject,'String')) returns contents of VideoFileQuality as a double

handles.video.filequality=str2num(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function VideoFileQuality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoFileQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in VerboseLevel.
function VerboseLevel_Callback(hObject, eventdata, handles)
% hObject    handle to VerboseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VerboseLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VerboseLevel

handles.verbose=-1+get(hObject,'value');
guidata(hObject, handles);
