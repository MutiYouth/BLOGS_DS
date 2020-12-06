%%%%%%%%%% MENU 3 %%%%%%%%%%

function menu3(action,varargin)
if nargin<1,
   action='Initialize';
end;

feval(action,varargin{:});
return;

function Initialize()

%%%% image processing variables
global Image1;							% original image
global Image2;							% blured image
global sigma;
global mu;
global NoGVFIterations;				% number of iterations
global NoSnakeIterations;		   % number of Snake iterations
global VectorFieldButt;				
global alpha beta gamma kappa dmin dmax;		% parameters for the snake
global px py;											% forse filed
global IncSnakeRadius;								% inicializaton snake radius
global XSnake YSnake;				% conture of the snake

%%%% interface variables
global VectorOfLocalMenuHD;		%vector of local objects that can be arased in next step
global HDmainf;			 			%main figure handle
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global HDedit1 HDedit2 HDedit3 HDedit4 HDedit5 HDedit6 HDedit7; % handels of snake edit uicontrol
global HDSnakeLine;					%vector of Handles of Snake lines on the picture
global HDedit8 HDedit9 HDRadioButton1 HDRadioButton2;
global HDButton1 HDButton2 HDButton4;
global SnakeON;						%indicate if snake is visible
global CircleOn;						% inicalization snake will be circle
global SnakeDotsON;				      % 1 if snake dots should be displeyed

global xsize ysize;					%size of the picture

global adgeD MinSize MenuSizeX MenuSizeY MenuPosX MenuPosY;
global ButtHeight ButtWidth ButtDist TextHeight;
global DotsSize;						% size in pixels of the dots on the snake


   
%%%%%% Close Old Objects %%%%%%%%
if ~isempty(VectorOfLocalMenuHD) 
   delete(VectorOfLocalMenuHD); 
   VectorOfLocalMenuHD=[];
end;
pause(0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define menu objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot the border for the menu
MenuSizeY=365;
MenuPosX=xsize*2+3*adgeD;
MenuPosY=ysize*2+3*adgeD-8-MenuSizeY;
HDMenuAxes=uicontrol( 'Parent',HDmainf , ...
   'Style','frame', ...
   'Units','pixels', ...
   'Position',[MenuPosX MenuPosY MenuSizeX MenuSizeY],...
   'BackgroundColor',[0.45 0.45 0.45]);

% Deform
labelStr='Deform';
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
   'Callback','SnakeIter');

% The BACK button
labelStr='<-- Back';
ButtPosX=MenuPosX+ButtDist;
HDButton2=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu2');

% UICONTROL for alpha

ButtWidth=MenuSizeX-2*ButtDist;
ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext1 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Alpha:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
callbackStr = 'snakeset';
stringVal=num2str(alpha);
HDedit1 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',alpha, ...
   'UserData',alpha,...
   'Enable','on',...
   'callback',callbackStr);

% UICONTROL for beta

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext2 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Beta:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(beta);
HDedit2 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',beta, ...
   'UserData',beta,...
   'Enable','on',...
   'callback',callbackStr);

% UICONTROL for gamma

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext3 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Gamma:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(gamma);
HDedit3 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',gamma, ...
   'UserData',gamma,...
   'Enable','on',...
   'callback',callbackStr);

% UICONTROL for kappa

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext4 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Kappa:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(kappa);
HDedit4 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',kappa, ...
   'UserData',kappa,...
   'Enable','on',...
   'callback',callbackStr);

% UICONTROL for dmin

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext5 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Dmin:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(dmin);
HDedit5 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',dmin, ...
   'UserData',dmin,...
   'Enable','on',...
   'callback',callbackStr);

% UICONTROL for dmax

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext6 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Dmax:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(dmax);
HDedit6 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',dmax, ...
   'UserData',dmax,...
   'Enable','on',...
   'callback',callbackStr);


% UICONTROL for number of snake iterations 

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.1*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext7 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Iterat.:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(NoSnakeIterations);
HDedit7 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',NoSnakeIterations, ...
   'UserData',NoSnakeIterations,...
   'Enable','on',...
   'callback',callbackStr);

