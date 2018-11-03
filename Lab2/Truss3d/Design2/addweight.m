function [barweight_m, reacjoints_w]=addweight(connectivity,joints,loadjoints,loadvecs,lin_dens,sleve,slevemass,jointmass,magnetmass)
% Oct 1th, 2018. ASEN 2001 Statics and Structures, Lab 2
% Done By:
%           - Abdulla Al Ameri
%           - Eric Hunnel
%           - Kunal Sinha
%           - Johann Kailey-Steiner
%           - Mia Abouhamad
%----------------------------------------------------------------------
% The following function will adjust given vectors of external loads and their
% locations and return two vectors, one about the location of the joints,
% and one about their actual magnitude in x y z 
%
% ----------------------------------------------------------------------
% INPUTS:
%           - connectivity: what joints has bars connected to them
%           - joints: the location of joints
%           - loadjoints: where loads already applied.
%           - laoadvecs: external loads (weight is to be added
%           - lin_dens = linear density in  kg / m
%           - sleve: Array of 0's and 1's, will be as big as how many bars
%           we have and if at the location of the bar 1 is returned that
%           mean there's a sleve there
%           - sleveweight: in N.
%           - jointmass: the mass of the balls that acted as joints
%           - magnetmass: mass of the magnets that were glued to the side
%           of each bar.
%      
%----------------------------------------------------------------------
% OUTPUTS: In order of output (total of 8)
%
%           - barweight_m: vector returns all external loads with weight
%           added
%
%           - reacjoints_w: the joints the load is applied to.
%
%
%----------------------------------------------------------------------
% If you are not fimilar with CLI ( Command Line interface ) function in
% matlab, you would've to do something like
% [a,b,c,d,e,f,g,h] = Extraction ('Lab2_Input.txt');
% where a,b,c ... are your outputs in order

%find length of each bar

[r c]=size(connectivity);
[r1 c1]=size(joints);
barlength = zeros(r,1);

% define weight of magnet balls that are acting as joints and weight of
% magnets that are glued at the end of each bar

magnetweight = (magnetmass)*9.81;
jointweight = (jointmass)*9.81;
sleveweight = (slevemass)*9.81;


%loop over conectivity to find length.

for i = 1:r
    %see each joints each bar is connected to.
    joint_2 = connectivity(i,2);
    joint_1 = connectivity(i,1);
    %get length and convert to meters
    barlength(i) = sqrt(((joints(joint_1,1)-joints(joint_2,1))^2)+((joints(joint_1,2)-joints(joint_2,2))^2)+((joints(joint_1,3)-joints(joint_2,3))^2))*(0.0254);
end


% barweight given bar dens and length
barweight = barlength.*(lin_dens*9.81);
barweight_m = zeros(r1,3);

% add pre-exisiting loads if there's any

for j = 1:length(loadjoints)
    
    barweight_m(loadjoints(j),:) = loadvecs(j,:);
    
end

%add half of the bar weight into each side and with that half there's also
%magnet that's glued at each side.

for k = 1:r
    
barweight_m(connectivity(k,1),3) = barweight_m(connectivity(k,1),3) - barweight(k)/2 - magnetweight ;
barweight_m(connectivity(k,2),3) = barweight_m(connectivity(k,2),3) - barweight(k)/2 - magnetweight ;

    
end

% after hardcoding sleves with 1 and 0, if there is a sleve add the weight
% to the bar

% the sleve vector is hard coded, check TrssInNOutDesign.m

for i = 1:length(sleve)
    if sleve(i) == 1
       barweight_m(connectivity(i,1),3) = barweight_m(connectivity(i,1),3) - (sleveweight/2);
       barweight_m(connectivity(i,2),3) = barweight_m(connectivity(i,2),3) - (sleveweight/2);
    end
end

% add weight of magnet balls that are acting as joints

barweight_m(:,3) = barweight_m(:,3) - jointweight ;

%restablish load joints, where each row will represent the number of joint
%or joint id
reacjoints_w = 1:r1;
reacjoints_w = reacjoints_w';





end