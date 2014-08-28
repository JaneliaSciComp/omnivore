function varargout = omnivore(varargin)
% OMNIVORE MATLAB code for omnivore.fig
%      OMNIVORE, by itself, creates a new OMNIVORE or raises the existing
%      singleton*.
%
%      H = OMNIVORE returns the handle to a new OMNIVORE or the handle to
%      the existing singleton*.
%
%      OMNIVORE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OMNIVORE.M with the given input arguments.
%
%      OMNIVORE('Property','Value',...) creates a new OMNIVORE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before omnivore_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to omnivore_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help omnivore

% Last Modified by GUIDE v2.5 12-Aug-2014 16:11:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @omnivore_OpeningFcn, ...
                   'gui_OutputFcn',  @omnivore_OutputFcn, ...
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


% --- Executes just before omnivore is made visible.
function omnivore_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to omnivore (see VARARGIN)

handles.rcfilename = 'most_recent_omnivore_config.mat';
if(exist(handles.rcfilename)==2)
  handles=load_config_file(handles.rcfilename,handles);
else
  handles=initialize(handles);
end
update_figure(handles,false);

[s,handles.git]=system('"c:\\Program Files (x86)\Git\bin\git" log -1 --pretty=format:"%ci %H"');
if s
    warning('cant''t find git.  to save version info, git-bash must be installed.');
end

handles.configure_analog_input_channels = @configure_analog_input_channels;
handles.configure_analog_output_channels = @configure_analog_output_channels;
handles.configure_digital_channels = @configure_digital_channels;
handles.configure_video_channels = @configure_video_channels;
handles.get_video_params = @get_video_params;
handles.set_video_param = @set_video_param;
handles.update_figure = @update_figure;
handles.video_setup_preview = @video_setup_preview;
handles.video_takedown_preview = @video_takedown_preview;
guidata(hObject, handles);

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

update_figure(handles,true);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = omnivore_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

handles=guidata(hObject);

stop(handles.system_monitor.timer);
delete(handles.system_monitor.timer);
handles.system_monitor=[];

if(handles.running)
  if(strcmp('no',questdlg('a recording is in progress.  force quit?','','yes','no','no')))
    return;
  end
end
save_config_file(handles,handles.rcfilename);

if(isfield(handles,'analogGui'))
  delete(handles.analogGui);
end
if(isfield(handles,'digitalGui'))
  delete(handles.digitalGui);
end
if(isfield(handles,'videoGui'))
  delete(handles.videoGui);
end
delete(hObject);


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_figure(handles,false);
persistent directory
if isempty(directory)  directory=pwd;  end

[file,directory]=uigetfile(fullfile(directory,'*.mat'),'Select configuration file to open');
if(isnumeric(file) && isnumeric(directory) && (file==0) && (directory==0))  return;  end
handles=load_config_file(fullfile(directory,file),handles);
handles=configure_analog_output_channels(handles);
handles=configure_analog_input_channels(handles);
handles=configure_digital_channels(handles);
handles=configure_video_channels(handles);
update_figure(handles,true);
guidata(hObject, handles);


% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

persistent directory
if isempty(directory)  directory=pwd;  end

[file,directory]=uiputfile(fullfile(directory,'*.mat'),'Select file to save configuration to');
if(isnumeric(file) && isnumeric(directory) && (file==0) && (directory==0))  return;  end
save_config_file(handles,fullfile(directory,file));


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_figure(handles,false);
questdlg('Reset configuration to default?','','Yes','No','No');
if(strcmp(ans,'No'))  return;  end
handles=initialize(handles);
handles=query_hardware(handles);
update_figure(handles,true);
guidata(hObject, handles);


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
  handles.filename=datestr(now,30);
  if isfield(handles,'session')
    rate=handles.samplingrate;
  else
    rate=handles.video.FPS;
  end
  
  if(handles.analog.out.on || handles.analog.in.on || ...
         handles.digital.out.on || handles.digital.in.on || ...
        (handles.video.on && handles.video.counter>1))
    if(isnan(rate) || isempty(rate) || (rate<1))
      uiwait(errordlg('sampling rate must be a positive integer'));
      set(handles.StartStop,'enable','on');  drawnow('expose');
      return;
    else
      handles.session.Rate=rate;
    end
  end

  handles.running=1;
  
  if(handles.analog.in.on)
    handles.analog.in.fid = nan;
    if(handles.analog.in.record)
      switch(handles.analog.in.fileformat)
        case 1  % version#=1, sample rate, nchan, (doubles)
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']),'w');
          fwrite(handles.analog.in.fid,[1 handles.samplingrate handles.analog.in.n],'double');
        case 2  % version#=2, sample rate, nchan, (singles)
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']),'w');
          fwrite(handles.analog.in.fid,[2 handles.samplingrate handles.analog.in.n],'double');
        case 3  % version#=3, sample rate, nchan, step, offset, (int16s = round((doubles-offset)/step))
          handles.analog.in.fid = fopen(fullfile(handles.analog.in.directory,[handles.filename 'a.bin']),'w');
          fwrite(handles.analog.in.fid,[3 handles.samplingrate handles.analog.in.n],'double');
          if(handles.analog.out.on)
            out_callback(hObject, eventdata, handles.figure1);
          end
          handles.analog.in.step=[];
          handles.analog.in.offset=[];
          data=handles.session.startForeground;
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
              update_figure(handles,true);
              return;
          end
        case 4
          % the one extra (zero valued) sample tic at the beginning
          % introduces a time shift of 1/Fs
          tmp2=fullfile(handles.analog.in.directory,[handles.filename 'a.wav']);
          audiowrite(tmp2, zeros(1,handles.analog.in.n), handles.samplingrate, 'bitspersample', 32);
          handles.analog.in.fid = fopen(tmp2,'r+');
      end
    end
  end

  if(handles.digital.in.on)
    handles.digital.in.fid = nan;
    % the one extra (zero valued) sample tic at the beginning
    % introduces a time shift of 1/Fs
    if(handles.analog.in.record)
      tmp=32;
      if(handles.digital.in.n<=8)
        tmp=8;
      elseif(handles.digital.in.n<=16)
        tmp=16;
      end
      tmp2=fullfile(handles.digital.in.directory,[handles.filename 'd.wav']);
      audiowrite(tmp2, uint8(0), handles.samplingrate, 'bitspersample', tmp);
      handles.digital.in.fid = fopen(tmp2,'r+');
    end
  end
  
  if(handles.analog.in.on || handles.digital.in.on)
    clear in_callback
    handles.listenerIn=handles.session.addlistener('DataAvailable',...
        @(hObject,eventdata)in_callback(hObject,eventdata,handles.figure1));
  end

  if(handles.analog.out.on || handles.digital.out.on)
    handles.analog.out.idx(logical(handles.analog.out.play))=1;
    handles.digital.out.idx(logical(handles.digital.out.play))=1;
    guidata(hObject, handles);
    tmp.Source.Channels=handles.session.Channels;
    for(i=1:5)  out_callback(hObject, tmp, handles.figure1);  end
    handles=guidata(hObject);
    handles.listenerOut=handles.session.addlistener('DataRequired',...
        @(hObject,eventdata)out_callback(hObject,eventdata,handles.figure1));
  end

  if((handles.digital.out.on || handles.digital.in.on) && ...
      ~handles.analog.out.on && ~handles.analog.in.on)
    handles.session.addAnalogInputChannel(handles.daqdevices.ID,0,'voltage');
    handles.listenerIn=handles.session.addlistener('DataAvailable',...
        @(hObject,eventdata) hObject);
  end
  
  tmp=[];
  if(handles.analog.in.record)
    tmp=handles.analog.in.directory;
  elseif(handles.digital.in.record)
    tmp=handles.digital.in.directory;
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
    clear video_callback
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
        handles.digital.out.on || handles.digital.in.on || ...
        (handles.video.on && (handles.video.counter>1)))
    handles.session.NotifyWhenDataAvailableExceeds=round(handles.session.Rate);
    handles.session.NotifyWhenScansQueuedBelow=5*round(handles.session.Rate);
    handles.session.IsContinuous=true;
    handles.session.startBackground;
  end
  handles.triggertime=clock;

  handles.timer.update_display=timer('Name','update display','Period',1,'ExecutionMode','fixedRate',...
      'TimerFcn',@(hObject,eventdata)display_callback(hObject,eventdata,handles));
  start(handles.timer.update_display);

