function caclVF();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calculate Vector field
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% image processing variables
global Image2;							% blured image
global mu;
global NoGVFIterations;				% number of iterations
global VectorFieldButt;				
global alpha beta gamma kappa dmin dmax;		% parameters for the snake
global px py u v;											% forse filed
global SchangeInFieldType;
global XSnake YSnake;				% conture of the snake


global xsize ysize;					%size of the picture

global adgeD;

%%%%% global handles
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture

global HDvectorFPic;
global HDSnakeLine;					%vector of Handles of Snake lines on the picture
global SnakeON;						%indicate if snake is visible
global SnakeDotsON;				      % 1 if snake dots should be displeyed
global DotsSize;						% size in pixels of the dots on the snake



if SchangeInFieldType==1
	if VectorFieldButt(1)==1
   	% Compute standard vector filed of Image2
   	[u,v] = gradient2(Image2);
	else
   	 % Compute the GVF of the edge Image2
    	disp(' Compute GVF ...');
    	[u,v] = GVF(Image2, mu, NoGVFIterations); 
   end
   SchangeInFieldType=0;
 end
 
 if VectorFieldButt(3)==1
  	mag = sqrt(u.*u+v.*v);
   px = u./(mag+1e-10); py = v./(mag+1e-10); 
 else
   	px=u; py=v;
 end
 
 %HDvectorFPic=subplot(223); 
 global HDmainf;
 set(HDmainf,'CurrentAxes',HDvectorFPic);
 xSpace=(1:size(Image2,1)/64:size(Image2,1));
 ySpace=(1:size(Image2,2)/64:size(Image2,2));
 qx=interp2(px,xSpace, ySpace');
 qy=interp2(py,xSpace, ySpace');

 quiver(xSpace,ySpace,qx,qy); axis('ij');
if VectorFieldButt(1)==1
   title('Standard potencial field');
else
   s=strcat('GVF   (mu=',num2str(mu),'  iterations=',num2str(NoGVFIterations),')');
   title(s);
end

set(HDvectorFPic,'Units', 'pixels','Position',[adgeD adgeD xsize ysize],...
   					'Units', 'normal',...
                  'XLim',[0 size(Image2,1)],...
                  'YLim',[0 size(Image2,2)],...
                  'XTickMode','manual','XTick',[],...
                  'YTickMode','manual','YTick',[],...
                  'Units', 'pixels');
               
%%%%% result
XS=[XSnake; XSnake(1)];
YS=[YSnake; YSnake(1)];

HDline1=line('Parent', HDorigPic,'XData',XS,'YData',YS,'Color','Red');
HDline2=line('Parent', HDbluredPic,'XData',XS,'YData',YS,'Color','Red');
HDline3=line('Parent', HDvectorFPic,'XData',XS,'YData',YS,'Color','Red');

HDSnakeLine=[HDline1 HDline2 HDline3];
SnakeON=1;
if SnakeDotsON==1 
   set(HDSnakeLine,'Marker','.','MarkerEdgeColor','Green','MarkerFaceColor','Blue','MarkerSize',DotsSize);
else
   set(HDSnakeLine,'Marker','None');
end;

               
HD=get(HDvectorFPic,'Children');
set(HD,'ButtonDownFcn','SnakeIter(''Pic3Click'')');
               
menu3;