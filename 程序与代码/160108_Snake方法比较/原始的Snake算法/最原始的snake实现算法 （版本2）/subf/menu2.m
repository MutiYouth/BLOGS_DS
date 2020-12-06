%%%%%%%%%% MENU 2 %%%%%%%%%%

function menu2()


%%%% image processing variables
global Image1;							% original image
global Image2;							% blured image

global sigma;
global mu;
global NoGVFIterations;
global VectorFieldButt;
global SchangeInFieldType;
global GradientOn;					% 1 if gradient is applayed with blur

%%%% interface variables
global VectorOfLocalMenuHD;		%vector of local objects that can be arased in next step
global HDmainf;			 			%main figure handle
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global HDRadioButton1;
global HDRadioButton2;
global HDRadioButton3;
global HDSnakeLine;					%vector of Handles of Snake lines on the picture


global HDedit1;
global HDedit2;
global SnakeON;						%indicate if snake is visible
SnakeON=0;

global xsize ysize;					%size of the picture

global adgeD MinSize MenuSizeX MenuSizeY MenuPosX MenuPosY;
global ButtHeight ButtWidth ButtDist TextHeight;


%%%%%% Close Old Objects %%%%%%%%
if ~isempty(HDSnakeLine) 
   delete(HDSnakeLine); 
   HDSnakeLine=[];
end;

if ~isempty(VectorOfLocalMenuHD) 
   delete(VectorOfLocalMenuHD); 
   VectorOfLocalMenuHD=[];
end;

%if ~isempty(HDvectorFPic) 
%   delete(HDvectorFPic); 
%   HDvectorFPic=[];
%end;
set(HDvectorFPic,'Visible','Off');
set(HDmainf,'CurrentAxes',HDvectorFPic);
cla;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define menu objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot the border for the menu
MenuSizeY=240;
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
   'Callback','caclVF');

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
   'Callback','menu1');

% Radio Button 1 			- standard vector filed
ButtPosY = ButtPosY-ButtDist-ButtHeight-adgeD;
ButtWidth=MenuSizeX-2*ButtDist;
labelStr='Standard vector field';
callbackStr='RadioUPDATE';

btnPos=[ButtPosX ButtPosY ButtWidth ButtHeight];
HDRadioButton1=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','radiobutton', ...
   'Units','pixels', ...
   'Position',btnPos, ...
   'String',labelStr, ...
   'value',VectorFieldButt(1),'Userdata',VectorFieldButt(1), ...
   'Callback',callbackStr);

% Radio Button 2 			- standard vector filed
ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelStr='GVF field';
callbackStr='RadioUPDATE';

btnPos=[ButtPosX ButtPosY ButtWidth ButtHeight];
HDRadioButton2=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','radiobutton', ...
   'Units','pixels', ...
   'Position',btnPos, ...
   'String',labelStr, ...
   'value',VectorFieldButt(2),'Userdata',VectorFieldButt(2), ...
   'Callback',callbackStr);

% UICONTROL for GVF mu
if VectorFieldButt(2)==1 
   onoff='on';
else
   onoff='off';
end

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.2*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext1 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Mu:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.65*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
callbackStr = 'muset';
stringVal=num2str(mu);
HDedit1 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',mu, ...
   'UserData',mu,...
   'Enable',onoff,...
   'callback',callbackStr);

% UICONTROL for GVF Number of Iterations

ButtPosY = ButtPosY-ButtDist-ButtHeight;
labelPos=[ButtPosX+0.2*ButtWidth ButtPosY ButtWidth*0.5 TextHeight];
HDtext2 = uicontrol('Parent', HDmainf, ...
   'Style','text', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'Horiz','left', ...
   'String','Iterations:', ...
   'Interruptible','off', ...
   'BackgroundColor',[0.45 0.45 0.45], ...
   'ForegroundColor','white');


