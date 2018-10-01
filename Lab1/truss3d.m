function [] = truss3d(Lab1_Input)
% Sept 17th, 2018 ASEN 2001 Statics and Structures, Lab 1
% Done By: Abdulla Al Ameri, Daniel Gutierrez Mendoza, Davis Peirce
%
% --------------------------------------------------------------------------------
%
% This function will determine the reaction forces around a body given info
% about the forces and moments act on it. The function will work with two other
% sub-functions, Extraction, and analyze. Each function is documneted.
%
% --------------------------------------------------------------------------------
%
%                               INPUTS:
%
% 1- txt file specially formatted to be analyzed
%
% --------------------------------------------------------------------------------
%                               OUTPUTS:
%
% 1- ASCII file that has the support reactions forces and moments.
%
%

%% Extraction

[ num_ext_f_m cord_ext_f mag_direc_ext_f mag_direc_ext_m loc_ext_m  loc_supp type_f_m_rec direc_f_m_rec ] = Extraction(Lab1_Input);

%% analyze

[ A b ] = analyze(num_ext_f_m,cord_ext_f,mag_direc_ext_f,mag_direc_ext_m,loc_ext_m,loc_supp,type_f_m_rec,direc_f_m_rec);

%% Get the reaction values/Printout the file

% get reaction values
x = A \ b ;

%% check for error in the reaction

% if b matrix had 0 or inf becasue we divided by 0, we will elminate them
% this's possible because in normal cases matrixes would be as big as
% unknowns, for our case we are always sitting it to be 6x6

% this loop will check for zeros and inf
for x_len = 1:length(x)
    
    if isnan(x(x_len)) == 1 || isinf(x(x_len)) == 1
        x(x_len) = 0;
    end
    
end


%% Print the results on table (just for visualization and arrangment)

% extract the type of reaction and put them in array
[ r c ] = size(type_f_m_rec);
for i_new = 1:r
    Type_of_reaction{i_new} = { type_f_m_rec(i_new) };
end

Type_of_reaction = Type_of_reaction';
Type = cellstr([Type_of_reaction{:}])';

% get the magnuitudes
Magnitude = x;

x = direc_f_m_rec(:,1);
y = direc_f_m_rec(:,2);
z = direc_f_m_rec(:,3);

     
%% print the result and the problem setup to a table

    %initate the file
    
    
    %the following line will rename the output file dynamically based on
    %the given problem, it'll go to the input file name and copy it but the
    %last 4 charcters (the extension .txt), and then add to it _raction.txt
    %and name it the file with it.
    
    output_file_name = [Lab1_Input(1:length(Lab1_Input)-4) '_Ractions.txt'];

fid = fopen(output_file_name,'w+'); %with premission to write.
    
    %output the reactions info in a loop
    
    for i_new=1:length(Magnitude)
        
fprintf(fid,'Reaction number: %d \n',i_new ); %print out the rection number as d (double), and \n insert new line after that.
fprintf(fid,'Magnitude: %0.4f \n',Magnitude(i_new)); %print out the magnitude as f floating number with 4 decimal places, and \n insert new line after that.
fprintf(fid,'Type: %c \n',type_f_m_rec(i_new)); %print out the type as c, character, and \n insert new line after that.
fprintf(fid,'Direction (xyz): %d',direc_f_m_rec(i_new,1)); %print out direction as d (double), and  DON'T \n insert new line after that.
fprintf(fid,'% d',direc_f_m_rec(i_new,2)); %print the second direction
fprintf(fid,'% d',direc_f_m_rec(i_new,3)); %print the third direction
fprintf(fid,'\n'); % add a new line
fprintf(fid,'\n'); % add another line on which the new reaction will output
    
    end
    
        % prepare for the problem setup
    fprintf(fid,'------------(THE PROBLEM SETUP IS BELOW!!)------------ \n');
    fprintf(fid,'\n'); % add a new line (as a spacer).

    %% The problem setup
    
    %open a new handle for the problem setup file to read it.
    fid_setup = fopen(Lab1_Input);
    
    %intiate a counter for the fgetl that will extract from the original
    %function line by line.
    setup = 'initial run';
    
    %loop until we're done with setup file
    while setup ~= -1 %when fgetl returns -1, this will tell us we finished reading the file line by line
        
        setup = fgetl(fid_setup); %read line by line
        
        if setup ~= -1 %this condition to avoid the last ittration of the loop, the last ittration will output -1 to the file but this condition will make sure it does not.
            
        fprintf(fid,'%s \n',setup ); %store the line you read as string array %s, and ( \n ) insert new line after that.
        end
        
    end
    

    fclose('all'); %close all handles.

end