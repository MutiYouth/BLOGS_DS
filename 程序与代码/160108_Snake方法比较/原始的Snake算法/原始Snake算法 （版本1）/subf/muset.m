% call functon for mu edit uicontrol

function muset()

global mu;
global SchangeInFieldType;


v = get(gcbo,'Userdata');
s = get(gcbo,'String');
vv = eval(s,num2str(v));
if vv(1) > 20 | vv(1) < 0 | s~=num2str(vv)
   vv = v; 
   set(gcbo, 'String', num2str(v))
   return
end
set(gcbo,'Userdata',vv,'String',num2str(vv))
mu=vv;
SchangeInFieldType=1;
return