%   guidata(hObject, handles);  % necessary??

elseif(handles.running)
  if(handles.analog.out.on || handles.analog.in.on || ...
      handles.digital.out.on || handles.digital.in.on || ...
      (handles.video.on && (handles.video.counter>1)))
    handles.session.stop();
    handles.session.IsContinuous=false;
  end

  if(handles.analog.out.on || handles.digital.out.on)
    delete(handles.listenerOut);
  end
  
  if(handles.analog.in.on || handles.digital.in.on)
    delete(handles.listenerIn);
  end
  if(handles.analog.in.on && handles.analog.in.record)
    fclose(handles.analog.in.fid);
  end
  if(handles.digital.in.on && handles.digital.in.record)
    fclose(handles.digital.in.fid);
  end

  if((handles.digital.out.on || handles.digital.in.on) && ...
      ~handles.analog.out.on && ~handles.analog.in.on)
    configure_analog_input_channels(handles);
    delete(handles.listenerIn);
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
                    'video_callback([],[],vi,' ...
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

update_figure(handles,true);
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

update_figure(handles,false);
handles.timelimit=str2num(get(handles.TimeLimit,'string'));
update_figure(handles,true);
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


% --- Executes on selection change in Verbose.
function Verbose_Callback(hObject, eventdata, handles)
% hObject    handle to Verbose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Verbose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Verbose

handles.verbose=-1+get(hObject,'value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Verbose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Verbose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ---
function handles=initialize(handles)

handles.analog.out.on=0;
handles.analog.out.maxn=nan;
handles.analog.out.n=nan;
handles.analog.out.curr=nan;
handles.analog.out.play=[];
handles.analog.out.file={};
handles.analog.out.y={};
handles.analog.out.fs=[];
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
handles.digital.out.on=0;
handles.digital.out.maxn=nan;
handles.digital.out.n=nan;
handles.digital.out.play=0;
handles.digital.out.file='';
handles.digital.out.fs=nan;
handles.digital.out.style=1;
handles.digital.out.autoscale=0;
handles.digital.out.y=[];
handles.digital.out.idx=nan;
handles.digital.in.on=0;
handles.digital.in.maxn=nan;
handles.digital.in.n=nan;
handles.digital.in.record=0;
handles.digital.in.directory='';
handles.digital.in.style=1;
handles.digital.in.autoscale=0;
handles.digital.direction=0;
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
handles.samplingrate=nan;
handles.daq=1;


% ---
function handles=load_config_file(filename,handles)

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
handles.digital.out.on=handles_saved.digital.out.on;
handles.digital.out.maxn=handles_saved.digital.out.maxn;
handles.digital.out.n=handles_saved.digital.out.n;
handles.digital.out.play=handles_saved.digital.out.play;
handles.digital.out.file=handles_saved.digital.out.file;
handles.digital.out.fs=handles_saved.digital.out.fs;
handles.digital.out.style=handles_saved.digital.out.style;
handles.digital.out.autoscale=handles_saved.digital.out.autoscale;
handles.digital.out.y=handles_saved.digital.out.y;
handles.digital.out.idx=handles_saved.digital.out.idx;
handles.digital.in.on=handles_saved.digital.in.on;
handles.digital.in.maxn=handles_saved.digital.in.maxn;
handles.digital.in.n=handles_saved.digital.in.n;
handles.digital.in.record=handles_saved.digital.in.record;
handles.digital.in.directory=handles_saved.digital.in.directory;
handles.digital.in.style=handles_saved.digital.in.style;
handles.digital.in.autoscale=handles_saved.digital.in.autoscale;
handles.digital.direction=handles_saved.digital.direction;
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
handles.samplingrate=handles_saved.samplingrate;
handles.daq=handles_saved.daq;
        
        
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
    'session'
    'videoadaptors'
    'listenerIn'
    'listenerOut'
    'system_monitor'
    'timer'};
for i = 1:length(fields_to_remove)
  if isfield(handles, fields_to_remove{i})
      handles = rmfield(handles, fields_to_remove{i});
  end
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
function update_figure(handles, flag)

