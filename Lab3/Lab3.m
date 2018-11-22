%% Housekeeping

clear;
clc;
close all;

%% read and extract file

E_Foam = 0.035483*10^9 ; %Pa
E_Bals = 3.2953*10^9 ; %Pa

% Wiffle Tree Weights:

Sleeve = 0.49 ; %N sleeve
six_in_bar = 1.77 ; %N 6 inch bar
twelve_in_bar = 2.94 ; %N 12 inch bar
eighteen_in_bar = 3.92 ; %N 18 inch bar

Thickness = 0.0206375; %in meter.
%% read test data:

[ TestData Comments ] = xlsread('TestData.xlsx');
FailType = cellstr(Comments(2:length(Comments),6));

% Check if you failing bending or shear

% the contains is case-sensitive;
BendFail = contains(FailType,{'Bending','bending'});
ShearFail = contains(FailType,{'Shear','shear','perpendicular'});

% get the exact data related to bend and ehar

BendData = TestData(BendFail,:);
ShearData = TestData(ShearFail,:);

% get the length of the middle bar b:

Barlength = 36*0.0254 ; % in m
bBend = (Barlength) - 2*BendData(:,3); % in meter
bShear = (Barlength) - 2*ShearData(:,3); % in meter

FoamLength = 3/4 * 0.0254 ; % in m
BalsaLength = 1/32 * 0.0254 ; % in m
Width = 4 * 0.0254; %in m
%% Shear/moment daiagram : TEST DATA

% do the shear/moment daiagrams for shear fail

ShearDiagram_ShearFail = {};

%place holders

ShearStress_ShearFail = zeros(1,length(bShear));
ShearStress_BendFail = zeros(1,length(bBend));
RootFunction_ShearFail = {};

%place holders for maximas
Max_Shear_ShearFail = zeros(1,length(bShear));
Max_Shear_BendFail = zeros(1,length(bBend));
Max_Moment_ShearFail = zeros(1,length(bShear));
Max_Moment_BendFail = zeros(1,length(bBend));


for i =1:length(bShear)
syms x
ShearDiagram_ShearFail{i} = piecewise ( 0<x<ShearData(i,3) , ShearData(i,2)/2 , ShearData(i,3)<x<bShear(i)+ShearData(i,3) , 0 , bShear(i)+ShearData(i,3)<x<Barlength , -ShearData(i,2)/2 );
Max_Shear_ShearFail(i) = double(max(subs(cell2sym(ShearDiagram_ShearFail(i)),[0:0.01:Barlength]))) ;
ShearStress_ShearFail(i) = ((3/2) * (Max_Shear_ShearFail(i)) )/ (Width*FoamLength) ;

end

% bending fail 

ShearDiagram_BendFail = {};

for i =1:length(bBend)
syms x
ShearDiagram_BendFail{i} = piecewise ( 0<x<BendData(i,3) , BendData(i,2)/2 , BendData(i,3)<x<bBend(i)+ BendData(i,3) , 0 , bBend(i)+BendData(i,3)<x<Barlength , -BendData(i,2)/2 );
Max_Shear_BendFail(i) = double(max(subs(cell2sym(ShearDiagram_BendFail(i)),[0:0.01:Barlength]))) ;
ShearStress_BendFail(i) = ((3/2) * (Max_Shear_BendFail(i)) )/ (Width*FoamLength) ;

end

%moment daiagarams = 

MomentDiagram_ShearFail = int(ShearDiagram_ShearFail,x);
MomentDiagram_BendFail = int(ShearDiagram_BendFail,x);


%loop to get max 

for i =1:length(bShear)
    
Max_Moment_ShearFail(i) = double(max(subs(MomentDiagram_ShearFail(i),[0:0.01:Barlength]))) ;

end

for i =1:length(bBend)
    
Max_Moment_BendFail(i) = double(max(subs(MomentDiagram_BendFail(i),[0:0.01:Barlength]))) ;

end

%% get p(0), V, and M : DESIGN

%{
syms p0 x
qx = 4*p0 * sqrt ( 1 - ((2*x)/Barlength)^2) ;

%get V
Vx = int(qx,p0,x);
Mx = int(Vx,p0,x);

% F = int(q(c),c,-l/2,l/2)
V(x) = f/2 + int(q(x),x,-1/2,x)
M(x) = int(V(x),x,-l/2,x)
subs 

%}