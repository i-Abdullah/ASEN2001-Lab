function [ loadvec_weightadded loadjoints_weighted ] = AddWeight(densityBars,lengthBars, loadvec,connectivity,joints)
% This function will add the weight
%
%
%
%
%
%
%
%

% check the lengthes of the connected stuff
[ r c ] = size(connectivity);
[ r2 c2 ] = size(loadvecs);

%establish the outputs
loadvec_weightadded = zeros(r,3);
loadjoints_weighted = 1:1:r2;

% first add the pre-existed loads
for i=1:r2
    
    
    
end


for j=1:r
    
    
    
end

end