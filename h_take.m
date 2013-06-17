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
handles.running=0;
handles.filename='';
handles.timelimit=0;
handles.verbose=true;


% ---
function handles=load_configuration_file(filename,handles)

handles_saved=load(filename);
handles_saved=handles_saved.handles;
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
handles.running=0;
handles.filename=handles_saved.filename;
handles.timelimit=handles_saved.timelimit;
handles.verbose=handles_saved.verbose;


% ---
function update_figure(handles)

set(handles.HygrometerOnOff,'value',handles.hygrometer.on,'enable','on');
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

handles.rcfilename = 'most_recent_h_config.mat';
if(exist(handles.rcfilename)==2)
  handles=load_configuration_file(handles.rcfilename,handles);
else
  handles=initialize(handles);
end

try
  % next two lines only needed for roian's rig
  %daq.reset;
  %daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);
  daq.getDevices;
  handles.daqdevices=ans(1);
catch
  uiwait(warndlg('no digitizer found'));
end

if(isfield(handles,'daqdevices'))
  handles.digital.session=daq.createSession('ni');

  handles.hygrometer.period=max(handles.hygrometer.period,10);
  handles=configure_hygrometer(handles);
else
  set(handles.HygrometerOnOff,'enable','off');
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
  if(~isempty(handles.hygrometer.object))
    handles.hygrometer.object.close;
  end
  handles.daqdevices=[];  handles.digital.session=[];  handles.listener1=[];
  handles.hygrometer.object=[];
  handles.hygrometer.timer=[];
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
function hygrometer_callback(src,evt,handles)

if handles.verbose
  disp('entering hygrometer_callback');
  tic
end

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

if handles.verbose
  disp(['exiting  hygrometer_callback:    ' num2str(toc) 's']);
end


% ---
function display_callback(src,evt,handles)

if handles.verbose
  disp('entering display_callback');
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

drawnow('expose')

if handles.verbose
  disp(['exiting  display_callback:    ' num2str(toc) 's']);
end


% --- Executes on button press in StartStop.
function StartStop_Callback(hObject, eventdata, handles)
% hObject    handle to StartStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.StartStop,'enable','off');  drawnow('expose');

if(~handles.running)
  handles.filename=datestr(now,30);
  
  handles.running=1;
  set(handles.StartStop,'string','stop','backgroundColor',[1 0 0]);
  set(handles.HygrometerOnOff,'enable','off');
  set(handles.HygrometerSave,'enable','off');
  set(handles.HygrometerPeriod,'enable','off');
  drawnow('expose');
  
  if(handles.hygrometer.on)
    handles.hygrometer.fid=nan;
    if(handles.hygrometer.save)
      handles.hygrometer.fid=fopen(fullfile(handles.hygrometer.directory,[handles.filename '.hyg']),'w');
    end
    handles.hygrometer.timer=timer('Name','hygrometer','Period',handles.hygrometer.period,'ExecutionMode','fixedRate',...
        'TimerFcn',@(hObject,eventdata)hygrometer_callback(hObject,eventdata,handles));
    start(handles.hygrometer.timer);
  end

  guidata(hObject, handles);

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
  if(handles.hygrometer.on)
    stop(handles.hygrometer.timer);
    delete(handles.hygrometer.timer);
    if(handles.hygrometer.save)
      fclose(handles.hygrometer.fid);
    end
  end

  if(isvalid(handles.timer.update_display))
    stop(handles.timer.update_display);
    delete(handles.timer.update_display);
  end

%   if(isvalid(handles.timer.auto_turn_off))
%     stop(handles.timer.auto_turn_off);
%     delete(handles.timer.auto_turn_off);
%   end

  set(handles.StartStop,'string','start','backgroundColor',[0 1 0]);
  update_figure(handles);

  handles.running=0;
end

guidata(hObject, handles);

set(handles.StartStop,'enable','on');  drawnow('expose');


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
