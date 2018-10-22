clear;
clc;
close all;

inputfile = 'test3d_1.inp';
outputfile = 'test3d_1_out.txt';
AssumedFail = 1/100 ;
LinDensity = 31.13 / 1000 ; % kg / m
sleveweight = (5.35/1000)*9.81;
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

%throw error for sizes c


[r c] = size(Reactions_forces);
reacjoints = Reactions_forces(:,1);
reacvecs = Reactions_forces(:,2:c);

[r c] = size(External_Loads);
loadjoints = External_Loads(:,1);
loadvecs = External_Loads(:,2:c);

%% add weight

%[barweight_m,reacjoints_w]=AddWeight(connectivity,joints,loadjoints,loadvecs,sleve,sleveweight);

%%
[barforces,reacforces]=FA3D_n(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);

%% Prepare writeoutput functions inputs

writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);

%% 

joints3D=zeros(size(joints,1),3);
joints3D(:,1:3)=joints;
plottruss(joints3D,connectivity,barforces,reacjoints,3*[0.025,0.04,0.05],[1 1 0 0]);


%% Monted Carlo

jstrmean   = 4.8;   % mean of joint strength 4.8 N
jstrcov    = 0.08;  % coefficient of variation (sigma/u) of joint strength = 0.4/4.8 N
jposcov    = 0.01;  % coefficient of variation of joint position percent of length of truss (ext)
numsamples = 1e5;   % number of samples


ProbFaliure = truss3dmcs(inputfile);

Fdsr = icdf('normal',AssumedFail,jstrmean,jstrcov);

% any given time your max tensile/compressive strength shouldn't exceed the
% 
Saf = 4.8 / Fdsr ;


%}
