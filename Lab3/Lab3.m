%% Housekeeping

clear;
clc;
close all;

%% read and extract file

E_Foam = 0.035483*10^9 ; %Pa
E_Bals = 3.2953*10^9 ; %Pa

% Wiffle Tree Weights:

Sleeve = 0.49 ; %N sleeve
six_in_bar = 1.77 ; %N 6 inch bar
twelve_in_bar = 2.94 ; %N 12 inch bar
eighteen_in_bar = 3.92 ; %N 18 inch bar

LengthCS = 0.0206375; %in meter.
%% read test data:

% read file
[ TestData Comments ] = xlsread('TestData.xlsx');

%get the comments as strings to see how it failed.
FailType = cellstr(Comments(2:length(Comments),6));

% Check if you failing bending or shear

% the contains is case-sensitive;
BendFail = contains(FailType,{'Bending','bending'});
ShearFail = contains(FailType,{'Shear','shear','perpendicular','both'});


%% excludeds :

% test 7 is excluded, no breakage
% test 11 : no comment

%% 
% get the exact data related to bend and ehar

BendData = TestData(BendFail,:);
ShearData = TestData(ShearFail,:);

%% add data manually:

%{
if some if borken on both shear and moment or might be shear but is
reported as moment, it should be added manually.

%}


%% get the length of the middle bar b:

Barlength = 36*0.0254 ; % in m
bBend = (Barlength) - 2*BendData(:,3); % in meter
bShear = (Barlength) - 2*ShearData(:,3); % in meter

FoamLength = 3/4 * 0.0254 ; % in m
BalsaLength = 1/32 * 0.0254 ; % in m
WidthCS = 4 * 0.0254; %in m CS = Cross-section
WidthCSBendData = BendData(:,4);
WidthCSShearData = ShearData(:,4);





%% Shear/moment daiagram : TEST DATA

%{

% do the shear/moment daiagrams for shear fail

ShearDiagram_ShearFail = {};

%place holders

ShearStress_ShearFail = zeros(1,length(bShear));
ShearStress_BendFail = zeros(1,length(bBend));
RootFunction_ShearFail = {};

%place holders for maximas
Max_Shear_ShearFail = zeros(1,length(bShear));
Max_Shear_BendFail = zeros(1,length(bBend));
Max_Moment_ShearFail = zeros(1,length(bShear));
Max_Moment_BendFail = zeros(1,length(bBend));


for i =1:length(bShear)
syms x
ShearDiagram_ShearFail{i} = piecewise ( 0<x<ShearData(i,3) , ShearData(i,2)/2 , ShearData(i,3)<x<bShear(i)+ShearData(i,3) , 0 , bShear(i)+ShearData(i,3)<x<Barlength , -ShearData(i,2)/2 );
Max_Shear_ShearFail(i) = double(max(abs(subs(cell2sym(ShearDiagram_ShearFail(i)),[0:0.01:Barlength])))) ;
%ShearStress_ShearFail(i) = ((3/2) * (Max_Shear_ShearFail(i)) )/ (WidthCS*FoamLength) ;

end

% bending fail 

ShearDiagram_BendFail = {};

for i =1:length(bBend)
syms x
ShearDiagram_BendFail{i} = piecewise ( 0<x<BendData(i,3) , BendData(i,2)/2 , BendData(i,3)<x<bBend(i)+ BendData(i,3) , 0 , bBend(i)+BendData(i,3)<x<Barlength , -BendData(i,2)/2 );
Max_Shear_BendFail(i) = double(max(abs(subs(cell2sym(ShearDiagram_BendFail(i)),[0:0.01:Barlength])))) ;
%ShearStress_BendFail(i) = ((3/2) * (Max_Shear_BendFail(i)) )/ (WidthCS*FoamLength) ;

end

%moment daiagarams = 
MomentDiagram_ShearFail1 = int(ShearDiagram_ShearFail,x,BendData(1,3),bBend(1)+ BendData(1,3));
MomentDiagram_ShearFail2 = int(ShearDiagram_ShearFail,x,BendData(1,3),bBend(1)+ BendData(1,3));
MomentDiagram_BendFail = int(ShearDiagram_BendFail,x)

%not needed:
%{
%loop to get max 
% remove ABS if you do not need the absloute value of max-min!
for i =1:length(bShear)
    
Max_Moment_ShearFail(i) = double(max(abs(subs(MomentDiagram_ShearFail(i),[0:0.01:Barlength])))) ;

end

for i =1:length(bBend)
    
Max_Moment_BendFail(i) = double(max(abs(subs(MomentDiagram_BendFail(i),[0:0.01:Barlength])))) ;

end
%}


%% Find Maximum moment: the moment at the location of faliure

for i =1:length(bBend)
    
Max_Moment_BendFail(i) = double(abs(subs(MomentDiagram_BendFail(i),x,BendData(i,5)))) ;

end

for i =1:length(bShear)
    
Max_Moment_ShearFail(i) = double(abs(subs(MomentDiagram_ShearFail(i),ShearData(i,5)))) ;

end



%}

