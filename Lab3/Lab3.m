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

%% Shear/moment daiagram

% do the shear/moment daiagrams for shear fail

ShearDiagram_ShearFail = {};

for i =1:length(bShear)
syms x
ShearDiagram_ShearFail{i} = piecewise ( 0<x<ShearData(i,3) , ShearData(i,2)/2 , ShearData(i,3)<x<bShear(i)+ShearData(i,3) , 0 , bShear(i)+ShearData(i,3)<x<Barlength , -ShearData(i,2)/2 );

end

% bending fail 

ShearDiagram_BendFail = {};

for i =1:length(bBend)
syms x
ShearDiagram_BendFail{i} = piecewise ( 0<x<BendData(i,3) , BendData(i,2)/2 , BendData(i,3)<x<bBend(i)+ BendData(i,3) , 0 , bBend(i)+BendData(i,3)<x<Barlength , -BendData(i,2)/2 );

end


%extract the related data:
