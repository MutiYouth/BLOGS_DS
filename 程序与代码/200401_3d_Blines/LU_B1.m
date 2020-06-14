% ref: 闭合 B 样条曲线控制点的快速求解算法及应用
% http://www.doc88.com/p-5714423317458.html
% https://blog.csdn.net/liumangmao1314/article/details/54588155


%计算B样条曲线控制点

function px = LU_B1(CPnum, V)
a = 1;
b = 4;
c = 1;
d = 1;
e = 1;

f = zeros(CPnum-1,1);
g = zeros(CPnum-2,1);
h = zeros(CPnum,1);
k = zeros(CPnum-1,1);

% get h[] & f[]
h(1) = b;
for i=1:CPnum-2
    f(i) = a/h(i);
    h(i+1) = b - f(i)*c;
end

% get g[] & f[n-1]
g(1) = d/h(1);
for i=1:CPnum-3
    g(i+1) = -g(i)*c/h(i+1);
end
f(CPnum-1) = ( a-g(CPnum-2)*c )/h(CPnum-1);

% get k[] & h[n]
k(1) = e;
for i=1:CPnum-3
    k(i+1) = -f(i)*k(i);
end
k(CPnum-1) = c - f(CPnum-2)*k(CPnum-2);

gksum = 0;
for i=1:CPnum-2
    gksum = gksum + g(i)*k(i);
end
h(CPnum) = b - gksum - f(CPnum-1)*c;

% 矩阵求解过程，追的过程
x = zeros(CPnum,1);   
x(1) = 6*V(end);

for i=1:CPnum-2      
    x(i+1) = 6*V(i) - f(i)*x(i);       
end

gxsum = 0;    

for i=1:CPnum-2
    gxsum = gxsum + g(i)*x(i);        
end

x(CPnum) = 6*V(CPnum-1) - gxsum - f(CPnum-1)*x(CPnum-1);    

% 赶的过程
px = zeros(CPnum+2,1);    

px(CPnum) = x(CPnum)/h(CPnum);
px(CPnum-1) = ( x(CPnum-1)-k(CPnum-1)*px(CPnum) )/h(CPnum-1);

for i=CPnum-2:-1:1
    px(i) = ( x(i)-c*px(i+1)-k(i)*px(CPnum) )/h(i);
end
px(CPnum+1) = px(1);
px(CPnum+2) = px(2);    

end

