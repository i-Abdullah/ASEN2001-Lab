function [probfail] = MonteCarls(inputfile)
%
% Stochastic analysis of 2-D statically determinate truss by
% Monte Carlo Simulation. Only positions and strength of joints 
% treated as random variables
%
% Assumption: variation of joint strength and positions described 
%             via Gaussian distributions
% 
%             joint strength : mean = 4.8
%                              coefficient of variation = 0.4
%             joint position : 
%                              coefficient of variation = 0.01
%                              (defined wrt to maximum dimension of truss)
%
%             number of samples is set to 1e5
%
% Input:  inputfile  - name of input file
%
% Author: Kurt Maute for ASEN 2001, Oct 13 2012

% parameters
jstrmean   = 4.8;   % mean of joint strength 4.8 N
jstrcov    = 0.08;  % coefficient of variation (sigma/u) of joint strength = 0.4/4.8 N
jposcov    = 0.01;  % coefficient of variation of joint position percent of length of truss (ext)
numsamples = 1e3;   % number of samples



% read input file
[numbers,cord_joints,connectivity,Reactions_forces,External_Loads] = ExtractTruss(inputfile);


[r1 c1] = size(connectivity);
sleve = zeros(1,r1);
sleveweight = (5.35/1000)*9.81;

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

% determine extension of truss
ext_x=max(joints(:,1))-min(joints(:,1));   % extension in x-direction
ext_y=max(joints(:,2))-min(joints(:,2));% extension in y-direction
ext_z=max(joints(:,3))-min(joints(:,3)); %extension in z-direction
ext  =max([ext_x,ext_y,ext_z]);


%% add weight :

LinDensity = 31.13 / 1000 ; % kg / m
sleveweight = (5.35/1000)*9.81;
magnetsmass = 1.7;
[r1 c1] = size(connectivity);
sleve = zeros(1,r1);


[loadvecs_weighted,loadjoints_weighted]=addweight(connectivity,joints,loadjoints,loadvecs,LinDensity,sleve,sleveweight,magnetsmass);

%%

% loop overall samples
numjoints=size(joints,1);       % number of joints
maxforces=zeros(numsamples,1);  % maximum bar forces for all samples
maxreact=zeros(numsamples,1);   % maximum support reactions for all samples
failure=zeros(numsamples,1);    % failure of truss

for is=1:numsamples 
    % generate random joint strength limit
    varstrength = (jstrcov*jstrmean)*randn(1,1);
    
    jstrength = jstrmean + varstrength;
    
    % generate random samples
    varjoints = (jposcov*ext)*randn(numjoints,3);
    
    % perturb joint positions
    randjoints = joints + varjoints;
    
    % compute forces in bars and reactions

    [barforces,reacforces]=FAA(joints,connectivity,reacjoints,reacvecs,loadjoints_weighted,loadvecs_weighted);
    
    % determine maximum force magnitude in bars and supports
    maxforces(is) = max(abs(barforces))
    maxreact(is)  = max(abs(reacforces));
    
    % determine whether truss failed
    failure(is) = maxforces(is) > jstrength || maxreact(is) > jstrength;
end

figure(2);
subplot(1,2,1);
histogram(maxforces,30);
title('Histogram of maximum bar forces');
xlabel('Magnitude of bar forces');
ylabel('Frequency');

subplot(1,2,2);
histogram(maxreact,30);
title('Histogram of maximum support reactions');
xlabel('Magnitude of reaction forces');
ylabel('Frequency');

%fprintf('\nFailure probability : %e \n\n',sum(failure)/numsamples);

probfail = sum(failure)/numsamples;
end