if(isfield(handles,'analogGui'))
  analogHandles = guidata(handles.analogGui);
  set(analogHandles.AnalogOutPlay,'enable','off');
  set(analogHandles.AnalogOutNumChannels,'enable','off');
  set(analogHandles.AnalogOutChannel,'enable','off');
  set(analogHandles.AnalogOutRange,'enable','off');
  set(analogHandles.AnalogOutAutoScale,'enable','off');
  set(analogHandles.AnalogOutLogScale,'enable','off');
  set(analogHandles.AnalogOutOnePercent,'enable','off');
  set(analogHandles.AnalogOutHighFreq,'enable','off');
  set(analogHandles.AnalogOutLowFreq,'enable','off');
  set(analogHandles.AnalogOutNFFT,'enable','off');
  set(analogHandles.AnalogOutFile,'enable','off');
  set(analogHandles.AnalogOutStyle,'enable','off');
  if(flag && handles.analog.out.on && (handles.analog.out.maxn>0))
    set(analogHandles.AnalogOutNumChannels,'string',handles.analog.out.n);
    set(analogHandles.AnalogOutChannel,'string',[1:handles.analog.out.n]);
    set(analogHandles.AnalogOutChannel,'value',handles.analog.out.curr);
    set(analogHandles.AnalogOutRange,'value',handles.analog.out.range);
    set(analogHandles.AnalogOutAutoScale,'value',handles.analog.out.autoscale);
    set(analogHandles.AnalogOutLogScale,'value',handles.analog.out.logscale);
    set(analogHandles.AnalogOutOnePercent,'value',handles.analog.out.onepercent);
    set(analogHandles.AnalogOutHighFreq,'string',handles.analog.out.highfreq);
    set(analogHandles.AnalogOutLowFreq,'string',handles.analog.out.lowfreq);
    set(analogHandles.AnalogOutNFFT,'string',handles.analog.out.nfft);
    set(analogHandles.AnalogOutFile,'string',handles.analog.out.file{handles.analog.out.curr});
    if(handles.analog.out.play(handles.analog.out.curr))
      set(analogHandles.AnalogOutFile,'enable','on');
      set(analogHandles.AnalogOutPlay,'value',1);
    else
      set(analogHandles.AnalogOutFile,'enable','off');
      set(analogHandles.AnalogOutPlay,'value',0);
    end
    set(analogHandles.AnalogOutStyle,'value',handles.analog.out.style);
    if(~handles.running)
      set(analogHandles.AnalogOutPlay,'enable','on');
      set(analogHandles.AnalogOutNumChannels,'enable','on');
      set(analogHandles.AnalogOutRange,'enable','on');
    end
    set(analogHandles.AnalogOutChannel,'enable','on');
    set(analogHandles.AnalogOutFile,'enable','on');
    set(analogHandles.AnalogOutStyle,'enable','on');
    if(handles.analog.out.style==1)
      set(analogHandles.AnalogOutAutoScale,'enable','on');
    else
      set(analogHandles.AnalogOutLogScale,'enable','on');
    end
    if(handles.analog.out.style==3)
      set(analogHandles.AnalogOutOnePercent,'enable','on');
      set(analogHandles.AnalogOutNFFT,'enable','on');
    end
    if(ismember(handles.analog.out.style,[2 3]))
      set(analogHandles.AnalogOutHighFreq,'enable','on');
      set(analogHandles.AnalogOutLowFreq,'enable','on');
    end
  end

  set(analogHandles.AnalogInRecord,'enable','off');
  set(analogHandles.AnalogInNumChannels,'enable','off');
  set(analogHandles.AnalogInChannel,'enable','off');
  set(analogHandles.AnalogInRange,'enable','off');
  set(analogHandles.AnalogInTerminalConfiguration,'enable','off');
  set(analogHandles.AnalogInFileFormat,'enable','off');
  set(analogHandles.AnalogInAutoScale,'enable','off');
  set(analogHandles.AnalogInLogScale,'enable','off');
  set(analogHandles.AnalogInOnePercent,'enable','off');
  set(analogHandles.AnalogInHighFreq,'enable','off');
  set(analogHandles.AnalogInLowFreq,'enable','off');
  set(analogHandles.AnalogInNFFT,'enable','off');
  set(analogHandles.AnalogInDirectory,'enable','off');
  set(analogHandles.AnalogInStyle,'enable','off');
  if(flag && handles.analog.in.on && (handles.analog.in.maxn>0))
    set(analogHandles.AnalogInNumChannels,'string',handles.analog.in.n);
    set(analogHandles.AnalogInChannel,'string',[1:handles.analog.in.n]);
    set(analogHandles.AnalogInChannel,'value',handles.analog.in.curr);
    set(analogHandles.AnalogInRange,'value',handles.analog.in.range);
    set(analogHandles.AnalogInTerminalConfiguration,'value',handles.analog.in.terminal_configuration);
    set(analogHandles.AnalogInFileFormat,'value',handles.analog.in.fileformat);
    set(analogHandles.AnalogInDirectory,'string',handles.analog.in.directory);
    set(analogHandles.AnalogInAutoScale,'value',handles.analog.in.autoscale);
    set(analogHandles.AnalogInLogScale,'value',handles.analog.in.logscale);
    set(analogHandles.AnalogInOnePercent,'value',handles.analog.in.onepercent);
    set(analogHandles.AnalogInHighFreq,'string',handles.analog.in.highfreq);
    set(analogHandles.AnalogInLowFreq,'string',handles.analog.in.lowfreq);
    set(analogHandles.AnalogInNFFT,'string',handles.analog.in.nfft);
    if(handles.analog.in.record)
      set(analogHandles.AnalogInDirectory,'enable','on');
      set(analogHandles.AnalogInRecord,'value',1);
    else
      set(analogHandles.AnalogInDirectory,'enable','off');
      set(analogHandles.AnalogInRecord,'value',0);
    end
    set(analogHandles.AnalogInStyle,'value',handles.analog.in.style);
    if(~handles.running)
      set(analogHandles.AnalogInRecord,'enable','on');
      set(analogHandles.AnalogInNumChannels,'enable','on');
      set(analogHandles.AnalogInChannel,'enable','on');
      set(analogHandles.AnalogInTerminalConfiguration,'enable','on');
      set(analogHandles.AnalogInRange,'enable','on');
      if(handles.analog.in.record)
        set(analogHandles.AnalogInFileFormat,'enable','on');
      end
    end
    set(analogHandles.AnalogInChannel,'enable','on');
    set(analogHandles.AnalogInDirectory,'enable','on');
    set(analogHandles.AnalogInStyle,'enable','on');
    if(handles.analog.in.style==4)
      set(analogHandles.AnalogInChannel,'enable','off');
    else
      set(analogHandles.AnalogInChannel,'enable','on');
    end
    if(handles.analog.in.style==1)
      set(analogHandles.AnalogInAutoScale,'enable','on');
    else
      set(analogHandles.AnalogInLogScale,'enable','on');
    end
    if(handles.analog.in.style==3)
      set(analogHandles.AnalogInOnePercent,'enable','on');
      set(analogHandles.AnalogInNFFT,'enable','on');
    end
    if(ismember(handles.analog.in.style,[2 3]))
      set(analogHandles.AnalogInHighFreq,'enable','on');
      set(analogHandles.AnalogInLowFreq,'enable','on');
    end
  end
