function varargout = chrimson(varargin)
% CHRIMSON MATLAB code for chrimson.fig
%      CHRIMSON, by itself, creates a new CHRIMSON or raises the existing
%      singleton*.
%
%      H = CHRIMSON returns the handle to a new CHRIMSON or the handle to
%      the existing singleton*.
%
%      CHRIMSON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHRIMSON.M with the given input arguments.
%
%      CHRIMSON('Property','Value',...) creates a new CHRIMSON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chrimson_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chrimson_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chrimson

% Last Modified by GUIDE v2.5 29-Aug-2014 15:15:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chrimson_OpeningFcn, ...
                   'gui_OutputFcn',  @chrimson_OutputFcn, ...
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

handles.counter.maxn=nan;
handles.counter.n=nan;
handles.counter.curr=nan;
handles.counter.frequency=[];
handles.counter.intensity=[];
handles.counter.timing={};
handles.counter.repeat=[];

handles.running=0;
handles.timelimit=0;
handles.verbose=0;
handles.daq=1;


% ---
function handles=load_configuration_file(filename,handles)

handles_saved=load(filename);
handles_saved=handles_saved.handles;
handles.counter.maxn=handles_saved.counter.maxn;
handles.counter.n=handles_saved.counter.n;
handles.counter.curr=handles_saved.counter.curr;
handles.counter.frequency=handles_saved.counter.frequency;
handles.counter.intensity=handles_saved.counter.intensity;
handles.counter.timing=handles_saved.counter.timing;
handles.counter.repeat=handles_saved.counter.repeat;

handles.running=0;
handles.timelimit=handles_saved.timelimit;
handles.verbose=handles_saved.verbose;
handles.daq=handles_saved.daq;


% ---
function update_figure(handles)

set(handles.CounterNumChannels,'enable','off');
set(handles.CounterChannel,'enable','off');
set(handles.CounterFrequency,'enable','off');
set(handles.CounterIntensity,'enable','off');
set(handles.CounterTiming,'enable','off');
set(handles.CounterRepeat,'enable','off');
set(handles.CounterNumChannels,'string',num2str(handles.counter.n));
set(handles.CounterChannel,'string',[1:handles.counter.n]);
set(handles.CounterChannel,'value',handles.counter.curr);
set(handles.CounterFrequency,'string',num2str(handles.counter.frequency(handles.counter.curr)));
set(handles.CounterIntensity,'string',num2str(handles.counter.intensity(handles.counter.curr)));
set(handles.CounterTiming,'string',num2str(handles.counter.timing{handles.counter.curr},'%g,'));
set(handles.CounterRepeat,'value',handles.counter.repeat(handles.counter.curr));
if(~handles.running)
  set(handles.CounterNumChannels,'enable','on');
  set(handles.CounterChannel,'enable','on');
  set(handles.CounterFrequency,'enable','on');
  set(handles.CounterIntensity,'enable','on');
  set(handles.CounterTiming,'enable','on');
  set(handles.CounterRepeat,'enable','on');
end

set(handles.TimeLimit,'enable','off','string',num2str(handles.timelimit));
set(handles.VerboseLevel,'enable','off','value',handles.verbose+1);
set(handles.DAQ,'enable','off','value',handles.daq);
if(~handles.running)
  set(handles.TimeLimit,'enable','on');
  set(handles.VerboseLevel,'enable','on');
  set(handles.DAQ,'enable','on');
end

set(handles.StartStop,'enable','on');
if(~handles.running)
  set(handles.StartStop,'string','start','backgroundColor',[0 1 0]);
else
  set(handles.StartStop,'string','stop','backgroundColor',[1 0 0]);
end


% ---
function handles=configure_counter_channels(handles)

for(i=1:handles.counter.maxn)
  handles.counter.session(i)=daq.createSession('ni');
  handles.counter.session(i).addCounterOutputChannel(handles.daqdevices.ID, i-1, 'PulseGeneration');
end


% ---
function handles=query_hardware(handles)

try
  % next two lines only needed for roian's rig, and prohibit using chr & hyg simultaneously
  % daq.reset;
  % daq.HardwareInfo.getInstance('DisableReferenceClockSynchronization',true);
  tmp=daq.getDevices;
  set(handles.DAQ,'string',{tmp.ID});
  handles.daq=min(length(tmp),handles.daq);
  handles.daqdevices=tmp(handles.daq);
catch
  uiwait(warndlg('no digitizer found'));
end

