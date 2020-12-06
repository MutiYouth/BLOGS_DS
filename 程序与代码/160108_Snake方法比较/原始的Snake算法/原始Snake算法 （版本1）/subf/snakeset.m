% call functon for snake parameters uicontrol

function snakeset()
global alpha beta gama kappa dmin dmax;		% parameters for the snake
global HDedit1 HDedit2 HDedit3 HDedit4 HDedit5 HDedit6 HDedit7;
global NoSnakeIterations;

v = get(gcbo,'Userdata');
s = get(gcbo,'String');
vv = eval(s,num2str(v));
if s~=num2str(vv)| vv<0
   vv = v; 
   set(gcbo, 'String', num2str(v))
   return
end
set(gcbo,'Userdata',vv,'String',num2str(vv))

switch gcbo
case HDedit1,
   alpha=vv;
case HDedit2,   
   beta=vv;
case HDedit3,   
   gama=vv;
case HDedit4,   
   kappa=vv;
case HDedit5,   
   dmin=vv;
case HDedit6,   
   dmax=vv;
case HDedit7,   
   NoSnakeIterations=vv;
end

return