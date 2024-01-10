function varargout = GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(gcf,'unit','centimeters','position',[22 3 14.5 18]);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
Interaction=importdata(get(handles.Interaction,'string'));
NodeNum=size(Interaction,2)-1;
CellLength=str2num(get(handles.CellLength,'string'));
TimeSpan=str2num(get(handles.TimeSpan,'string'));
dt=str2num(get(handles.dt,'string'));
SavingInterval=str2num(get(handles.SavingInterval,'string'));
FolderName=get(handles.FolderName,'string');
axes(handles.Process);
WaitProcess=gcf;
PolarSimData(NodeNum,CellLength,Interaction,TimeSpan,dt,SavingInterval,FolderName,WaitProcess);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
PatternPathway=get(handles.Pattern,'string');
Pattern=importdata(PatternPathway);
%plot pattern and output interface velocity
plane=PolarSimPlot(Pattern);
set(handles.TransitionPlane,'string',plane);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
StartPatternPathway=get(handles.StartTime,'string');
StartPattern=importdata(StartPatternPathway);
ST=str2double(extractBetween(StartPatternPathway,"Pattern_",".mat"));
EndPatternPathway=get(handles.EndTime,'string');
EndPattern=importdata(EndPatternPathway);
ET=str2double(extractBetween(EndPatternPathway,"Pattern_",".mat"));
%output interface velocity
velocity=PolarSimVelocity(StartPattern,EndPattern,ST,ET);
set(handles.InterfaceVelocity,'string',velocity);

function NodeNum_Callback(hObject, eventdata, handles)
function NodeNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Interaction_Callback(hObject, eventdata, handles)
function Interaction_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TimeSpan_Callback(hObject, eventdata, handles)
function TimeSpan_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dt_Callback(hObject, eventdata, handles)
function dt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SavingInterval_Callback(hObject, eventdata, handles)
function SavingInterval_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Pattern_Callback(hObject, eventdata, handles)
function Pattern_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FolderName_Callback(hObject, eventdata, handles)
function FolderName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CellLength_Callback(hObject, eventdata, handles)
function CellLength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StartTime_Callback(hObject, eventdata, handles)
function StartTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EndTime_Callback(hObject, eventdata, handles)
function EndTime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function InterfaceVelocity_Callback(hObject, eventdata, handles)
function InterfaceVelocity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TransitionPlane_Callback(hObject, eventdata, handles)
function TransitionPlane_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