% The Manual
labelStr='Manual';
ButtPosX=MenuPosX+0.5*ButtDist+MenuSizeX/2;
ButtPosY = ButtPosY-ButtDist-ButtHeight;
ButtWidth=MenuSizeX/2-1.5*ButtDist;

HDButton3=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu3(''ManualSnakeON'')');

% The Inic
labelStr='Initial.';
ButtPosX=MenuPosX+ButtDist;
HDButton4=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu3(''InicSnake'')');


% UICONTROL for Radius of snake
ButtWidth=MenuSizeX-2*ButtDist;
ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX ButtPosY ButtWidth*0.5 TextHeight];
HDRadioButton1 = uicontrol('Parent', HDmainf, ...
   'Style','CheckBox', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Radius:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white',...
   'Callback','menu3(''CallbackRadius'')',...
   'Value',CircleOn);

if (CircleOn==1) 
   en='On'; 
else 
   en='Off'; 
end;
callbackStr='menu3(''RadiusChange'')';
textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(IncSnakeRadius);
HDedit8 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',IncSnakeRadius, ...
   'UserData',IncSnakeRadius,...
   'Enable',en,...
   'callback',callbackStr);

% UICONTROL for Dots on the snake
if (SnakeDotsON==0 )
   value=0;
else value=1; end;
   
ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX ButtPosY ButtWidth*0.5 TextHeight];
HDRadioButton2 = uicontrol('Parent', HDmainf, ...
   'Style','CheckBox', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Dots', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white',...
   'Callback','menu3(''CallbackDots'')',...
   'Value',value);

callbackStr='menu3(''DotsSizeChange'')';
textPos=[ButtPosX+0.5*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
stringVal=num2str(DotsSize);
if (SnakeDotsON==1) 
   en='On'; 
else 
   en='Off'; 
end;

HDedit9 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',DotsSize, ...
   'UserData',DotsSize,...
   'Enable',en,...
   'callback',callbackStr);

% button Load Snake
labelStr='Save S.';
ButtPosX=MenuPosX+0.5*ButtDist+MenuSizeX/2;
ButtPosY = ButtPosY-ButtDist-ButtHeight;
ButtWidth=MenuSizeX/2-1.5*ButtDist;

HDButton5=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu3(''SaveSnake'')');

% The Inic
labelStr='Load S.';
ButtPosX=MenuPosX+ButtDist;
HDButton6=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[ButtPosX ButtPosY ButtWidth ButtHeight], ...
   'String',labelStr, ...
   'Enable','on', ...
   'Callback','menu3(''LoadSnake'')');

%=========================================================
% HELP
%=========================================================

str='Click on images for magnification.|~';
str=strcat(str,'\bf<--Back|\rmBack to the previous menu.|');
str=strcat(str,'~\bfSnake|\rmRun snake iterations.|~  \it[x,y] = snakeinterp(XSnake,YSnake,dmax,dmin);|~ \it[x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,NoIterations);|');
str=strcat(str,'~\bfAlpha|\rmTension of the snake.|');
str=strcat(str,'~\bfBeta|\rmRigidity of the snake.|');
str=strcat(str,'~\bfGamma|\rmStep size in one iteration.|');
str=strcat(str,'~\bfKappa|\rmExternal force weight.|');
str=strcat(str,'~\bfDmin|\rmMin resolution of the snake.|');
str=strcat(str,'~\bfDmax|\rmMax resolution of the snake.|');
str=strcat(str,'~\bfInitialization|\rmInitial snake position to the starting|or manual position.|');
str=strcat(str,'~\bfManual|\rmManual draw initial snake.|');
str=strcat(str,'~\bfRadious|\rmRadius of initial snake.|');
str=strcat(str,'~\bfDots|\rmDefine if nodes of snake are going to| be displayed.|');
str=strcat(str,'~\bfLoad Snake|\rmLoad snake parameters and position.|');
str=strcat(str,'~\bfSave Snake|\rmSave snake parameters and position.|');

