function varargout = analog(varargin)
% ANALOG MATLAB code for analog.fig
%      ANALOG, by itself, creates a new ANALOG or raises the existing
%      singleton*.
%
%      H = ANALOG returns the handle to a new ANALOG or the handle to
%      the existing singleton*.
%
%      ANALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALOG.M with the given input arguments.
%
%      ANALOG('Property','Value',...) creates a new ANALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analog

% Last Modified by GUIDE v2.5 30-Jul-2014 11:12:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analog_OpeningFcn, ...
                   'gui_OutputFcn',  @analog_OutputFcn, ...
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


% --- Executes just before analog is made visible.
function analog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analog (see VARARGIN)

% Choose default command line output for analog
handles.output = hObject;

handles.omnivore = varargin{find(strcmp(varargin, 'omnivore'))+1};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in AnalogInRecord.
function AnalogInRecord_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInRecord

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);

if(get(handles.AnalogInRecord,'value'))
  tmp=uigetdir(directory,'Select analog input directory');
  if(tmp~=0)
    omnivoreHandles.analog.in.record=1;
    omnivoreHandles.analog.in.directory=tmp;
    set(handles.AnalogInDirectory,'string',omnivoreHandles.analog.in.directory,'enable','on');
    set(handles.AnalogInFileFormat,'enable','on');
    directory=tmp;
  else
    set(handles.AnalogInRecord,'value',0);
  end
else
  omnivoreHandles.analog.in.record=0;
  set(handles.AnalogInDirectory,'enable','off');
  set(handles.AnalogInFileFormat,'enable','off');
end

guidata(handles.omnivore,omnivoreHandles);
guidata(hObject,handles);


% --- Executes on selection change in AnalogInChannel.
function AnalogInChannel_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInChannel

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.curr=get(handles.AnalogInChannel,'value');
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


function AnalogInNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInNumChannels as text
%        str2double(get(hObject,'String')) returns contents of AnalogInNumChannels as a double

omnivoreHandles = guidata(handles.omnivore);
tmp=str2num(get(hObject,'String'));
if(tmp>omnivoreHandles.analog.in.maxn)
  tmp=omnivoreHandles.analog.in.maxn;
  set(hObject,'String',tmp);
end
omnivoreHandles.analog.in.n=tmp;
omnivoreHandles.analog.in.curr = min(omnivoreHandles.analog.in.curr, omnivoreHandles.analog.in.n);
omnivoreHandles=omnivoreHandles.configure_analog_input_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on button press in AnalogInOnOff.
function AnalogInOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInOnOff

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.on=~omnivoreHandles.analog.in.on;
omnivoreHandles=omnivoreHandles.configure_analog_input_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on selection change in AnalogInRange.
function AnalogInRange_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInRange

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.range=get(hObject,'value');
omnivoreHandles=omnivoreHandles.configure_analog_input_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.terminal_configuration=get(hObject,'value');
omnivoreHandles=omnivoreHandles.configure_analog_input_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on selection change in AnalogInStyle.
function AnalogInStyle_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInStyle

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.style=get(hObject,'value');
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function AnalogInStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in AnalogInFileFormat.
function AnalogInFileFormat_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInFileFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogInFileFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogInFileFormat

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.fileformat=get(hObject,'value');
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function AnalogInFileFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogInFileFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AnalogInAutoScale.
function AnalogInAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInAutoScale

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.autoscale=~omnivoreHandles.analog.in.autoscale;
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in AnalogInLogScale.
function AnalogInLogScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInLogScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInLogScale

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.logscale=~omnivoreHandles.analog.in.logscale;
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in AnalogInOnePercent.
function AnalogInOnePercent_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInOnePercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogInOnePercent

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.onepercent=~omnivoreHandles.analog.in.onepercent;
guidata(handles.omnivore,omnivoreHandles);


function AnalogInHighFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInHighFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInHighFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogInHighFreq as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.highfreq=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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



function AnalogInLowFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInLowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInLowFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogInLowFreq as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.lowfreq=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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



function AnalogInNFFT_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogInNFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogInNFFT as text
%        str2double(get(hObject,'String')) returns contents of AnalogInNFFT as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.in.nfft=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on button press in AnalogOutPlay.
function AnalogOutPlay_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutPlay

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);

channel=omnivoreHandles.analog.out.curr;

if(get(handles.AnalogOutPlay,'value'))
  [filename,directory,~]=uigetfile(fullfile(directory,'*.wav'),['Select analog out channel' num2str(channel) 'file']);
  if(filename~=0)
    omnivoreHandles.analog.out.play(channel)=1;
    omnivoreHandles.analog.out.file{channel}=fullfile(directory,filename);
    [omnivoreHandles.analog.out.y{channel},omnivoreHandles.analog.out.fs(channel),~]=...
        wavread(omnivoreHandles.analog.out.file{channel});
    omnivoreHandles.analog.out.idx(channel)=1;
    set(handles.AnalogOutFile,'string',omnivoreHandles.analog.out.file(channel),'enable','on');
  else
    set(handles.AnalogOutPlay,'value',0);
  end
else
  omnivoreHandles.analog.out.play(channel)=0;
  set(handles.AnalogOutFile,'enable','off');
end

guidata(handles.omnivore,omnivoreHandles);
guidata(hObject,handles);


% --- Executes on selection change in AnalogOutChannel.
function AnalogOutChannel_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogOutChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogOutChannel

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.curr=get(hObject,'value');
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on button press in AnalogOutOnOff.
function AnalogOutOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutOnOff

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.on=~omnivoreHandles.analog.out.on;
omnivoreHandles=omnivoreHandles.configure_analog_output_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


function AnalogOutNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutNumChannels as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutNumChannels as a double

omnivoreHandles = guidata(handles.omnivore);
tmp=str2num(get(hObject,'String'));
if(tmp>omnivoreHandles.analog.out.maxn)
  tmp=omnivoreHandles.analog.out.maxn;
  set(hObject,'String',tmp);
end
omnivoreHandles.analog.out.n=tmp;
omnivoreHandles.analog.out.curr = min(omnivoreHandles.analog.out.curr, omnivoreHandles.analog.out.n);
omnivoreHandles=omnivoreHandles.configure_analog_output_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.range=get(hObject,'value');
omnivoreHandles=omnivoreHandles.configure_analog_output_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on selection change in AnalogOutStyle.
function AnalogOutStyle_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AnalogOutStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AnalogOutStyle

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.style=get(hObject,'value');
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function AnalogOutStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AnalogOutStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AnalogOutAutoScale.
function AnalogOutAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutAutoScale

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.autoscale=~omnivoreHandles.analog.out.autoscale;
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in AnalogOutLogScale.
function AnalogOutLogScale_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutLogScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutLogScale

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.logscale=~omnivoreHandles.analog.out.logscale;
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in AnalogOutOnePercent.
function AnalogOutOnePercent_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutOnePercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AnalogOutOnePercent

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.onepercent=~omnivoreHandles.analog.out.onepercent;
guidata(handles.omnivore,omnivoreHandles);


function AnalogOutHighFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutHighFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutHighFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutHighFreq as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.highfreq=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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



function AnalogOutLowFreq_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutLowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutLowFreq as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutLowFreq as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.lowfreq=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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



function AnalogOutNFFT_Callback(hObject, eventdata, handles)
% hObject    handle to AnalogOutNFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AnalogOutNFFT as text
%        str2double(get(hObject,'String')) returns contents of AnalogOutNFFT as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.analog.out.nfft=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject);
