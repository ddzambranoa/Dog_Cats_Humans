function varargout = Interfaz(varargin)
% INTERFAZ MATLAB code for Interfaz.fig
%      INTERFAZ, by itself, creates a new INTERFAZ or raises the existing
%      singleton*.
%
%      H = INTERFAZ returns the handle to a new INTERFAZ or the handle to
%      the existing singleton*.
%
%      INTERFAZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFAZ.M with the given input arguments.
%
%      INTERFAZ('Property','Value',...) creates a new INTERFAZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interfaz_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interfaz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interfaz

% Last Modified by GUIDE v2.5 19-Jun-2021 18:54:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interfaz_OpeningFcn, ...
                   'gui_OutputFcn',  @Interfaz_OutputFcn, ...
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


% --- Executes just before Interfaz is made visible.
function Interfaz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interfaz (see VARARGIN)

% Choose default command line output for Interfaz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interfaz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interfaz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SubirImagen.
function SubirImagen_Callback(hObject, eventdata, handles)
% hObject    handle to SubirImagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Gato,'Visible','Off')
set(handles.Perro,'Visible','Off')
set(handles.Persona,'Visible','Off')
set(handles.tituloP,'Visible','Off')
set(handles.tituloG,'Visible','Off')
set(handles.tituloPe,'Visible','Off')
set(handles.tituloPer,'Visible','Off')
[archivo,carpeta] = uigetfile('*.jpg; *.png');
try
    if archivo == 0
      return;
    end
    im = imread(fullfile(carpeta, archivo));
    im = imresize(im, [227 227]);
    imshow(im);
    set(handles.imagen, 'UserData', im);
catch
end

% --- Executes on button press in Predecir.
function Predecir_Callback(hObject, eventdata, handles)
% hObject    handle to Predecir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    load modelo.mat %#ok<LOAD>
    im = get(handles.imagen, 'UserData');
    [labelpredict, err] = classify(modelo, im);
    set(handles.Gato,'Visible','On')
    set(handles.Perro,'Visible','On')
    set(handles.Persona,'Visible','On')
    set(handles.tituloP,'Visible','On')
    set(handles.tituloG,'Visible','On')
    set(handles.tituloPe,'Visible','On')
    set(handles.tituloPer,'Visible','On')
    preGato = (err(1) * 100); 
    prePerro = (err(2) * 100); 
    prePersona = (err(3) * 100);
    formatSpec = "%0.1f %%";
    porcentajeGato = sprintf(formatSpec,preGato);
    porcentajePerro = sprintf(formatSpec,prePerro);
    porcentajePersona = sprintf(formatSpec,prePersona);
    set(handles.Gato, 'String', porcentajeGato);
    set(handles.Perro, 'String', porcentajePerro);
    set(handles.Persona, 'String', porcentajePersona);
    rangoPrecision = 0.50; 
    rangoVerificar = 0.20;
    if err(1) > rangoPrecision || err(2) > rangoPrecision || err(3) > rangoPrecision
        
        if err(1) > rangoPrecision && (err(2)> rangoVerificar || err(3) > rangoVerificar)
            title({['El modelo lo reconoce como ' char(labelpredict)]
                   ['pero la predicción es elevada en las otras variables']
                   ['verifique que la imagen corresponda a un ' char(labelpredict)]
                   });  %#ok<NBRAK>
        elseif err(2) > rangoPrecision && (err(1)> rangoVerificar || err(3) > rangoVerificar)
            title({['El modelo lo reconoce como ' char(labelpredict)]
                   ['pero la predicción es elevada en las otras variables']
                   ['verifique que la imagen corresponda a un ' char(labelpredict)]
                   });  %#ok<NBRAK>
        elseif err(3) > rangoPrecision && (err(2)> rangoVerificar || err(1) > rangoVerificar)
            title({['El modelo lo reconoce como ' char(labelpredict)]
                   ['pero la predicción es elevada en las otras variables']
                   ['verifique que la imagen corresponda a una ' char(labelpredict) ]
                   });  %#ok<NBRAK>
        else
            title(upper(char(labelpredict)));
        end
    else
        title(upper(char('ERROR, NO SUPERA EL 50% DE PREDICCIÓN')));
    end
catch
end
