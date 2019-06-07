gen_hist = readtable('Gen.csv');
pv_hist = readtable('PV_gen.csv');
wind_hist = readtable('WIND_gen.csv');
demand = readtable('Demand.csv');

%******************************
start_m=9; % month
end_m= 9;    % ending month
start_d=1;  %starting day of the month 
end_d=30;    % ending day of the month 
%********************************
st = datetime(sprintf('2016-%d-%d 00:00',start_m,start_d));
ed = datetime(sprintf('2016-%d-%d 23:00',end_m,end_d));

results =struct('model_name',[],'Gen',[],'IMR',[],'Cost',[],'Status',[],'Up',[],'Down',[],'Startup',[],'FuelCost',[],'GenCost',[],'SUCost',[],'Aux',[],'Price',[],'NSE',[], 'LineFlow',[],'ZonalGen',[],'FuelGen',[],'TechGen',[],'MIPGAP',[]);
results(1).model_name = 'results_base';
results(2).model_name = 'results_forney1';
results(3).model_name = 'results_forney2';
results(4).model_name = 'results_lamar1';
results(5).model_name = 'results_lamar2';
results(6).model_name = 'results_north';
results(7).model_name = 'results_rio';
results(8).model_name = 'results_barney';
results(9).model_name = 'results_bastrop';
results(10).model_name = 'results_south';
results(11).model_name = 'results_odessa1';
results(12).model_name = 'results_odessa2';

for i=st:ed
    disp(i)
    if i == st 
        write_initcond(i,gen_hist);
        write_ts_gdx(i,pv_hist,wind_hist,demand);
    else
        write_ts_gdx(i,pv_hist,wind_hist,demand);
    end
    string= sprintf('gams uc_model.gms  lo=3'); 
    system(string);
    results = read_gdx('results_base.gdx',results,1);
    system('rm results_base.gdx');
    for j =1:4
        write_gcc_set(j);
        string= sprintf('gams uc_model_all25.gms  lo=3'); 
        system(string); 
        results = read_gdx('results_all25.gdx',results,j+1);
        system('rm results_all25.gdx');
    end
            
end

results = prep_results(st,ed,results);
save('results_9.mat','results');