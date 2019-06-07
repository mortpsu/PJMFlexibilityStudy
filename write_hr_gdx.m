function [powerpointdata, IHRdata] = write_hr_gdx(pGenData)

% Column 2 of table has Generator type
% Column 3 of table has heat rate curve type
% Column 4 of table has Avg Heat Rate
% Column 7 is Pmax
% Column 8 is Pmin

NumGens = 245;
NumK = 5;

gType = pGenData{:,2};
gHType = pGenData{:,3};
gHR = pGenData{:,4};
gPmax = pGenData{:,7};
gPmin = pGenData{:,8};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));
G.name='G';
G.uels = guel1('G',1:NumGens);
G.type='SET';

GEN_PARAMS.name='GEN_PARAMS';
GEN_PARAMS.uels = {'GenType','HRType','AvgHR','Fprice','VarOM','Pmax','Pmin','MINUP','MINDOWN','Zone','FuelType','Ramp','AvgOpCost'};
GEN_PARAMS.type='SET';

datavals = pGenData{:,2:end};


GenData.name='GenData';
GenData.type='parameter';
GenData.val=datavals;
GenData.form='full';
GenData.uels{1}= G.uels;
GenData.uels{2}= GEN_PARAMS.uels;
wgdx('GenData',G,GEN_PARAMS,GenData);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load HR curve type data from file
load('HRTypes.mat');

% Correct heat rates to calibrate to 2016 data
load('HeatRateCorrection.mat');

powerpointdata = zeros(NumGens,NumK);
IHRdata = zeros(NumGens,NumK);

%gHR(1:25) = gHR(1:25) .* HeatRateCorrection(1:25);

for i=1:NumGens
   [powerpointdata(i,:), IHRdata(i,:)] = MakeHeatRateCurve(gPmax(i),gHR(i),gHType(i),HRTypes); 
end

guel2 = @(s,v) strcat(s,strsplit(num2str(v)));
K.name='K';
K.uels = guel2('K',0:NumK-1);
K.type='SET';

PowPnt.name='PowPnt';
PowPnt.type='parameter';
PowPnt.val=powerpointdata;
PowPnt.form='full';
PowPnt.uels{1}= G.uels;
PowPnt.uels{2}= K.uels;
wgdx('PowPnt',G,K,PowPnt);

IHR.name='IHR';
IHR.type='parameter';
IHR.val=IHRdata;
IHR.form='full';
IHR.uels{1}= G.uels;
IHR.uels{2}= K.uels;
wgdx('IHR',G,K,IHR);


%%%%%%%%%%%%%%%%%%%%%%%%%%%

CCtrajectory = [1     0      0      0    0    0;
                0.25  1      0      0    0    0;
                0.1   0.25   0.5    1    0    0];

STtrajectory = [0.1   0.33   0.55   1       0      0;
                0.1   0.33   0.55   0.67    1      0;
                0.1   0.25   0.45   0.55    0.75   1];


SUtraj = zeros(NumGens,3,6);
SUtime = zeros(NumGens,3);
SUcost = zeros(NumGens,3);
GShutdata = zeros(NumGens,2);
Turndowndata = zeros(NumGens,1);
Downtimedata = zeros(NumGens,3);


guel3 = @(s,v) strcat(s,strsplit(num2str(v)));
G3.name='G';
G3.uels = guel3('G',1:NumGens);
G3.type='SET';


guel4 = @(s,v) strcat(s,strsplit(num2str(v)));
SU.name='SU';
SU.uels = guel4('SU',1:3);
SU.type='SET';


guel5 = @(s,v) strcat(s,strsplit(num2str(v)));
L.name='L';
L.uels = guel5('L',1:6);
L.type='SET';


for g=1:NumGens
    
    if (gType(g) == 1 )
        STflag = 1;
        CCflag = 0;
        SUtime(g,:) = [4 5 6];
        SUcost(g,:) = [10000 15000 20000];
        GShutdata(g,:) = [1.0 0.2] .* gPmin(g);
        Turndowndata(g) = 2;
        Downtimedata(g,:) = [8 16 24];
    elseif (gType(g) == 4 || gType(g) == 8)
        STflag = 1;
        CCflag = 0;
        SUtime(g,:) = [4 5 6];
        SUcost(g,:) = [7500  11250   15000];
        GShutdata(g,:) = [0.2 0] .* gPmin(g);
        Turndowndata(g) = 1;
        Downtimedata(g,:) = [6 12 18];
    elseif(gType(g) == 2)
        STflag = 0;
        CCflag = 1;
        SUtime(g,:) = [1 2 4];
        SUcost(g,:) = [5000 7500 10000];
        GShutdata(g,:) = [0.2 0] .* gPmin(g);
        Turndowndata(g) = 1;
        Downtimedata(g,:) = [4 8 16];
    else
        STflag = 0;
        CCflag = 0;
        SUtime(g,:) = [0 0 0];
        SUcost(g,:) = [0 0 0];
        GShutdata(g,:) = [0 0] ;
        Turndowndata(g) = 0;
        Downtimedata(g,:) = [0 0 0];
   end
    
    
    for su = 1:3
        for l = 1:6
            if (STflag)
                SUtraj(g,su,l) = STtrajectory(su,l) * gPmin(g);
            elseif (CCflag)
                SUtraj(g,su,l) = CCtrajectory(su,l) * gPmin(g);
            end
        end
    end
end



Trajectory.name='Trajectory';
Trajectory.type='parameter';
Trajectory.val=SUtraj;
Trajectory.form='full';
Trajectory.uels{1}= G3.uels;
Trajectory.uels{2}= SU.uels;
Trajectory.uels{3}= L.uels;
wgdx('Trajectory',G3,SU,L,Trajectory);

StartupTime.name='StartupTime';
StartupTime.type='parameter';
StartupTime.val=SUtime;
StartupTime.form='full';
StartupTime.uels{1}= G3.uels;
StartupTime.uels{2}= SU.uels;
wgdx('StartupTime',G3,SU,StartupTime);

StartupCost.name='StartupCost';
StartupCost.type='parameter';
StartupCost.val=SUcost;
StartupCost.form='full';
StartupCost.uels{1}= G3.uels;
StartupCost.uels{2}= SU.uels;
wgdx('StartupCost',G3,SU,StartupCost);


GShut.name='GShut';
GShut.type='parameter';
GShut.val=GShutdata;
GShut.form='full';
GShut.uels{1}= G3.uels;
GShut.uels{2}= L.uels;
wgdx('GShut',G3,L,GShut);


Turndown.name='Turndown';
Turndown.type='parameter';
Turndown.val=Turndowndata;
Turndown.form='full';
Turndown.uels{1}= G3.uels;
wgdx('Turndown',G3,Turndown);


Downtime.name='Downtime';
Downtime.type='parameter';
Downtime.val=Downtimedata;
Downtime.form='full';
Downtime.uels{1}= G3.uels;
Downtime.uels{2}= SU.uels;
wgdx('Downtime',G3,SU,Downtime);



end

