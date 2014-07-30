function varargout = video(varargin)
% VIDEO MATLAB code for video.fig
%      VIDEO, by itself, creates a new VIDEO or raises the existing
%      singleton*.
%
%      H = VIDEO returns the handle to a new VIDEO or the handle to
%      the existing singleton*.
%
%      VIDEO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEO.M with the given input arguments.
%
%      VIDEO('Property','Value',...) creates a new VIDEO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before video_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to video_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help video

% Last Modified by GUIDE v2.5 30-Jul-2014 11:13:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @video_OpeningFcn, ...
                   'gui_OutputFcn',  @video_OutputFcn, ...
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


% --- Executes just before video is made visible.
function video_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to video (see VARARGIN)

% Choose default command line output for video
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes video wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = video_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in VideoSave.
function VideoSave_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSave

persistent directory2
if(isempty(directory2))  directory2=pwd;  end

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);

if(get(handles.VideoSave,'value'))
  tmp=uigetdir(directory2,'Select video directory');
  if(tmp~=0)
    omnivoreHandles.video.save(omnivoreHandles.video.curr)=1;
    omnivoreHandles.video.directory{omnivoreHandles.video.curr}=tmp;
    if omnivoreHandles.video.samedirectory==1
      omnivoreHandles.video.save=repmat(omnivoreHandles.video.save(omnivoreHandles.video.curr), 1, omnivoreHandles.video.n);
      omnivoreHandles.video.directory=repmat(omnivoreHandles.video.directory(omnivoreHandles.video.curr), 1, omnivoreHandles.video.n);
    end
    set(handles.VideoDirectory,'string',omnivoreHandles.video.directory{omnivoreHandles.video.curr});
    set(handles.VideoDirectory,'enable','on');
    set(handles.VideoTimeStamps,'enable','on');
    set(handles.VideoFileFormat,'enable','on');
    set(handles.VideoFileQuality,'enable','on');
    directory2=tmp;
  else
    set(handles.VideoSave,'value',0);
  end
else
  omnivoreHandles.video.save(omnivoreHandles.video.curr)=0;
  set(handles.VideoDirectory,'enable','off');
  set(handles.VideoTimeStamps,'enable','off');
  set(handles.VideoFileFormat,'enable','off');
  set(handles.VideoFileQuality,'enable','off');
end
guidata(handles.omnivore,omnivoreHandles);
guidata(hObject,handles);


% --- Executes on selection change in VideoChannel.
function VideoChannel_Callback(hObject, eventdata, handles)
% hObject    handle to VideoChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoChannel

omnivoreHandles = guidata(handles.omnivore);
if omnivoreHandles.running
  omnivoreHandles=omnivoreHandles.video_takedown_preview(omnivoreHandles);
end
omnivoreHandles.video.curr=get(handles.VideoChannel,'value');
if omnivoreHandles.running
  omnivoreHandles=omnivoreHandles.video_setup_preview(omnivoreHandles);
end
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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



function VideoFPS_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoFPS as text
%        str2double(get(hObject,'String')) returns contents of VideoFPS as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.FPS=str2num(get(hObject,'String'));
omnivoreHandles=omnivoreHandles.configure_video_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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

omnivoreHandles = guidata(handles.omnivore);
tmp=str2num(get(hObject,'String'));
if(tmp>omnivoreHandles.video.maxn)
  tmp=omnivoreHandles.video.maxn;
  set(hObject,'String',tmp);
end
omnivoreHandles.video.n=tmp;
omnivoreHandles.video.curr = min(omnivoreHandles.video.curr, omnivoreHandles.video.n);
omnivoreHandles=omnivoreHandles.configure_video_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on button press in VideoOnOff.
function VideoOnOff_Callback(hObject, eventdata, handles)
% hObject    handle to VideoOnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoOnOff

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.on=~omnivoreHandles.video.on;
omnivoreHandles=omnivoreHandles.configure_video_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


function VideoROI_Callback(hObject, eventdata, handles)
% hObject    handle to VideoROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoROI as text
%        str2double(get(hObject,'String')) returns contents of VideoROI as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.ROI{omnivoreHandles.video.curr}=str2num(get(hObject,'String'));
if omnivoreHandles.video.sameroi==1
  omnivoreHandles.video.ROI=repmat(omnivoreHandles.video.ROI(omnivoreHandles.video.curr), 1, omnivoreHandles.video.n);
end
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on selection change in VideoFormat.
function VideoFormat_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoFormat

omnivoreHandles = guidata(handles.omnivore);
i=handles.video.curr;
omnivoreHandles.video.formatvalue(i)=get(handles.VideoFormat,'value');
%handles.video.params{handles.video.curr}=[];
omnivoreHandles.video.params{i}=get_video_params(...
  omnivoreHandles.video.adaptor(i),...
  omnivoreHandles.video.deviceid(i),...
  omnivoreHandles.video.formatlist{i}{omnivoreHandles.video.formatvalue(i)});
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on selection change in VideoTrigger.
function VideoTrigger_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoTrigger contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoTrigger

omnivoreHandles = guidata(handles.omnivore);
if omnivoreHandles.video.syncpulseonly && (get(handles.VideoTrigger,'value')==1)
  set(handles.VideoTrigger,'value',2)
end
omnivoreHandles.video.counter=get(handles.VideoTrigger,'value');
omnivoreHandles=omnivoreHandles.configure_video_channels(omnivoreHandles);
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function VideoTrigger_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in VideoFileFormat.
function VideoFileFormat_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFileFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoFileFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoFileFormat

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.fileformat=get(handles.VideoFileFormat,'value');
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function VideoFileFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoFileFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VideoFileQuality_Callback(hObject, eventdata, handles)
% hObject    handle to VideoFileQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoFileQuality as text
%        str2double(get(hObject,'String')) returns contents of VideoFileQuality as a double

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.filequality=str2num(get(hObject,'String'));
guidata(handles.omnivore,omnivoreHandles);


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


% --- Executes on button press in VideoHistogram.
function VideoHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to VideoHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;

omnivoreHandles = guidata(handles.omnivore);

invoke(omnivoreHandles.video.actx(omnivoreHandles.video.curr), 'Execute', ...
    'im_cdata = get(im,''cdata'');');
im_cdata=omnivoreHandles.video.actx(omnivoreHandles.video.curr).GetVariable('im_cdata','base');
invoke(omnivoreHandles.video.actx(omnivoreHandles.video.curr), 'Execute', ...
    'nbands = vi.NumberOfBands;');
nbands=omnivoreHandles.video.actx(omnivoreHandles.video.curr).GetVariable('nbands','base');

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

% guidata(handles.omnivore,omnivoreHandles);
% guidata(hObject, handles);


% --- Executes on selection change in VideoTimeStamps.
function VideoTimeStamps_Callback(hObject, eventdata, handles)
% hObject    handle to VideoTimeStamps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VideoTimeStamps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VideoTimeStamps

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.timestamps=get(handles.VideoTimeStamps,'value');
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);


% --- Executes during object creation, after setting all properties.
function VideoTimeStamps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoTimeStamps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VideoSameDirectory.
function VideoSameDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSameDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSameDirectory

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);
if get(handles.VideoSameDirectory,'Value')
  questdlg('Copy directory to all other channels?','','Yes','No','No');
  if(strcmp(ans,'No'))
    omnivoreHandles.video.samedirectory=0;
    set(hObject,'Value',0);
    return;
  end
  omnivoreHandles.video.samedirectory=1;
  omnivoreHandles.video.save=repmat(omnivoreHandles.video.save(omnivoreHandles.video.curr), 1, omnivoreHandles.video.n);
  omnivoreHandles.video.directory=repmat(omnivoreHandles.video.directory(omnivoreHandles.video.curr), 1, omnivoreHandles.video.n);
else
  omnivoreHandles.video.samedirectory=0;
end
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in VideoSameROI.
function VideoSameROI_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSameROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSameROI

handles=guidata(hObject);
omnivoreHandles = guidata(handles.omnivore);
if get(handles.VideoSameROI,'Value')
  questdlg('Copy ROI to all other channels?','','Yes','No','No');
  if(strcmp(ans,'No'))
    omnivoreHandles.video.sameroi=0;
    set(hObject,'Value',0);
    return;
  end
  omnivoreHandles.video.sameroi=1;
  omnivoreHandles.video.ROI=repmat(omnivoreHandles.video.ROI(omnivoreHandles.video.curr), 1, omnivoreHandles.video.n);
else
  omnivoreHandles.video.sameroi=0;
end
guidata(handles.omnivore,omnivoreHandles);


% --- Executes on button press in VideoSyncPulseOnly.
function VideoSyncPulseOnly_Callback(hObject, eventdata, handles)
% hObject    handle to VideoSyncPulseOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VideoSyncPulseOnly

omnivoreHandles = guidata(handles.omnivore);
omnivoreHandles.video.syncpulseonly=get(handles.VideoSyncPulseOnly,'value');
if omnivoreHandles.video.syncpulseonly && (omnivoreHandles.video.counter==1)
  omnivoreHandles.video.counter=2;
  set(handles.VideoTrigger,'value',2)
end
omnivoreHandles.update_figure(omnivoreHandles);
guidata(handles.omnivore,omnivoreHandles);
guidata(hObject,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject);
