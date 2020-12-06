%%%%%%%%%% Snake Iter %%%%%%%%%%

function SnakeIter(action,varargin)
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
global XSnake YSnake;								% conture of the snake


%%%% interface variables
global VectorOfLocalMenuHD;		%vector of local objects that can be arased in next step
global HDmainf;			 			%main figure handle
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global HDedit1 HDedit2 HDedit3 HDedit4 HDedit5 HDedit6; % handels of snake edit uicontrol
global HDSnakeLine;					%vector of Handles of Snake lines on the picture
global SnakeON;						%indicate if snake is visible
global SnakeDotsON;				      % 1 if snake dots should be displeyed
global DotsSize;						% size in pixels of the dots on the snake


global xsize ysize;					%size of the picture

global adgeD MinSize MenuSizeX MenuSizeY MenuPosX MenuPosY;
global ButtHeight ButtWidth ButtDist TextHeight;

%%%%%%%%% close old objects
if ~isempty(HDSnakeLine(1)) 
   delete(HDSnakeLine(1)); 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% snake deformation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x,y] = snakeinterp(XSnake,YSnake,dmax,dmin);

set(HDmainf,'CurrentAxes',HDorigPic);
hold on

XS=[x; x(1)];
YS=[y; y(1)];
HD=line(XS,YS);
for i=1:ceil(NoSnakeIterations/5),
   if i<=floor(NoSnakeIterations/5) 
      [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,5);
      title(['Iter = ', num2str(i*5)])
   else 
      [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,NoSnakeIterations-floor(NoSnakeIterations/5)*5);
      title(['Iter = ', num2str(NoSnakeIterations)])
   end;
   [x,y] = snakeinterp(x,y,dmax,dmin);
   XS=[x; x(1)];
   YS=[y; y(1)];
   
   set(HD,'Color','Red','Marker','None');
   HD=line(XS,YS);
   if (SnakeDotsON==1) % draw dots if it is chosen
   	set(HD,'Color','Red','Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
	else
  	 set(HD,'Color','Red','Marker','None');
	end;
   
   pause(0.1);
end
XSnake=x; YSnake=y;
title(['Iter = ' num2str(NoSnakeIterations)])
pause(0.1);
hold off;

imdisp(-Image1); title('Original image');

%%%%% result
set(HDmainf,'CurrentAxes',HDorigPic);
hold on
HDline1=plot(XS,YS,'red');
hold off;

set(HDmainf,'CurrentAxes',HDbluredPic);
hold on
HDline2=plot(XS,YS,'red');
hold off;

set(HDmainf,'CurrentAxes',HDvectorFPic);
hold on
HDline3=plot(XS,YS,'red');
hold off;

%%%% define if butt click on picture
HD=get(HDorigPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic1Click'')');

HD=get(HDbluredPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic2Click'')');

HD=get(HDvectorFPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic3Click'')');

%%%%%%%%% close old objects
if ~isempty(HDSnakeLine(2:3)) 
   delete(HDSnakeLine(2:3)); 
   HDSnakeLine=[];
end;

%%%% define local menu objects, that should be deletet 
HDSnakeLine=[HDline1 HDline2 HDline3];
SnakeON=1;

	% draw dots if it is chosen
if SnakeDotsON==1 
   set(HDSnakeLine,'Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
else
   set(HDSnakeLine,'Marker','None');
end;


%set(HDSnakeLine,'XData',XS,'YData',YS);
return

%--------------------
% subfunction for click on picture 1

function Pic1Click()
global Image1;
global SnakeON;
global SnakeDotsON;				      % 1 if snake dots should be displeyed
global DotsSize;						% size in pixels of the dots on the snake

global XSnake YSnake;								% conture of the snake


f1=figure; imdisp(-Image1); title('Original image');
set(f1, 'Color', [0.8 0.8 0.8], ... 
               'NumberTitle', 'off', ... 
               'Name', 'Original image with snake', ... 
               'Units', 'pixels',...
               'ButtonDownFcn','SnakeIter(''CloseFig'')',...
               'UserData',f1);
            
hold on
if SnakeON==1 
   XS=[XSnake; XSnake(1)];
   YS=[YSnake; YSnake(1)];
   HDline=line(XS, YS); 
end

HD=get(f1,'Children');
HD=get(HD,'Children');

set(HD,'ButtonDownFcn','SnakeIter(''CloseFig'')',...
   'UserData',f1);

if (SnakeON==1)
	if (SnakeDotsON==1) % draw dots if it is chosen
   	set(HDline,'Color','Red','Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
	else
  	 set(HDline,'Color','Red','Marker','None');
	end;
end;

return              

%--------------------
% subfunction for click on picture 2

function Pic2Click()
global Image2;
global XSnake YSnake;								% conture of the snake
global sigma;
global SnakeON;
global SnakeDotsON;				      % 1 if snake dots should be displeyed
global DotsSize;						% size in pixels of the dots on the snake

f2=figure; imdisp(-Image2); title(strcat('Blured image   (sigma=',num2str(sigma),')'));
set(f2, 'Color', [0.8 0.8 0.8], ... 
               'NumberTitle', 'off', ... 
               'Name', 'Blured image with snake', ... 
               'Units', 'pixels',...
               'ButtonDownFcn','SnakeIter(''CloseFig'')',...
               'UserData',f2);
            
hold on
if SnakeON==1 
   XS=[XSnake; XSnake(1)];
   YS=[YSnake; YSnake(1)];
   HDline=line(XS, YS); 
end

HD=get(f2,'Children');
HD=get(HD,'Children');

set(HD,'ButtonDownFcn','SnakeIter(''CloseFig'')',...
   'UserData',f2);

if (SnakeON==1)
	if (SnakeDotsON==1) % draw dots if it is chosen
   	set(HDline,'Color','Red','Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
	else
  	 set(HDline,'Color','Red','Marker','None');
	end;
end;
return              

%--------------------
% subfunction for click on picture 2

function Pic3Click()
global Image2;
global XSnake YSnake;								% conture of the snake
global mu NoGVFIterations;
global VectorFieldButt;
global px py;
global SnakeON;
global SnakeDotsON;				      % 1 if snake dots should be displeyed
global DotsSize;						% size in pixels of the dots on the snake

f3=figure;
 xSpace=(1:size(Image2,1)/64:size(Image2,1));
 ySpace=(1:size(Image2,2)/64:size(Image2,2));
 qx=interp2(px,xSpace, ySpace');
 qy=interp2(py,xSpace, ySpace');

 quiver(xSpace,ySpace,qx,qy); axis('ij');  axis equal;

if VectorFieldButt(1)==1
   title('Standard potencial field');
else
   s=strcat('GVF   (mu=',num2str(mu),'  iterations=',num2str(NoGVFIterations),')');
   title(s);
end

set(f3, 'Color', [0.8 0.8 0.8], ... 
               'NumberTitle', 'off', ... 
               'Name', 'Potencial field with snake', ... 
               'Units', 'pixels',...
               'ButtonDownFcn','SnakeIter(''CloseFig'')',...
               'UserData',f3);
            
hold on
if SnakeON==1 
   XS=[XSnake; XSnake(1)];
   YS=[YSnake; YSnake(1)];
   HDline=line(XS, YS); 
end

if VectorFieldButt(1)==1
   title('Standard potencial field');
else
   s=strcat('GVF   (mu=',num2str(mu),'  iterations=',num2str(NoGVFIterations),')');
   title(s);
end

HD=get(f3,'CurrentAxes');
set(HD,'XLim',[0 size(Image2,1)],...
                  'YLim',[0 size(Image2,2)],...
                  'XTickMode','manual','XTick',[],...
                  'YTickMode','manual','YTick',[],...
                  'Box','On');
HD=get(f3,'Children');
HD=get(HD,'Children');

set(HD,'ButtonDownFcn','SnakeIter(''CloseFig'')',...
   'UserData',f3);

if (SnakeON==1)
	if (SnakeDotsON==1) % draw dots if it is chosen
   	set(HDline,'Color','Red','Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
	else
  	 set(HDline,'Color','Red','Marker','None');
	end;
end;
return              

%----------------------
% function close opend figure when button is down

function CloseFig()
close(get(gcbo,'UserData'));
return
