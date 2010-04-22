function varargout = preview_wYAML_v9(varargin)
% PREVIEW_WYAML_V9 M-file for preview_wYAML_v9.fig
%      PREVIEW_WYAML_V9, by itself, creates a new PREVIEW_WYAML_V9 or raises the existing
%      singleton*.
%
%      H = PREVIEW_WYAML_V9 returns the handle to a new PREVIEW_WYAML_V9 or the handle to
%      the existing singleton*.
%
%      PREVIEW_WYAML_V9('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREVIEW_WYAML_V9.M with the given input arguments.
%
%      PREVIEW_WYAML_V9('Property','Value',...) creates a new PREVIEW_WYAML_V9 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preview_wYAML_v9_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preview_wYAML_v9_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preview_wYAML_v9

% Last Modified by GUIDE v2.5 15-Apr-2010 17:17:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preview_wYAML_v9_OpeningFcn, ...
                   'gui_OutputFcn',  @preview_wYAML_v9_OutputFcn, ...
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


% --- Executes just before preview_wYAML_v9 is made visible.
function preview_wYAML_v9_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preview_wYAML_v9 (see VARARGIN)

% Choose default command line output for preview_wYAML_v9
handles.output = hObject;

handles.CamFrameNumber = [];
handles.Head_data = []; 
handles.Tail_data = [];
handles.BoundaryAx_data = [];
handles.BoundaryAy_data = [];
handles.BoundaryBx_data = [];
handles.BoundaryBy_data = [];
handles.DLPIsOn_data = [];
handles.IllumSegCenter_data = [];
handles.IllumSegRadius_data = [];
handles.IllumNullLeftRightBoth_data = [];
handles.SegmentedCenterlinex_data = [];
handles.SegmentedCenterliney_data = [];
handles.FloodLightIsOn_data = [];
handles.IllumRectOrigin_data = [];
handles.IllumRectRadius_data = [];
handles.mmVidObj=[];

% Update handles structure
guidata(hObject, handles);

%Make sure dependencies are installed...
if isempty(which('newid','-all'))
    errordlg('You are missing a dependency. Please download newid from mathworks and follow the directions at http://www.mathworks.com/support/solutions/en/data/1-39UWQT/index.html?product=ML&solution=1-39UWQT');
    disp('http://www.mathworks.com/support/solutions/en/data/1-39UWQT/index.html?product=ML&solution=1-39UWQT');
end


% UIWAIT makes preview_wYAML_v9 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preview_wYAML_v9_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% SELECT FILE BUTTON
% --- Executes on button press in pushbutton1.
% This is the "load image button"
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    contents = get(handles.popupmenu1,'String') ;
	filetype = contents{get(handles.popupmenu1,'Value')};
    prefix = get(handles.edit_prefix, 'String');
    
    [filename,pathname]  = uigetfile({['*' filetype]}, 'select file', prefix);
    
    if ~strcmp(filetype, '.avi')
        tmp = zeros(1,length(filename)-4);
        for kk=1:length(filename)-4
            tmp(kk) = length(str2num(filename(kk)));
        end
        last_nondigit = find(~tmp, 1, 'last');  % position of last non-numeric character not including extension
        prefix = [pathname filename(1:last_nondigit)];
        numdigits = length(filename) - last_nondigit-4;
    else
        prefix = [pathname filename(1:end-4)];
        numdigits = 0;
        tmp = aviinfo([pathname filename]);
        numframes = tmp.NumFrames;
        set(handles.edit_numframes, 'String', num2str(numframes));
    end
    set(handles.edit_prefix, 'String', prefix);
    %Update the frame number from the box in the current frame
    current_HUDS_frame = str2num(get(handles.edit_currentframe, 'String'));
    numspec = ['%0' num2str(numdigits) 'd'];
    set(handles.edit15, 'String', numspec); 
        
        %Load in Videa with mmreader
       
    prefix = get(handles.edit_prefix, 'String');
    if strcmp(filetype, '.avi')
        filetype = contents{get(handles.popupmenu1,'Value')};
        handles.mmVidObj=mmreader([prefix filetype]);
        guidata(hObject, handles);
    end
    img = load_img(handles,current_HUDS_frame);   %1
    display_img(handles,img);

function out=load_img(handles,current_frame)
    contents = get(handles.popupmenu1,'String') ;
	filetype = contents{get(handles.popupmenu1,'Value')};
    prefix = get(handles.edit_prefix, 'String');
    numspec = get(handles.edit15, 'String');
    if (current_frame > 9999) && (strcmp(numspec, '%04d'))
        numspec = '%05d';
    end

    try
        if strcmp(filetype, '.avi')
            %read in the frame using multimedia reader object
            tempframe = read(handles.mmVidObj,current_frame);
            out = tempframe(:,:,1);
        else
            out = imread([prefix num2str(current_frame, numspec) filetype]);
        end
    catch
        disp('error');
    end

function display_img(handles,img)    
    current_frame = str2num(get(handles.edit_currentframe, 'String'));
        decim = str2num(get(handles.edit3, 'String'));
        if decim>1
            decim_filter = ones(decim,decim)/(decim*decim);
            img = imfilter(img, decim_filter, 'same');
            img = img(1:decim:end,1:decim:end);
        end
        
        if get(handles.checkbox4, 'Value')  % autoscale ON
             lim1=min(min(img));
             lim2=max(max(img));
        else
             lim1 = str2double(get(handles.edit8,'String'));
             lim2 = str2double(get(handles.edit9,'String'));
        end
        
        if get(handles.checkbox1, 'Value')  % increase brightness
            lim1=min(min(img));
            lim2 = lim1+ 0.1*(max(max(img)) - lim1);
        end

    if get(handles.docrop, 'Value')
        cropx1 = str2num(get(handles.cropx1, 'String'));
        cropx2 = str2num(get(handles.cropx2, 'String'));
        cropy1 = str2num(get(handles.cropy1, 'String'));
        cropy2 = str2num(get(handles.cropy2, 'String'));
    else
        cropx1 = 1;
        cropx2 = size(img,2);
        cropy1 = 1;
        cropy2 = size(img,1);
    end

    if ~get(handles.rotate90, 'Value')
       imagesc(img(cropy1:cropy2,cropx1:cropx2), [lim1 lim2]);

    else
       imagesc(img(cropy1:cropy2,cropx2:-1:cropx1)', [lim1 lim2]);
    end
       axis image;
        if get(handles.checkbox3, 'Value')
            colormap jet;
        else
            colormap gray;
        end
    drawnow;

% --- Executes on button press in pushbutton2.   % ANALYZE
function pushbutton2_Callback(hObject, eventdata, handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles)



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% point = get(gca,'CurrentPoint')


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




%
% ACCEPT KEYPRESS AND UPDATE IMAGE
%
% --- Executes on key press with focus on slider2 and no controls selected.
function slider2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.popupmenu1,'String') ;
filetype = contents{get(handles.popupmenu1,'Value')};

%the box tells us the current HUDS frame
current_frame = str2num(get(handles.edit_currentframe, 'String'));


 
prefix = get(handles.edit_prefix, 'String');
numspec = get(handles.edit15, 'String');

f=gcf;
val=double(get(f,'CurrentCharacter'));
% idx = str2num(get(handles.text2, 'String'));
    old_frame = current_frame;
     disp(val);
    switch val
        case 28  % left arrow
            current_frame=current_frame-1;
        case 29  % right arrow
            current_frame=current_frame+1;
        case 30  % up arrow
            current_frame=current_frame-10;
        case 31  % down arrow
            current_frame=current_frame+10;
        case 97  % A
            current_frame=current_frame-20;
        case 115  % S
            current_frame=current_frame+20;
        case 48  % 0
            current_frame=current_frame-100;
        case 46  % .
            current_frame=current_frame+100;
        case 49  % 1
            set(handles.edit_T1, 'String', num2str(current_frame));
        case 50  % 2
            set(handles.edit_T4, 'String', num2str(current_frame));
        case 103 %g
            hframe=str2num(char(newid('Go to HUDS frame number:','Jump to HUDS frame number')));
            mframe=find(handles.frameindex(:,1)==hframe);
            if ~isempty(mframe)
                current_frame=mframe;
            else
                msgbox('That number is not valid')
            end
        case 45 % -  (jump to previous DLP off->on event)
            %find all off->on events
            q=find(handles.dlpindex(:,3)==1);
            %Find the most recent off->on event
            current_frame = max(q(find(q<current_frame)));
            clear q;
        
        case 43 % +  (jump to next DLP off->on event)
            %find all off->on events
            q=find(handles.dlpindex(:,3)==1);
            %Find the next off->on event
            current_frame = min(q(find(q>current_frame)));
            clear q;
        case 109% m for magic
            buff=str2num(char(newid('Enter number of frames before and after dlp event:','Magically assign a temporal region of interest')));
            
            %find the nearest off->on event
            q=find(handles.dlpindex(:,3)==1)
            [blah, ind]=min(abs(q-current_frame))
            t2=q(ind);
            clear q;
            
            %find the subsequent on->off event
            q=find(handles.dlpindex(:,3)==-1);
            t3=min(q(find(q>t2)));
            clear q;
            t1=t2-buff;
            t4=t3+buff;
            
            
             set(handles.edit_T1, 'String', num2str(t1));
             set(handles.edit_T2, 'String', num2str(t2));
             set(handles.edit_T3, 'String', num2str(t3));
             set(handles.edit_T4, 'String', num2str(t4));
             
        otherwise
    end
    if isempty(current_frame)
        current_frame=old_frame;
    end
    if current_frame < 1  
        current_frame = 1;
    end
    set(handles.edit_currentframe, 'String', num2str(current_frame));
    
    %Find hframe (HUDS) corresponding to mframe (movie) and set that. 
    set(handles.HUDSFrame, 'String', num2str(handles.frameindex(current_frame,1)));

    try
        img = load_img(handles,current_frame);   
        display_img(handles,img);
        set(handles.status, 'String', 'OK');
    catch
        current_frame = old_frame;
        set(handles.edit_currentframe, 'String', num2str(current_frame));
        set(handles.status, 'String', 'Out of range or file error');
    end

        
function edit_T1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_T1 as text
%        str2double(get(hObject,'String')) returns contents of edit_T1 as a double


% --- Executes during object creation, after setting all properties.
function edit_T1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_T4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_T4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_T4 as text
%        str2double(get(hObject,'String')) returns contents of edit_T4 as a double


% --- Executes during object creation, after setting all properties.
function edit_T4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_T4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton3 and no controls selected.
function pushbutton3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_frame = str2num(get(handles.edit_currentframe, 'String'));
set(handles.edit_T1, 'String', num2str(current_frame));


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
current_frame = str2num(get(handles.edit_currentframe, 'String'));
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_T4, 'String', num2str(current_frame));

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton4.
function pushbutton4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton5.
function pushbutton5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3





