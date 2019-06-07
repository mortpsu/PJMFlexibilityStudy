function [results] = base_forney_daynum6(doy)

results =struct('model_name',[],'TotalCost',[],'TotalGenCost',[],'TotalSUCost',[],'TotalReserveCost',[],'TotalPenaltyCost',[],'Gen',[],'RS10',[],'RN10',[],'RS30',[],'RN30',[],'GenCost',[],'GenSUCost',[],'IMR',[],'IMR_Hr',[],'Status',[],'Up',[],'Down',[],'Startup',[],'FuelCost',[],'VOMCost',[],'Aux',[],'Price',[],'PriceRS10',[],'PriceRP10',[],'PriceRP30',[],'NSE',[], 'OverGen',[],'RS10_SHORT',[],'RP10_SHORT',[],'RP30_SHORT',[],'MIPGAP',[],'AVGcost',[]);
results(1).model_name = 'results_base';
results(2).model_name = 'all_forney1';
results(3).model_name = 'pmin_forney1';
results(4).model_name = 'pmax_forney1';
results(5).model_name = 'start_forney1';
results(6).model_name = 'ramp_forney1';
int_cond = struct('commit',[],'gen',[]);

% Convert month and day to dayofyear
%doy = day(datetime(2016,m,d),'dayofyear');

addpath('./lib');
addpath('./data');

genhist = readtable('GenHistData2016.csv');
demandhist = readtable('DemandHist2016.csv');
pGenData = readtable('pGenData.csv');
day1 = datetime(sprintf('2016-%d-%d 12:00 AM',1,1));
i = day1 + doy - 1;

write_initcond(i,genhist);

% write_ts_gdx(i,demandhist);
% write_ts_gdx2(i,demandhist);
write_ts_gdx3(i,demandhist);

% Do this once after updating the gen data set
write_hr_gdx(pGenData);

% Write out generator availability for this day
write_avail_gdx2(doy)

string= sprintf('gams uc_model6.gms  lo=3'); 
system(string);
results = read_gdx6('results_base.gdx',results,1);

%write_gcc_set(1);

string= sprintf('gams uc_model6_all25.gms  lo=3'); 
system(string); 
results = read_gdx6('results_all25.gdx',results,2);

string= sprintf('gams uc_model6_pmin.gms  lo=3'); 
system(string); 
results = read_gdx6('results_pmin.gdx',results,3);

string= sprintf('gams uc_model6_pmax.gms  lo=3'); 
system(string); 
results = read_gdx6('results_pmax.gdx',results,4);

string= sprintf('gams uc_model6_start.gms  lo=3'); 
system(string); 
results = read_gdx6('results_start.gdx',results,5);

string= sprintf('gams uc_model6_ramp.gms  lo=3'); 
system(string); 
results = read_gdx6('results_ramp.gdx',results,6);

filename = sprintf('results_%d_v6.mat',(doy));
st = day1 + doy;
ed = st + 1 - hours(1);
%results = prep_results(st,ed,results);
%results = prep_results2(st,ed,results);
%int_cond = read_int_cond('base_hour.gdx',int_cond,st);
save(filename,'results');
end
