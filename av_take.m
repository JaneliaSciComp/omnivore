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
handles.analog.out.range=1;
handles.analog.in.on=0;
handles.analog.in.maxn=nan;
handles.analog.in.n=nan;
handles.analog.in.curr=nan;
handles.analog.in.record=0;
handles.analog.in.directory='';
handles.analog.in.fs=nan;
handles.analog.in.style=1;
handles.analog.in.range=1;
handles.analog.in.terminal_configuration=1;
handles.digital.in.on=0;
handles.digital.in.directory='';
handles.digital.in.clock.port=nan;
handles.digital.in.clock.terminal=nan;
handles.digital.in.data.port=nan;
handles.digital.in.data.terminals=nan;
handles.digital.in.channel.port=nan;
handles.digital.in.channel.terminals=nan;
handles.digital.in.error.port=nan;
handles.digital.in.error.terminals=nan;
handles.digital.in.sync.port=nan;
handles.digital.in.sync.terminals=nan;
handles.hygrometer.on=0;
handles.hygrometer.save=0;
handles.hygrometer.directory='';
handles.hygrometer.object=[];
handles.hygrometer.period=nan;
handles.hygrometer.clock=0;     % the digital output line connected to the SHT7x's SCK line
handles.hygrometer.linein=0;    % the digital input line(s) connected to the SHT7x's DATA line
handles.hygrometer.lineout=1;   % the digital output line connected to the SHT7x's DATA line
handles.portin=2;          % which hardware port is used for digital input
handles.portout=1;         % which hardware port is used for digital output
handles.video.on=0;
handles.video.maxn=nan;
handles.video.n=nan;
handles.video.curr=nan;
handles.video.save=0;
handles.video.directory={};
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
handles.video.ROI=[];
handles.video.FPS=nan;
handles.video.trigger=[];
handles.video.ncounters=0;
handles.video.counter=1;
handles.video.compression='Motion JPEG AVI';
handles.video.pool=1;
handles.running=0;
handles.filename='';
handles.timelimit=0;


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
handles.analog.out.range=handles_saved.analog.out.range;
handles.analog.in.on=handles_saved.analog.in.on;
handles.analog.in.maxn=handles_saved.analog.in.maxn;
handles.analog.in.n=handles_saved.analog.in.n;
handles.analog.in.curr=handles_saved.analog.in.curr;
handles.analog.in.record=handles_saved.analog.in.record;
handles.analog.in.directory=handles_saved.analog.in.directory;
handles.analog.in.fs=handles_saved.analog.in.fs;
handles.analog.in.style=handles_saved.analog.in.style;
handles.analog.in.range=handles_saved.analog.in.range;
handles.analog.in.terminal_configuration=handles_saved.analog.in.terminal_configuration;
handles.digital.in.on=handles_saved.digital.in.on;
handles.digital.in.directory=handles_saved.digital.in.directory;
handles.digital.in.clock.port=handles_saved.digital.in.clock.port;
handles.digital.in.clock.terminal=handles_saved.digital.in.clock.terminal;
handles.digital.in.data.port=handles_saved.digital.in.data.port;
handles.digital.in.data.terminals=handles_saved.digital.in.data.terminals;
handles.digital.in.channel.port=handles_saved.digital.in.channel.port;
handles.digital.in.channel.terminals=handles_saved.digital.in.channel.terminals;
handles.digital.in.error.port=handles_saved.digital.in.error.port;
handles.digital.in.error.terminals=handles_saved.digital.in.error.terminals;
handles.digital.in.sync.port=handles_saved.digital.in.sync.port;
handles.digital.in.sync.terminals=handles_saved.digital.in.sync.terminals;
handles.hygrometer.on=handles_saved.hygrometer.on;
handles.hygrometer.save=handles_saved.hygrometer.save;
handles.hygrometer.directory=handles_saved.hygrometer.directory;
handles.hygrometer.object=handles_saved.hygrometer.object;
handles.hygrometer.period=handles_saved.hygrometer.period;
handles.hygrometer.clock=handles_saved.hygrometer.clock;
handles.hygrometer.linein=handles_saved.hygrometer.linein;
handles.hygrometer.lineout=handles_saved.hygrometer.lineout;
handles.portin=handles_saved.portin;
handles.portout=handles_saved.portout;
handles.video.on=handles_saved.video.on;
handles.video.maxn=handles_saved.video.maxn;
handles.video.n=handles_saved.video.n;
handles.video.curr=handles_saved.video.curr;
handles.video.save=handles_saved.video.save;
handles.video.directory=handles_saved.video.directory;
handles.video.preview=handles_saved.video.preview;
handles.video.adaptor=handles_saved.video.adaptor;
handles.video.devicename=handles_saved.video.devicename;
handles.video.deviceid=handles_saved.video.deviceid;
handles.video.formatlist=handles_saved.video.formatlist;
handles.video.formatvalue=handles_saved.video.formatvalue;
handles.video.ROI=handles_saved.video.ROI;
handles.video.FPS=handles_saved.video.FPS;
handles.video.trigger=handles_saved.video.trigger;
handles.video.ncounters=handles_saved.video.ncounters;
handles.video.counter=handles_saved.video.counter;
handles.video.compression=handles_saved.video.compression;
handles.video.pool=handles_saved.video.pool;
handles.running=0;
handles.filename=handles_saved.filename;
handles.timelimit=handles_saved.timelimit;


% ---
function update_figure(handles)

set(handles.AnalogOutOnOff,'value',handles.analog.out.on);
if(handles.analog.out.on && (handles.analog.out.maxn>0))
  set(handles.AnalogOutNumChannels,'string',handles.analog.out.n);
  set(handles.AnalogOutChannel,'string',[1:handles.analog.out.n]);
  set(handles.AnalogOutChannel,'value',handles.analog.out.curr);
  set(handles.AnalogOutRange,'value',handles.analog.out.range);
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
  switch(handles.analog.out.style)
    case 1
      set(handles.AnalogOutTimeSeries,'value',1);
    case 2
      set(handles.AnalogOutSpectrum,'value',1);
    case 3
      set(handles.AnalogOutEqualizer,'value',1);
  end
  set(handles.AnalogOutPlay,'enable','on');
  set(handles.AnalogOutFile,'enable','on');
  set(handles.AnalogOutNumChannels,'enable','on');
  set(handles.AnalogOutChannel,'enable','on');
  set(handles.AnalogOutTimeSeries,'enable','on');
  set(handles.AnalogOutSpectrum,'enable','on');
  set(handles.AnalogOutEqualizer,'enable','on');
  set(handles.AnalogOutXScale,'enable','on');
  set(handles.AnalogOutYScale,'enable','on');