function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
current_frame = str2num(get(handles.edit_currentframe, 'String'))
set(handles.edit_T2, 'String', num2str(current_frame));
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
current_frame = str2num(get(handles.edit_currentframe, 'String'))
% current_frame
set(handles.edit_T3, 'String', num2str(current_frame));
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_T2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_T2 as text
%        str2double(get(hObject,'String')) returns contents of edit_T2 as a double


% --- Executes during object creation, after setting all properties.
function edit_T2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_T3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_T3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_T3 as text
%        str2double(get(hObject,'String')) returns contents of edit_T3 as a double


% --- Executes during object creation, after setting all properties.
function edit_T3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_T3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton6.
function pushbutton6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('pushbutton8');
[x y] = ginput(1);
set(handles.edit6, 'String', num2str(round(x)));
set(handles.edit7, 'String', num2str(round(y)));




function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton8.
function pushbutton8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in docrop.
function docrop_Callback(hObject, eventdata, handles)
% hObject    handle to docrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of docrop



function cropy1_Callback(hObject, eventdata, handles)
% hObject    handle to cropy1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cropy1 as text
%        str2double(get(hObject,'String')) returns contents of cropy1 as a
%        double


% --- Executes during object creation, after setting all properties.
function cropy1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cropy1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cropy2_Callback(hObject, eventdata, handles)
% hObject    handle to cropy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cropy2 as text
%        str2double(get(hObject,'String')) returns contents of cropy2 as a double


