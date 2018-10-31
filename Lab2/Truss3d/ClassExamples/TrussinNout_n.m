%% info:

%% house keeping
clear;
clc;
close all;


%% intro

%change the name of the input and output here
inputfile = 'test3d_1.inp';
outputfile = 'test3d_1_out.txt';

%assumed failure probability. 
AssumedFail = 1/100 ;
LinDensity = 31.13 / 1000 ; % kg / m
sleveweight = (5.35/1000)*9.81; % N %measured.

%run extraction function
[numbers,cord_joints,connectivity,Reactions_forces,External_Loads] = ExtractTruss(inputfile);

[r1 c1] = size(connectivity);
sleve = zeros(1,r1);
% -8.21 what you should get for test case 1
%% Force Analysis

%Prepare inputs:
[ r c ] = size(cord_joints);
joints = cord_joints(:,(2:end));

[r c] = size(connectivity);
connectivity = connectivity(:,2:c);


[r c] = size(Reactions_forces);
reacjoints = Reactions_forces(:,1);
reacvecs = Reactions_forces(:,2:c);

[r c] = size(External_Loads);
loadjoints = External_Loads(:,1);
loadvecs = External_Loads(:,2:c);

% run force analysis.

[barforces,reacforces]=FA3D_n(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);

%% Prepare writeoutput functions inputs

writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);

%%  Plot in 3d.
joints3D=zeros(size(joints,1),3);
joints3D(:,1:3)=joints;
plottruss(joints3D,connectivity,barforces,reacjoints,3*[0.025,0.04,0.05],[1 1 0 0]);