else
  set(handles.AnalogOutPlay,'enable','off');
  set(handles.AnalogOutFile,'enable','off');
  set(handles.AnalogOutNumChannels,'enable','off');
  set(handles.AnalogOutChannel,'enable','off');
  set(handles.AnalogOutTimeSeries,'enable','off');
  set(handles.AnalogOutSpectrum,'enable','off');
  set(handles.AnalogOutEqualizer,'enable','off');
  set(handles.AnalogOutXScale,'enable','off');
  set(handles.AnalogOutYScale,'enable','off');
end

set(handles.AnalogInOnOff,'value',handles.analog.in.on);
if(handles.analog.in.on && (handles.analog.in.maxn>0))
  set(handles.AnalogInNumChannels,'string',handles.analog.in.n);
  set(handles.AnalogInChannel,'string',[1:handles.analog.in.n]);
  set(handles.AnalogInChannel,'value',handles.analog.in.curr);
  set(handles.AnalogInRange,'value',handles.analog.in.range);
  set(handles.AnalogInTerminalConfiguration,'value',handles.analog.in.terminal_configuration);
  set(handles.AnalogInDirectory,'string',handles.analog.in.directory);
  set(handles.AnalogInFs,'string',num2str(handles.analog.in.fs));
  if(handles.analog.in.record)
    set(handles.AnalogInDirectory,'enable','on');
    set(handles.AnalogInRecord,'value',1);
  else
    set(handles.AnalogInDirectory,'enable','off');
    set(handles.AnalogInRecord,'value',0);
  end
  switch(handles.analog.in.style)
    case 1
      set(handles.AnalogInTimeSeries,'value',1);
    case 2
      set(handles.AnalogInSpectrum,'value',1);
    case 3
      set(handles.AnalogInEqualizer,'value',1);
  end
  set(handles.AnalogInRecord,'enable','on');
  set(handles.AnalogInDirectory,'enable','on');
  set(handles.AnalogInNumChannels,'enable','on');
  set(handles.AnalogInChannel,'enable','on');
  set(handles.AnalogInTimeSeries,'enable','on');
  set(handles.AnalogInSpectrum,'enable','on');
  set(handles.AnalogInEqualizer,'enable','on');
  set(handles.AnalogInXScale,'enable','on');
  set(handles.AnalogInYScale,'enable','on');
else
  set(handles.AnalogInRecord,'enable','off');
  set(handles.AnalogInDirectory,'enable','off');
  set(handles.AnalogInNumChannels,'enable','off');
  set(handles.AnalogInChannel,'enable','off');
  set(handles.AnalogInTimeSeries,'enable','off');
  set(handles.AnalogInSpectrum,'enable','off');
  set(handles.AnalogInEqualizer,'enable','off');
  set(handles.AnalogInXScale,'enable','off');
  set(handles.AnalogInYScale,'enable','off');
end

set(handles.HygrometerOnOff,'value',handles.hygrometer.on);
if(handles.hygrometer.on)
  set(handles.HygrometerDirectory,'string',handles.hygrometer.directory);
  set(handles.HygrometerPeriod,'string',num2str(handles.hygrometer.period));
  set(handles.HygrometerSave,'enable','on');
  set(handles.HygrometerPeriod,'enable','on');
  if(handles.hygrometer.save)
    set(handles.HygrometerDirectory,'enable','on');
    set(handles.HygrometerSave,'value',1);
  else
    set(handles.HygrometerDirectory,'enable','off');
    set(handles.HygrometerSave,'value',0);
  end
else
  set(handles.HygrometerSave,'enable','off');
  set(handles.HygrometerPeriod,'enable','off');
end

set(handles.VideoOnOff,'value',handles.video.on);
if(handles.video.on && (handles.video.maxn>0))
  set(handles.VideoFPS,'string',handles.video.FPS);
  set(handles.VideoROI,'string',num2str(handles.video.ROI(handles.video.curr,:),'%d,%d,%d,%d'));
  set(handles.VideoNumChannels,'string',handles.video.n);
  set(handles.VideoChannel,'string',[1:handles.video.n]);
  set(handles.VideoChannel,'value',handles.video.curr);
  set(handles.VideoDirectory,'string',handles.video.directory(handles.video.curr));
  set(handles.VideoFormat,'string',handles.video.formatlist{handles.video.curr},...
      'value',handles.video.formatvalue(handles.video.curr));
  arrayfun(@(x) sprintf('trigger %d',x),0:(handles.video.ncounters-1),'uniformoutput',false);
  set(handles.VideoTrigger,'string',{'free running' ans{:}});
  set(handles.VideoTrigger,'value',handles.video.counter);
  if(handles.video.save(handles.video.curr))
    set(handles.VideoDirectory,'enable','on');
    set(handles.VideoSave,'value',1);
  else
    set(handles.VideoDirectory,'enable','off');
    set(handles.VideoSave,'value',0);
  end
  set(handles.VideoSave,'enable','on');
  set(handles.VideoFPS,'enable','on');
  set(handles.VideoNumChannels,'enable','on');
  set(handles.VideoChannel,'enable','on');
  set(handles.VideoPreview,'enable','on');
  set(handles.VideoFormat,'enable','on');
else
  set(handles.VideoSave,'enable','off');
  set(handles.VideoFPS,'enable','off');
  set(handles.VideoNumChannels,'enable','off');
  set(handles.VideoChannel,'enable','off');
  set(handles.VideoPreview,'enable','off');
  set(handles.VideoFormat,'enable','off');
end

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
function handles=configure_digital_input_channels(handles)

i=1;
while i<=length(handles.digital.session.Channels)
  if strcmp(class(handles.digital.session.Channels(i)),'daq.ni.DigitalInputVoltageChannel')
    handles.digital.session.removeChannel(i);
  else
    i=i+1;
  end
end