% --- Executes during object creation, after setting all properties.
function cropy2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cropy2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cropx1_Callback(hObject, eventdata, handles)
% hObject    handle to cropx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cropx1 as text
%        str2double(get(hObject,'String')) returns contents of cropx1 as a double


% --- Executes during object creation, after setting all properties.
function cropx1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cropx1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cropx2_Callback(hObject, eventdata, handles)
% hObject    handle to cropx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cropx2 as text
%        str2double(get(hObject,'String')) returns contents of cropx2 as a double


% --- Executes during object creation, after setting all properties.
function cropx2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cropx2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in cropbutton.
function cropbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cropbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on;
pause;
zoom off;
cropx = xlim;
cropy = ylim;
set(handles.cropx1, 'String', num2str(round(cropx(1))));
set(handles.cropx2, 'String', num2str(round(cropx(2))));
set(handles.cropy1, 'String', num2str(round(cropy(1))));
set(handles.cropy2, 'String', num2str(round(cropy(2))));
set(handles.docrop, 'Value', 1);



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cropbutton.
function cropbutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cropbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rotate90.
function rotate90_Callback(hObject, eventdata, handles)
% hObject    handle to rotate90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate90





function edit_prefix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_prefix as text
%        str2double(get(hObject,'String')) returns contents of edit_prefix as a double
get(hObject,'String')

% --- Executes during object creation, after setting all properties.
function edit_prefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_currentframe_Callback(hObject, eventdata, handles)
% hObject    handle to edit_currentframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_currentframe as text
%        str2double(get(hObject,'String')) returns contents of edit_currentframe as a double


