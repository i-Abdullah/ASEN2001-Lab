% Purpose: compute forces in bars and reaction forces
%
% Input:  joints       - coordinates of joints
%         connectivity - connectivity 
%         reacjoints   - joint id where reaction acts on
%         reacvecs     - unit vector associated with reaction force
%         loadjoints   - joint id where external load acts on
%         loadvecs     - load vector
%
% Output: barforces    - force magnitude in bars
%         reacforces   - reaction forces
%
% Created 9/21/2011
% Modified 10/30/2016
%
% Authors: 
% Kurt Maute
% Connor Myers 104788767
% Cody Goldman 104520953

function [Amat]=buildAmat(joints,connectivity,reacjoints,reacvecs)
numjoints = size(joints,1); numbars = size(connectivity,1);
numreact = size(reacjoints,1); numeqns = 3 * numjoints;
Amat = zeros(numeqns);
for i=1:numjoints
   idx = 3*i-2; idy = 3*i-1; idz = 3*i;
   [ibar,ijt]=find(connectivity==i);
   for ib=1:length(ibar)
       barid=ibar(ib); joint_i = joints(i,:);
       if ijt(ib) == 1
           jid = connectivity(barid,2);
       else
           jid = connectivity(barid,1);
       end
       joint_j = joints(jid,:); vec_ij = joint_j - joint_i;
       uvec   = vec_ij/norm(vec_ij); Amat([idx idy idz],barid)=uvec;
   end
end
for i=1:numreact
    jid=reacjoints(i); idx = 3*jid-2; idy = 3*jid-1; idz = 3*jid;
    Amat([idx idy idz],numbars+i)=reacvecs(i,:);
end
end