end

if(isfield(handles,'digitalGui'))
  digitalHandles = guidata(handles.digitalGui);
  set(digitalHandles.DigitalOutPlay,'enable','off');
  set(digitalHandles.DigitalOutNumChannels,'enable','off');
  set(digitalHandles.DigitalOutDirection,'enable','off');
  set(digitalHandles.DigitalOutAutoScale,'enable','off');
  set(digitalHandles.DigitalOutFile,'enable','off');
  set(digitalHandles.DigitalOutStyle,'enable','off');
  if(flag && handles.digital.out.on && (handles.digital.out.maxn>0))
    set(digitalHandles.DigitalOutNumChannels,'string',handles.digital.out.n);
    if(handles.digital.direction)
      set(digitalHandles.DigitalOutDirection,'string','Up from 0');
    else
      set(digitalHandles.DigitalOutDirection,'string',['Down from ' num2str(handles.digital.out.maxn)]);
    end
    set(digitalHandles.DigitalOutAutoScale,'value',handles.digital.out.autoscale);
    set(digitalHandles.DigitalOutFile,'string',handles.digital.out.file);
    if(handles.digital.out.play)
      set(digitalHandles.DigitalOutFile,'enable','on');
      set(digitalHandles.DigitalOutPlay,'value',1);
    else
      set(digitalHandles.DigitalOutFile,'enable','off');
      set(digitalHandles.DigitalOutPlay,'value',0);
    end
    set(digitalHandles.DigitalOutStyle,'value',handles.digital.out.style);
    if(~handles.running)
      set(digitalHandles.DigitalOutPlay,'enable','on');
      set(digitalHandles.DigitalOutNumChannels,'enable','on');
      set(digitalHandles.DigitalOutDirection,'enable','on');
    end
    set(digitalHandles.DigitalOutFile,'enable','on');
    set(digitalHandles.DigitalOutStyle,'enable','on');
    if(handles.digital.out.style==2)
      set(digitalHandles.DigitalOutAutoScale,'enable','on');
    end
  end

  set(digitalHandles.DigitalInRecord,'enable','off');
  set(digitalHandles.DigitalInNumChannels,'enable','off');
  set(digitalHandles.DigitalInDirection,'enable','off');
  set(digitalHandles.DigitalInAutoScale,'enable','off');
  set(digitalHandles.DigitalInDirectory,'enable','off');
  set(digitalHandles.DigitalInStyle,'enable','off');
  if(flag && handles.digital.in.on && (handles.digital.in.maxn>0))
    set(digitalHandles.DigitalInNumChannels,'string',handles.digital.in.n);
    if(handles.digital.direction)
      set(digitalHandles.DigitalInDirection,'string',['Down from ' num2str(handles.digital.in.maxn)]);
    else
      set(digitalHandles.DigitalInDirection,'string','Up from 0');
    end
    set(digitalHandles.DigitalInDirectory,'string',handles.digital.in.directory);
    set(digitalHandles.DigitalInAutoScale,'value',handles.digital.in.autoscale);
    if(handles.digital.in.record)
      set(digitalHandles.DigitalInDirectory,'enable','on');
      set(digitalHandles.DigitalInRecord,'value',1);
    else
      set(digitalHandles.DigitalInDirectory,'enable','off');
      set(digitalHandles.DigitalInRecord,'value',0);
    end
    set(digitalHandles.DigitalInStyle,'value',handles.digital.in.style);
    if(~handles.running)
      set(digitalHandles.DigitalInRecord,'enable','on');
      set(digitalHandles.DigitalInNumChannels,'enable','on');
      set(digitalHandles.DigitalInDirection,'enable','on');
    end
    set(digitalHandles.DigitalInDirectory,'enable','on');
    set(digitalHandles.DigitalInStyle,'enable','on');
    if(handles.digital.in.style==2)
      set(digitalHandles.DigitalInAutoScale,'enable','on');
    end
  end
end