str=strcat(str,'|~\bfTheoretical backgrounds|~\rmSnake moves trough image|in order to minimize energy of|');
str=strcat(str,'~  E=1/2\int[\alpha\mid\bfX''\rm(s)\mid^2+\beta\mid\bfX''''\rm(s)\mid^2]+\kappa E_e_x_t(\bfX\rm(s))ds');
WriteHelp(str);


%%%% define local menu objects, that should be deletet 
VectorOfLocalMenuHD=[HDButton1 HDButton2 HDButton3 HDButton4 HDedit1 HDtext1 HDedit2 HDtext2 HDMenuAxes HDedit3 HDtext3 HDedit4 HDtext4 HDedit5 HDtext5 HDedit6 HDtext6 HDedit7 HDtext7 HDedit8 HDRadioButton1 HDRadioButton2 HDedit9 HDButton5 HDButton6];
pause(0.1);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sub functons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initalize the sanke to the circle

function InicSnake();
global XSnake YSnake IncSnakeRadius Image1 HDSnakeLine;
global XSnakeInc YSnakeInc;   	% incicialization conture of the snake
global CircleOn;

if CircleOn==1
	t = 0:0.05:6.28;
	XSnake = (size(Image1,1)/2 +  IncSnakeRadius/2*size(Image1,1)*cos(t))';
   YSnake = (size(Image1,2)/2 +  IncSnakeRadius/2*size(Image1,2)*sin(t))';
else
   XSnake=[XSnakeInc; XSnakeInc(1)];
   YSnake=[YSnakeInc; YSnakeInc(1)];
end

set(HDSnakeLine,'XData',XSnake,'YData',YSnake,'Color','Red');
return


% callfunction for snake radius change
function RadiusChange()
global IncSnakeRadius;
global XSnake YSnake IncSnakeRadius Image1 HDSnakeLine;


v = get(gcbo,'Userdata');
s = get(gcbo,'String');
vv = eval(s,num2str(v));
if vv(1) > 1 | vv(1) < 0 | s~=num2str(vv)
   vv = v; 
   set(gcbo, 'String', num2str(v))
   return
end
set(gcbo,'Userdata',vv,'String',num2str(vv))
IncSnakeRadius=vv;

t = 0:0.05:6.28;
XSnake = (size(Image1,1)/2 +  IncSnakeRadius/2*size(Image1,1)*cos(t))';
YSnake = (size(Image1,2)/2 +  IncSnakeRadius/2*size(Image1,2)*sin(t))';
set(HDSnakeLine,'XData',XSnake,'YData',YSnake,'Color','Red');
return


% callfunction for Manual Snake

function ManualSnakeON()
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global HDSnakeLine;
global HDManualSnakeLine;
global XSnakeManual YSnakeManual;
global HDpointer;				% handle of + pointer on the scren
global HDedit8 HDRadioButton1;
global CircleOn;
global HDButton1 HDButton2 HDButton4;

set([HDButton1 HDButton2 HDButton4],'Enable','Off');
set(HDedit8,'Enable','Off');
set(HDRadioButton1,'Value',0,'Enable','Off');
CircleOn=0;

set(gcbo,'String','End M.',...
   'CallBack','menu3(''ManualSnakeOFF'')');

HD=get(HDorigPic,'Children');
set(HD,'ButtonDownFcn','menu3(''DrawSnake'')');

%HD=get(HDbluredPic,'Children');
%set(HD,'ButtonDownFcn','menu3(''DrawSnake'')');

set(HDSnakeLine,'Visible','Off');
HDManualSnakeLine=[];
XSnakeManual=[];
YSnakeManual=[];
HDpointer=[];

%=========================================================
% HELP
%=========================================================

str='Click on the Original Image in order|to draw the contour of the snake.|';
str=strcat(str,'~|\bfEnd Manual|\rmClick when you finish drawing.|');
WriteHelp(str);

return

function ManualSnakeOFF()
global HDSnakeLine;
global HDpointer;				% handle of + pointer on the scren
global HDManualSnakeLine;
global HDRadioButton1;
global XSnakeManual YSnakeManual;
global XSnake YSnake;
global XSnakeInc YSnakeInc;   	% incicialization conture of the snake
global HDButton1 HDButton2 HDButton4;
global HDorigPic;

set([HDButton1 HDButton2 HDButton4],'Enable','On');

set(gcbo,'String','Manual',...
   'CallBack','menu3(''ManualSnakeON'')');
set(HDRadioButton1,'Enable','On');

if ~isempty(HDManualSnakeLine) 
   delete(HDManualSnakeLine);
end

if ~isempty(HDpointer)
   delete(HDpointer);   
end;

if size(XSnakeManual,1)>=3
   XSnake=XSnakeManual;
   YSnake=YSnakeManual;
   XSnakeInc=XSnake;
   YSnakeInc=YSnake;
end

set(HDSnakeLine,'XData',[XSnake; XSnake(1)],'YData',[YSnake; YSnake(1)],'Color','Red','Visible','on');

HD=get(HDorigPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic1Click'')');

%=========================================================
% HELP
%=========================================================

str='Click on images for magnification.|~';
str=strcat(str,'\bf<--Back|\rmBack to the previous menu.|');
str=strcat(str,'~\bfSnake|\rmRun snake iterations.|~  \it[x,y] = snakeinterp(XSnake,YSnake,dmax,dmin);|~ \it[x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,NoIterations);|');
str=strcat(str,'~\bfAlpha|\rmTension of the snake.|');
str=strcat(str,'~\bfBeta|\rmRigidity of the snake.|');
str=strcat(str,'~\bfGamma|\rmStep size in one iteration.|');
str=strcat(str,'~\bfKappa|\rmExternal force weight.|');
str=strcat(str,'~\bfDmin|\rmMin raster of the snake.|');
str=strcat(str,'~\bfDmax|\rmMax raster of the snake.|');
str=strcat(str,'~\bfInitialization|\rmInitial snake position to the starting|or manual position.|');
str=strcat(str,'~\bfManual|\rmManual draw initial snake.|');
str=strcat(str,'~\bfRadious|\rmRadious of initial snake.|');
str=strcat(str,'~\bfDotst|\rmDefine if dots are going to| be displayed.|');
str=strcat(str,'~\bfLoad Snake|\rmLoad snake parameters and position.|');
str=strcat(str,'~\bfSave Snake|\rmSave snake parameters and position.|');

str=strcat(str,'|~\bfTheoretical back grounds|~\rmSnake moves trought image|in order to minimize energy of|');
str=strcat(str,'~  E=1/2\int[\alpha\mid\bfX''\rm(s)\mid^2+\beta\mid\bfX''''\rm(s)\mid^2]+\kappa E_e_x_t(\bfX\rm(s))ds');
WriteHelp(str);


