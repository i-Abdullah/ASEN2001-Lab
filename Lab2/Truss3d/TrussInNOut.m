clear;
clc;
close all;

inputfile = 'test3d_1.txt';
outputfile = 'OurTest.txt';

[numbers,cord_joints,connectivity,Reactions_forces,External_Loads] = ExtractTruss(inputfile);

%% Force Analysis

%Prepare inputs:

joints = cord_joints(:,2:length(cord_joints));

[r c] = size(connectivity);
connectivity = connectivity(:,2:c);

%throw error for sizes c

[r c] = size(Reactions_forces);
reacjoints = Reactions_forces(:,1);
reacvecs = Reactions_forces(:,2:c);

[r c] = size(External_Loads);
loadjoints = External_Loads(:,1);
loadvecs = External_Loads(:,2:c);

%%
[barforces,reacforces]=FA3D(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs)

%% Prepare writeoutput functions inputs

writeoutput(outputfile,inputfile,barforces,reacforces,joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs);

%% 

joints3D=zeros(size(joints,1),3);
joints3D(:,1:3)=joints;
plottruss(joints3D,connectivity,barforces,reacjoints,3*[0.025,0.04,0.05],[1 1 0 0])