if(handles.digital.in.on)
  if((~isnan(handles.digital.in.clock.port)) && (~isnan(handles.digital.in.clock.terminal)))
    [~,handles.digital.in.clock.idx]=...
        handles.digital.session.addDigitalChannel(handles.daqdevices.ID,...
        ['port' num2str(handles.digital.in.clock.port) '/line' num2str(handles.digital.in.clock.terminal)],...
        'InputOnly');
  end
  if((~isnan(handles.digital.in.data.port)) && (~isnan(handles.digital.in.data.terminal)))
    for i=1:length(handles.digital.in.data.port)
      [~,handles.digital.in.data.idx(i)]=...
          handles.digital.session.addDigitalChannel(handles.daqdevices.ID,...
          ['port' num2str(handles.digital.in.data.port) '/line' num2str(handles.digital.in.data.terminal)],...
          'InputOnly');
    end
  end
  if((~isnan(handles.digital.in.channel.port)) && (~isnan(handles.digital.in.channel.terminal)))
    for i=1:length(handles.digital.in.channel.port)
      [~,handles.digital.in.channel.idx(i)]=...
          handles.digital.session.addDigitalChannel(handles.daqdevices.ID,...
          ['port' num2str(handles.digital.in.channel.port) '/line' num2str(handles.digital.in.channel.terminal)],...
          'InputOnly');
    end
  end
  if((~isnan(handles.digital.in.error.port)) && (~isnan(handles.digital.in.error.terminal)))
    for i=1:length(handles.digital.in.error.port)
      [~,handles.digital.in.error.idx(i)]=...
          handles.digital.session.addDigitalChannel(handles.daqdevices.ID,...
          ['port' num2str(handles.digital.in.error.port) '/line' num2str(handles.digital.in.error.terminal)],...
          'InputOnly');
    end
  end
  if((~isnan(handles.digital.in.sync.port)) && (~isnan(handles.digital.in.sync.terminal)))
    [~,handles.digital.in.sync.idx(i)]=...
        handles.digital.session.addDigitalChannel(handles.daqdevices.ID,...
        ['port' num2str(handles.digital.in.sync.port) '/line' num2str(handles.digital.in.sync.terminal)],...
        'InputOnly');
  end
end


% ---
function handles=configure_video_channels(handles)

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
  handles.video.trigger=handles.analog.session.addCounterOutputChannel(...
      handles.daqdevices.ID,handles.video.counter-2,'PulseGeneration');
  set(handles.video.trigger,'Frequency',handles.video.FPS);
end
 

% ---
function handles=configure_hygrometer(handles)

if(handles.hygrometer.on)
  handles.hygrometer.object=hygrometer(handles.daqdevices, handles.portout, handles.portin, ...
      handles.hygrometer.clock, handles.hygrometer.lineout, handles.hygrometer.linein);
  [T RH timeT timeRH]=handles.hygrometer.object.take;
  set(handles.HygrometerData,'string',[num2str(T,'%2.1f') 'C,' num2str(RH,2) '%']);
else
  if(~isempty(handles.hygrometer.object))
    handles.hygrometer.object.close;
  end
end

  
% --- Executes just before av_take is made visible.
function av_take_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to av_take (see VARARGIN)

% TODO
%   test with flycap2, crashed once after 10 min
%   implement equalizer
%   implement time limit
%   implement y/x-scales on analog
%   implement multiple channels of video
%   monitor video while recording?
%   hygrometer interuptible

handles.rcfilename = 'most_recent_config.mat';
if(exist(handles.rcfilename)==2)
  handles=load_configuration_file(handles.rcfilename,handles);
else
  handles=initialize(handles);
