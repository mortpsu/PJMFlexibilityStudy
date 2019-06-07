function[] = write_ts_gdx4(st,demandhist)

% New demand file contains the following columns:
%   Column 1: Date-Time
%   Column 2: Load (Demand)
%   Column 3: Wind Generation
%   Column 4: Solar Generation
%   Column 5: Nuclear Generation
%   Column 6: Net Load (Demand - wind - solar - nuclear)
%   Column 7: Dispatchable Generation: Observed total gen 
%   Column 8: NetLoad2 = residual between net load and observed generation


row = demandhist.Var1 >= st  & demandhist.Var1 <= (st + hours(24)) ;

MakeDATES();
rowdates = DATES(row);


GrossLoad = demandhist{row,2};
WindGen = demandhist{row,3};
PVGen = demandhist{row,4};
NucGen = demandhist{row,5};
NetLoad = demandhist{row,6};
DispGen = demandhist{row,7};
Resid = demandhist{row,8};

%load('Cogen2016.mat');

%Cogen = Cogen2016(row);

%NetLoad2 = DispGen - Cogen;

% Write time series data to GDX

N.name='N';
N.uels = {(1:25)};
N.type='SET';

TS.name='TS';
TS.uels = {'GrossLoad ','WindGen','PVGen','NucGen','NetLoad','DispGen','Resid','Cogen','NetLoad2'};
TS.type='SET';

TimeSeries.name ='Demand';
TimeSeries.type='parameter';
%TimeSeries.val=NetLoad2;
TimeSeries.val=DispGen;
TimeSeries.form='full';
TimeSeries.uels{1}= N.uels;

wgdx('Demand',N,TS,TimeSeries);

end