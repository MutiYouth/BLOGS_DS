%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 		SNAKE DEMO ver 1.0 beta
% 
%   Interface by
%
%	 Dejan Tomazevic	(e-mail dejan.tomazevic@kiss.uni-lj.si)	10/2/98
%   Copyright (c) 1998 by Dejan Tomazevic
%	 BIPROG, Faculty of Electrical Engineering, University of Ljubljana
%
%   Snake and GVF functions by
%   Chenyang Xu and Jerry L. Prince 6/17/97
%   Copyright (c) 1996-97 by Chenyang Xu and Jerry L. Prince
%   Image Analysis and Communications Lab, Johns Hopkins University
%
%
%	 This program was written during Dejan Tomazevic visit Johns Hopkins University in
% 	 purpose to show the use of traditional snakes and GVF snakes M fuctions.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% PROGRAM BEGINS %%%%%%%%%%


%%%%%%% INICIALIZATIONA %%%%%%%%%%%%%%
clear;

% Add the tools to the current path
p = path;
path(p, './snake;./subf');

%%%%%%%%%%%%% define global variables %%%%%%%%%%%%%%%%%%%
%%%% image processing variables
global Image1;							% original image
global sigma;
global mu;
global alpha beta gamma kappa dmin dmax;		% parameters for the snake
global NoGVFIterations;				% number of GVF iterations
global NoSnakeIterations;		   % number of Snake iterations
global SchangeInFieldType;
global VectorFieldButt;				% define the type of vector filed
global SnakeON;						% indicate if snake is visible
global IncSnakeRadius;				% inicializaton snake radius
global CircleOn;						% inicalization snake will be circle
global SnakeDotsON;				   % 1 if snake dots should be displeyed
global GradientOn;					% 1 if gradient is applayed with blur
global XSnake YSnake;				% conture of the snake
global XSnakeInc YSnakeInc;   	% incicialization conture of the snake


sigma=0;
mu=0.1;
alpha=0.05;
beta=0;
gamma=1;
kappa=0.6;			
dmin=0.5;
dmax=2;
SchangeInFieldType=1;

NoGVFIterations=80;
NoSnakeIterations=40;

VectorFieldButt(1)=1;				% standard field
VectorFieldButt(2)=0;				% GVF filed
VectorFieldButt(3)=1;				% normalized GVF
SnakeON=0;								% snake is not drown on the picture at the begining
IncSnakeRadius=0.5;

CircleOn=1;
SnakeDotsON=1;
GradientOn=0;

%%%% interface variables
global VectorOfLocalMenuHD;		%vector of local objects that can be arased
VectorOfLocalMenuHD=[];
global HDmainf;			 			%main figure handle
global HDorigPic;						%original picture axes handle
global HDbluredPic;				   %blured picture axes handle
global HDvectorFPic;					%handle of vector field picture
global HDhelpAxes;					%handle of help window
global HDhelpSlider1 HDhelpSlider2;	%handle of the slider for help text 
global HDvectorOfTexthd;			% vector of help text handels
global xsize ysize;					%size of the picture
global HDMenuAxes;					%Axes for the help
global HDSnakeLine;					%vector of Handles of Snake lines on the picture
global FileName PathName;			% name of the file
global ExampleNo;						% number of exampel
global DotsSize;						% size in pixels of the dots on the snake
global HDRadioButton1;

HDRadioButton1=[];
HDbluredPic=[];
HDvectorFPic=[];
HDSnakeLine=[];
HDvectorOfTexthd=[];
ExampleNo=1;

global adgeD MinSize MenuSizeX MenuSizeY MenuPosX MenuPosY;
global ButtHeight ButtWidth ButtDist TextHeight;

adgeD=30;								% picture distance form the edge of the figure and each other
MinSize=180;							% min size of picture in pixel on the scren (othewise picture is scaled larger)
MenuSizeX=135;							% menu x size
MenuSizeY=300;
MenuPosX=0; %%							% menu position on the figure
MenuPosY=0; %%
ButtHeight=22;							% size of the button
ButtWidth=50; %%%
ButtDist=7;							% Button distance from the adge of the menu bar
TextHeight=20;
DotsSize=5;
            
menu0;