end

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

  handles.digital.session=daq.createSession('ni');
  handles=configure_digital_input_channels(handles);

  handles.hygrometer.period=max(handles.hygrometer.period,10);
  handles=configure_hygrometer(handles);

  idx=find(cellfun(@(x) strcmp(x,'CounterOutput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  handles.video.ncounters=handles.daqdevices.Subsystems(idx).NumberOfChannelsAvailable;
else
  set(handles.AnalogOutOnOff,'enable','off');
  set(handles.AnalogInOnOff,'enable','off');
  set(handles.HygrometerOnOff,'enable','off');
end

if(isfield(handles,'videoadaptors'))
  tmp=[];
  maxn=0;  adaptor={};  deviceid=[];  devicename={};  formatlist={};
  for i=handles.videoadaptors.InstalledAdaptors
    info=imaqhwinfo(char(i));
    if(~isempty(info.DeviceIDs))
      tmp=length(info.DeviceIDs);
      maxn=maxn+tmp;
      adaptor=[adaptor repmat(i,1,tmp)];
      deviceid=[deviceid info.DeviceIDs{:}];
      devicename=[devicename {info.DeviceInfo.DeviceName}];
      formatlist={formatlist{:} info.DeviceInfo.SupportedFormats};
    end
  end
  if((handles.video.maxn~=maxn) || ~isequal(handles.video.adaptor,adaptor) || ...
        ~isequal(handles.video.deviceid,deviceid) || ~isequal(handles.video.devicename,devicename) || ...
        ~isequal(handles.video.formatlist,formatlist))
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
    handles.video.ROI=repmat([0 0 640 480],maxn,1);
    handles.video.FPS=1;
    c=parcluster;
    handles.video.pool=c.NumWorkers-1;
  end
  handles=configure_video_channels(handles);
else
  set(handles.VideoOnOff,'enable','off');
end

set(handles.StartStop,'string','start','backgroundColor',[0 1 0]);
delete(timerfind);

% javaaddpath('javasysmon-0.3.4.jar');
% import com.jezhumble.javasysmon.JavaSysMon.*
% handles.system_monitor.object=com.jezhumble.javasysmon.JavaSysMon();
% handles.system_monitor.timer=timer('Name','system_monitor','Period',1,'ExecutionMode','fixedRate',...
%     'TimerFcn',@(hObject,eventdata)system_monitor_callback(hObject,eventdata,handles));
% warning('off','MATLAB:Java:ConvertFromOpaque');
% start(handles.system_monitor.timer);

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

next_cpu=handles.system_monitor.object.cpuTimes();
mem=handles.system_monitor.object.physical();
if(~isempty(last_cpu))
  %disp(['cpu: ' num2str(last_cpu.getCpuUsage(next_cpu)) ', mem=' num2str(mem.getFreeBytes()/mem.getTotalBytes())]);
  set(handles.SystemMonitor,'string',[num2str(round(100*last_cpu.getCpuUsage(next_cpu))) '% cpu, ' ...
      num2str(round(100*(mem.getTotalBytes()-mem.getFreeBytes())/mem.getTotalBytes())) '% mem']);
  drawnow
end
last_cpu=next_cpu;


% ---
function figure_CloseRequestFcn(hObject, eventdata)

handles=guidata(hObject);

% stop(handles.system_monitor.timer);
% delete(handles.system_monitor.timer);
% handles.system_monitor=[];

if(isfield(handles,'daqdevices'))
  if(handles.running)
    uiwait(errordlg('please stop the recording first'));
    return;
  end
  delete(handles.analog.session);
  delete(handles.digital.session);
  if(~isempty(handles.hygrometer.object))
    handles.hygrometer.object.close;
  end
  handles.daqdevices=[];  handles.analog.session=[];  handles.digital.session=[];  handles.listener1=[];
  handles.analog.out.ranges_available=[];
  handles.analog.in.ranges_available=[];
  handles.analog.in.terminal_configuration_available=[];
  handles.hygrometer.object=[];  handles.video.input=[];  handles.video.trigger=[];
  handles.timer=[];
  save(handles.rcfilename,'handles');
end
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
function analog_out_callback(src,evt,hObject)

handles=guidata(hObject);

for i=1:handles.analog.out.n
  if(handles.analog.out.play(i))
    tmp=handles.analog.out.idx(i)+handles.analog.out.fs(i)-1;
    idx=min(tmp,length(handles.analog.out.y{i}));
    idx2=tmp-idx;
    out(:,i)=[handles.analog.out.y{i}(handles.analog.out.idx(i):idx); handles.analog.out.y{i}(1:idx2)];
    handles.analog.out.idx(i)=idx2+1;
    if(idx2==0)
      handles.analog.out.idx(i)=idx+1;
    end
  else
    out(:,i)=zeros(max(1024,max(handles.analog.out.fs)),1); 
  end
  if(i==handles.analog.out.curr)
    switch(handles.analog.out.style)
      case 1
        plot(handles.AnalogOutPlot,out(:,i),'k-');
      case 2
        [pxx f]=pwelch(out(:,i)',[],[],[],handles.analog.fs);
        plot(handles.AnalogOutPlot,f,20*log10(pxx),'k-');
      case 3
    end
    axis(handles.AnalogOutPlot,'tight');
    axis(handles.AnalogOutPlot,'off');
  end
end

handles.analog.session.queueOutputData(out);

guidata(hObject, handles);


% --- 
function analog_in_callback(src,evt,hObject)

persistent last_timestamp

handles=guidata(hObject);

if(handles.analog.in.record)
  fwrite(handles.analog.in.fid,evt.Data,'double');
end

if(~isempty(last_timestamp))
  tmp=round((evt.TimeStamps(1)-last_timestamp)*handles.analog.in.fs);
  if(tmp~=1)
    disp(['warning:  skipped ' num2str(tmp) ' analog input samples']);
  end
end
last_timestamp=evt.TimeStamps(end);

plot(handles.AnalogInPlot,evt.Data(:,handles.analog.in.curr),'k-');
%axis(handles.AnalogInPlot,'tight');
%axis(handles.AnalogInPlot,'off');


% --- 
function digital_in_callback(src,evt,hObject)

persistent last_timestamp

handles=guidata(hObject);

if(handles.digital.in.record)
  tmp=evt.Data(:,[handles.digital.in.data.idx handles.digital.in.channel.idx ...
        handles.digital.in.error.idx handles.digital.in.sync.idx]);
  tmp=uint16(binaryVectorToDecimal(tmp));
  fwrite(handles.digital.in.fid,tmp,'uint16');
end

%if(~isempty(last_timestamp))
%  tmp=round((evt.TimeStamps(1)-last_timestamp)*handles.analog.in.fs);
%  if(tmp~=1)
%    disp(['warning:  skipped ' num2str(tmp) ' analog input samples']);
%  end
%end
%last_timestamp=evt.TimeStamps(end);

binaryVectorToDecimal(evt.Data(:,[handles.digital.in.channel.idx]));
find(ans==handles.digital.in.curr);
binaryVectorToDecimal(evt.Data(ans,[handles.digital.in.data.idx]));
plot(handles.DigitalInPlot,ans,'k-');
%axis(handles.AnalogInPlot,'tight');
%axis(handles.AnalogInPlot,'off');

handles.digital.in.error1=handles.digital.in.error1+sum(evt.Data(:,handles.digital.in.error.idx(1)));
set(handles.DigitalInError1,'string',num2str(handles.digital.in.error1));
handles.digital.in.error2=handles.digital.in.error2+sum(evt.Data(:,handles.digital.in.error.idx(2)));
set(handles.DigitalInError2,'string',num2str(handles.digital.in.error2));


% ---
function hygrometer_callback(src,evt,handles)

fc=get(handles.HygrometerData,'foregroundcolor');
bc=get(handles.HygrometerData,'backgroundcolor');
set(handles.HygrometerData,'foregroundcolor',bc);
set(handles.HygrometerData,'backgroundcolor',fc);
drawnow;

[T RH timeT timeRH]=handles.hygrometer.object.take;

set(handles.HygrometerData,'string',[num2str(T,'%2.1f') 'C,' num2str(RH,2) '%']);

if(handles.hygrometer.save)
  fprintf(handles.hygrometer.fid,'%f ',etime(clock,datevec(timeT)));
  fprintf(handles.hygrometer.fid,'%f ',T);
  fprintf(handles.hygrometer.fid,'%f ',RH);
  fprintf(handles.hygrometer.fid,'\n');
end

set(handles.HygrometerData,'foregroundcolor',fc);
set(handles.HygrometerData,'backgroundcolor',bc);
drawnow;


% ---
function video_callback(src,evt,vi,M1,M,save,directory,filename,chan,pool)

persistent time0

tic;
%if M1.Data(1)==0  return;  end

try
  [data time metadata]=getdata(vi,pool);
catch
  [data time metadata]=getdata(vi);
end

if(~isempty(time0))
  M.Data(2)=length(time)/(time(end)-time0);
end
time0=time(end);

if(save)
  parfor i=1:size(data,4)
    if(isempty(chan))
      tmp=fullfile(directory,filename,[num2str(metadata(i).FrameNumber) '.jpg']);
    else
      tmp=fullfile(directory,filename,num2str(chan),[num2str(metadata(i).FrameNumber) '.jpg']);
    end
    imwrite(data(:,:,:,i),tmp,'jpg');
  end
end

M.Data(3)=pool/toc;
M.Data(4)=metadata(end).FrameNumber;


% ---
function video_thread(n,mfile,adaptor,deviceid,formatlist,formatvalue,ROI,...
    save,directory,filename,pool,counter)

imaqmem(1e10);

% continue/stop, video.n * (frames available, FPS achieved, FPS processed, most recent frame #)
M{1} = memmapfile(mfile, 'Writable', true, 'Format', 'double', 'Repeat', 1);
for i=1:n
  if(~save(i))  continue;  end
  M{1+i} = memmapfile(mfile, 'Writable', true, 'Format', 'double', 'Repeat', 4, 'Offset', 8*(1+4*(i-1)));

  vi{i}=videoinput(adaptor{i},deviceid(i),formatlist{i}{formatvalue(i)});
  if(~isempty(ROI))
    set(vi{i},'ROIPosition',ROI(i,:));
  end
  if(counter>1)
    set(vi{i},'FramesPerTrigger',1,'TriggerRepeat',inf);
    triggerconfig(vi{i}, 'hardware', 'fallingEdge', 'externalTriggerMode0-Source0');
  else
    set(vi{i},'FramesPerTrigger',inf,'TriggerRepeat',1);
    triggerconfig(vi{i}, 'immediate', 'none', 'none');
  end

  set(vi{i},'FrameGrabInterval',1);
  chan=[];  if(sum(save)>1)  chan=i;  end
  set(vi{i},'FramesAcquiredFcnCount',pool,...
      'FramesAcquiredFcn',@(hObject,eventdata)video_callback(hObject,eventdata,...
      vi{i},M{1},M{1+i},save(i),directory{i},filename,chan,pool));
  set(vi{i},'LoggingMode','memory','DiskLogger',[]);
  %if(handles.video.save)
  %  vifile=VideoWriter(fullfile(handles.video.directory,[handles.filename '.avi']), ...
  %      handles.video.compression);
  %  set(vifile,'FrameRate',handles.video.FPS);
  %  set(handles.video.input,'LoggingMode','disk&memory','DiskLogger',vifile);
  %else
  %end
end

start([vi{:}]);
%trigger(vi);
M{1}.Data(1)=1;

while M{1}.Data(1)
  pause(0.1);
  for i=1:n
    if(~save(i))  continue;  end
    M{1+i}.Data(1)=get(vi{i},'FramesAvailable');
    disp(M{1+i}.Data(1));
  end
end

stop([vi{:}]);

flag=true;
while flag
  flag=false;
  for i=1:n
    if(~save(i))  continue;  end
    M{1+i}.Data(1)=get(vi{i},'FramesAvailable');
    if(M{1+i}.Data(1)>0)
      flag=true;
      video_callback([],[],vi{i},M{1},M{1+i},save(i),directory{i},filename,chan,pool)
    end
  end
end

delete([vi{:}]);
M=[];


% ---
function display_callback(src,evt,handles)

if(isfield(handles,'triggertime'))
  set(handles.TimeElapsed,'string',[num2str(round(etime(clock,handles.triggertime))) 's']);
end

if(handles.analog.out.on)
  set(handles.AnalogOutBuffer,'string',num2str(handles.analog.session.ScansQueued));
end

%if(handles.video.on && isfield(handles.video,'M') && (~isempty(handles.video.M)))
nsave=sum(handles.video.save);
if(handles.video.on && (nsave>0) && ...
      isfield(handles.video,'M') && ~isempty(handles.video.M) && (handles.video.M{1+handles.video.curr}.Data(4)>0))
  set(handles.VideoFramesAvailable,'string',num2str(handles.video.M{1+handles.video.curr}.Data(1)));
  set(handles.VideoFPSAchieved,'string',num2str(round(handles.video.M{1+handles.video.curr}.Data(2))));
  set(handles.VideoFPSProcessed,'string',num2str(round(handles.video.M{1+handles.video.curr}.Data(3))));
  if(nsave>1)
    imread(fullfile(handles.video.directory{handles.video.curr},handles.filename,...
        num2str(handles.video.curr),[num2str(handles.video.M{1+handles.video.curr}.Data(4)) '.jpg']));
  else
    imread(fullfile(handles.video.directory{handles.video.curr},handles.filename,...
        [num2str(handles.video.M{1+handles.video.curr}.Data(4)) '.jpg']));
  end
  image(ans,'parent',handles.video.ha);
  axis(handles.video.ha,'off');
  axis(handles.video.ha,'image');
end

drawnow('expose')


% --- Executes on button press in StartStop.
function StartStop_Callback(hObject, eventdata, handles)
% hObject    handle to StartStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.StartStop,'enable','off');  drawnow;

if(~handles.running)
  if(sum(handles.analog.out.play)>0)
    if(sum(diff([handles.analog.out.fs(logical([handles.analog.out.play]))]))>0)
      uiwait(errordlg('analog output sampling rates must be equal'));
      set(handles.StartStop,'enable','on');  drawnow;
      return;
    end
  end
  if((sum(handles.analog.out.play)>0) && handles.analog.in.record)
    find([handles.analog.out.play],1,'first');
    if(handles.analog.out.fs(ans) ~= handles.analog.in.fs)
      uiwait(warndlg('analog input and output sampling rate must be equal'));
      set(handles.StartStop,'enable','on');  drawnow;
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
  
  if(isnan(rate) || isempty(rate) || (rate<1))
    uiwait(errordlg('sampling rate must be a positive integer'));
    set(handles.StartStop,'enable','on');  drawnow;
    return;
  else
    handles.analog.session.Rate=rate;
  end

  handles.running=1;
  set(handles.StartStop,'string','stop','backgroundColor',[1 0 0]);
  set(handles.AnalogOutOnOff,'enable','off');
  set(handles.AnalogOutPlay,'enable','off');
  set(handles.AnalogOutNumChannels,'enable','off');
  set(handles.AnalogOutRange,'enable','off');
  set(handles.AnalogInOnOff,'enable','off');
  set(handles.AnalogInRecord,'enable','off');
  set(handles.AnalogInNumChannels,'enable','off');
  set(handles.AnalogInFs,'enable','off');
  set(handles.AnalogInRange,'enable','off');
  set(handles.AnalogInTerminalConfiguration,'enable','off');
  set(handles.HygrometerOnOff,'enable','off');
  set(handles.HygrometerSave,'enable','off');
  set(handles.HygrometerPeriod,'enable','off');
  set(handles.VideoOnOff,'enable','off');
  set(handles.VideoSave,'enable','off');
  set(handles.VideoFormat,'enable','off');
  set(handles.VideoROI,'enable','off');
  set(handles.VideoFPS,'enable','off');
  set(handles.VideoNumChannels,'enable','off');
  set(handles.VideoPreview,'enable','off');

  handles.analog.session.IsContinuous=true;

  if(handles.analog.out.on)
    handles.analog.out.idx(logical(handles.analog.out.play))=1;
    guidata(hObject, handles);
    for(i=1:5)  analog_out_callback(hObject, eventdata, handles.figure1);  end
    handles=guidata(hObject);
    handles.analog.session.NotifyWhenScansQueuedBelow=5*round(handles.analog.session.Rate);
    handles.listenerAnalogOut=handles.analog.session.addlistener('DataRequired',...
        @(hObject,eventdata)analog_out_callback(hObject,eventdata,handles.figure1));
  end

  if(handles.analog.in.on)
    clear analog_in_callback
    handles.analog.in.fid = nan;
    if(handles.analog.in.record)
      handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename '.bin']),'w');
      % version#, sample rate, nchan
      fwrite(handles.analog.in.fid,[1 handles.analog.in.fs handles.analog.in.n],'double');
    end
    handles.listenerAnalogIn=handles.analog.session.addlistener('DataAvailable',...
        @(hObject,eventdata)analog_in_callback(hObject,eventdata,handles.figure1));
  end

  if(handles.digital.in.on)
    handles.digital.in.fid = nan;
    if(handles.digital.in.record)
      handles.digital.in.fid = fopen(fullfile(handles.digital.in.directory,[handles.filename '.bin']),'w');
      %version#, sample rate, nchan
      %fwrite(handles.digital.in.fid,[1 handles.analog.in.fs handles.analog.in.n],'double');
    end
    handles.digital.in.error1=0;
    handles.digital.in.error2=0;
    handles.listenerDigitalIn=handles.digital.session.addlistener('DataAvailable',...
        @(hObject,eventdata)digital_in_callback(hObject,eventdata,handles.figure1));
  end

  if(handles.hygrometer.on)
    handles.hygrometer.fid=nan;
    if(handles.hygrometer.save)
      handles.hygrometer.fid=fopen(fullfile(handles.hygrometer.directory,[handles.filename '.hyg']),'w');
    end
    handles.hygrometer.timer=timer('Name','hygrometer','Period',handles.hygrometer.period,'ExecutionMode','fixedRate',...
        'TimerFcn',@(hObject,eventdata)hygrometer_callback(hObject,eventdata,handles));
    start(handles.hygrometer.timer);
  end

  nsave=sum(handles.video.save);
  if(handles.video.on && (nsave>0))
    handles.video.mfile = tempname;
    handles.video.hf = figure('position',handles.video.ROI(handles.video.curr,:));
    handles.video.ha = subplot('position',[0 0 1 1],'parent',handles.video.hf);
    colormap(handles.video.ha,gray(256));
    fid=fopen(handles.video.mfile,'w');  fwrite(fid,zeros(1,1+4*handles.video.n),'double');  fclose(fid);
    handles.video.M{1} = memmapfile(handles.video.mfile, 'Writable', true, 'Format', 'double', 'Repeat', 1);
    for i=1:handles.video.n
      if(~handles.video.save(i))  continue;  end
      if(nsave==1)
        mkdir(fullfile(handles.video.directory{i},handles.filename));
      else
        mkdir(fullfile(handles.video.directory{i},handles.filename,num2str(i)));
      end
      handles.video.M{1+i} = memmapfile(handles.video.mfile, 'Writable', true, 'Format', 'double', ...
          'Repeat', 4, 'Offset', 8*(1+4*(i-1)));
    end
    handles.video.thread=batch(@video_thread,0,...
        {handles.video.n, handles.video.mfile, handles.video.adaptor, handles.video.deviceid,...
         handles.video.formatlist, handles.video.formatvalue, handles.video.ROI,...
         handles.video.save, handles.video.directory, handles.filename, handles.video.pool, ...
         handles.video.counter},...
        'matlabpool',handles.video.pool);
    disp('waiting for batch job to start...');
    while handles.video.M{1}.Data(1)==0  pause(1);  end
    disp('batch job has started');
  end

  guidata(hObject, handles);

  if(handles.digital.in.on)
    handles.digital.session.startBackground;
  end
  if(handles.analog.out.on || handles.analog.in.on || handles.video.on)
    handles.analog.session.startBackground;
  end
  handles.triggertime=clock;
  
  handles.timer.update_display=timer('Name','update display','Period',1,'ExecutionMode','fixedRate',...
      'TimerFcn',@(hObject,eventdata)display_callback(hObject,eventdata,handles));
  start(handles.timer.update_display);

  guidata(hObject, handles);

%   tmp=handles.timelimit;
%   if(tmp>0)
%     handles.timer.auto_turn_off.=timer('Name','auto turn off','startDelay',60*tmp,'ExecutionMode','singleShot',...
%         'TimerFcn',@OnOff_Callback);
%     start(handles.timer.auto_turn_off);
%   end

elseif(handles.running)
  handles.analog.session.stop();

  if(handles.analog.out.on)
    delete(handles.listenerAnalogOut);
  end
  
  if(handles.analog.in.on)
    delete(handles.listenerAnalogIn);
    if(handles.analog.in.record)
      fclose(handles.analog.in.fid);
    end
  end

  if(handles.digital.in.on)
    delete(handles.listenerDigitalIn);
    if(handles.digital.in.record)
      fclose(handles.digital.in.fid);
    end
  end

  if(handles.hygrometer.on)
    stop(handles.hygrometer.timer);
    delete(handles.hygrometer.timer);
    if(handles.hygrometer.save)
      fclose(handles.hygrometer.fid);
    end
  end

  if(handles.video.on && (sum(handles.video.save)>0))
    handles.video.M{1}.Data(1)=0;
    while(sum(cellfun(@(x) x.Data(1),handles.video.M(2:end)))>0)  pause(1);  end
    wait(handles.video.thread);
%    diary(handles.video.thread)
    delete(handles.video.thread);
    handles.video.M=[];
    close(handles.video.hf);
    delete(handles.video.mfile);   % throws error b/c M is not released
    %while(handles.video.input.DiskLoggerFrameCount~=handles.video.input.FramesAcquired)
    %  pause(1);
    %end
    %close(handles.vi.DiskLogger);
%    vw=VideoWriter(fullfile(handles.video.directory,[handles.filename '.avi']), ...
%        handles.video.compression);
%    open(vw);
%    list=dir(fullfile(handles.video.directory,[handles.filename '*.jpg']));
%    for i=1:length(list)
%      imread(fullfile(handles.video.directory,list(i).name),'jpg');
%      writeVideo(vw,ans);
%    end
%    close(vw);
  end

  if(isvalid(handles.timer.update_display))
    stop(handles.timer.update_display);
    delete(handles.timer.update_display);
  end

%   if(isvalid(handles.timer.auto_turn_off))
%     stop(handles.timer.auto_turn_off);
%     delete(handles.timer.auto_turn_off);
%   end

  handles.analog.session.IsContinuous=false;

  set(handles.StartStop,'string','start','backgroundColor',[0 1 0]);
  set(handles.AnalogOutOnOff,'enable','on');
  set(handles.AnalogOutPlay,'enable','on');
  set(handles.AnalogOutNumChannels,'enable','on');
  set(handles.AnalogOutRange,'enable','on');
  set(handles.AnalogInOnOff,'enable','on');
  set(handles.AnalogInRecord,'enable','on');
  set(handles.AnalogInNumChannels,'enable','on');
  set(handles.AnalogInFs,'enable','on');
  set(handles.AnalogInRange,'enable','on');
  set(handles.AnalogInTerminalConfiguration,'enable','on');
  set(handles.HygrometerOnOff,'enable','on');
  set(handles.HygrometerSave,'enable','on');
  set(handles.HygrometerPeriod,'enable','on');
  set(handles.VideoOnOff,'enable','on');
  set(handles.VideoSave,'enable','on');
  set(handles.VideoFormat,'enable','on');
  set(handles.VideoROI,'enable','on');
  set(handles.VideoFPS,'enable','on');
  set(handles.VideoNumChannels,'enable','on');
  set(handles.VideoPreview,'enable','on');

  handles.running=0;
end

guidata(hObject, handles);

set(handles.StartStop,'enable','on');  %drawnow;


function TimeLimit_Callback(hObject, eventdata, handles)
% hObject    handle to TimeLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeLimit as text
%        str2double(get(hObject,'String')) returns contents of TimeLimit as a double

handles.timelimit=str2num(get(handles.TimeLimit,'string'));


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
function MenuFile_Callback(hObject, eventdata, handles)
% hObject    handle to MenuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenuFileLoad_Callback(hObject, eventdata, handles)
% hObject    handle to MenuFileLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path]=uigetfile('*.mat','Select configuration file to open');
if(isnumeric(file) && isnumeric(path) && (file==0) && (path==0))  return;  end
handles=load_configuration_file(fullfile(path,file),handles);
update_figure(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function MenuFileSave_Callback(hObject, eventdata, handles)
% hObject    handle to MenuFileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path]=uiputfile('*.mat','Select file to save configuration to');
if(isnumeric(file) && isnumeric(path) && (file==0) && (path==0))  return;  end
save(fullfile(path,file),'handles');


