function varargout = digital(varargin)
% DIGITAL MATLAB code for digital.fig
%      DIGITAL, by itself, creates a new DIGITAL or raises the existing
%      singleton*.
%
%      H = DIGITAL returns the handle to a new DIGITAL or the handle to
%      the existing singleton*.
%
%      DIGITAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGITAL.M with the given input arguments.
%
%      DIGITAL('Property','Value',...) creates a new DIGITAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before digital_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to digital_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help digital

% Last Modified by GUIDE v2.5 22-Aug-2014 15:21:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @digital_OpeningFcn, ...
                   'gui_OutputFcn',  @digital_OutputFcn, ...
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


% --- Executes just before digital is made visible.
function digital_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to digital (see VARARGIN)

% Choose default command line output for digital
handles.output = hObject;

handles.omnivore = varargin{find(strcmp(varargin, 'omnivore'))+1};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes digital wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = digital_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DigitalInRecord.
function DigitalInRecord_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalInRecord

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);

if(get(handles.DigitalInRecord,'value'))
  tmp=uigetdir(directory,'Select digital input directory');
  if(tmp~=0)
    omnivoreHandles.digital.in.record=1;
    omnivoreHandles.digital.in.directory=tmp;
    set(handles.DigitalInDirectory,'string',omnivoreHandles.digital.in.directory,'enable','on');
    directory=tmp;
  else
    set(handles.DigitalInRecord,'value',0);
  end
else
  omnivoreHandles.digital.in.record=0;
  set(handles.DigitalInDirectory,'enable','off');
end

guidata(handles.omnivore,omnivoreHandles);
guidata(hObject,handles);


function DigitalInNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalInNumChannels as text
%        str2double(get(hObject,'String')) returns contents of DigitalInNumChannels as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
tmp=str2num(get(hObject,'String'));
tmp2=min([tmp omnivoreHandles.digital.in.maxn]);
if(omnivoreHandles.digital.out.on)
  tmp2=min([tmp2 omnivoreHandles.digital.in.maxn-omnivoreHandles.digital.out.n]);
end
if(tmp2~=tmp)
  tmp=tmp2;
  warndlg(['the sum of the number of input and output channels must not exceed ' num2str(omnivoreHandles.digital.in.maxn)]);
  set(hObject,'String',tmp);
end
omnivoreHandles.digital.in.n=tmp;
omnivoreHandles=omnivoreHandles.configure_digital_channels(omnivoreHandles);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function DigitalInNumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
omnivoreHandles.digital.in.on=~omnivoreHandles.digital.in.on;
if(omnivoreHandles.digital.in.on && omnivoreHandles.digital.out.on)
  tmp=omnivoreHandles.digital.in.n + omnivoreHandles.digital.out.n;
  if(tmp>omnivoreHandles.digital.in.maxn)
    omnivoreHandles.digital.in.n=omnivoreHandles.digital.in.maxn-omnivoreHandles.digital.out.n;
    set(handles.DigitalInNumChannels,'string',omnivoreHandles.digital.in.n);
  end
end
omnivoreHandles=omnivoreHandles.configure_digital_channels(omnivoreHandles);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on selection change in DigitalInStyle.
function DigitalInStyle_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DigitalInStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DigitalInStyle

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
omnivoreHandles.digital.in.style=get(hObject,'value');
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function DigitalInStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalInStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DigitalInAutoScale.
function DigitalInAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalInAutoScale

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.digital.in.autoscale=~omnivoreHandles.digital.in.autoscale;
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in DigitalOutPlay.
function DigitalOutPlay_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalOutPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalOutPlay

persistent directory
if(isempty(directory))  directory=pwd;  end

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);

if(get(handles.DigitalOutPlay,'value'))
  [filename,directory,~]=uigetfile(fullfile(directory,'*.wav'),['Select digital out file']);
  if(filename~=0)
    omnivoreHandles.digital.out.play=1;
    omnivoreHandles.digital.out.file=fullfile(directory,filename);
    [omnivoreHandles.digital.out.y, omnivoreHandles.digital.out.fs]=...
        audioread(omnivoreHandles.digital.out.file,'native');
    omnivoreHandles.digital.out.idx=1;
    set(handles.DigitalOutFile,'string',omnivoreHandles.digital.out.file,'enable','on');
    audioinfo(omnivoreHandles.digital.out.file);
    if(ans.BitsPerSample<omnivoreHandles.digital.out.n)
      warndlg('this file contains fewer bits per sample than the desired number of channels');
    end
  else
    set(handles.DigitalOutPlay,'value',0);
  end
else
  omnivoreHandles.digital.out.play=0;
  set(handles.DigitalOutFile,'enable','off');
end

omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);
guidata(hObject,handles);


% --- Executes on button press in DigitalOutOnOff.
function DigitalOutOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalOutOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalOutOnOff

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
omnivoreHandles.digital.out.on=~omnivoreHandles.digital.out.on;
if(omnivoreHandles.digital.out.on && omnivoreHandles.digital.in.on)
  tmp=omnivoreHandles.digital.out.n + omnivoreHandles.digital.in.n;
  if(tmp>omnivoreHandles.digital.out.maxn)
    omnivoreHandles.digital.out.n=omnivoreHandles.digital.out.maxn-omnivoreHandles.digital.in.n;
    set(handles.DigitalOutNumChannels,'string',omnivoreHandles.digital.out.n);
  end
end
omnivoreHandles=omnivoreHandles.configure_digital_channels(omnivoreHandles);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);


function DigitalOutNumChannels_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalOutNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DigitalOutNumChannels as text
%        str2double(get(hObject,'String')) returns contents of DigitalOutNumChannels as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
tmp=str2num(get(hObject,'String'));
tmp2=min([tmp omnivoreHandles.digital.out.maxn]);
if(omnivoreHandles.digital.in.on)
  tmp2=min([tmp2 omnivoreHandles.digital.out.maxn-omnivoreHandles.digital.in.n]);
end
if(tmp2~=tmp)
  tmp=tmp2;
  warndlg(['the sum of the number of input and output channels must not exceed ' num2str(omnivoreHandles.digital.out.maxn)]);
  set(hObject,'String',tmp);
end
omnivoreHandles.digital.out.n=tmp;
omnivoreHandles=omnivoreHandles.configure_digital_channels(omnivoreHandles);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function DigitalOutNumChannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalOutNumChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DigitalOutStyle.
function DigitalOutStyle_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalOutStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DigitalOutStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DigitalOutStyle

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
omnivoreHandles.digital.out.style=get(hObject,'value');
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function DigitalOutStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DigitalOutStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DigitalOutAutoScale.
function DigitalOutAutoScale_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalOutAutoScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalOutAutoScale

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.digital.out.autoscale=~omnivoreHandles.digital.out.autoscale;
guidata(handles.omnivore,omnivoreHandles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);


% --- Executes on button press in DigitalInDirection.
function DigitalDirection_Callback(hObject, eventdata, handles)
% hObject    handle to DigitalInDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DigitalInDirection

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,false);
omnivoreHandles.digital.direction=~omnivoreHandles.digital.direction;
omnivoreHandles=omnivoreHandles.configure_digital_channels(omnivoreHandles);
omnivoreHandles = omnivoreHandles.update_figure(omnivoreHandles,true);
guidata(handles.omnivore,omnivoreHandles);
