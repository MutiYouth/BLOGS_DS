%%%%%%%%%% MENU 1 %%%%%%%%%%

function menu1(action,varargin)
if nargin<1,
   action='Initialize';
end;

feval(action,varargin{:});
return;

function Initialize()
%%%%%%%%%% FIRST MENU %%%%%%%%%%

%%%% image processing variables
global Image1;							% original image
global sigma;

%%%% interface variables
global VectorOfLocalMenuHD;				%vector of local objects that can be arased
global HDmainf;			 			%main figure handle
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global ExampleNo;						% number of exampel
global GradientOn;					% 1 if gradient is applayed with blur

global xsize ysize;					%size of the picture


global adgeD MinSize MenuSizeX MenuSizeY MenuPosX MenuPosY;
global ButtHeight ButtWidth ButtDist TextHeight;

global HDRadioButton1;

%====================================

MenuSizeY=ButtHeight+3*ButtDist+TextHeight+20;

%====================================

%%%%%% Close Old Objects %%%%%%%%
if ~isempty(VectorOfLocalMenuHD) 
   delete(VectorOfLocalMenuHD); 
   VectorOfLocalMenuHD=[];
end;

%if ~isempty(HDbluredPic) 
%   delete(HDbluredPic); 
%   HDbluredPic=[];
%end;
global BluredPic;
BluredPic=1;
set(HDbluredPic,'Visible','Off');
set(HDmainf,'CurrentAxes',HDbluredPic);
title('');
cla;

%plot the border for the menu
MenuSizeY=140;
MenuPosX=xsize*2+3*adgeD;
MenuPosY=ysize*2+3*adgeD-8-MenuSizeY;
HDMenuAxes=uicontrol( 'Parent',HDmainf , ...
   'Style','frame', ...
   'Units','pixels', ...
   'Position',[MenuPosX MenuPosY MenuSizeX MenuSizeY],...
   'BackgroundColor',[0.45 0.45 0.45]);

% The NEXT button
labelStr='Next -->';
ButtPosX=MenuPosX+0.5*ButtDist+MenuSizeX/2;
ButtPosY=MenuPosY+MenuSizeY-ButtDist-ButtHeight;
ButtWidth=MenuSizeX/2-1.5*ButtDist;

HDButton1=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu2');

% The Open button
labelStr='Open';
ButtPosX=MenuPosX+ButtDist;
HDButton2=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu1(''CallbackOpen'')');
ButtPosY=MenuPosY+MenuSizeY-ButtDist-ButtHeight;

% text "Examles"
ButtPosY=ButtPosY-ButtDist-ButtHeight;
ButtPosX=MenuPosX+ButtDist;
ButtWidth=MenuSizeX-2*ButtDist;
labelPos=[ButtPosX ButtPosY ButtWidth*0.4 TextHeight-2];
HDtext2 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Examples:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');

% popupmenu 			
labelStr='Room|U shape';
callbackStr='menu1(''CallbackPopupmenu'')';

btnPos=[ButtPosX+ButtWidth*0.45 ButtPosY ButtWidth*0.55 ButtHeight];
HDpopmenu=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','popupmenu', ...
   'Units','pixels', ...
   'Position',btnPos, ...
   'String',labelStr, ...
   'value',ExampleNo,'Userdata',ExampleNo, ...
   'Callback',callbackStr);

% checkbutton for Gradient
ButtWidth=MenuSizeX-2*ButtDist;
ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX ButtPosY ButtWidth*0.8 TextHeight];
HDRadioButton1 = uicontrol('Parent', HDmainf, ...
   'Style','CheckBox', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Gradient', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white',...
   'Callback','menu1(''CallbackGradient'')',...
   'Value',GradientOn);


% UICONTROL for sigma
ButtPosY=ButtPosY-ButtDist-ButtHeight;
ButtPosX=MenuPosX+ButtDist;
ButtWidth=MenuSizeX-2*ButtDist;
labelPos=[ButtPosX ButtPosY ButtWidth*0.6 TextHeight];
HDtext1 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Sigma:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos = [ButtPosX+0.35*ButtWidth ButtPosY ButtWidth*0.25 TextHeight];
callbackStr = 'sigmaset';
stringVal=num2str(sigma);
HDedit1 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',sigma, ...
   'UserData',sigma,...
   'callback',callbackStr);

% help for menu1
str='Click on image for magnification.|';
str=strcat(str,'~\bfOpen|\rmOpens raw image file.|~\it [Image,map] = rawread(FileName);|');
str=strcat(str,'~\bfNext-->|\rmBlures the image and apply|gradinet, if it is defined.|');
str=strcat(str,'~\bfExamples\rm|Choose one of examples.|');
str=strcat(str,'~\bfGradient\rm|Apply gradient on the image|in order to get edges.|~\it Image2=abs(gradient2(bluredImage))|');
str=strcat(str,'~\bfSigma (\sigma)\rm|Parameter for the gaussian blure|(noise-free image).|No blure is recomendent (\it\sigma = 0\rm)|~\it bluredImage = gaussianBlur(Image1,sigma);|');
WriteHelp(str);