textPos=[ButtPosX+0.65*ButtWidth ButtPosY ButtWidth*0.35 TextHeight];
callbackStr = 'iterset';
stringVal=num2str(NoGVFIterations);
HDedit2 = uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','edit', ...
   'Units','pixel', ...
   'Position',textPos, ...
   'Units','normal', ...
   'Horiz','right', ...
   'Background','white', ...
   'Foreground','black', ...
   'String',stringVal,'Value',mu, ...
   'UserData',NoGVFIterations,...
   'Enable',onoff,...
   'callback',callbackStr);

% Radio Button 3 			- Normalized
ButtPosY = ButtPosY-2*ButtDist-ButtHeight;
labelPos=[ButtPosX ButtPosY ButtWidth TextHeight];
labelStr='Normailze';
callbackStr='RadioUPDATE';

btnPos=[ButtPosX ButtPosY ButtWidth ButtHeight];
HDRadioButton3=uicontrol('Parent', HDmainf, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','radiobutton', ...
   'Units','pixels', ...
   'Position',labelPos, ...
   'String',labelStr, ...
   'value',VectorFieldButt(3),'Userdata',VectorFieldButt(3), ...
   'Callback',callbackStr);

% help for menu1
str='Click on images for magnification.|';
str=strcat(str,'~\bf<--Back|\rmBack to the previous menu.|');
str=strcat(str,'~\bfNext-->|\rmCalculates external force|vector field.|');
str=strcat(str,'~\bfStandard vector field|\rmCalculates standard external|force vector field using gradient.|~\it [u,v] = gradient2(Image2);|');
str=strcat(str,'~\bfGVF field|\rmCalculates Gradient Vector Field|external force.|~\it [u,v] = GVF(Image2, mu, NoGVFIterations)|;');
str=strcat(str,'~\bf  Mu (\mu)|  \rmParameter for GVF field.|  (See Theoretical back grounds)|');
str=strcat(str,'~\bf  Iterations|  \rmNumber of iterations in|  calculating GVF.|');
str=strcat(str,'~\bfNormalize|\rmNormalize vectors in vector field.|~\it mag = sqrt(u.*u+v.*v);|\it px = u./(mag+1e-10); py = v./(mag+1e-10);|');

str=strcat(str,'|~\bfTheoretical backgrounds|~\rmStandard vector external vector|field is calculated as|~  \rmF_e_x_t = - \nabla f|');
str=strcat(str,'~\rmGVF vector field is calculated|in order to minimize|~  \rm\epsilon = \int\int\mu(u_x^2+u_y^2+v_x^2+v_y^2)+\mid\nablaf\mid^2\mid\bfv\rm-\nablaf\mid^2dxdy|');
str=strcat(str,'~where|~  \bfv\rm(x,y)=[u(x,y) v(x,y)]');

WriteHelp(str);


%%%% define local menu objects, that should be deletet 
VectorOfLocalMenuHD=[HDButton1 HDButton2 HDedit1 HDtext1 HDedit2 HDtext2 HDMenuAxes HDRadioButton1 HDRadioButton2 HDRadioButton3];
pause(0.1);

%%%% blured and draw the picture

if sigma~=0 
   f = gaussianBlur(Image1,sigma);
else
   f = Image1;
end;

if GradientOn 
	Image2 = abs(gradient2(f));
else 
   Image2 = f;
end;

%Image2 = Image2/max(max(Image2)); % scale the edge map to [0,1]

%set(HDbluredPic,'Visible','Off');
global BluredPic;
if BluredPic==1
   s=strcat('Blured image   (sigma=',num2str(sigma),')');
	HDbluredPic=subplot(222); imdisp(-Image2); title(s);
   set(HDbluredPic,'Units', 'pixels','Position',[adgeD*2+xsize adgeD*2+ysize xsize ysize],'Units', 'normal');
   BluredPic=0;
end

HD=get(HDbluredPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic2Click'')');