return

% callfunction for when the button is down 

function DrawSnake()
global HDmainf;
global HDpointer;				% handle of + pointer on the scren
global XSnakeManual YSnakeManual;
global HDManualSnakeLine;

if ~isempty(HDpointer)
   delete(HDpointer);   
end;

HD=get(gcbo,'Parent');
set(HDmainf,'CurrentAxes',HD);
hold on;
P=get(HD,'CurrentPoint');
HDpointer=plot(P(1,1),P(1,2),'b+');

XSnakeManual=[XSnakeManual; P(1,1)];
YSnakeManual=[YSnakeManual; P(1,2)];

if size(XSnakeManual,1)==1
   HDManualSnakeLine=line(XSnakeManual, YSnakeManual);
end

set(HDManualSnakeLine,'XData',XSnakeManual,'YData',YSnakeManual,'EraseMode','none','Color','Red');
return


function CallbackRadius()
global CircleOn;						% inicalization snake will be circle
global HDedit8;

if get(gcbo,'Value')==1 
    CircleOn=1;
    set(HDedit8,'Enable','On');
 else
    CircleOn=0;
    set(HDedit8,'Enable','Off');
 end;   
return


% callfunction for snake radius change
function CallbackDots()
global HDSnakeLine;
global SnakeDotsON DotsSize;				      % 1 if snake dots should be displeyed
global HDedit9;

if get(gcbo,'Value')==1
   SnakeDotsON=1;
else
   SnakeDotsON=0;
end;

