clear;
clc;
close all;

[numbers,cord_joints,connectivity,Reactions_forces,External_Loads] = ExtractTruss('test3d_1.txt');

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
[barforces,reacforces]=ForceAnalysis3d(joints,connectivity,reacjoints,reacvecs,loadjoints,loadvecs)

%% Prepare writeoutput functions inputs


