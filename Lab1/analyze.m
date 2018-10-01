function [A,b] = analyze(num_ext_f_m,cord_ext_f,mag_direc_ext_f,mag_direc_ext_m,loc_ext_m,loc_supp,type_f_m_rec,direc_f_m_rec)
% Sept 17th, 2018. ASEN 2001 Statics and Structures, Lab 1
% Done By: Abdulla Al Ameri, Daniel Gutierrez Mendoza, Davis Peirce
%----------------------------------------------------------------------
% This function takes information about a system in static equilibrium and
% calculates the magnitudes of the reaction forces and moments.
%----------------------------------------------------------------------
% INPUTS:
%          1- Number of external forces and moments
%          2- Coordinates of the external forces
%          3- Magnitude and direction of the external forces
%          4- Coordinates of the external moments
%          5- Magnitude and direction of the external moments
%          6- Location of the supports
%          7- Type of the reactions
%          8- Direction of the reactions
% OUTPUTS:
%          1- Matrix of coefficients (A)
%          2- Vector of the sums of forces and moments in the X,Y,Z (b)
%
%

%% EXTERNAL FORCES
% Get the external forces and their unit vector, and get their location from origin

% Convert the forces to cartesian
[ r c ] = size(mag_direc_ext_f); %Take the size of the matrix
ext_f_in_cart = zeros(r,(c-1)); %Initialize the matrix

for i = 1:r %Loop for each force
 %Normalize the forces and then multiply by the magnitude.
    ext_f_in_cart(i,:) = (mag_direc_ext_f(i)) .* (mag_direc_ext_f(i,2:(c)) ./ norm(mag_direc_ext_f(i,2:c)));
    
end

%Set the displacement vector equal to the coordinates
r_to_ext_f = cord_ext_f;


%end

%% Moments
% Moments due to forces

[ r c ] = size(ext_f_in_cart); %Take the size of the forces matrix. Each force may cause a moment.
m_due_to_ext_f = zeros(r,c); %Initialize the matrix for the moments

for i=1:r %Loop for each force
    
m_due_to_ext_f(i,:) = cross(r_to_ext_f(i,:),ext_f_in_cart(i,:)); %Take the
%cross product of each displacement vector and its corresponding force.

end



% External moments

[ r c ] = size(mag_direc_ext_m); %Take the size of the matrix of external

%moments

%get unit vector along axis of rotation for each external moment

for i=1:r % Loop for each moment
%Normalize each of the moments to get the unit vectors 
unit_v_ext_m(i,:) = mag_direc_ext_m(2:c) / norm(mag_direc_ext_m(2:c));

end

for i=1:r %Loop for each moment
%Multiply each unit vector by the magnitude of the moment
    m_due_to_ext_m(i,:) = mag_direc_ext_m(i) .* unit_v_ext_m(i,:);
end

%% Setup [A]{b} = {x}

%% Sum Fx Fy Fz
[ r c ] = size(ext_f_in_cart);

%Throw an error here if c doesn't == 3.
if c ~= 3
    error('Error: not enough force components');
end


for i=1:c % Loop for each force component
x(i) = sum(ext_f_in_cart(:,i)); % Sum each column
end


%% correcting the mistakes in moments

% sometimes having 0 external moment or moment due to force will result in
% NaN due to the division by 0, the following loop will check if that
% happens and not count it.

%there will be either the 3 component of any moment is NaN which in this
%case we will have to disregard the 3 components or maybe one of the
%components is NaN, then we will have to make this specific component == 0,
% this what the following loop will do!

% the following loop will correct the mistakes in each component of the
% moment, moment due to external moment and momennt due to force, then add
% them.


[ r_m1 c_m1 ] = size(m_due_to_ext_m); %determine the size of each matrix, the number of rows == how many differet moments we have
[ r_m2 c_m2 ] = size(m_due_to_ext_f); %determine the size of each matrix, the number of rows == how many differet moments we have

% first loop will be to moment due to external moments.

for moments = 1:(r_m1) % we will loop until we cover all the moments which are equivelent to the number of rows we have total.
    if isnan(m_due_to_ext_m(moments,1)) + isnan(m_due_to_ext_m(moments,2)) + isnan(m_due_to_ext_m(moments,3)) == 3
    %if each column, each component of the moment is Nan, then each one
    %will return 1 to the function isnan, and their sum will be == 3, and
    %thus we will disregard all of them
    
    m_due_to_ext_m(moments,:) = []; %delete that whole row if all are NaN.
    
    elseif isnan(m_due_to_ext_m(moments,1)) == 1 && isnan(m_due_to_ext_m(moments,2)) + isnan(m_due_to_ext_m(moments,3)) == 2 
            %if the problem is just the first component, make it 0
        m_due_to_ext_m(moments,1) == 0;
        
    elseif isnan(m_due_to_ext_m(moments,2)) == 1 && isnan(m_due_to_ext_m(moments,1)) + isnan(m_due_to_ext_m(moments,3)) == 0
            %if the problem is just the second component, make it 0
             m_due_to_ext_m(moments,1) == 0;
        
     elseif isnan(m_due_to_ext_m(moments,3)) == 1 && isnan(m_due_to_ext_m(moments,1)) + isnan(m_due_to_ext_m(moments,2)) == 0 
            %if the problem is just the third component, make it 0
             m_due_to_ext_m(moments,1) == 0;
    end

