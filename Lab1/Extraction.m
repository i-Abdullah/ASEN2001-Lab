
function [num_f_m,ext_f_cord,mag_direc_ext_f,mag_direc_ext_couple_m,loc_couple_ext_m,supp_loc,type_reaction,direc_reaction] = Extraction (Lab1_Input)
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

handle = fopen(Lab1_Input); %give the input file ID.

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


%% Data Set 1: Number of External Forces and Moments

set = {}; %Initialize set
i = 1; %Initialize counter variable i
num_f_m = [ 0 0 ]; %Initialize num_f_m

if data_indi(1+i) - data_indi(i) == 1 %If two lines of data are consecutive
    
    while data_indi(i+1) - data_indi(i) == 1 % Then while lines are consective
        
        set{1} = input_file{data_indi(i)}; %Store the data in set
        num_f_m_new = str2num(set{i}); %Then convert the contents of set to numbers
        
    end
    
    num_f_m = [ num_f_m ; num_f_m_new ]; %Store the contents in num_f_m
    
    
else
    
    set{i} = input_file{data_indi(i)}; %Store the line in set
    num_f_m = str2num(set{i}); %Then convert the contents of set to numbers
    %And store them in num_f_m
    i = i+1; %Tick up the counter variable
        
end

%% Data Set 2: External Force Coordinates

set = {}; %Clear set
ext_f_cord = [ 0 0 0 ]; %Initialize ext_f_cord

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive

        k = 1; %Initialize k to 1
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        ext_f_cord_new = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        ext_f_cord = [ ext_f_cord ; ext_f_cord_new ]; %Concatenate ext_f_cord and the data 

