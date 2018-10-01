function [ truss ] = TrussReadInput( fname )
% "block" sets the kind of input argument that is meant to be read.
% 0 - initializer line
% 1 - joint block
% 2 - connectivity block
% 3 - reaction forces
% 4 - external loads
block = 0;
count = 0;

fid = fopen(fname);
frewind(fid);

line = fgetl(fid);
% Each time fgetl(fid) is called, the next line is read and the output
% contains the string of that line. If there are no more lines to read, the
% output is -1.
while line ~= -1
    % If the current line is commented out using a '#' symbol as the first
    % character or is empty, then move to the next line and begin from the
    % start of the while loop.
    if line(1) == '#'
        line = fgetl(fid);
        continue;
    end
    
    % Otherwise, read the necessary input data and save it to the truss
    % structure.
    switch block
        case 0
            % Get number of joints, bars, reactions, and external loads
            % from the first data line in the file.
            dims = sscanf(line,'%d%d%d%d%d');
            
            % Initiailize output matrices.
            numJoints = dims(1);
            joints    = zeros(numJoints,3);
            numBars   = dims(2);
            bars      = zeros(numBars,2);
            numReacts = dims(3);
            reacts    = zeros(numReacts,4);
            numLoads  = dims(4);
            loads     = zeros(numLoads,4);
            
            % Change to the next command block.
            block = block + 1;
            
        case 1
            % Get the coordinates of the truss joints.
            dat    = sscanf(line,'%d%e%e%e');
            jid    = dat(1);   % joint id
            jcoord = dat(2:4); % cooordinate vector
            
            joints(jid,:) = jcoord;
            count = count + 1;
            
            % If the block is complete, proceed to the next one.
            if count == numJoints
                count = 0;
                block = block + 1;
            end
            
        case 2
            dat = sscanf(line,'%d%d%d%d%d');
            bid = dat(1); % bar id
            b1  = dat(2); % bar 1
            b2  = dat(3); % bar 2
            
            bars(bid,:) = [b1; b2];
            count = count + 1;
            
            % If the block is complete, proceed to the next one.
            if count == numBars
                count = 0;
                block = block + 1;
            end
            
        case 3
            dat  = sscanf(line,'%d%e%e%e%e');
            rid  = dat(1);   % reaction joint id
            rdir = dat(2:4); % direction of reaction
            % Convert reaction direction vetor to unit vector.
            rdir = rdir/norm(rdir);
            
            reacts(count+1,:) = [rid; rdir];
            count = count + 1;
            
            % If the block is complete, proceed to the next one.
            if count == numReacts
                count = 0;
                block = block + 1;
            end
            
        case 4
            dat  = sscanf(line,'%d%e%e%e%e');
            lid  = dat(1);   % external load joint id
            lvec = dat(2:4); % external load vector
            
            reacts(count+1,:) = [lid; lvec];
            count = count + 1;
            
            % If the block is complete, proceed to the next one.
            if count == numLoads
                count = 0;
                block = block + 1;
            end
    end
    
    % Continue to the next line and repeat.
    line = fgetl(fid);
end

% Save output matrices into output structure.
truss.joints = joints;
truss.bars   = bars;
truss.reacts = reacts;
truss.loads  = loads;

% Close the input file.
fclose(fid);
end