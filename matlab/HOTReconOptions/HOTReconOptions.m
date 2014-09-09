function varargout = HOTReconOptions(varargin)
% HOTRECONOPTIONS MATLAB code for HOTReconOptions.fig
%      HOTRECONOPTIONS, by itself, creates a new HOTRECONOPTIONS or raises the existing
%      singleton*.
%
%      H = HOTRECONOPTIONS returns the handle to a new HOTRECONOPTIONS or the handle to
%      the existing singleton*.
%
%      HOTRECONOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOTRECONOPTIONS.M with the given input arguments.
%
%      HOTRECONOPTIONS('Property','Value',...) creates a new HOTRECONOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HOTReconOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HOTReconOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HOTReconOptions

% Last Modified by GUIDE v2.5 02-Sep-2014 11:25:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HOTReconOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @HOTReconOptions_OutputFcn, ...
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


% --- Executes just before HOTReconOptions is made visible.
function HOTReconOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HOTReconOptions (see VARARGIN)

% Choose default command line output for HOTReconOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% populate all of the GUI entries
populateGUIEntries(handles);

% UIWAIT makes HOTReconOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HOTReconOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

    % reconstruct as an image (fermi filtered) or 2D spectrum (no filtering)
% data_type=getHOTReconOption('data_type');
if get(handles.popupmenu1,'Value') == 1
    setHOTReconOption('data_type','2D spectra');
elseif get(handles.popupmenu1,'Value') == 2
    setHOTReconOption('data_type','images');
else
    warning(cell2str(strcat({'"',data_type,'" is an invalid value for option "data_type"'})));
end

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

function populateGUIEntries(handles)
    % which echoes to average
    set(handles.edit1,'String',num2str(getHOTReconOption('num_echoes_avg')));
    
    % reconstruct as an image (fermi filtered) or 2D spectrum (no filtering)
    data_type=getHOTReconOption('data_type');
    if strcmp(data_type,'2D spectra')
        set(handles.popupmenu1,'Value',1);
    elseif strcmp(data_type,'images')
        set(handles.popupmenu1,'Value',2);
    else
        warning(cell2str(strcat({'"',data_type,'" is an invalid value for option "data_type"'})))
    end
    
       % display data after recon
    display=getHOTReconOption('display');
    if display==1
        set(handles.popupmenu1,'Value',1);
    elseif display==0
        set(handles.popupmenu1,'Value',2);
    else
        warning(cell2str(strcat({'value of "display" must be 1 (on) or 0 (off)'})))
    end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
if get(handles.popupmenu2,'Value') == 1
    setHOTReconOption('display',1);
elseif get(handles.popupmenu2,'Value') == 2
    setHOTReconOption('display',0);
else
    warning(cell2str(strcat({'value of "display" must be 1 (on) or 0 (off)'})))
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