% --------------------------------------------------------------------
function MenuFileReset_Callback(hObject, eventdata, handles)
% hObject    handle to MenuFileReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

questdlg('Reset configuration to default?','','Yes','No','No');
if(strcmp(ans,'No'))  return;  end
handles=initialize(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


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

handles.analog.out.curr=get(handles.AnalogOutChannel,'value');
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
function AnalogOutYScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutYScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function AnalogOutYScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutYScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AnalogOutXScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutXScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function AnalogOutXScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutXScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected object is changed in AnalogOutStyle.
function AnalogOutStyle_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in AnalogOutStyle 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch hObject
  case handles.AnalogOutTimeSeries
    handles.analog.out.style=1;
  case handles.AnalogOutSpectrum
    handles.analog.out.style=2;
  case handles.AnalogOutEqualizer
    handles.analog.out.style=3;
end

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
function AnalogInStyle_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in AnalogInStyle 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch hObject
  case handles.AnalogInTimeSeries
    handles.analog.in.style=1;
  case handles.AnalogInSpectrum
    handles.analog.in.style=2;
  case handles.AnalogInEqualizer
    handles.analog.in.style=3;
end

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
function AnalogInYScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInYScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function AnalogInYScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInYScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function AnalogInXScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInXScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function AnalogInXScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInXScale (see GCBO)
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
  directory=uigetdir(directory,'Select analog input directory');
  if(directory~=0)
    handles.analog.in.record=1;
    handles.analog.in.directory=directory;
    set(handles.AnalogInDirectory,'string',handles.analog.in.directory,'enable','on');
  else
    set(handles.AnalogInRecord,'value',0);
  end
else
  handles.analog.in.record=0;
  set(handles.AnalogInDirectory,'enable','off');
end

guidata(hObject,handles);


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


% --- Executes on button press in DigitalInOnOff.
function DigitalInOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalInOnOff

handles.digital.in.on=~handles.digital.in.on;
handles=configure_digital_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function DigitalInError2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInError2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function DigitalInFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function DigitalInXScale_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInXScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function DigitalInXScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInXScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function DigitalInYScale_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInYScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function DigitalInYScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInYScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in DigitalInChannel.
function DigitalInChannel_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DigitalInChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DigitalInChannel

handles.digital.in.curr=get(handles.DigitalInChannel,'value');
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DigitalInChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DigitalInRecord.
function DigitalInRecord_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalInRecord

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);

