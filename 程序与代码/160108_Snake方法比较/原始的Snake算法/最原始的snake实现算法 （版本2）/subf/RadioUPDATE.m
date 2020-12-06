%%%%% sub function
%%%%% calback radio button

function RadioUPDATE()
global SchangeInFieldType;

global HDRadioButton1 HDRadioButton2 HDRadioButton3 HDedit1 HDedit2;
global VectorFieldButt;				

if gcbo==HDRadioButton1 
   set([HDedit1 HDedit2],'Enable','off'); 
   VectorFieldButt(1)=1;							% standar vector filed
   VectorFieldButt(2)=0;
   set(gcbo,'Value',1);
   set(HDRadioButton2, 'value', 0);
   SchangeInFieldType=1;
end;

if gcbo==HDRadioButton2 
   set([HDedit1 HDedit2],'Enable','on'); 
   VectorFieldButt(1)=0;							% GVF vector filed
   VectorFieldButt(2)=1;
   set(gcbo,'Value',1);
   set(HDRadioButton1, 'value', 0);
   SchangeInFieldType=1;
end;

if gcbo==HDRadioButton3								% switch between normalized an non-normalized vector field
   if VectorFieldButt(3)==1 
      VectorFieldButt(3)=0;
   else
      VectorFieldButt(3)=1;
   end
end

return