if(isfield(handles,'videoGui'))
  videoHandles = guidata(handles.videoGui);
  set(videoHandles.VideoSave,'enable','off');
  set(videoHandles.VideoSyncPulseOnly,'enable','off');
  set(videoHandles.VideoSameDirectory,'enable','off');
  set(videoHandles.VideoSameROI,'enable','off');
  set(videoHandles.VideoFormat,'enable','off');
  set(videoHandles.VideoTimeStamps,'enable','off');
  set(videoHandles.VideoROI,'enable','off');
  set(videoHandles.VideoFPS,'enable','off');
  set(videoHandles.VideoNumChannels,'enable','off');
  set(videoHandles.VideoTrigger,'enable','off');
  set(videoHandles.VideoFileFormat,'enable','off');
  set(videoHandles.VideoFileQuality,'enable','off','tooltipstring','');
  set(videoHandles.VideoParams,'enable','on');
  set(videoHandles.VideoHistogram,'enable','off');
  set(videoHandles.VideoChannel,'enable','off');
  set(videoHandles.VideoParams,'enable','off');
  if(flag && handles.video.on && (handles.video.maxn>0))
    set(videoHandles.VideoSyncPulseOnly,'value',handles.video.syncpulseonly);
    set(videoHandles.VideoFPS,'string',handles.video.FPS);
    set(videoHandles.VideoROI,'string',num2str(handles.video.ROI{handles.video.curr},'%d,%d,%d,%d'));
    set(videoHandles.VideoNumChannels,'string',handles.video.n);
    set(videoHandles.VideoChannel,'string',...
        cellfun(@(n,s) [num2str(n) ' ' s], num2cell(1:handles.video.n),...
        handles.video.devicename(1:handles.video.n),'uniformoutput',false));
    set(videoHandles.VideoChannel,'value',handles.video.curr);
    set(videoHandles.VideoDirectory,'string',handles.video.directory(handles.video.curr));
    set(videoHandles.VideoFormat,'string',handles.video.formatlist{handles.video.curr},...
        'value',handles.video.formatvalue(handles.video.curr));
    tmp={};
    if(handles.video.ncounters>0)
      tmp=arrayfun(@(x) sprintf('trigger %d',x),0:(handles.video.ncounters-1),'uniformoutput',false);
    end
    set(videoHandles.VideoTrigger,'string',{'free running' tmp{:}});
    set(videoHandles.VideoTrigger,'value',handles.video.counter);
    if(handles.video.save(handles.video.curr))
      set(videoHandles.VideoDirectory,'enable','on');
      set(videoHandles.VideoSave,'value',1);
    else
      set(videoHandles.VideoDirectory,'enable','off');
      set(videoHandles.VideoSave,'value',0);
    end
    set(videoHandles.VideoSameDirectory,'value',handles.video.samedirectory);
    set(videoHandles.VideoSameROI,'value',handles.video.sameroi);
    set(videoHandles.VideoTimeStamps,'value',handles.video.timestamps);
    set(videoHandles.VideoFileFormat,'value',handles.video.fileformat);
    set(videoHandles.VideoFileQuality,'string',handles.video.filequality);
    set(videoHandles.VideoParams,'data',handles.video.params{handles.video.curr});
    if ~handles.running
      if handles.video.ncounters>1
        set(videoHandles.VideoSyncPulseOnly,'enable','on');
        set(videoHandles.VideoTrigger,'enable','on');
      end
      if handles.video.counter>1
        set(videoHandles.VideoFPS,'enable','on');
      end
    end
    if ~handles.video.syncpulseonly
      set(videoHandles.VideoParams,'enable','on');
      set(videoHandles.VideoChannel,'enable','on');
      if ~handles.running
        set(videoHandles.VideoSave,'enable','on');
        if handles.video.n>1
          set(videoHandles.VideoSameDirectory,'enable','on');
          set(videoHandles.VideoSameROI,'enable','on');
        end
        set(videoHandles.VideoFormat,'enable','on');
        set(videoHandles.VideoROI,'enable','on');
        set(videoHandles.VideoNumChannels,'enable','on');
        if(handles.video.save(handles.video.curr))
          set(videoHandles.VideoTimeStamps,'enable','on');
          set(videoHandles.VideoFileFormat,'enable','on');
          set(videoHandles.VideoFileQuality,'enable','on');
          switch(handles.video.fileformats_available{handles.video.fileformat})
            case {'Motion JPEG AVI','MPEG-4'}
              set(videoHandles.VideoFileQuality,'enable','on','tooltipstring','quality (1-100)');
            case 'Motion JPEG 2000'
              set(videoHandles.VideoFileQuality,'enable','on','tooltipstring','compression ratio (>1)');
          end
        end
      else
        set(videoHandles.VideoHistogram,'enable','on');
      end
    end
  end
end

if(isfield(handles,'analogGui'))
  set(analogHandles.AnalogOutOnOff,'enable','off','value',handles.analog.out.on);
  set(analogHandles.AnalogInOnOff,'enable','off','value',handles.analog.in.on);
end
if(isfield(handles,'digitalGui'))
  set(digitalHandles.DigitalOutOnOff,'enable','off','value',handles.digital.out.on);
  set(digitalHandles.DigitalInOnOff,'enable','off','value',handles.digital.in.on);
end
if(isfield(handles,'videoGui'))
  set(videoHandles.VideoOnOff,'enable','off','value',handles.video.on);
end
set(handles.TimeLimit,'enable','off','string',num2str(handles.timelimit));
set(handles.Verbose,'enable','off','value',handles.verbose+1);
if(isfield(handles,'analogGui') || isfield(handles,'digitalGui'))
  set(handles.SamplingRate,'enable','off');
end
set(handles.DAQ,'enable','off','value',handles.daq);
set(handles.StartStop,'enable','off');

set(handles.Load,'enable','off');
set(handles.Save,'enable','off');
set(handles.Reset,'enable','off');

if(~flag)  return;  end

set(handles.Load,'enable','on');
set(handles.Save,'enable','on');
set(handles.Reset,'enable','on');

if(~handles.running)
  if(isfield(handles,'analogGui'))
    if(handles.analog.in.maxn>0)
      set(analogHandles.AnalogInOnOff,'enable','on');
    end
    if(handles.analog.out.maxn>0)
      set(analogHandles.AnalogOutOnOff,'enable','on');
    end
  end
  if(isfield(handles,'digitalGui'))
    if(handles.digital.in.maxn>0)
      set(digitalHandles.DigitalInOnOff,'enable','on');
    end
    if(handles.digital.out.maxn>0)
      set(digitalHandles.DigitalOutOnOff,'enable','on');
    end
  end
  if((isfield(handles,'analogGui') && handles.analog.in.on && (handles.analog.in.n>0)) || ...
    (isfield(handles,'digitalGui') && handles.digital.in.on && (handles.digital.in.n>0)))
    set(handles.SamplingRate,'enable','on','string',handles.samplingrate);
  end
  if(isfield(handles,'videoGui') && (handles.video.maxn>0))
    set(videoHandles.VideoOnOff,'enable','on');
  end
  set(handles.TimeLimit,'enable','on');
  set(handles.Verbose,'enable','on');
  set(handles.DAQ,'enable','on');
end

tmp=[];  tmp2={};
if(strcmp(get(handles.SamplingRate,'enable'),'on'))
  tmp=[tmp handles.samplingrate];
  tmp2{end+1}=['box = ' num2str(get(handles.SamplingRate,'string'))];
end
if(isfield(handles,'analogGui') && handles.analog.out.on && (sum(handles.analog.out.play)>0))
  tmp=[tmp handles.analog.out.fs(logical(handles.analog.out.play))];
  for(i=1:handles.analog.out.n)
    if(~handles.analog.out.play(i))  continue;  end
    tmp2{end+1}=['analog #' num2str(i) ' = ' num2str(handles.analog.out.fs(i))];
  end
end
if(isfield(handles,'digitalGui') && handles.digital.out.on && (handles.digital.out.n>0))
  tmp=[tmp handles.digital.out.fs];
  tmp2{end+1}=['digital = ' num2str(handles.digital.out.fs)];
end
tmp=tmp(~isnan(tmp));
handles.samplingrate=median(tmp);
if(length(unique(tmp))>1)
  tmp2={'not all sampling rates are the same:' tmp2{:}};
  tmp2{end+1}=['will go with ' num2str(handles.samplingrate) ' for now'];
  warndlg(tmp2);
end

if((isfield(handles,'analogGui') && (handles.analog.out.on || handles.analog.in.on)) || ...
   (isfield(handles,'digitalGui') && (handles.digital.out.on || handles.digital.in.on)) || ...
   handles.video.on)
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
while i<=length(handles.session.Channels)
  if strcmp(class(handles.session.Channels(i)),'daq.ni.AnalogOutputVoltageChannel')
    handles.session.removeChannel(i);
  else
    i=i+1;
  end