if(get(handles.DigitalInRecord,'value'))
  directory=uigetdir(directory,'Select digital input directory');
  if(directory~=0)
    handles.digital.in.record=1;
    handles.digital.in.directory=directory;
    set(handles.DigitalInDirectory,'string',handles.digital.in.directory,'enable','on');
  else
    set(handles.DigitalInRecord,'value',0);
  end
else
  handles.digital.in.record=0;
  set(handles.DigitalInDirectory,'enable','off');
end

guidata(hObject,handles);


function DigitalInClock_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInClock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInClock as text
%        str2double(get(hObject,'String')) returns contents of DigitalInClock as a double

tmp=sscanf(get(hObject,'String'),'%d.%d');
handles.digital.clock.port=tmp(1);
handles.digital.clock.terminal=tmp(2);
handles=configure_digital_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DigitalInClock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInClock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DigitalInData_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInData as text
%        str2double(get(hObject,'String')) returns contents of DigitalInData as a double

tmp=sscanf(get(hObject,'String'),'%d.%d-%d');
handles.digital.data.terminals=tmp(2):tmp(3);
handles.digital.data.port=repmat(tmp(1),1,length(handles.digital.data.terminals));;
handles=configure_digital_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DigitalInData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DigitalInAddress_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInAddress as text
%        str2double(get(hObject,'String')) returns contents of DigitalInAddress as a double

