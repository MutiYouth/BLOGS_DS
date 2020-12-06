
function iterset2()
% call functon for snake iteratons edit uicontrol

global NoGVFIterations;

v = get(gcbo,'Userdata');
s = get(gcbo,'String');
vv = eval(s,num2str(v));
if vv(1) > 200 | vv(1) < 0 | s~=num2str(vv)| round(vv(1))~=vv(1)
   vv = v; 
   set(gcbo, 'String', num2str(v))
   return
end
set(gcbo,'Userdata',vv,'String',num2str(vv))
NoSnakeIterations=vv;
return