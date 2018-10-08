function varargout = ResponsePad2I2AFC(varargin)
% RESPONSEPAD2I2AFC MATLAB code for ResponsePad2I2AFC.fig
%      RESPONSEPAD2I2AFC, by itself, creates a new RESPONSEPAD2I2AFC or raises the existing
%      singleton*.
%
%      H = RESPONSEPAD2I2AFC returns the handle to a new RESPONSEPAD2I2AFC or the handle to
%      the existing singleton*.
%
%      RESPONSEPAD2I2AFC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESPONSEPAD2I2AFC.M with the given input arguments.
%
%      RESPONSEPAD2I2AFC('Property','Value',...) creates a new RESPONSEPAD2I2AFC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResponsePad2I2AFC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResponsePad2I2AFC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResponsePad2I2AFC

% Last Modified by GUIDE v2.5 30-Aug-2018 08:12:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResponsePad2I2AFC_OpeningFcn, ...
                   'gui_OutputFcn',  @ResponsePad2I2AFC_OutputFcn, ...
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


% --- Executes just before ResponsePad2I2AFC is made visible.
function ResponsePad2I2AFC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ResponsePad2I2AFC (see VARARGIN)

movegui('center'); 

% Choose default command line output for ResponsePad2I2AFC
handles.output = hObject;
handles.FeedbackDurationSec=.6;
OneSoundDuration=varargin{1};
ISI=varargin{2};
handles.CorrectAnswer=varargin{3};
handles.CorrectImage=varargin{4};
handles.WrongImage=varargin{5};

fontSize = 50;
set(handles.interval1,'FontSize',fontSize);
set(handles.interval2,'FontSize',fontSize);
% % L->R and R->L
% set(handles.interval1,'String',[char(76) char(10140) char(82) ]);
% set(handles.interval2,'String',[char(82) char(10140) char(76) ]);

% <-L and ->R
% set(handles.interval1,'String',[char(129144) char(76)]);
% set(handles.interval2,'String',[char(129146) char(82)]);

RA=char(hex2dec('2192'));
LA=char(hex2dec('2190'));
set(handles.interval1,'String',[char(76) ' ' LA]);
set(handles.interval2,'String',[RA ' ' char(82)]);

% set(handles.interval1,'String',[LA ' moving ' char(76)]);
% set(handles.interval2,'String',[RA ' moving ' char(82)]);

% Update handles structure
guidata(hObject, handles);

% if varargin{8}==1 % the first trial
%     pause(2)
% end

% playEm = audioplayer(varargin{1},varargin{2});
% play(playEm);

% UIWAIT makes ResponsePad2I2AFC wait for user response (see UIRESUME)
if varargin{6}==0 % the first trial
    uiresume(handles.figure1)
else
    uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ResponsePad2I2AFC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
if isempty(handles)
    varargout{1}='quit';
else
    varargout{1} = handles.output;
end


% --- Executes on button press in interval1.
function interval1_Callback(hObject, eventdata, handles)
% hObject    handle to interval1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output= 1;
set(handles.interval1,'String','');
set(handles.interval2,'String','');
if handles.CorrectAnswer==1
   set(handles.interval1,'cdata',handles.CorrectImage);
else
    set(handles.interval1,'cdata',handles.WrongImage);
end
pause(handles.FeedbackDurationSec)
set(handles.interval1,'cdata',[]);   
guidata(hObject, handles);
uiresume(handles.figure1); 


% --- Executes on button press in interval2.
function interval2_Callback(hObject, eventdata, handles)
% hObject    handle to interval2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output= 2;
set(handles.interval2,'String','');
set(handles.interval1,'String','');
if handles.CorrectAnswer==2
   set(handles.interval2,'cdata',handles.CorrectImage);
else
    set(handles.interval2,'cdata',handles.WrongImage);
end
pause(handles.FeedbackDurationSec)
set(handles.interval2,'cdata',[]);   
guidata(hObject, handles);
uiresume(handles.figure1); 


% --- Executes on button press in interval3.
function interval3_Callback(hObject, eventdata, handles)
% hObject    handle to interval3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output= 3;
if handles.CorrectAnswer==3
   set(handles.interval3,'cdata',handles.CorrectImage);
else
    set(handles.interval3,'cdata',handles.WrongImage);
end
pause(handles.FeedbackDurationSec)
set(handles.interval3,'cdata',[]);   
guidata(hObject, handles);
uiresume(handles.figure1); 