if SnakeDotsON==1 
   set(HDSnakeLine,'Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
   set(HDedit9,'Enable','On');
else
   set(HDSnakeLine,'Marker','None');
   set(HDedit9,'Enable','Off');
end;
return

% callback function for dots change size
function DotsSizeChange()
global DotsSize HDSnakeLine;

v = get(gcbo,'Userdata');
s = get(gcbo,'String');
vv = eval(s,num2str(v));
if vv(1) > 30 | vv(1) <= 0 | s~=num2str(vv)| round(vv(1))~=vv(1)
   vv = v; 
   set(gcbo, 'String', num2str(v))
   return
end
set(gcbo,'Userdata',vv,'String',num2str(vv))
DotsSize=vv;
set(HDSnakeLine,'Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
return

%%% Callback function for save snake parameters 
function SaveSnake()
global SnakeFileName SnakePathName;  % name of the snake parameters file

global alpha beta gamma kappa dmin dmax;		% parameters for the snake
global XSnake YSnake;								% conture of the snake
global NoSnakeIterations;		   % number of Snake iterations
global SnakeDotsON;				   % 1 if snake dots should be displeyed
global IncSnakeRadius;				% inicializaton snake radius
global DotsSize;						



	[FileNameT PathNameT]=uiputfile(strcat(SnakePathName,SnakeFileName),'Save snake parameters');
   if FileNameT~=0 
      disp(' ');
      disp(strcat(' Saving	',FileNameT));
      save(strcat(PathNameT,FileNameT),'alpha','beta','gamma','kappa','dmin','dmax','XSnake','YSnake','NoSnakeIterations','SnakeDotsON','IncSnakeRadius','DotsSize');
      SnakePathName=PathNameT;
      SnakeFileName=FileNameT;
      disp(' ');
   end
return

%%% Callback function for load snake parameters 
function LoadSnake()
global SnakeFileName SnakePathName;  % name of the snake parameters file

global alpha beta gamma kappa dmin dmax;		% parameters for the snake
global XSnake YSnake;								% conture of the snake
global NoSnakeIterations;		   % number of Snake iterations
global SnakeDotsON;				   % 1 if snake dots should be displeyed
global IncSnakeRadius;				% inicializaton snake radius
global XSnakeInc YSnakeInc;   	% incicialization conture of the snake
global DotsSize;						
global HDedit1 HDedit2 HDedit3 HDedit4 HDedit5 HDedit6 HDedit7 HDedit8 HDedit9 ; % handels of snake edit uicontrol
global CircleOn;						% inicalization snake will be circle
global HDRadioButton1 HDRadioButton2;

	[FileNameT PathNameT]=uigetfile(strcat(SnakePathName,'\*.mat'),'Load snake parameters');
   if FileNameT~=0 
      disp(' ');
      disp(strcat(' Load	',FileNameT));
      disp(' ');

		load(strcat(PathNameT,FileNameT));

      SnakePathName=PathNameT;
      SnakeFileName=FileNameT;
      
      XSnakeInc=XSnake;
      YSnakeInc=YSnake;
      
      global HDSnakeLine;
      set(HDSnakeLine,'XData',[XSnake; XSnake(1)],'YData',[YSnake; YSnake(1)]);
      if SnakeDotsON==1 
		   set(HDSnakeLine,'Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
         set(HDedit9,'Enable','On');
         set(HDRadioButton2,'Value',1);
		else
   		set(HDSnakeLine,'Marker','None');
         set(HDedit9,'Enable','Off');
         set(HDRadioButton2,'Value',0);
		end;
      
      % reset the values in the menu
      set(HDedit1,'String',num2str(alpha),'Value',alpha);
      set(HDedit2,'String',num2str(beta),'Value',beta);
      set(HDedit3,'String',num2str(gamma),'Value',gamma);
      set(HDedit4,'String',num2str(kappa),'Value',kappa);
      set(HDedit5,'String',num2str(dmin),'Value',dmin);
      set(HDedit6,'String',num2str(dmax),'Value',dmax);
      set(HDedit7,'String',num2str(NoSnakeIterations),'Value',NoSnakeIterations);
		set(HDedit8,'String',num2str(IncSnakeRadius),'Value',IncSnakeRadius);
		set(HDedit9,'String',num2str(DotsSize),'Value',DotsSize);
			
      set(HDRadioButton1,'Value',0);
      set(HDedit8,'Enable','Off');
      CircleOn=0;
   end
return