end

    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    
    set{1} = input_file{data_indi(i)}; %Extract the data to set
    ext_f_cord_new = str2num(set{1}); 
    ext_f_cord = [ ext_f_cord ; ext_f_cord_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

ext_f_cord(1,:) = []; %Clear the first line of zeros

%% Data Set 3: Magnitude and Direction of External Forces

i = i+1; %Tick up the line counter
set = {}; %Clear set
mag_direc_ext_f = [ 0 0 0 0 ]; %Initialize

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive

        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        mag_direc_ext_f_new = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        mag_direc_ext_f = [ mag_direc_ext_f ; mag_direc_ext_f_new ]; %Concatenate data with the array 

end

    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    
    set{1} = input_file{data_indi(i)}; %Extract the data to set
    mag_direc_ext_f_new = str2num(set{1});
    
    %the if statment will check for forgotten info in the file that will
    %cause problems.
    if length(mag_direc_ext_f) ~= length(mag_direc_ext_f_new)
        warning('if you are getting an error you propably have something wrong with your input file which may very well be that you are missing some lines of info, check your file. Our info idicates that you are missing a force, check that');
    end
    
    mag_direc_ext_f = [ mag_direc_ext_f ; mag_direc_ext_f_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

mag_direc_ext_f(1,:) = []; %Clear the first line

%% Data Set 4: Couple Moments Coordinates

i = i+1; %Tick up line counter
set = {}; %Clear set
loc_couple_ext_m = [ 0 0 0 ]; %Initialize array

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive
 
        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        loc_couple_ext_m_new = str2num(set{k});%Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        loc_couple_ext_m = [ loc_couple_ext_m ; loc_couple_ext_m_new ]; %Concatenate data with the array
  
end
  
    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    
    set{1} = input_file{data_indi(i)}; %Extract the data to set
    loc_couple_ext_m_new = str2num(set{1});
    loc_couple_ext_m = [ loc_couple_ext_m ; loc_couple_ext_m_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

loc_couple_ext_m(1,:) = []; %Clear the first line

%% Data Set 5: Magnitude and Direction of Couple Moments

i = i+1; %Tick up line counter
set = {}; %Clear set
mag_direc_ext_couple_m = [ 0 0 0 0 ]; %Initialize array

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive
        
        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        mag_direc_ext_couple_m_new = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        
        %check if the user forgot to put moments or deleted the whole
        %section.
        
    if length(mag_direc_ext_couple_m) ~= length(mag_direc_ext_couple_m_new)
        warning('if you are getting an error you propably have something wrong with your input file which may very well be that you are missing some lines of info, check your file. Our info idicates that you are missing a moment, check that');
    end
    
        mag_direc_ext_couple_m = [ mag_direc_ext_couple_m ; mag_direc_ext_couple_m_new ];

end

    
    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    set{1} = input_file{data_indi(i)};
    mag_direc_ext_couple_m_new = str2num(set{1});
    mag_direc_ext_couple_m = [ mag_direc_ext_couple_m ; mag_direc_ext_couple_m_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

mag_direc_ext_couple_m(1,:) = []; %Clear the first line


%% Data Set 6: Location of Supports

i = i+1; %Tick up line counter
set = {}; %Clear set
supp_loc = [ 0 0 0 ]; %Initialize array

while data_indi(1+i) - data_indi(i) == 1 %While data is consecutive
    
        k = 1; %Initialize k
        set{1} = input_file{data_indi(i)}; %Extract the data to set
        supp_loc_new = str2num(set{k}); %Put the data from set into a new variable
        k = k+1; %Tick up k
        i = i+1; %Tick up line counter
        supp_loc = [ supp_loc ; supp_loc_new ]; %Concatenate data with the array

end

    if data_indi(i+1) - data_indi(i) ~= 1 %If data is not consecutive, such as the last line
    set{1} = input_file{data_indi(i)};
    supp_loc_new = str2num(set{1});
    supp_loc = [ supp_loc ; supp_loc_new ]; %Concatenate data with the array
    %k = k+1;
    
    end

supp_loc(1,:) = [];


%% Data Set 7: Type and Direction of Reactions


i = i+1;
set = {};

direc_reaction = [ 0 0 0 ];
type_reaction = [0];


while data_indi(1+i) - data_indi(i) == 1

    
    while data_indi(i+1) - data_indi(i) == 1
        
        k = 1;
        set{1} = input_file{data_indi(i)};
        
        %Since this new part has letters and numbers, new method will be
        %used
        
        %regexp function will be used to seperate the numbers and the
        %letters each in its own cell, then the letters will be stored in
        %one array themselves and the numbers will be stored in one array
        %themselve.
        
        seperation = regexp(set(1),'\s','split'); %seperation cells
        seperation = seperation{1};
        seperation = seperation(~cellfun('isempty',seperation)); %delete all empty cells due to seperation       
        
        type_reaction_new = seperation{1};
        direc_reaction_new(k,1) = str2num(seperation{2});
        direc_reaction_new(k,2) = str2num(seperation{3});
        direc_reaction_new(k,3) = str2num(seperation{4});
        
        k = k+1;
        i = i+1;
        type_reaction = [ type_reaction ; type_reaction_new ];
        direc_reaction = [ direc_reaction ; direc_reaction_new ];

     if i+1 > length(data_indi)
    break
     end
 
    end
    
    break

    % the breaks will exit the loop once we reach the final itteration and
    % excute the last itteration in a different loop for the way the loops
    % are setup will cause and indicie problem.

end



            if i == length(data_indi)
    
        set{1} = input_file{data_indi(i)};
        seperation = regexp(set(1),'\s','split'); %seperation cells
        seperation = seperation{1};
        seperation = seperation(~cellfun('isempty',seperation)); %delete all empty cells due to seperation       
        
                k = 1;

        type_reaction_new = seperation{1};
        direc_reaction_new = [];
        direc_reaction_new(k,1) = str2num(seperation{2});
        direc_reaction_new(k,2) = str2num(seperation{3});
        direc_reaction_new(k,3) = str2num(seperation{4});
        %k = k+1;
        i = i+1;
        type_reaction = [ type_reaction ; type_reaction_new ];
        direc_reaction = [ direc_reaction ; direc_reaction_new ];    
            
            end
                


direc_reaction(1,:) = [];
type_reaction(1,:) = [];

end
