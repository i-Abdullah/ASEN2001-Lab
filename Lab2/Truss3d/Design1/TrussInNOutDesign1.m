clear;
clc;
close all;

inputfile = 'Design1.inp';
outputfile = 'Design1Out.txt';
AssumedFail = 0.028/100 ;
LinDensity = 31.13 / 1000 ; % kg / m
sleveweight = (5.35/1000)*9.81;
magnetsmass = 1.7;
[numbers,cord_joints,connectivity,Reactions_forces,External_Loads] = ExtractTruss(inputfile);

[r1 c1] = size(connectivity);
sleve = zeros(1,r1);



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

[loadvecs_weighted,loadjoints_weighted]=addweight(connectivity,joints,loadjoints,loadvecs,LinDensity,sleve,sleveweight,magnetsmass);

%%
[barforces,reacforces]=FAA(joints,connectivity,reacjoints,reacvecs,loadjoints_weighted,loadvecs_weighted);

%% Prepare writeoutput functions inputs

writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints_weighted,loadvecs_weighted);

%% plot 3D Truss

joints3D=zeros(size(joints,1),3);
joints3D(:,1:3)=joints;
plottruss(joints3D,connectivity,barforces,loadjoints_weighted,3*[0.025,0.04,0.05],[1 1 0 0]);


%% Monted Carlo


jstrmean   = 4.8;   % mean of joint strength 4.8 N
jstrcov    = 0.08;  % coefficient of variation (sigma/u) of joint strength = 0.4/4.8 N
jposcov    = 0.01;  % coefficient of variation of joint position percent of length of truss (ext)
numsamples = 1e5;   % number of samples


ProbFaliure = MonteCarls(inputfile);

Fdsr = icdf('normal',AssumedFail,jstrmean,jstrcov);

% any given time your max tensile/compressive strength shouldn't exceed the
% 
Saf = 4.8 / Fdsr ;

%save the montecarlo result
saveas(gcf,['MonteCarlo.png'])