end


%second loop is for the moments due to external forces.

for moments = 1:(r_m2) % we will loop until we cover all the moments which are equivelent to the number of rows we have total.
    if isnan(m_due_to_ext_f(moments,1)) + isnan(m_due_to_ext_f(moments,2)) + isnan(m_due_to_ext_f(moments,3)) == 3
    %if each column, each component of the moment is Nan, then each one
    %will return 1 to the function isnan, and their sum will be == 3, and
    %thus we will disregard all of them
    
    m_due_to_ext_f(moments,:) = []; %delete that whole row if all are NaN.
    
    elseif isnan(m_due_to_ext_f(moments,1)) == 1 && isnan(m_due_to_ext_f(moments,2)) + isnan(m_due_to_ext_f(moments,3)) == 2 
            %if the problem is just the first component, make it 0
        m_due_to_ext_f(moments,1) == 0;
        
    elseif isnan(m_due_to_ext_f(moments,2)) == 1 && isnan(m_due_to_ext_f(moments,1)) + isnan(m_due_to_ext_f(moments,3)) == 0
            %if the problem is just the second component, make it 0
             m_due_to_ext_f(moments,1) == 0;
        
     elseif isnan(m_due_to_ext_f(moments,3)) == 1 && isnan(m_due_to_ext_f(moments,1)) + isnan(m_due_to_ext_f(moments,2)) == 0 
            %if the problem is just the third component, make it 0
             m_due_to_ext_f(moments,1) == 0;
    end

end

%% Sum Mx My Mz

    total_m = [ m_due_to_ext_m ; m_due_to_ext_f ]; % Put all moments in one array

for i=1:c  % Loop for each moment component x y z
x(r+i+1) = sum(total_m(:,i)); % Sum the moment columns
end


x = x'; % Invert the vector

%% Set up the matrix of coefficients (A)

A = zeros(6); % Initialize the matrix

% Forces loop
for i=1:6 % Loop 6 times
    
    if type_f_m_rec(i) == 'F' % Go through the list of reaction types and find where they are forces
   A(1:3,i) = (direc_f_m_rec(i,:) ./ norm(direc_f_m_rec(i,:)))';
   %Normalize the direction of the reaction to get the unit vector
   %And add it to rows 1 through 3 of matrix A
    end
    
end

% External Moments Loop
for i=1:6  % Loop 6 times
    
    if type_f_m_rec(i) == 'M' % Go through the list of reaction types and find where they are moments
   A(4:6,i) = (direc_f_m_rec(i,:) ./ norm(direc_f_m_rec(i,:)))';
   %Normalize the direction of the reaction to get the unit vector
   %And add it to rows 4 through 6 of matrix A
    end

end


% Reaction Moments Loop
for i=1:6 % Loop 6 times
    
    if type_f_m_rec(i) == 'F' % Go through the list of reaction types and find where they are forces
    u_a = (direc_f_m_rec(i,:) ./ norm(direc_f_m_rec(i,:)))';
    %Normalize the direction of the reaction force to get the unit vector
    a = cross(loc_supp(i,:),u_a);
    %And cross it with the displacement vector of the location
    %To get moment directions
    A(4:6,i) = a;
    %And add it to matrix A
    end
    
end

%% Check for errors in A

%Sometimes when you divide by a unit vector of 0 NaN will be trown, we will
%make them zeros.

%also, if A is not 6x6 or a square matrix (rows == columns), we will throw an error.

[ rows columns ] = size(A);

%check for square matrices

if rows ~= columns
    
    error('you do not have a square matrix, rows does not equal columns, check your inputs file');
    
end

% check for NaN and make them zeros.

for nan_r=1:rows
    for nan_c=1:columns
        
        if isnan(A(nan_r,nan_c)) == 1 %check if cell is NaN
            %this will return 1 for Nan cells.
            
            A(nan_r,nan_c) = 0;
        end
    end
end

%% Set up the resultant matrix (b)

b = zeros(6,1); %Initialize b

%The first three rows are the sum of forces in x y z
for i=1:3 % Loop 3 times
    
    b(i) = sum(ext_f_in_cart(:,i)); % Sum the forces in x, y, z
    
end

%The last three rows are the sums of moments about x y z
for i=4:6 % Loop three times
    
    b(i) = sum( [ m_due_to_ext_m(:,i-3) (m_due_to_ext_f(:,i-3))' ] ); %Sum the moments
    
end

b = -1 .* b; %Invert b

%% Check for errors in b

% b also should equal the number of rows / columns in A

if length(b) ~= length(A)
    
    error('b matrix have a demnsion problem, check your input file!')
    
end

% also delete all the Nan from b. Just Like A.

for b_len = 1:length(b)
    
    if isnan(b(b_len)) ==1
        b(b_len) = 0;
    end
    
end
end