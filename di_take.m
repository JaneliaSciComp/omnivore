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

handles.digital.in.on=0;
handles.digital.in.curr=nan;
handles.digital.in.record=0;
handles.digital.in.directory='';
handles.digital.in.clock.string='';
handles.digital.in.clock.port=[];
handles.digital.in.clock.terminal=[];
handles.digital.in.data.string='';
handles.digital.in.data.port=[];
handles.digital.in.data.terminal=[];
handles.digital.in.error.string='';
handles.digital.in.error.port=[];
handles.digital.in.error.terminal=[];
handles.digital.in.sync.string='';
handles.digital.in.sync.port=[];
handles.digital.in.sync.terminal=[];
handles.running=0;
handles.filename='';
handles.timelimit=0;
handles.verbose=true;


% ---
function handles=load_configuration_file(filename,handles)

handles_saved=load(filename);
handles_saved=handles_saved.handles;
handles.digital.in.on=handles_saved.digital.in.on;
handles.digital.in.curr=handles_saved.digital.in.curr;
handles.digital.in.record=handles_saved.digital.in.record;
handles.digital.in.directory=handles_saved.digital.in.directory;
handles.digital.in.clock.string=handles_saved.digital.in.clock.string;
handles.digital.in.clock.port=handles_saved.digital.in.clock.port;
handles.digital.in.clock.terminal=handles_saved.digital.in.clock.terminal;
handles.digital.in.data.string=handles_saved.digital.in.data.string;
handles.digital.in.data.port=handles_saved.digital.in.data.port;
handles.digital.in.data.terminal=handles_saved.digital.in.data.terminal;
handles.digital.in.error.string=handles_saved.digital.in.error.string;
handles.digital.in.error.port=handles_saved.digital.in.error.port;
handles.digital.in.error.terminal=handles_saved.digital.in.error.terminal;
handles.digital.in.sync.string=handles_saved.digital.in.sync.string;
handles.digital.in.sync.port=handles_saved.digital.in.sync.port;
handles.digital.in.sync.terminal=handles_saved.digital.in.sync.terminal;
handles.running=0;
handles.filename=handles_saved.filename;
handles.timelimit=handles_saved.timelimit;
handles.verbose=handles_saved.verbose;


% ---
function update_figure(handles)

set(handles.DigitalInOnOff,'value',handles.digital.in.on,'enable','on');
if(handles.digital.in.on)
  set(handles.DigitalInChannel,'string',[1:4]);
  set(handles.DigitalInChannel,'value',handles.digital.in.curr);
  set(handles.DigitalInDirectory,'string',handles.digital.in.directory);
  if(handles.digital.in.record)
    set(handles.DigitalInDirectory,'enable','on');
    set(handles.DigitalInRecord,'value',1);
  else
    set(handles.DigitalInDirectory,'enable','off');
    set(handles.DigitalInRecord,'value',0);
  end
  set(handles.DigitalInClock,'string',handles.digital.in.clock.string);
  set(handles.DigitalInData,'string',handles.digital.in.data.string);
  set(handles.DigitalInError,'string',handles.digital.in.error.string);
  set(handles.DigitalInSync,'string',handles.digital.in.sync.string);
  set(handles.DigitalInRecord,'enable','on');
  set(handles.DigitalInDirectory,'enable','on');
  set(handles.DigitalInXScale,'enable','on');
  set(handles.DigitalInYScale,'enable','on');
  set(handles.DigitalInChannel,'enable','on');
  set(handles.DigitalInClock,'enable','on');
  set(handles.DigitalInData,'enable','on');
  set(handles.DigitalInError,'enable','on');
  set(handles.DigitalInSync,'enable','on');
else
  set(handles.DigitalInRecord,'enable','off');
  set(handles.DigitalInDirectory,'enable','off');
  set(handles.DigitalInXScale,'enable','off');
  set(handles.DigitalInYScale,'enable','off');
  set(handles.DigitalInChannel,'enable','off');
  set(handles.DigitalInClock,'enable','off');
  set(handles.DigitalInData,'enable','off');
  set(handles.DigitalInError,'enable','off');
  set(handles.DigitalInSync,'enable','off');
end


% ---
function handles=configure_digital_input_channels(handles)

i=1;
while i<=length(handles.digital.session.Channels)
  if strcmp(class(handles.digital.session.Channels(i)),'daq.ni.DigitalInputChannel')
    handles.digital.session.removeChannel(i);
  else
    i=i+1;
  end
end

if(handles.digital.in.on)
  handles.digital.session.addDigitalChannel(handles.daqdevices.ID,'port0/line0:7','InputOnly');
  if((~isempty(handles.digital.in.clock.port)) && (length(handles.digital.session.Channels)>0))
    handles.digital.session.addClockConnection('External','PXI1Slot3/PFI7','ScanClock');
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

if(isfield(handles,'daqdevices'))
  handles.digital.session=daq.createSession('ni');
  handles.digital.session.IsContinuous=true;
  handles.digital.session.NotifyWhenDataAvailableExceeds=10000;
  %handles.digital.session.Rate=125000;
  handles=configure_digital_input_channels(handles);
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
  delete(handles.digital.session);
  handles.daqdevices=[];  handles.digital.session=[];  handles.listener1=[];
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
function digital_in_callback(src,evt,hObject)