%Largest moment
[ r c ] = size(BendData) ;
for i=1:r
    
    if 0 <= BendData(i,5) < BendData(i,3)
        
        Mfail(i) = (BendData(i,2)/2)*BendData(i,5);
        
    elseif BendData(i,3) <= BendData(i,5) && BendData(i,5) < BendData(i,3)+bBend(i)
        
       Mfail(i) = (BendData(i,2)/2)*BendData(i,3);

    else
        
        Mfail(i) = (BendData(i,2)/2)*BendData(i,5);
        
    end
    
    
end

%Largest shear
[ r c ] = size(ShearData) ;
for i=1:r
    
    if 0 <= ShearData(i,5) < ShearData(i,3)
        
        Vfail(i) = ShearData(i,2)/2;
        
    elseif ShearData(i,3) <= ShearData(i,5) && ShearData(i,5) < ShearData(i,3)+ShearData(i)
        
       Vfail(i) = ShearData(i,2)/2; % It should be 0 but they didn't account
       %for the strap in the test, so we will just use the value before it.
       %Because there's no way it'll break @ 0 shear.

    else
        
        Vfail(i) = -ShearData(i,2)/2;
        
    end
    
    
end


%% Moment of Inertia: from centroidal axis.

% the neutral axis is the z axis, thus moment about z axis for foam will be
% just at the axis itself,

CentroidShape = ((FoamLength+(2*BalsaLength))/2) ;
CnetroidTopBalsa = ( (FoamLength + BalsaLength) + BalsaLength/2 );

IFoam_Bend = (1/12).*( WidthCSBendData ).*(FoamLength)^3 ;
IBalsa_Bend = 2*((1/12).*(WidthCSBendData).*(BalsaLength)^3 + ( CentroidShape - CnetroidTopBalsa ) ^2 ).*(WidthCSBendData.*BalsaLength) ;

IFoam_Shear = (1/12).*( WidthCSShearData ).*(FoamLength)^3 ;
IBalsa_Shear = 2*((1/12).*(WidthCSShearData).*(BalsaLength)^3 + ( CentroidShape - CnetroidTopBalsa ) ^2 ).*(WidthCSShearData.*BalsaLength) ;

%% safety factor

FOS = 1.3;

%% Max Normal Stress: Flexural Formula

