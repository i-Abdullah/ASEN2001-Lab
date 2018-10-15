
function [num,magnets,rods_and_connections,Reactions_forces,External_Loads] = ExtractTruss(Input)
% Sept 17th, 2018. ASEN 2001 Statics and Structures, Lab 1
% Done By: Abdulla Al Ameri, Daniel Gutierrez Mendoza, Davis Peirce
%----------------------------------------------------------------------
% This codes extracts information
% about a body, forces, and moments acting on a body from a file.
% ----------------------------------------------------------------------
% INPUTS:
%           - .txt file name
%           - Important: the name needs to include the extension
%      
%----------------------------------------------------------------------
% OUTPUTS: In order of output (total of 8)
%
%           - number of external forces and moments (in array respectively)
%
%           - coordinates of the points at which external forces are
%           applied (x y z)
%
%           - magnitude and direction of external forces ( F dx dy dz )
%           
%           - location at which external couple moments are applied ( x y
%           z )
%
%           - magnitude and direction of external couple moments (M   ux
%           uy   uz)
%
%           - location of supports ( x y z )
%
%           - type (F/M) of reactions
%
%           -  direction of reactions
%----------------------------------------------------------------------
% If you are not fimilar with CLI ( Command Line interface ) function in
% matlab, you would've to do something like
% [a,b,c,d,e,f,g,h] = Extraction ('Lab1_Input');
% where a,b,c ... are your outputs in order

%% Housekeeping
clc

%% Extract the whole file

%-----------------------------(GET THE DATA)-------------------------------

handle = fopen(Input); %give the input file ID.

i = 'initial run'; %initialize the looping variable
j = 0; %loop counter

input_file = {};
%Create a file with cells input to extract each line from the data file to a cell.

while i ~= -1 %fgetl returns -1 when the lines have all been read
    
	i = fgetl(handle); %Opens the file line by line
    j = j+1; %Keeping count to make sure data goes in the right cell
    input_file {j} = i; %Put the data extracted in cell j of input_file

end

%% See where the #comments are in the cell
% 1 = cell is comments, 0 = cell is data

comments_indi = zeros(1,length(input_file)-1); 
%Initialize an array of the length of the cell vector minus 1

for j = 1 : (length(input_file)-1) %loop for the length of the index

    if contains(input_file(j),'#') == 1 %check if the cell is comment
    comments_indi(j) = 1; %return 1 at the indicie of the comment cell
    
    end
end

%% Extract the info between the comments

% The following sections will extract data blocks and write them in seperate
% arrays. 

data_indi = find(comments_indi==0); %Finds the locations of the zeros (the data)
%It's like a treasure map

%From there, if data is consecutive they will be
%extracted together in one array.

% There's 7 total blocks of data.


%% Data Set 1: num bars reactions ext f

set = {}; %Initialize set
i = 1; %Initialize counter variable i
num = [ 0 0 0 0 ]; %Initialize num_f_m

if data_indi(1+i) - data_indi(i) == 1 %If two lines of data are consecutive
    
    while data_indi(i+1) - data_indi(i) == 1 % Then while lines are consective
        
        set{1} = input_file{data_indi(i)}; %Store the data in set
        num_new = str2num(set{i}); %Then convert the contents of set to numbers
        
    end
    
    num = [ num ; num_ew ]; %Store the contents in num_f_m
    
    
else
    
    set{i} = input_file{data_indi(i)}; %Store the line in set
    num = str2num(set{i}); %Then convert the contents of set to numbers
    %And store them in num_f_m
    i = i+1; %Tick up the counter variable
        
end

num_joints = num(1);
num_bars = num(2);
num_reactions = num(3);
num_ext_loads = num(4);

%% Data Set 2: Magnets cords and their cordinates

set = {}; %Clear set
magnets = [ 0 0 0 0 ]; %Initialize ext_f_cord

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive

        k = 1; %Initialize k to 1
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        manets_new = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        magnets = [ magnets ; manets_new ]; %Concatenate ext_f_cord and the data 

end

    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    
    set{1} = input_file{data_indi(i)}; %Extract the data to set
    manets_new = str2num(set{1}); 
    magnets = [ magnets ; manets_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

magnets(1,:) = []; %Clear the first line of zeros

%% Data Set 3: Rods and their asocciated joints

i = i+1; %Tick up the line counter
set = {}; %Clear set
rods_and_connections = [ 0 0 0 ]; %Initialize

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive

        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        rods_and_connections_new = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        rods_and_connections = [ rods_and_connections ; rods_and_connections_new ]; %Concatenate data with the array 

end

    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    
    set{1} = input_file{data_indi(i)}; %Extract the data to set
    rods_and_connections_new = str2num(set{1});
    
    
    rods_and_connections = [ rods_and_connections ; rods_and_connections_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

rods_and_connections(1,:) = []; %Clear the first line

%% Data Set 4: Reactions forces

i = i+1; %Tick up line counter
set = {}; %Clear set
Reactions_forces = [ 0 0 0 0 ]; %Initialize array

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive
 
        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        Reaction_forces_New = str2num(set{k});%Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        Reactions_forces = [ Reactions_forces ; Reaction_forces_New ]; %Concatenate data with the array
  
end
  
    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    
    set{1} = input_file{data_indi(i)}; %Extract the data to set
    Reaction_forces_New = str2num(set{1});
    Reactions_forces = [ Reactions_forces ; Reaction_forces_New ]; %Concatenate data with the array
    %k = k+1;
    
    end

Reactions_forces(1,:) = []; %Clear the first line


%% Data Set 5: Externa Loads

i = i+1; %Tick up line counter
set = {}; %Clear set
External_Loads = [ 0 0 0 0 ]; %Initialize array

if i == length(data_indi)
    
    External_Loads = str2num(input_file{data_indi(i)});
    
else
    
while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive
        
        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        External_Loads_New = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        
        
        
        External_Loads = [ External_Loads ; External_Loads_New ];

        % the last itteration
        
            if i == length(data_indi) %If data is not consecutive, such as the last line
    set{1} = input_file{data_indi(i)};
    External_Loads_New = str2num(set{1});
    External_Loads = [ External_Loads ; External_Loads_New ]; %Concatenate data with the array
    %k = k+1;
    break
            end
end

    

    External_Loads(1,:) = []; %Clear the first line

end

end