persistent last_timestamp

handles=guidata(hObject);

if handles.verbose
  disp('entering digital_in_callback');
  tic
end

if(handles.digital.in.record)
  tmp=uint8(sum(bsxfun(@times,evt.Data,2.^(0:7)),2));
  fwrite(handles.digital.in.fid,tmp,'uint8');
end

%if(~isempty(last_timestamp))
%  tmp=round((evt.TimeStamps(1)-last_timestamp)*handles.analog.in.fs);
%  if(tmp~=1)
%    disp(['warning:  skipped ' num2str(tmp) ' analog input samples']);
%  end
%end
%last_timestamp=evt.TimeStamps(end);

DataT=evt.Data';

idx=find(evt.Data(:,handles.digital.in.clock.terminal+1));
idx=idx-handles.digital.in.clock.port;
idx=idx(1:(end-1));
idx=idx+2*(handles.digital.in.curr-1);

idx2=sub2ind(size(DataT),handles.digital.in.data.terminal+1,handles.digital.in.data.port+1);
tmp=arrayfun(@(i) DataT(sub2ind(size(DataT),1,i)+idx2-1)',idx,'uniformoutput',false);
sum(bsxfun(@times,[tmp{:}]',2.^(0:10)),2);
plot(handles.DigitalInPlot,ans,'k-');

%set(handles.DigitalInFs,'string',num2str((length(idx)-1)/(evt.TimeStamps(idx(end))-evt.TimeStamps(idx(1)))));

%axis(handles.AnalogInPlot,'tight');
%axis(handles.AnalogInPlot,'off');

tmp1=sum(evt.Data((idx(1)+handles.digital.in.error.port(1)):2:end,...
    handles.digital.in.error.terminal(1)+1));
tmp2=sum(evt.Data((idx(1)+handles.digital.in.error.port(2)):2:end,...
    handles.digital.in.error.terminal(2)+1));
handles.digital.in.error1=handles.digital.in.error1+tmp1;
set(handles.DigitalInError1,'string',num2str(handles.digital.in.error1));
handles.digital.in.error2=handles.digital.in.error2+tmp2;
set(handles.DigitalInError2,'string',num2str(handles.digital.in.error2));

%drawnow('expose')

if handles.verbose
  disp(['exiting  digital_in_callback: ' num2str(toc) 's']);
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
  set(handles.DigitalInOnOff,'enable','off');
  set(handles.DigitalInRecord,'enable','off');
  set(handles.DigitalInClock,'enable','off');
  set(handles.DigitalInData,'enable','off');
  set(handles.DigitalInError,'enable','off');
  set(handles.DigitalInSync,'enable','off');
  drawnow('expose');
  
  if(handles.digital.in.on)
    handles.digital.in.fid = nan;
    if(handles.digital.in.record)
      handles.digital.in.fid = fopen(fullfile(handles.digital.in.directory,[handles.filename 'd.bin']),'w');
      %version#, sample rate, nchan
      %fwrite(handles.digital.in.fid,[1 handles.analog.in.fs handles.analog.in.n],'double');
    end
    handles.digital.in.error1=0;
    handles.digital.in.error2=0;
    handles.listenerDigitalIn=handles.digital.session.addlistener('DataAvailable',...
        @(hObject,eventdata)digital_in_callback(hObject,eventdata,handles.figure1));
  end

  guidata(hObject, handles);

  if(handles.digital.in.on)
    handles.digital.session.startBackground;
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
  if(handles.digital.in.on)
    handles.digital.session.stop();
  end

  if(handles.digital.in.on)
    delete(handles.listenerDigitalIn);
    if(handles.digital.in.record)
      fclose(handles.digital.in.fid);
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

handles.digital.in.clock.string=get(hObject,'String');
tmp=sscanf(handles.digital.in.clock.string,'%d.%d');
handles.digital.in.clock.port=tmp(1);
handles.digital.in.clock.terminal=tmp(2);
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

handles.digital.in.data.string=get(hObject,'String');
tmp=sscanf(handles.digital.in.data.string,'%d.%d-%d,%d.%d-%d');
handles.digital.in.data.terminal=[tmp(2):tmp(3) tmp(5):tmp(6)];
handles.digital.in.data.port=[repmat(tmp(1),1,tmp(3)-tmp(2)+1) repmat(tmp(4),1,tmp(6)-tmp(5)+1)];
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



function DigitalInError_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInError (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInError as text
%        str2double(get(hObject,'String')) returns contents of DigitalInError as a double

handles.digital.in.error.string=get(hObject,'String');
tmp=sscanf(handles.digital.in.error.string,'%d.%d-%d');
handles.digital.in.error.terminal=tmp(2):tmp(3);
handles.digital.in.error.port=repmat(tmp(1),1,length(handles.digital.in.error.terminal));
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

handles.digital.in.sync.string=get(hObject,'String');
tmp=sscanf(handles.digital.in.sync.string,'%d.%d');
handles.digital.in.sync.port=tmp(1);
handles.digital.in.sync.terminal=tmp(2);
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
