%******************************
start_m=5; % month
end_m= 5;    % ending month
start_d=1;  %starting day of the month 
end_d=1;    % ending day of the month 
%********************************
st = datetime(sprintf('2016-%d-%d 00:00',start_m,start_d));
ed = datetime(sprintf('2016-%d-%d 23:00',end_m,end_d));
results = init_results();
gen_hist = readtable('Gen.csv');
pv_hist = readtable('PV_gen.csv');
wind_hist = readtable('WIND_gen.csv');
demand = readtable('Demand.csv');
for i=st:ed
            disp(i)
            if i == st 
                write_initcond(i,gen_hist);
                write_ts_gdx(i,pv_hist,wind_hist,demand);
            else
                write_ts_gdx(i,pv_hist,wind_hist,demand);
            end
            
            string= sprintf('gams uc_model_all25.gms o=~/scratch/null lo=3'); 
            system(string); 
            results = read_gdx('results_all25.gdx',results,3);
            system('rm results_all25.gdx');
            
            string= sprintf('gams uc_model.gms o=~/scratch/null lo=3'); 
            system(string);
            results = read_gdx('results_base.gdx',results,9);
            system('rm results_base.gdx');

end
results = prep_results(st,ed,results);
save('results.mat','results');

%%Plot 
%{
dt = st:hours(1):ed;
GT = array2table(Gen);
DT = array2table(dt');
FT = array2table(FuelGen);
TT = array2table(TechGen);
T1 =[DT GT];
T2 = [DT,FT];
T3 = [DT,TT];


hFig = figure(1);
set(gcf,'PaperPositionMode','auto')
set(hFig, 'Position', [0 0 1000 500])
area(T3(:,1).Variables,T3(:,2:end).Variables,'LineStyle',':','FaceColor','flat');
title('ERCOT Generation by Technology ')
ylabel('Generation in MW') 
xlabel('Time') 
lgd = legend('Nuclear','Steam Turbine', 'Combustion Turbine', 'DC line' , 'Internal Combustion', 'Wind', 'Solar','Location','NorthEastOutside');
title(lgd,'Technology Type ','FontSize',10);
saveas(hFig,'Techtype.png')

hFig = figure(1);
set(gcf,'PaperPositionMode','auto')
set(hFig, 'Position', [0 0 500 500])
pie(mean(T2(:,2:end).Variables))
title('ERCOT Generation by Fuel type ')
legend('DC LINE','COAL','Natural Gas','Nuclear','OTHER','Solar','Wind','Location','NorthEastOutside')
saveas(hFig,'Fueltype.png')

%}