tmp=sscanf(get(hObject,'String'),'%d.%d-%d');
handles.digital.address.terminals=tmp(2):tmp(3);
handles.digital.address.port=repmat(tmp(1),1,length(handles.digital.address.terminals));;
handles=configure_digital_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DigitalInAddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInAddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DigitalInError_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInError as text
%        str2double(get(hObject,'String')) returns contents of DigitalInError as a double

tmp=sscanf(get(hObject,'String'),'%d.%d-%d');
handles.digital.error.terminals=tmp(2):tmp(3);
handles.digital.error.port=repmat(tmp(1),1,length(handles.digital.error.terminals));;
handles=configure_digital_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DigitalInError_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DigitalInSync_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInSync as text
%        str2double(get(hObject,'String')) returns contents of DigitalInSync as a double

tmp=sscanf(get(hObject,'String'),'%d.%d');
handles.digital.sync.port=tmp(1);
handles.digital.sync.terminal=tmp(2);
handles=configure_digital_input_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DigitalInSync_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in HygrometerOnOff.
function HygrometerOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to HygrometerOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HygrometerOnOff

handles.hygrometer.on=~handles.hygrometer.on;
handles=configure_hygrometer(handles);
update_figure(handles);
guidata(hObject, handles);


function HygrometerPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to HygrometerPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HygrometerPeriod as text
%        str2double(get(hObject,'String')) returns contents of HygrometerPeriod as a double