end

if handles.analog.out.on && (handles.analog.out.n>0)
  [~,idx]=handles.session.addAnalogOutputChannel(handles.daqdevices.ID,0:(handles.analog.out.n-1),'voltage');
  [handles.analog.Channels(idx).Range]=deal(handles.analog.out.ranges_available(handles.analog.out.range));
end

if(length(handles.analog.out.play)~=handles.analog.out.n)
  handles.analog.out.play=zeros(1,handles.analog.out.n);
  handles.analog.out.file=cell(1,handles.analog.out.n);
  handles.analog.out.y=cell(1,handles.analog.out.n);
  handles.analog.out.fs=nan(1,handles.analog.out.n);
  handles.analog.out.idx=ones(1,handles.analog.out.n);
end

  
% ---
function handles=configure_analog_input_channels(handles)

i=1;
while i<=length(handles.session.Channels)
  if strcmp(class(handles.session.Channels(i)),'daq.ni.AnalogInputVoltageChannel')
    handles.session.removeChannel(i);
  else
    i=i+1;
  end
end

if(handles.analog.in.on) && (handles.analog.in.n>0)
  [~,idx]=handles.session.addAnalogInputChannel(handles.daqdevices.ID,0:(handles.analog.in.n-1),'voltage');
  [handles.session.Channels(idx).Range]=deal(handles.analog.in.ranges_available(handles.analog.in.range));
  [handles.session.Channels(idx).TerminalConfig]=...
      deal(handles.analog.in.terminal_configurations_available{handles.analog.in.terminal_configuration});
end


% ---
function handles=configure_digital_channels(handles)

i=1;
while i<=length(handles.session.Channels)
  tmp=class(handles.session.Channels(i));
  if(strcmp(tmp,'daq.ni.DigitalOutputChannel') || strcmp(tmp,'daq.ni.DigitalInputChannel'))
    handles.session.removeChannel(i);
  else
    i=i+1;
  end
end

if(handles.digital.out.on) && (handles.digital.out.n>0)
  if(handles.digital.direction)
    start=0; incr=1; stop=handles.digital.out.n-1;
  else
    start=handles.digital.out.maxn-1; incr=-1; stop=handles.digital.out.maxn-handles.digital.out.n;
  end
  for(i=start:incr:stop)
    handles.session.addDigitalChannel(handles.daqdevices.ID,...
        ['port0/line' num2str(i)], 'InputOnly');
  end
end

if(handles.digital.in.on) && (handles.digital.in.n>0)
  if(handles.digital.direction)
    start=handles.digital.in.maxn-1; incr=-1; stop=handles.digital.in.maxn-handles.digital.in.n;
  else
    start=0; incr=1; stop=handles.digital.in.n-1;
  end
  for(i=start:incr:stop)
    handles.session.addDigitalChannel(handles.daqdevices.ID,...
        ['port0/line' num2str(i)], 'InputOnly');
  end
end


% ---
function handles=configure_video_channels(handles)

if(~isfield(handles,'session'))  return;  end

i=1;
while i<=length(handles.session.Channels)
  if strcmp(class(handles.session.Channels(i)),'daq.ni.CounterOutputPulseGenerationChannel')
    handles.session.removeChannel(i);
    break;
  else
    i=i+1;
  end
end

if(handles.video.on && (handles.video.n>0) && handles.video.counter>1 && ~isnan(handles.video.FPS))
  h=handles.session.addCounterOutputChannel(...
      handles.daqdevices.ID,handles.video.counter-2,'PulseGeneration');
  set(h,'Frequency',handles.video.FPS);
end
 

% ---
function set_video_param(videoObj, event, videoHandles, handles)

data=get(videoHandles.VideoParams,'data');
handles.video.params{handles.video.curr}=data;
guidata(videoHandles.omnivore, handles);

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
function data=get_video_params(currAdaptor,DeviceID,format)

vi=videoinput(char(currAdaptor),num2str(DeviceID),format);

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

delete(vi);
        
% ---
function handles=query_hardware(handles)

try
  % next two lines only needed for roian's rig, and prohibit using chr & hyg simultaneously
  % daq.reset;
  % daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);
  tmp=daq.getDevices;
  set(handles.DAQ,'string',{tmp.ID});
  handles.daqdevices=tmp(handles.daq);
catch
  uiwait(warndlg('no digitizer found'));
end

try
  handles.videoadaptors=imaqhwinfo;
catch
  uiwait(warndlg('no camera found'));
end

