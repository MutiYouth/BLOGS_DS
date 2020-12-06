%%%%%%%%%% MENU 0 %%%%%%%%%%
% opens About window

function menu0(action,varargin)
if nargin<1,
   action='Initialize';
end;

feval(action,varargin{:});
return;

function Initialize()

% About
disp(' ');
disp(' ');
disp('	**************************************************************************');  
disp('	SNAKE DEMO ver 1.0 beta																');
disp('																								');
disp('	Interface by																				');
disp('																								');	
disp('	Dejan Tomazevic	(e-mail dejan.tomazevic@kiss.uni-lj.si)	10/2/98		');
disp('	Copyright (c) 1998 by Dejan Tomazevic												');
disp('	BIPROG, Faculty of Electrical Engineering, University of Ljubljana		');
disp('																								');
disp('	Snake and GVF functions by															');
disp('	Chenyang Xu and Jerry L. Prince 6/17/97											');	
disp('	Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince					');
disp('	Image Analysis and Communications Lab, Johns Hopkins University			');	
disp('																								');
disp('																								');	
disp('	This program was written during Dejan Tomazevic visit Johns Hopkins 	');
disp('	University in purpose to show the use of traditional snakes and GVF 	');
disp('	snakes M fuctions.																						');
disp('	**************************************************************************');  
disp(' ');
disp(' ');

   %%%%%%% DEFINING MAIN OBJECTS %%%%%%%%

% open the main figure
global HDmainf;
HDmainf = figure;
 
set(HDmainf, 'Color', [0.8 0.8 0.8], ... 
               'NumberTitle', 'off', ... 
               'Name', 'Snake Demo', ... 
               'Units', 'pixels',...
               'Resize','Off',...
               'CloseRequestFcn','closeapl');
            
% opens the starting picture
[X,MAP] = imread('head.jpg','jpg');
HD=axes; image(X);
pos=get(HDmainf,'Position');
set(HDmainf,'Position',[pos(1:2) size(X,2) size(X,1)]);
set(HD,'Units','pixels',...
   'Position',[0 0 size(X,2) size(X,1)],...
   'Units','normal');

% Continue button
ButtHeight=22;							% size of the button
ButtWidth=70; %%%

global adgeD;
global HDButton1;
ButtPosX=(size(X,2)-ButtWidth)/2;
ButtPosY=15;
HDButton1=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String','Continue', ...
   'Enable','on', ...
   'Callback','menu0(''CallBackContinue'')');
global Cont;
Cont=0;

%while ~Cont 
%pause(0.1);
%end
%if Cont==2 break; end;
return

function CallBackContinue()
%%%% interface variables
global VectorOfLocalMenuHD;		%vector of local objects that can be arased
VectorOfLocalMenuHD=[];
global HDmainf;			 			%main figure handle
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global HDhelpAxes;					%handle of help window
global HDhelpSlider1 HDhelpSlider2;	%handle of the slider for help text 
global HDvectorOfTexthd;			% vector of help text handels
global xsize ysize;					%size of the picture
global HDMenuAxes;					%Axes for the help
global HDSnakeLine;					%vector of Handles of Snake lines on the picture
global FileName PathName;			% name of the file
global ExampleNo;						% number of exampel
global DotsSize;						% size in pixels of the dots on the snake
global HDRadioButton1;
global adgeD MinSize MenuSizeX MenuSizeY MenuPosX MenuPosY;
global ButtHeight ButtWidth ButtDist TextHeight;


global HDButton1;
delete(HDButton1);

FileName='room.pgm';
PathName='.\images\';
menu1('OpenImageFile');

            %define inc position for HDvectorFPic
HDbluredPic=subplot(222);
set(HDbluredPic,'Units', 'pixels','Position',[adgeD*2+xsize adgeD*2+ysize xsize ysize],'Visible','Off');
HDvectorFPic=subplot(223);
set(HDvectorFPic,'Units', 'pixels','Position',[adgeD adgeD xsize ysize],'Visible','Off');
HDhelpAxes=subplot(224);
set(HDhelpAxes,'Units', 'pixels','Position',[adgeD*2+xsize adgeD xsize ysize],'Visible','Off');



%====================================================
%			open help window		%
%====================================================

% help window
HDhelpAxes=subplot(224); 
col=[1 1 1];
set(HDhelpAxes,'Units', 'pixels','Position',[adgeD*2+xsize adgeD xsize ysize],...
   					'Units', 'normal',...
                  'XLim',[0 1],...
                  'YLim',[0 1],...
                  'Color',col,...
                  'XColor',col,...
               	'YColor',col,...
                  'GridLineStyle','none',...
                  'XTickMode','manual','XTick',[],...
                  'YTickMode','manual','YTick',[]);
               
% help scroll bar
HDhelpSlider1=uicontrol( 'Parent',HDmainf , ...
							   'Style','slider', ...
							   'Units','pixels', ...
							   'Position',[adgeD*2+2*xsize adgeD 17 ysize],...
                        'BackgroundColor',[0.45 0.45 0.45],...
                        'CallBack','CallBackHelpSlider',...
                        'Value',1);
                     
HDhelpSlider2=uicontrol( 'Parent',HDmainf , ...
							   'Style','slider', ...
							   'Units','pixels', ...
							   'Position',[adgeD*2+xsize adgeD-17 xsize 17],...
                        'BackgroundColor',[0.45 0.45 0.45],...
                        'CallBack','CallBackHelpSlider',...
                        'Value',0);
                     
%====================================================
% Caling first menu
menu1;
%====================================================
                     
return