if(isfield(handles,'daqdevices'))
  idx=find(cellfun(@(x) strcmp(x,'CounterOutput'),{handles.daqdevices.Subsystems.SubsystemType}),1,'first');
  if(~isempty(idx) && (handles.counter.maxn~=handles.daqdevices.Subsystems(idx).NumberOfChannelsAvailable))
    handles.counter.maxn=handles.daqdevices.Subsystems(idx).NumberOfChannelsAvailable;
    handles.counter.n=handles.counter.maxn;
    handles.counter.curr=1;
    handles.counter.frequency=nan(1,handles.counter.maxn);
    handles.counter.intensity=nan(1,handles.counter.maxn);
    handles.counter.repeat=zeros(1,handles.counter.maxn);
    for(i=1:handles.counter.maxn)
      handles.counter.timing{i}=nan;
    end
  end
  handles=configure_counter_channels(handles);
end


% --- Executes just before chrimson is made visible.
function chrimson_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chrimson (see VARARGIN)

handles.rcfilename = 'most_recent_chr_config.mat';
if(exist(handles.rcfilename)==2)
  handles=load_configuration_file(handles.rcfilename,handles);
else
  handles=initialize(handles);
end

handles=query_hardware(handles);

% Choose default command line output for chrimson
handles.output = hObject;

set(hObject,'CloseRequestFcn',@figure_CloseRequestFcn);

