%% ransac方法与最小二乘方法求直线
% 2015-10-18
% WENG
% Version 1.0 

%% 
clear all; clc; %#ok<CLSCR>
load data;

%% 使用ransac算法求解直线
Th=3;
PtNum=100;
IteratorCount=10000;                                                                            %IteratorCount为迭代次数
ParaOfModel=zeros(IteratorCount,2);                                                             %ParaOfModel存储模型参数
NumInliner=zeros(IteratorCount,1);                                                              % NumInliner存储局内点个数
dataXY=data;


for iC=1:IteratorCount
    
    %随机产生点1和点2
    Index2Pt=fix(100*random('unif',0,1,1,2))+1;                                                 %Index2Pt为随机抽取点的序号
    x1=dataXY(Index2Pt(1),1); y1=dataXY(Index2Pt(1),2); 
    x2=dataXY(Index2Pt(2),1); y2=dataXY(Index2Pt(2),2);                                                                                  
    % calculate parameters
    k=(y1-y2)/(x1-x2);
    b=y1-k*x1;
    ParaOfModel(iC,:)=[k,b];
    % calculate the residual of all data
    v=abs(dataXY(:,2)-(k*dataXY(:,1)+b));
    iCount=0;                                                                                  %求出符合此模型的点数
    for ii=1:PtNum
        if v(ii)<Th
            iCount=iCount+1;
        end
    end
    NumInliner(iC,1)=iCount;                                                                   %将点数存入 NumInliner
end

[C,I]=max(NumInliner);
mc=ParaOfModel(I,:);
vv=abs(dataXY(:,2)-(mc(1)*dataXY(:,1)+mc(2)));

% keep the point in the permit range
KeepsPtIndex=[];
for iii=1:PtNum
        if vv(iii)<Th
            KeepsPtIndex=[KeepsPtIndex;iii]; %#ok<AGROW>
        end
end

KeepsPt=dataXY(KeepsPtIndex,:);
KeepsPtNum=length(KeepsPt);
AA=[KeepsPt(:,1),ones(KeepsPtNum,1)];
LL=KeepsPt(:,2);
PARA_ransac=(AA'*AA)^(-1)*(AA'*LL); % (ATA)^-1(ATL)
fprintf(1,'ransac processing results\n-------------------------------------------\n');
fprintf(1,sprintf('Points keeps %d (Totall %d)\n',KeepsPtNum,length(dataXY)));
fprintf(1,sprintf('Parameters are, k=%f, b=%f\n',PARA_ransac(1),PARA_ransac(2)));



%% 使用最小二乘求解直线
PtNum_Ori=length(dataXY);
AA=[dataXY(:,1),ones(PtNum_Ori,1)];
LL=dataXY(:,2);
PARA_LS=(AA'*AA)^(-1)*(AA'*LL);

fprintf(1,'\nLS ( Least Squares ) processing results\n-------------------------------------------\n');
fprintf(1,sprintf('Parameters are, k=%f, b=%f\n',PARA_LS(1),PARA_LS(2)));


%% 作图
X=1:100;
Y1=PARA_ransac(1)*X+PARA_ransac(2);
Y2=PARA_LS(1)*X+PARA_LS(2);
plot(dataXY(:,1),dataXY(:,2),'.','MarkerSize',8); hold on;
plot(KeepsPt(:,1),KeepsPt(:,2),'g.','MarkerSize',10); 
plot(Y1,'r');
plot(Y2,'g');
hleg1=legend('原始数据','Ransac选取的点','Ransac fitted regression line', 'LS fitted regression line');
set(hleg1, 'Position', [.60,.20,.2,.05]);
hold off
title('the difference bettwen Rancac and LS (Least Squares)');
set(gcf,'Position',[100,50,600,500]);



    