VectorOfLocalMenuHD=[HDButton1 HDButton2 HDedit1 HDtext1 HDMenuAxes HDpopmenu HDtext2 HDRadioButton1];
return

%%% Callback function for open the file 
function CallbackOpen()
global FileName PathName;
	[FileNameT PathNameT]=uigetfile(strcat(PathName,'*.pgm;*.jpg;*.bmp;*.hdf;*.pcx;'),'Open image file');
   if FileNameT~=0 
      FileName=FileNameT;
      PathName=PathNameT;
      menu1('OpenImageFile');
   end
return


%%% sub function witch opens the image file
function OpenImageFile()
global FileName PathName;				 % name of the image file
global SnakeFileName SnakePathName;  % name of the snake parameters file
global HDmainf;
global HDorigPic;
global Image1;
global MinSize adgeD MenuSizeX;
global xsize ysize;					%size of the picture
global IncSnakeRadius;				% inicializaton snake radius
global XSnake YSnake;				% conture of the snake
global XSnakeInc YSnakeInc;   	% incicialization conture of the snake
global SchangeInFieldType;


set(HDmainf,'Units','pixels');
fpos=get(HDmainf,'Position');

% Read in image -------------------------------
filen=strcat(PathName,FileName);
enddot = max(find(filen== '.'));
suffix = filen(enddot+1:enddot+3);
if (suffix=='pgm')+(suffix=='raw')
   [I,map] = rawread(strcat(PathName,FileName)); 
else
   if (suffix=='jpg')+(suffix=='bmp')+(suffix=='hdf')+(suffix=='pcx')+(suffix=='tif')
      [X,MAP] = IMREAD(strcat(PathName,FileName));
      I=X(:,:,1);
   end
end
      
% get proposal file name for snake parameters
SnakePathName=PathName;
n=[];
for i=1:size(FileName,2)
   if FileName(i)~='.' 
      n=FileName(1:i);
   else
      break;
   end;
end;
SnakeFileName=strcat(n,'.mat');

I=double(I);
maxvalue=max(max(I)');
f = 1 - I/maxvalue; 
Image1=f;

[xsize ysize]=size(I);

%scalin picture, if it is to small to plot it on the scren
[m n]=min([xsize ysize]);
if (m<MinSize) 
   if (n==1)
       ysize=ysize*MinSize/xsize;
       xsize=MinSize;
   else
      xsize=xsize*MinSize/ysize;
      ysize=MinSize;
   end
end

deltay=ysize*2+3*adgeD-fpos(4);
set(HDmainf,'Position',[fpos(1),fpos(2)-deltay,xsize*2+5+3*adgeD+MenuSizeX,ysize*2+3*adgeD],...
   			'Units', 'normal');
         
% chech if image is gary level or binary 
global GradientOn;					% 1 if gradient is applayed with blur
global HDRadioButton1;
   
if sum(sum(Image1-Image1.^2)')>xsize*ysize/255
   GradientOn=1;   
   if ~isempty(HDRadioButton1) set(HDRadioButton1,'Value',1); end
else
   GradientOn=0;   
   if ~isempty(HDRadioButton1) set(HDRadioButton1,'Value',0); end
end;

         
% plot the original picture

HDorigPic=subplot(221); imdisp(-f); title('Original image');

set(HDorigPic,'Units', 'pixels','Position',[adgeD adgeD*2+ysize xsize ysize],'Units', 'normal');

%%%% define if butt click on picture
HD=get(HDorigPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic1Click'')');

% name of the figure
set(HDmainf,'Name',strcat('Snake Demo     [',PathName,FileName,']'));

% define Inc snake
t = 0:0.05:6.28;
XSnake = (size(Image1,1)/2 +  IncSnakeRadius/2*size(Image1,1)*cos(t))';
YSnake = (size(Image1,2)/2 +  IncSnakeRadius/2*size(Image1,2)*sin(t))';

XSnakeInc=XSnake; YSnakeInc=YSnake;
SchangeInFieldType=1;
return   

% popmenu callback function
function CallbackPopupmenu()
global FileName PathName;
global ExampleNo;						% number of exampel


if get(gcbo,'Value')==1
   FileName='room.pgm';
   PathName='./images/';
   ExampleNo=1;
else
   FileName='u64.pgm';
   PathName='./images/';
   ExampleNo=2;
end
menu1('OpenImageFile'); 
return

function CallbackGradient()
global GradientOn;					% 1 if gradient is applayed with blur
global SchangeInFieldType;


if get(gcbo,'Value')==0
	GradientOn=0;   
else
   GradientOn=1;   
end
SchangeInFieldType=1;
return