handles.hygrometer.period=str2num(get(hObject,'String'));
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function HygrometerPeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HygrometerPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in HygrometerSave.
function HygrometerSave_Callback(hObject, eventdata, handles)
% hObject    handle to HygrometerSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HygrometerSave

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);
if(get(handles.HygrometerSave,'value'))
  directory=uigetdir(directory,'Select hygrometer directory');
  if(directory~=0)
    handles.hygrometer.save=1;
    handles.hygrometer.directory=directory;
    set(handles.HygrometerDirectory,'string',handles.hygrometer.directory);
    set(handles.HygrometerDirectory,'enable','on');
  else
    set(handles.HygrometerSave,'value',0);
  end
else
  handles.hygrometer.save=0;
  set(handles.HygrometerDirectory,'enable','off');
end
guidata(hObject,handles);


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
function VideoSave_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSave

persistent directory2
if(isempty(directory2))  directory2=pwd;  end

handles=guidata(hObject);
if(get(handles.VideoSave,'value'))
  directory2=uigetdir(directory2,'Select video directory');
  if(directory2~=0)
    handles.video.save(handles.video.curr)=1;
    handles.video.directory{handles.video.curr}=directory2;
    set(handles.VideoDirectory,'string',handles.video.directory{handles.video.curr});
    set(handles.VideoDirectory,'enable','on');
  else
    set(handles.VideoSave,'value',0);
  end
else
  handles.video.save(handles.video.curr)=0;
  set(handles.VideoDirectory,'enable','off');
end
guidata(hObject,handles);



% --- Executes on selection change in VideoFormat.
function VideoFormat_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoFormat

handles.video.formatvalue(handles.video.curr)=get(handles.VideoFormat,'value');
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



function VideoROI_Callback(hObject, eventdata, handles)
% hObject    handle to VideoROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoROI as text
%        str2double(get(hObject,'String')) returns contents of VideoROI as a double

handles.video.ROI(handles.video.curr,:)=str2num(get(hObject,'String'));
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


% --- Executes on selection change in VideoChannel.
function VideoChannel_Callback(hObject, eventdata, handles)
% hObject    handle to VideoChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoChannel

handles.video.curr=get(handles.VideoChannel,'value');
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


% ---
function set_videopreview(handles)

persistent vi

if(handles.video.preview)
  set(handles.StartStop,'enable','off');  drawnow;
  vi=videoinput(handles.video.adaptor{handles.video.curr},handles.video.deviceid(handles.video.curr),...
      handles.video.formatlist{handles.video.curr}{handles.video.formatvalue(handles.video.curr)});
  if(~isempty(handles.video.ROI))
    set(vi,'ROIPosition',handles.video.ROI(handles.video.curr,:));
  end
  preview(vi);
else
  if(~isempty(vi) && isvalid(vi))
    stoppreview(vi);
    delete(vi);
  end
  set(handles.StartStop,'enable','on');  drawnow;
end


% --- Executes on button press in VideoPreview.
function VideoPreview_Callback(hObject, eventdata, handles)
% hObject    handle to VideoPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoPreview

handles.video.preview=~handles.video.preview;
set_videopreview(handles);
guidata(hObject, handles);


% --- Executes on button press in VideoTrigger.
function VideoTrigger_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoTrigger

handles.video.counter=get(handles.VideoTrigger,'value');
handles=configure_video_channels(handles);
update_figure(handles);
guidata(hObject, handles);