update_figure(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes chrimson wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ---
function save_config_file(handles,filename)

tmp=fieldnames(handles);
for(i=1:length(tmp))
  if(isnumeric(handles.(tmp{i})) && (numel(handles.(tmp{i}))==1)&& (handles.(tmp{i})>0) && ishandle(handles.(tmp{i})))
    handles=rmfield(handles,tmp{i});
  end
end

if isfield(handles, 'timer')
  handles = rmfield(handles, 'timer');
end
if isfield(handles, 'daqdevices')
  handles = rmfield(handles, 'daqdevices');
end
if isfield(handles.counter, 'session')
  handles.counter = rmfield(handles.counter, 'session');
end
if isfield(handles.counter, 'timers')
  handles.counter = rmfield(handles.counter, 'timers');
end

save(filename,'handles');


% --- Outputs from this function are returned to the command line.
function varargout = chrimson_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% ---
function display_callback(src,evt,handles)

if handles.verbose>1
  disp('entering counter display_callback');
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

drawnow('expose');

if handles.verbose>1
  disp(['exiting  counter display_callback:    ' num2str(toc) 's']);
end


% ---
function counter_callback(src,evt,handles,i,j)

if handles.verbose>1
  disp('entering counter_callback');
  tic
end

handles.counter.session(i).Channels.Frequency=handles.counter.frequency(i);
handles.counter.session(i).DurationInSeconds=handles.counter.timing{i}(2*j)*60;
handles.counter.session(i).Channels.DutyCycle=handles.counter.intensity(i)/100;
handles.counter.session(i).startBackground;

drawnow('expose');

if handles.verbose>1
  disp(['exiting  counter display_callback:    ' num2str(toc) 's']);
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
  if(any(isnan(handles.counter.frequency(1:handles.counter.n))))
    uiwait(errordlg('frequency must be a positive integer'));
    set(handles.StartStop,'enable','on');  drawnow('expose');
    return;
  end
  if(any(isnan(handles.counter.intensity(1:handles.counter.n))))
    uiwait(errordlg('intensity must be between 0 and 100'));
    set(handles.StartStop,'enable','on');  drawnow('expose');
    return;
  end
  for(i=1:handles.counter.n)
    if(any(isnan(handles.counter.timing{i})))
      uiwait(errordlg('timing must non be NaN'));
      set(handles.StartStop,'enable','on');  drawnow('expose');
      return;
    end
  end
  
  handles.running=1;
  handles.triggertime=clock;

  handles.counter.timers={};
  for(i=1:handles.counter.n)
    tmp=cumsum(handles.counter.timing{i});
    handles.counter.timers{i}={};
    for(j=1:floor(length(tmp)/2))
      tmp2 = 'singleShot';
      if(handles.counter.repeat(i))
        tmp2 = 'fixedRate';
      end
      handles.counter.timers{i}{j}=timer('Name',['counter' num2str(i) '.' num2str(j)],...
          'ExecutionMode', tmp2,...
          'Period',60*tmp(end), 'StartDelay',60*tmp(2*j-1),...
          'TimerFcn',@(hObject,eventdata)counter_callback(hObject,eventdata,handles,i,j));
    end
  end
  handles.timer.update_display=timer('Name','update display','Period',1,'ExecutionMode','fixedRate',...
      'TimerFcn',@(hObject,eventdata)display_callback(hObject,eventdata,handles));

  for(i=1:length(handles.counter.timers))
    for(j=1:length(handles.counter.timers{i}))
      start(handles.counter.timers{i}{j});
    end
  end
  start(handles.timer.update_display);

elseif(handles.running)
  if(isvalid(handles.timer.update_display))
    stop(handles.timer.update_display);
    delete(handles.timer.update_display);
  end
  for(i=1:length(handles.counter.timers))
    for(j=1:floor(length(handles.counter.timers{i})))
      if(isvalid(handles.counter.timers{i}{j}))
        stop(handles.counter.timers{i}{j});
        delete(handles.counter.timers{i}{j});
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


% --- Executes on selection change in VerboseLevel.
function VerboseLevel_Callback(hObject, eventdata, handles)
% hObject    handle to VerboseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VerboseLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VerboseLevel
handles.verbose=-1+get(hObject,'value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function VerboseLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VerboseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
persistent directory
if isempty(directory)  directory=pwd;  end

[file,directory]=uigetfile(fullfile(directory,'*.mat'),'Select configuration file to open');
if(isnumeric(file) && isnumeric(directory) && (file==0) && (directory==0))  return;  end
handles=load_configuration_file(fullfile(directory,file),handles);
handles=configure_counter_channels(handles);
update_figure(handles);
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
questdlg('Reset configuration to default?','','Yes','No','No');
if(strcmp(ans,'No'))  return;  end
handles=initialize(handles);
handles=query_hardware(handles);
update_figure(handles);
guidata(hObject, handles);



function CounterNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to CounterNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CounterNumChannels as text
%        str2double(get(hObject,'String')) returns contents of CounterNumChannels as a double
tmp=str2num(get(hObject,'String'));
if(tmp>handles.counter.maxn)
  tmp=handles.counter.maxn;
  set(hObject,'String',tmp);
end
handles.counter.n=tmp;
handles.counter.curr = min(handles.counter.curr, handles.counter.n);
handles=configure_counter_channels(handles);
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function CounterNumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CounterNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CounterChannel.
function CounterChannel_Callback(hObject, eventdata, handles)
% hObject    handle to CounterChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CounterChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CounterChannel
handles.counter.curr=get(hObject,'value');
update_figure(handles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function CounterChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CounterChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CounterFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to CounterFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CounterFrequency as text
%        str2double(get(hObject,'String')) returns contents of CounterFrequency as a double
str2num(get(hObject,'string'));
tmp=max(0,ans);
handles.counter.frequency(handles.counter.curr)=tmp;
set(hObject,'string',tmp);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function CounterFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CounterFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CounterIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to CounterIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CounterIntensity as text
%        str2double(get(hObject,'String')) returns contents of CounterIntensity as a double
str2num(get(hObject,'string'));
tmp=max(0,min(100,ans));
handles.counter.intensity(handles.counter.curr)=tmp;
set(hObject,'string',tmp);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function CounterIntensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CounterIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CounterTiming_Callback(hObject, eventdata, handles)
% hObject    handle to CounterTiming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CounterTiming as text
%        str2double(get(hObject,'String')) returns contents of CounterTiming as a double
handles.counter.timing{handles.counter.curr}=str2num(get(hObject,'string'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function CounterTiming_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CounterTiming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CounterRepeat.
function CounterRepeat_Callback(hObject, eventdata, handles)
% hObject    handle to CounterRepeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CounterRepeat
handles.counter.repeat(handles.counter.curr)=~handles.counter.repeat(handles.counter.curr);
guidata(hObject,handles);


% --- Executes when user attempts to close figure1.
function figure_CloseRequestFcn(hObject, eventdata)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles=guidata(hObject);
if(handles.running)
  if(strcmp('no',questdlg('a recording is in progress.  force quit?','','yes','no','no')))
    return;
  end
  for(i=1:length(handles.counter.timers))
    for(j=1:floor(length(handles.counter.timers{i})))
      if(isvalid(handles.counter.timers{i}{j}))
        stop(handles.counter.timers{i}{j});
        delete(handles.counter.timers{i}{j});
      end
    end
  end
end
save_config_file(handles,handles.rcfilename);
delete(hObject);


% --- Executes on selection change in DAQ.
function DAQ_Callback(hObject, eventdata, handles)
% hObject    handle to DAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DAQ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DAQ

handles.daq=get(hObject,'value');

for(i=1:handles.counter.maxn)
  delete(handles.counter.session(i));
end

handles=query_hardware(handles);
update_figure(handles);

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
