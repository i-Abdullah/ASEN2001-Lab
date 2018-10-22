function [barweight_m, reacjoints_w]=addweight(connectivity,joints,loadjoints,loadvecs,sleve,sleveweight)
%find length of each bar
[r c]=size(connectivity);
[r1 c1]=size(joints);
lin_dens=31.3/1000;
lin_dens=31.3/1000;
barlength = zeros(r,1);
for i = 1:r
    joint_2 = connectivity(i,2);
    joint_1 = connectivity(i,1);
    barlength(i) = sqrt(((joints(joint_1,1)-joints(joint_2,1))^2)+((joints(joint_1,2)-joints(joint_2,2))^2)+((joints(joint_1,3)-joints(joint_2,3))^2))*(0.0254);
end
% barweight given bar dens and length
barweight = barlength.*(lin_dens*9.81);
barweight_m = zeros(r,3);

for j = 1:length(loadjoints)
    
    barweight_m(loadjoints(j),:) = loadvecs(j,:);
    
end

%add half of the bar weight into each side

for k = 1:r
    
barweight_m(connectivity(k,1),3) = barweight_m(connectivity(k,1),3) - barweight(k)/2;
barweight_m(connectivity(k,2),3) = barweight_m(connectivity(k,2),3) - barweight(k)/2;

    
end

% after hardcoding sleves with 1 and 0, if there is a sleve add the weight
% to the bar
for i = 1:r
    if sleve(i) == 1
       barweight_m(connectivity(i,1),3) = barweight_m(connectivity(i,1),3) - sleveweight/2;
       barweight_m(connectivity(i,2),3) = barweight_m(connectivity(i,2),3) - sleveweight/2;
    end
end

magweight = (1.7/1000)*9.81;
barweight_m(:,3) = barweight_m(:,3) - magweight;
reacjoints_w = 1:r1;
reacjoints_w = reacjoints_w';
%{
% unit vector force direction
loc_barweight= [0,0,-1];



% force of each magnet

[r2 c2] = size(joints);
joint_load = zeros(r2,3);
joint_load(:,3) = magweight;

% magnitude of weight load from both joints and bars
loadjoints_weightsAdded=zeros(r+r2,1);

for i=1:r
    loadjoints_weightsAdded(i,1)=barweight(i,1);
end

for i=r+1:r2+r
    loadjoints_weightsAdded(i,1)= magweight;
end

% load vectors from weight load
loadvecs_weightsAdded=zeros(r+r2,3);

for i=1:r+2
    loadvecs_weightsAdded(i,3)= barweight(i,1)/2;
end

for i=r+1:r+r2
    loadvecs_weightsAdded(i,1)=magweight*joints(i-r,1);
    loadvecs_weightsAdded(i,2)=magweight*joints(i-r,2);
    loadvecs_weightsAdded(i,3)=magweight*joints(i-r,3);
end

loadvecs_weightsAdded = [loadvecs;loadvecs_weightsAdded];
loadjoints_weightsAdded = [loadjoints;loadjoints_weightsAdded];
%}
end
    

    