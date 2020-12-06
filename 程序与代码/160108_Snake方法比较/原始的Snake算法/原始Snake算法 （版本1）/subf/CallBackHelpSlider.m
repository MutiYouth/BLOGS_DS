function CallBackHelpSlider()
global IntYPos;				% vector of inital position of the every text line - used for slider
global HDvectorOfTexthd;
global ysize xsize;
global HDhelpSlider1 HDhelpSlider2;	%handle of the slider for help text 

   k1=1-get(HDhelpSlider1,'Value');
   k2=get(HDhelpSlider2,'Value');
	L=IntYPos(length(IntYPos));
   ymove=ysize*k1/0.12;
   xmove=xsize*1.5*k2;
	xpos=10;
	for i=1:length(IntYPos)
   	set(HDvectorOfTexthd(i),'Position',[5-xmove IntYPos(i)+ymove]);
	end
return