MaxNormalStress_BendFail = -(Mfail' .* (BalsaLength+(FoamLength/2)))./ ( IBalsa_Bend + (E_Foam/E_Bals).*IFoam_Bend) ;
%remove outlayers

MaxNormalStress_BendFail(5) = [];

% they're both the same, it's sample 10;

%max alloweable normal stress
MaxAllowNormal = mean(MaxNormalStress_BendFail)./ FOS ; 

%% Max Shear Stress: Shear Formula

% the ShearStress_BendFail takes the whole area instead of half, double
% check.

%we checked, it's the full area.

for i=1:length(Vfail)
MaxShearStress_ShearFail = (3/2) * (abs(Vfail)'./((FoamLength).*ShearData(i,4))) ;
end

%remove outlayers

%get picket values

%all of them are 0 here but this needs to be checked later.

PickedAllow = min(MaxShearStress_ShearFail);

%{
% determine which width of the beam you have picked:

if isnumeric(find(MaxShearStress_ShearFail == PickedAllow))==1
    
    PickedWidth = find(MaxShearStress_ShearFail == PickedAllow);
    
else
    
    PickedWidth = find(MaxShearStress_BendFail == PickedAllow);
    
end

%}

MaxAllowShear = ( PickedAllow /1.3); 

%%


%% get p(0), V, and M : DESIGN

syms p0 x
qx = (4*0.0254)*p0 * sqrt ( 1 - ((2*x)/Barlength)^2) ;

%Get F:
F = int(qx,x,(-Barlength/2),(Barlength/2));
%get V

Vx = -F/2 + int(qx,x,(-Barlength/2),x);

Mx = int(Vx,x,(-Barlength/2),x);

%solve for M as function of p0, then solve for p0;


% here If and Ib will use the width of the cross section, 4 inches or
% what's stored as WidthCS;

If = (1/12).*( WidthCS ).*(FoamLength)^3 ;

%we had to mulyiply by 2 to make it work, check why:
Ib = 2*((1/12).*(WidthCS).*(BalsaLength)^3 + ( CentroidShape - 2*CnetroidTopBalsa ) ^2 ).*(WidthCS.*BalsaLength) ;



MP0 = subs(Mx,x,0); %sub 0 for x in Mx;

Equation = MaxAllowNormal == (MP0 .* (BalsaLength+(FoamLength/2)))/ ( Ib + (E_Foam/E_Bals)* If ) ;
p0Value = solve(Equation,p0);

%SUB back P0 in the moment function

Mx_WithP0 = subs(Mx,p0,p0Value);
Vx_WithP0 = subs(Vx,p0,p0Value);
% C = distance from neutral axis
Cvalue = (BalsaLength+(FoamLength/2));


%moment of inertia of foam and balasa for bending data, width now isn't
%constant width is function will be solved for o

If = (1/12)*(FoamLength)^3 ;
Ib = 2*((1/12)*(BalsaLength)^3 + ( CentroidShape - CnetroidTopBalsa ) ^2 *BalsaLength);


Width_Moment_Function = Mx_WithP0 * (BalsaLength+(FoamLength/2))/((Ib + (E_Foam/E_Bals).*If)*MaxAllowNormal);
Width_Shear_Function = (((MaxAllowShear*(2/3))/(Vx_WithP0))^-1)/(FoamLength);

%loop over the two plots to get width function
j = 1; %index of storing
for i=(-Barlength/2):0.01:(Barlength/2)
    %width is maximum of both graphs of shear and moment
    WidthFunction(j) = max(abs(subs(Width_Moment_Function,i)), abs(subs(Width_Shear_Function,i)));
    iValues(j) = i; %store x values
    j = j+1;
end

WidthFunction = WidthFunction/2;
%Just to half the width because it gives us width for full span of 4 inches
% and we're doing half top and half bottom.

ForCut = double([ iValues' WidthFunction' ]);
% this just for us to cut the wing in practice.

ForCut = ForCut * 100 ; %convert
%% plotting

figure(1)
fplot(Width_Moment_Function)
hold on
fplot(Width_Shear_Function)
legend('Width function for moment', 'Width function for shear');
grid minor
hold off


figure(2);
plot(iValues,WidthFunction)
hold on
plot(iValues,-WidthFunction)
title('Width function');
xlabel('Length')
ylabel('Width')
hold on
grid minor