if(isfield(handles,'daqdevices'))
  
  idxAO=find(cellfun(@(x) strcmp(x,'AnalogOutput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  idxAI=find(cellfun(@(x) strcmp(x,'AnalogInput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  idxDIO=find(cellfun(@(x) strcmp(x,'DigitalIO'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  idxCO=find(cellfun(@(x) strcmp(x,'CounterOutput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');

  if((~isempty(idxAO)) || (~isempty(idxAI)) || (~isempty(idxDIO)) || (~isempty(idxCO)))
    handles.session=daq.createSession('ni');
  end
  if(isempty(idxAO) && isempty(idxAI) && isempty(idxDIO))
    set(handles.SamplingRate,'visible','off');
    set(handles.SamplingRateLabel,'visible','off');
  end
  
  if((~isempty(idxAO)) || (~isempty(idxAI)))
    handles.analogGui=analog('omnivore', handles.figure1);
    analogHandles = guidata(handles.analogGui);
  end
    
  if(~isempty(idxAO))
    handles.analog.out.ranges_available=handles.daqdevices.Subsystems(idxAO).RangesAvailable;
    set(analogHandles.AnalogOutRange,'String', ...
        arrayfun(@char,handles.analog.out.ranges_available,'uniformoutput',false));
    handles.analog.out.range=min(handles.analog.out.range,length(handles.analog.out.ranges_available));
    handles.analog.out.maxn=handles.daqdevices.Subsystems(idxAO).NumberOfChannelsAvailable;
    handles.analog.out.n=min(handles.analog.out.n,handles.analog.out.maxn);
    handles.analog.out.curr=min(handles.analog.out.curr,handles.analog.out.maxn);
    handles=configure_analog_output_channels(handles);
  else
    handles.analog.out.maxn=0;
    handles.analog.out.n=0;
    handles.analog.out.on=0;
  end

  if(~isempty(idxAI))
    tmp=handles.daqdevices.Subsystems(idxAI).TerminalConfigsAvailable;
    if(~iscell(tmp)) tmp={tmp};  end
    handles.analog.in.terminal_configurations_available=tmp;
    set(analogHandles.AnalogInTerminalConfiguration,'String', ...
        handles.analog.in.terminal_configurations_available);
    handles.analog.in.terminal_configuration=...
        min(handles.analog.in.terminal_configuration,length(handles.analog.in.terminal_configurations_available));
    handles.analog.in.ranges_available=handles.daqdevices.Subsystems(idxAI).RangesAvailable;
    set(analogHandles.AnalogInRange,'String', ...
        arrayfun(@char,handles.analog.in.ranges_available,'uniformoutput',false));
    handles.analog.in.range=min(handles.analog.in.range,length(handles.analog.in.ranges_available));
    handles.analog.in.maxn=handles.daqdevices.Subsystems(idxAI).NumberOfChannelsAvailable;
    handles.analog.in.n=min(handles.analog.in.n,handles.analog.in.maxn);
    handles.analog.in.curr=min(handles.analog.in.curr,handles.analog.in.maxn);
    handles=configure_analog_input_channels(handles);
  else
    handles.analog.in.maxn=0;
    handles.analog.in.n=0;
    handles.analog.in.on=0;
  end

  if(~isempty(idxDIO))
    handles.digitalGui=digital('omnivore', handles.figure1);
    digitalHandles = guidata(handles.digitalGui);
    
    tmp=sum(cellfun(@(x) strncmp(x,'port0',5), handles.daqdevices.Subsystems(idxDIO).ChannelNames));
    handles.digital.out.maxn=tmp;
    handles.digital.in.maxn=tmp;
    handles.digital.out.n=min(handles.digital.out.n, handles.digital.out.maxn);
    if(handles.digital.in.on)
      handles.digital.out.n=min(handles.digital.out.n, handles.digital.out.maxn-handles.digital.in.n);
    end
    handles.digital.in.n=min(handles.digital.in.n, handles.digital.in.maxn);
    if(handles.digital.out.on)
      handles.digital.in.n=min(handles.digital.in.n, handles.digital.in.maxn-handles.digital.out.n);
    end
    handles=configure_digital_channels(handles);
  else
    handles.digital.out.maxn=0;
    handles.digital.out.n=0;
    handles.digital.in.maxn=0;
    handles.digital.in.n=0;
  end

  handles.video.ncounters=0;
  if(~isempty(idxCO))
      handles.video.ncounters=handles.daqdevices.Subsystems(idxCO).NumberOfChannelsAvailable;
  end
end

if(isfield(handles,'videoadaptors'))
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
        params{currDevice}=get_video_params(...
            currAdaptor, info.DeviceIDs{currDevice},...
            info.DeviceInfo(currDevice).SupportedFormats{1});
      end
    end
  end
  if(maxn>0)
    handles.videoGui=video('omnivore', handles.figure1);
    videoHandles = guidata(handles.videoGui);

    tmp=VideoWriter(tempname);
    tmp=tmp.getProfiles;
    [handles.video.fileformats_available{1:length(tmp)}]=deal(tmp.Name);
    handles.video.fileformat=min(handles.video.fileformat,length(handles.video.fileformats_available));
    set(videoHandles.VideoFileFormat,'String',handles.video.fileformats_available);

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
    handles.video.maxn=0;
    handles.video.n=0;
    handles.video.on=0;
  end
end


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
function analog_plot(haxis, data, hanalog, fs)

if(isempty(data)) return;  end

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
function digital_plot(haxis, data, hdigital, fs)

if(isempty(data)) return;  end

switch hdigital.style
  case 1
    plot(haxis,(1:size(data,1))./fs,bsxfun(@plus,0.9.*data,0:(size(data,2)-1)),'k-');
    axis(haxis,'tight');
    v=axis(haxis);
    axis(haxis,[v(1) v(2) 0 size(data,2)]);
    xlabel(haxis,'time (sec)');
  case 2
    plot(haxis,(1:size(data,1))./fs,bin2dec(num2str(fliplr(data))),'k-');
    axis(haxis,'tight');
    if(~hdigital.autoscale)
      v=axis(haxis);
      axis(haxis,[v(1) v(2) 0 2^size(data,2)]);
    end
    xlabel(haxis,'time (sec)');
  case 3
    bar(haxis,1:hdigital.n,mean(data),'k');
    axis(haxis,'tight');
    v=axis(haxis);
    axis(haxis,[v(1) v(2) 0 1]);
    xlabel(haxis,'channel #');
end


% ---
function out_callback(src,evt,hObject)

handles=guidata(hObject);

if handles.verbose>0
  disp('entering out_callback');
  tic
end

chan=arrayfun(@(x) strcmp(class(x),'daq.ni.AnalogOutputVoltageChannel') || ...
    strcmp(class(x),'daq.ni.DigitalOutputChannel'), evt.Source.Channels);
out=zeros(round(handles.session.Rate),sum(chan)); 

if(isfield(handles,'analogGui') && handles.analog.out.on)
  chan2=arrayfun(@(x) strcmp(class(x),'daq.ni.AnalogOutputVoltageChannel'), evt.Source.Channels);
  chan2=chan2(chan);
  1:length(chan2);
  chan2=ans(chan2);

  for i=1:handles.analog.out.n
    if(handles.analog.out.play(i))
      tmp=handles.analog.out.idx(i)+round(handles.session.Rate)-1;
      idx=min(tmp,length(handles.analog.out.y{i}));
      idx2=tmp-idx;
      out(:,chan2(i))=[handles.analog.out.y{i}(handles.analog.out.idx(i):idx); handles.analog.out.y{i}(1:idx2)];
      handles.analog.out.idx(i)=idx2+1;
      if(idx2==0)
        handles.analog.out.idx(i)=idx+1;
      end
    end
  end
  
  analogHandles = guidata(handles.analogGui);
  analog_plot(analogHandles.AnalogOutPlot, out(:,chan2), handles.analog.out, handles.samplingrate);
end

if(isfield(handles,'digitalGui') && handles.digital.out.on)
  chan2=arrayfun(@(x) strcmp(class(x),'daq.ni.DigitalOutputChannel'), evt.Source.Channels);
  chan2=chan2(chan);
  1:length(chan2);
  chan2=ans(chan2);

  if(handles.digital.out.play)
    tmp=handles.digital.out.idx+round(handles.session.Rate)-1;
    idx=min(tmp,length(handles.digital.out.y));
    idx2=tmp-idx;
    tmp=dec2bin([handles.digital.out.y(handles.digital.out.idx:idx); handles.digital.out.y(1:idx2)], ...
        handles.digital.out.n);
    for i=1:handles.digital.out.n
      out(:,chan2(i))=str2num(tmp(:,i));
    end
    handles.digital.out.idx=idx2+1;
    if(idx2==0)
      handles.digital.out.idx=idx+1;
    end
  end
  
  digitalHandles = guidata(handles.digitalGui);
  digital_plot(digitalHandles.DigitalOutPlot, out(:,chan2), handles.digital.out, handles.samplingrate);
end

handles.session.queueOutputData(out);

guidata(hObject, handles);

if handles.verbose>0
  disp(['exiting  out_callback: ' ...
        num2str(toc/(length(out)/handles.samplingrate(1)),3) 'x real time is ' ...
        num2str(toc,3) 's to process ' ...
        num2str(length(out)/handles.samplingrate(1),3) 's of data']);
end


% --- 
function in_callback(src,evt,hObject)

persistent last_timestamp

handles=guidata(hObject);

if handles.verbose>0
  disp('entering in_callback');
  tic
end

if(isfield(handles,'analogGui') && handles.analog.in.on)
  analogHandles = guidata(handles.analogGui);
  idx=arrayfun(@(x) strcmp(class(x),'daq.ni.AnalogInputVoltageChannel'), evt.Source.Channels);
  analog_plot(analogHandles.AnalogInPlot, evt.Data(:,idx), handles.analog.in, handles.samplingrate);

  if(handles.analog.in.record)
    switch(handles.analog.in.fileformat)
      case 1
        fwrite(handles.analog.in.fid,evt.Data(:,idx)','float64');
      case 2
        fwrite(handles.analog.in.fid,evt.Data(:,idx)','float32');
      case 3
        d=bsxfun(@minus,evt.Data(:,idx),handles.analog.in.offset);
        d=bsxfun(@rdivide,d,handles.analog.in.step);
        fwrite(handles.analog.in.fid,d','int16');
      case 4
        data_length = numel(evt.Data(:,idx)) * 4;

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
            evt.Data(:,idx) ./ handles.analog.in.ranges_available(handles.analog.in.range).Max, ...
            'single', 0, 'ieee-le');
    end
  end
end

if(isfield(handles,'digitalGui') && handles.digital.in.on)
  digitalHandles = guidata(handles.digitalGui);
  idx=arrayfun(@(x) strcmp(class(x),'daq.ni.DigitalInputChannel'), evt.Source.Channels);
  digital_plot(digitalHandles.DigitalInPlot, evt.Data(:,idx), handles.digital.in, handles.samplingrate);

  if(handles.digital.in.record)
    data_length = numel(evt.Data(:,idx)) * 4;

    fseek(handles.digital.in.fid,4,'bof');
    chunk_size = fread(handles.digital.in.fid, 1, 'uint32');
    fseek(handles.digital.in.fid,4,'bof');
    fwrite(handles.digital.in.fid,chunk_size + data_length,'uint32'); 

    fseek(handles.digital.in.fid,42,'bof');
    subchunk_size = fread(handles.digital.in.fid, 1, 'uint32');
    fseek(handles.digital.in.fid,42,'bof');
    fwrite(handles.digital.in.fid,subchunk_size + data_length, 'uint32');

    tmp2=bin2dec(num2str(evt.Data(:,idx)));
    if(handles.digital.in.n<=8)
      tmp='uint8';
    elseif(handles.digital.in.n<=16)
      tmp='int16';
      tmp2=tmp2-INTMAX(tmp)/2;
    else
      tmp='int32';
      tmp2=tmp2-INTMAX(tmp)/2;
    end
    fseek(handles.digital.in.fid,0,'eof');
    fwrite(handles.digital.in.fid, tmp2, tmp);
  end
end

if(~isempty(last_timestamp))
  tmp=round((evt.TimeStamps(1)-last_timestamp)*handles.samplingrate);
  if(tmp~=1)
    disp(['warning:  skipped ' num2str(tmp) ' analog input samples']);
  end
end
last_timestamp=evt.TimeStamps(end);

%axis(handles.AnalogInPlot,'tight');
%axis(handles.AnalogInPlot,'off');

if handles.verbose>0
  disp(['exiting  in_callback:  ' ...
        num2str(toc/(length(evt.Data)/handles.samplingrate),3) 'x real time is ' ...
        num2str(toc,3) 's to process ' ...
        num2str(length(evt.Data)/handles.samplingrate,3) 's of data']);
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
            '''FramesAcquiredFcn'',@(hObject,eventdata)video_callback(hObject,eventdata,vi,' ...
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

if(isfield(handles,'analogGui') && handles.analog.out.on)
  analogHandles = guidata(handles.analogGui);
  set(analogHandles.AnalogOutBuffer,'string',num2str(handles.session.ScansQueued));
end

if handles.video.on && handles.video.save(handles.video.curr)
  try
    videoHandles = guidata(handles.videoGui);
    set(videoHandles.VideoFPSAchieved,'string',...
        num2str(handles.video.actx(handles.video.curr).GetVariable('FPSAchieved','base')));
    set(videoHandles.VideoFramesAvailable,'string',...
        num2str(handles.video.actx(handles.video.curr).GetVariable('FramesAvailable','base')));
    if handles.video.counter>1
      set(videoHandles.VideoFramesSkipped,'string',...
          num2str(handles.video.actx(handles.video.curr).GetVariable('FramesSkipped','base')));
    end
  catch
  end
end

drawnow('expose');

if handles.verbose>1
  disp(['exiting  audio/video display_callback:    ' num2str(toc) 's']);
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



function SamplingRate_Callback(hObject, eventdata, handles)
% hObject    handle to SamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SamplingRate as text
%        str2double(get(hObject,'String')) returns contents of SamplingRate as a double

tmp=str2num(get(hObject,'String'));
handles.samplingrate=tmp;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function SamplingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DAQ.
function DAQ_Callback(hObject, eventdata, handles)
% hObject    handle to DAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DAQ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DAQ

handles.daq=get(hObject,'value');

if(isfield(handles,'analogGui'))
  delete(handles.analogGui);
end
if(isfield(handles,'digitalGui'))
  delete(handles.digitalGui);
end
if(isfield(handles,'videoGui'))
  delete(handles.videoGui);
end
delete(handles.session);

handles=query_hardware(handles);
update_figure(handles,true);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DAQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