% --- Executes during object creation, after setting all properties.
function edit_currentframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currentframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton_play.
function pushbutton_play_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_frame = str2num(get(handles.edit_currentframe, 'String'));
istart = str2num(get(handles.edit_T1, 'String'));
iend = str2num(get(handles.edit_T4, 'String'));
iskip = str2num(get(handles.edit_skip, 'String'));
delay_time = str2num(get(handles.edit_delay, 'String'));
for i=istart:iskip:iend
    img = load_img(handles,i);
    display_img(handles,img);
    set(handles.edit_currentframe, 'String', num2str(i));
    pause(delay_time/1000);
end
set(handles.edit_currentframe, 'String', num2str(current_frame)); % restore original frame
img = load_img(handles,current_frame);
display_img(handles,img);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_delay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_delay as text
%        str2double(get(hObject,'String')) returns contents of edit_delay as a double


% --- Executes during object creation, after setting all properties.
function edit_delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_skip_Callback(hObject, eventdata, handles)
% hObject    handle to edit_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_skip as text
%        str2double(get(hObject,'String')) returns contents of edit_skip as a double


% --- Executes during object creation, after setting all properties.
function edit_skip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton_loadYAML.
function pushbutton_loadYAML_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadYAML (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% initialize or clear YAML-specific variables
% handles.CamFrameNumberYAML = [];
handles.YAML_data = [];

[ filename pathname ]  = uigetfile([get(handles.edit_prefix, 'String') '.yaml']);
yamlfile = [pathname filename];
set(handles.edit_yamlfile, 'String', yamlfile);

f = fopen(yamlfile, 'r');
disp(['Building index of ' yamlfile '...']);

%%%%%%%%
h = waitbar(0,'Building index');
flag = 0;
idx = 1;
linenumber = 0;
handles.frameindex = [];  
handles.dlpindex = [];
numframes = str2num(get(handles.edit_numframes, 'String'));
disp(['With ' num2str(numframes) '  frames']);
% Each row of frameindex contains this info:
% [ internal_frame_number, YAML_line_number, byte_position ]
while ~flag
    bytepos = ftell(f); % grab position BEFORE reading line
    line1 = fgetl(f);
    if ~isnumeric(line1)  % line1 = -1 at EOF
        linenumber = linenumber + 1;   
        line1_scan=textscan(line1, '%s');
        line1_scan = line1_scan{1};
        if strcmp(line1_scan{1}, 'FrameNumber:')
            framenumber = str2num(line1_scan{2});
            handles.frameindex(idx,:) = [framenumber linenumber bytepos] ;
                        %Everyso-often display the frame number we are workign onintermittantly
            if mod(idx, 100)==0 
                fprintf([num2str(idx) ' ']); 
            end
            if mod(idx, 2000)==0 
                fprintf('\n'); 
            end
            idx = idx+1;
            waitbar(idx/numframes)
        end
       %Now let's also check the status of the DLP... is it on or off?
       if strcmp(line1_scan{1},'DLPIsOn:')
           handles.dlpindex(idx-1,:)=[framenumber str2num(line1_scan{2})];
       end
           
    else
        flag = 1;  % END OF FILE
    end
end
%Make the third column be an index of when the dlp transitions
handles.dlpindex= [handles.dlpindex handles.dlpindex(:,2)-circshift(handles.dlpindex(:,2),1)]

fclose(f);
close(h);


numframes = size(handles.frameindex, 1);
fprintf('\n');
disp([num2str(numframes) ' frames found']);   
set(handles.edit_numframes, 'String', num2str(numframes));
guidata(hObject, handles); % Save the updated structure


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_yamlfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_yamlfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_yamlfile as text
%        str2double(get(hObject,'String')) returns contents of edit_yamlfile as a double


% --- Executes during object creation, after setting all properties.
function edit_yamlfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_yamlfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_analyzeT1T4.
function pushbutton_analyzeT1T4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analyzeT1T4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initialize or clear YAML-derived data variables
handles.CamFrameNumber = [];

handles.sElapsed_data = [];
handles.msRemElapsed_data = [];
handles.Head_data = []; 
handles.Tail_data = [];
handles.BoundaryAx_data = [];
handles.BoundaryAy_data = [];
handles.BoundaryBx_data = [];
handles.BoundaryBy_data = [];
handles.DLPIsOn_data = [];
handles.IllumSegCenter_data = [];
handles.IllumSegRadius_data = [];
handles.IllumNullLeftRightBoth_data = [];
handles.SegmentedCenterlinex_data = [];
handles.SegmentedCenterliney_data = [];
handles.ProtocolIsOn_data = [];
handles.ProtocolStep_data = [];

frame_start = str2num(get(handles.edit_T1,'String'));
frame_end = str2num(get(handles.edit_T4,'String'));

yamlfile = get(handles.edit_yamlfile, 'String');
f = fopen(yamlfile, 'r');
fseek(f, handles.frameindex(frame_start, 3), 'bof');
max_words_per_frame = 700;
tmp = textscan(f, '%s', max_words_per_frame* (frame_end - frame_start));
fclose(f);
% tmp
handles.YAML_data = tmp{1};
tmp2=find(strcmp(handles.YAML_data, 'FrameNumber:'));
YAMLline_start = 1;
YAMLline_end = tmp2(frame_end - frame_start + 2)-1;

numframes = str2num(get(handles.edit_numframes, 'String'));

disp(['Parsing yaml file over interval ' num2str(frame_start) '-' num2str(frame_end)]);
h = waitbar(0,'Parsing yaml file');
newframeline = [];
current_frame = 0;
for j=1:YAMLline_end
    switch(handles.YAML_data{j})
        case 'FrameNumber:'
            waitbar(j/YAMLline_end)
            current_frame = current_frame + 1;
            handles.CamFrameNumber(current_frame) = str2num(handles.YAML_data{j+1});
            if mod(current_frame,10)==0
                fprintf([num2str(current_frame) ' ']);
                if mod(current_frame,100)==0
                    fprintf('\n');
                end
            end
        case 'sElapsed:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.sElapsed_data(current_frame) = tmp{1};
        case 'msRemElapsed:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.msRemElapsed_data(current_frame) = tmp{1};
        case 'Head:'
            tmpx=textscan(handles.YAML_data{j+2}, '%d');
            tmpy=textscan(handles.YAML_data{j+4}, '%d');
            handles.Head_data(current_frame,:) = [tmpx{1} tmpy{1}];
        case 'Tail:'
            tmpx=textscan(handles.YAML_data{j+2}, '%d');
            tmpy=textscan(handles.YAML_data{j+4}, '%d');
            handles.Tail_data(current_frame,:) = [tmpx{1} tmpy{1}];
        case 'BoundaryA:'
            numdatapts = 2*str2num(handles.YAML_data{j+5});
            tmp = {handles.YAML_data{j+10:j+10+numdatapts-1}};
            tmp2 = zeros(1,numdatapts);
            for k=1:numdatapts
                tmp3=textscan(tmp{k}, '%d');
                tmp2(k) = tmp3{1};
            end
            handles.BoundaryAx_data(current_frame,:) = tmp2(1:2:end);
            handles.BoundaryAy_data(current_frame,:) = tmp2(2:2:end);
        case 'BoundaryB:'
            numdatapts = 2*str2num(handles.YAML_data{j+5});
            tmp = {handles.YAML_data{j+10:j+10+numdatapts-1}};
            tmp2 = zeros(1,numdatapts);
            for k=1:numdatapts
                tmp3=textscan(tmp{k}, '%d');
                tmp2(k) = tmp3{1};
            end
            handles.BoundaryBx_data(current_frame,:) = tmp2(1:2:end);
            handles.BoundaryBy_data(current_frame,:) = tmp2(2:2:end);
        case 'DLPIsOn:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.DLPIsOn_data(current_frame) = tmp{1};
        case 'FloodLightIsOn:'    
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.FloodLightIsOn_data(current_frame) = tmp{1};
        case 'IllumRectOrigin:'    
            tmp1=textscan(handles.YAML_data{j+2}, '%d');
            tmp2=textscan(handles.YAML_data{j+4}, '%d');
            handles.IllumRectOrigin_data(current_frame,:) = [tmp1{1} tmp2{1}];
        case 'IllumRectRadius:'    
            tmp1=textscan(handles.YAML_data{j+2}, '%d');
            tmp2=textscan(handles.YAML_data{j+4}, '%d');
            handles.IllumRectRadius_data(current_frame,:)  = [tmp1{1} tmp2{1}];
        case 'IllumSegCenter:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.IllumSegCenter_data(current_frame) = tmp{1};
        case 'IllumSegRadius:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.IllumSegRadius_data(current_frame) = tmp{1};
        case 'IllumNullLeftRightBoth:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.IllumNullLeftRightBoth_data(current_frame) = tmp{1};
        case 'SegmentedCenterline:'
%             disp(['j=' num2str(j) ' SegmentedCenterline:']);
            numdatapts = 2*str2num(handles.YAML_data{j+5});
            tmp = {handles.YAML_data{j+10:j+10+numdatapts-1}};
            tmp2 = zeros(1,numdatapts);
            for k=1:numdatapts
                tmp3=textscan(tmp{k}, '%d');
                tmp2(k) = tmp3{1};
            end
            handles.SegmentedCenterlinex_data(current_frame,:) = tmp2(1:2:end);
            handles.SegmentedCenterliney_data(current_frame,:) = tmp2(2:2:end);
        case 'ProtocolIsOn:'
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.ProtocolIsOn_data(current_frame) = tmp{1};
        case 'ProtocolStep:' 
            tmp=textscan(handles.YAML_data{j+1}, '%d');
            handles.ProtocolStep_data(current_frame) = tmp{1};
    end
end
fprintf('\n');
disp([num2str(current_frame) ' frames loaded']); 
close(h)
disp('handles.CamFrameNumber');
handles.CamFrameNumber


if get(handles.radiobutton_invert_headtail, 'Value') % switch head and tail
    handles.SegmentedCenterlinex_data = handles.SegmentedCenterlinex_data(:,end:-1:1);
    handles.SegmentedCenterliney_data = handles.SegmentedCenterliney_data(:,end:-1:1);

    tmp=handles.Head_data; 
    handles.Head_data = handles.Tail_data;
    handles.Tail_data = tmp;

end
disp('handles.DLPIsOn_data');
handles.DLPIsOn_data
figure(1);
subplot(421);
try
    area(handles.DLPIsOn_data);
end
title('DLPIsOn_data', 'Interpreter', 'None');
ylim([0 2]);
subplot(423);
try
    plot(handles.ProtocolStep_data, '-ob');
end
% ylim([0 4]);
title('ProtocolStep_data', 'Interpreter', 'None');
subplot(425);
try 
    area(handles.IllumSegCenter_data);
end
title('IllumSegCenter_data', 'Interpreter', 'None');
subplot(427);
try
    area(handles.IllumSegRadius_data);
end
title('IllumSegRadius_data', 'Interpreter', 'None');

figure(preview_wYAML_v9);
xlim0 = xlim;
ylim0 = ylim;

handles.lendata = [];
handles.cv2i_data = [];
handles.curvdata = [];

current_frame = str2num(get(handles.edit_currentframe, 'String'));
delay_time = str2num(get(handles.edit_delay, 'String'));
spline_p = str2num(get(handles.edit_spline_p, 'String'));
numcurvpts = str2num(get(handles.edit_numcurvpts, 'String'));
decim = str2num(get(handles.edit3, 'String'));
for absframe=frame_start:frame_end
    j = absframe - frame_start + 1;
    xy = [handles.SegmentedCenterlinex_data(j,:); ...
        handles.SegmentedCenterliney_data(j,:)];
    df = diff(xy,1,2); 
    t = cumsum([0, sqrt([1 1]*(df.*df))]); 
    cv = csaps(t,xy,spline_p);
    cv2 =  fnval(cv, t)';
    df2 = diff(cv2,1,1); df2p = df2';
    splen = cumsum([0, sqrt([1 1]*(df2p.*df2p))]);
    handles.lendata(j) = splen(end);
    % interpolate to equally spaced length units
    cv2i = interp1(splen+.00001*[0:length(splen)-1],cv2, [0:(splen(end)-1)/(numcurvpts+1):(splen(end)-1)]);
    handles.cv2i_data(k,:,:) = cv2i;
    df2 = diff(cv2i,1,1);
    atdf2 = unwrap(atan2(-df2(:,2), df2(:,1)));
    curv = unwrap(diff(atdf2,1)); 
    handles.curvdata(j,:) = curv';
    if get(handles.radiobutton_showimg, 'Value')
        img = load_img(handles,absframe);
        display_img(handles,img);
        hold on;
    end
    set(handles.edit_currentframe, 'String', num2str(absframe));
    plot(cv2i(:,1)/(2*decim), cv2i(:,2)/(2*decim), '-g');hold on;
    plot(cv2i(1,1)/(2*decim), cv2i(1,2)/(2*decim), 'or');hold off;
    axis ij;
    set(gca, 'Color', [0 0 0]);
    xlim(xlim0);
    ylim(ylim0);
    pause(.001);
    hold off; 
end
set(handles.edit_currentframe, 'String', num2str(current_frame)); % restore original frame
img = load_img(handles,current_frame);
display_img(handles,img); % restore original img

% handles.curvdata(176:end,:) = -handles.curvdata(176:end,end:-1:1);

figure(2);clf;
subplot(231);
max0 = max(max(abs(handles.curvdata * numcurvpts)));
imagesc(handles.curvdata * numcurvpts, [-10 10]); hold on;
colormap(redbluecmap(1)); 
%colorbar %took out colorbar because I don't think its necessary
seg1 = handles.IllumSegCenter_data - handles.IllumSegRadius_data;
seg2 = handles.IllumSegCenter_data + handles.IllumSegRadius_data;
T1 = str2num(get(handles.edit_T1, 'String'));
T2 = str2num(get(handles.edit_T2, 'String'));
T3 = str2num(get(handles.edit_T3, 'String'));

if T2 > T1
    plot([0 numcurvpts], [T2-T1 T2-T1], '--w');
end
if T3 > T1
    plot([0 numcurvpts], [T3-T1 T3-T1], '--w');
end


axesPosition = get(gca,'Position');          %# Get the current axes position
hNewAxes = axes('Position',axesPosition,...  %# Place a new axes on top...
                'Color','none',...           %#   ... with no background color 
                'YLim',[ handles.frameindex(str2num(get(handles.edit_T1, 'String')),1);...
                handles.frameindex(str2num(get(handles.edit_T4, 'String')),1)],...            %#   ... and a different scale
                'YAxisLocation','right',...  %#   ... located on the right
                'XTick',[]);                 %#   ... and with no x tick marks
ylabel(hNewAxes,'hframe');  %# Add a label to the right y axis




subplot(234);
imagesc(handles.curvdata>0 ); hold on;
plot_illum_lines(handles);
colorbar;

timefilter = 5;
bodyfilter = 5;
curvfilter = fspecial('average',[timefilter,bodyfilter]);
% handles.curvdatafiltered = imfilter(handles.curvdata,  curvfilter , 'replicate');
handles.curvdatafiltered = medfilt2(handles.curvdata,  [timefilter,bodyfilter] );
handles.curvdatafiltered_t = diff(handles.curvdatafiltered, 1, 1);
handles.curvdatafiltered_t_filtered = imfilter(handles.curvdatafiltered_t,  curvfilter , 'replicate');
subplot(232);
imagesc(handles.curvdatafiltered_t, [-.01 .01] ); hold on;
colormap(redbluecmap(1)); 
plot_illum_lines(handles);
colorbar;
subplot(235);
imagesc(handles.curvdatafiltered_t>0 ); hold on;
plot_illum_lines(handles);
colorbar;
subplot(233);
imagesc(handles.curvdatafiltered_t_filtered, [-.005 .005] ); hold on;
plot_illum_lines(handles);
colorbar;
subplot(236);
imagesc(handles.curvdatafiltered_t_filtered >0); hold on;
plot_illum_lines(handles);
colorbar;

guidata(hObject, handles);  % update GUI data
velocityanalysis(handles);



function plot_illum_lines(handles)
% disp('plot_illum_lines');
numcurvpts = str2num(get(handles.edit_numcurvpts, 'String'));
T1 = str2num(get(handles.edit_T1, 'String'));
T2 = str2num(get(handles.edit_T2, 'String'));
T3 = str2num(get(handles.edit_T3, 'String'));
if T2 > T1
    plot([0 numcurvpts], [T2-T1 T2-T1], '--w');
end
if T3 > T1
    plot([0 numcurvpts], [T3-T1 T3-T1], '--w');
end

function edit_numframes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numframes as text
%        str2double(get(hObject,'String')) returns contents of edit_numframes as a double


% --- Executes during object creation, after setting all properties.
function edit_numframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_export.
function pushbutton_export_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base', 'prefix', get(handles.edit_prefix, 'String'));
assignin('base', 'yamlfile', get(handles.edit_yamlfile, 'String'));
assignin('base', 'frameindex', handles.frameindex);
assignin('base', 'T1', str2num(get(handles.edit_T1, 'String')));
assignin('base', 'T2', str2num(get(handles.edit_T2, 'String')));
assignin('base', 'T3', str2num(get(handles.edit_T3, 'String')));
assignin('base', 'T4', str2num(get(handles.edit_T4, 'String')));
assignin('base', 'spline_p', str2num(get(handles.edit_spline_p, 'String')));
assignin('base', 'numcurvpts', str2num(get(handles.edit_numcurvpts, 'String')));
% assignin('base', 'CamFrameNumberYAML', handles.CamFrameNumberYAML);
assignin('base', 'sElapsed_data', handles.sElapsed_data);
assignin('base', 'msRemElapsed_data', handles.msRemElapsed_data);
assignin('base', 'Head_data', handles.Head_data);
assignin('base', 'Tail_data', handles.Tail_data);
assignin('base', 'BoundaryAx_data', handles.BoundaryAx_data);
assignin('base', 'BoundaryAy_data', handles.BoundaryAy_data);
assignin('base', 'BoundaryBx_data', handles.BoundaryBx_data);
assignin('base', 'BoundaryBy_data', handles.BoundaryBy_data);
assignin('base', 'DLPIsOn_data', handles.DLPIsOn_data);
assignin('base', 'IllumSegCenter_data', handles.IllumSegCenter_data);
assignin('base', 'IllumSegRadius_data', handles.IllumSegRadius_data);
assignin('base', 'IllumNullLeftRightBoth_data', handles.IllumNullLeftRightBoth_data);
assignin('base', 'SegmentedCenterlinex_data', handles.SegmentedCenterlinex_data);
assignin('base', 'SegmentedCenterliney_data', handles.SegmentedCenterliney_data);
assignin('base', 'ProtocolIsOn_data', handles.ProtocolIsOn_data);
assignin('base', 'ProtocolStep_data', handles.ProtocolStep_data);
assignin('base', 'lendata', handles.lendata);
assignin('base', 'cv2i_data', handles.cv2i_data);
assignin('base', 'curvdata', handles.curvdata);
assignin('base', 'curvdatafiltered', handles.curvdatafiltered);
assignin('base', 'curvdatafiltered_t', handles.curvdatafiltered_t);


%create a filenume that uses the HUDS frame number
tmp=[get(handles.edit_prefix, 'String') '_' ...
    num2str(handles.frameindex(str2num( get(handles.edit_T1, 'String') ),1))...
    '-' num2str(handles.frameindex(str2num( get(handles.edit_T4, 'String') ),1)) '.mat'];
[filename pathname ] = uiputfile('*.mat', tmp, tmp);
save([pathname filename]);

fnamefig = [pathname filename(1:end-4) '.tif'];
figure(2);
saveas(gcf,fnamefig, 'tif');

% 
% prefix = get(handles.edit_prefix, 'String');
% yamlfile = get(handles.edit_yamlfile, 'String');
% 
% T1 = str2num(get(handles.edit_T1, 'String'));
% T2 = str2num(get(handles.edit_T2, 'String'));
% T3 = str2num(get(handles.edit_T3, 'String'));
% T4 = str2num(get(handles.edit_T4, 'String'));
% 
% spline_p = str2num(get(handles.edit_spline_p, 'String'));
% numcurvpts = str2num(get(handles.edit_numcurvpts, 'String'));
% 
% CamFrameNumberYAML = handles.CamFrameNumberYAML;
% Head_data = handles.Head_data; 
% Tail_data=handles.Tail_data;
% BoundaryAx_data=handles.BoundaryAx_data;
% BoundaryAy_data=handles.BoundaryAy_data;
% BoundaryBx_data=handles.BoundaryBx_data;
% BoundaryBy_data=handles.BoundaryBy_data;
% DLPIsOn_data=handles.DLPIsOn_data;
% IllumSegCenter_data=handles.IllumSegCenter_data;
% IllumSegRadius_data=handles.IllumSegRadius_data;
% IllumNullLeftRightBoth_data=handles.IllumNullLeftRightBoth_data;
% SegmentedCenterlinex_data=handles.SegmentedCenterlinex_data;
% SegmentedCenterliney_data=handles.SegmentedCenterliney_data;

% assignin('base', 'handles', tmp_handles);


% --- Executes on button press in radiobutton_showimg.
function radiobutton_showimg_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_showimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_showimg




% --- Executes on button press in radiobutton_invert_headtail.
function radiobutton_invert_headtail_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_invert_headtail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_invert_headtail





function edit_spline_p_Callback(hObject, eventdata, handles)
% hObject    handle to edit_spline_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_spline_p as text
%        str2double(get(hObject,'String')) returns contents of edit_spline_p as a double


% --- Executes during object creation, after setting all properties.
function edit_spline_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_spline_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit_numcurvpts_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numcurvpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numcurvpts as text
%        str2double(get(hObject,'String')) returns contents of edit_numcurvpts as a double


% --- Executes during object creation, after setting all properties.
function edit_numcurvpts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numcurvpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton_autoT2.
function pushbutton_autoT2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_autoT2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d1 = diff(handles.DLPIsOn_data,1,2);
d2 = find(d1,2, 'first')
T1 = str2num(get(handles.edit_T1, 'String'));
switch length(d2)
    case 1
    set(handles.edit_T2, 'String', num2str(T1+d2));
    case 2
    set(handles.edit_T2, 'String', num2str(T1+d2(1)));
    set(handles.edit_T3, 'String', num2str(T1+d2(2)));
end

% --- Executes on button press in pushbutton_loadMAT.
function pushbutton_loadMAT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp=[get(handles.edit_prefix, 'String') '.mat'];
[filename pathname ] = uigetfile('*.mat', tmp, tmp);
load([pathname filename]);




function HUDSFrame_Callback(hObject, eventdata, handles)
% hObject    handle to HUDSFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HUDSFrame as text
%        str2double(get(hObject,'String')) returns contents of HUDSFrame as a double


% --- Executes during object creation, after setting all properties.
function HUDSFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HUDSFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
