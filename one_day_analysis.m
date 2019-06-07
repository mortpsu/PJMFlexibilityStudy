st = datetime(sprintf('2016-%d-%d 00:00',9,2));%%Enter the month and day here

results =struct('model_name',[],'Gen',[],'IMR',[],'Cost',[],'Status',[],'Up',[],'Down',[],'Startup',[],'FuelCost',[],'GenCost',[],'SUCost',[],'Aux',[],'Price',[],'NSE',[], 'LineFlow',[],'ZonalGen',[],'FuelGen',[],'TechGen',[],'MIPGAP',[]);
results(1).model_name = 'results_all25';
results(2).model_name = 'results_base';
gen_hist = readtable('Gen.csv');
pv_hist = readtable('PV_gen.csv');
wind_hist = readtable('WIND_gen.csv');
demand = readtable('Demand.csv');

write_initcond(st,gen_hist);
write_ts_gdx(st,pv_hist,wind_hist,demand);

string= sprintf('gams uc_model_all25.gms  lo=3'); 
system(string); 
results = read_gdx('results_all25.gdx',results,1);
system('rm results_all25.gdx');

string= sprintf('gams uc_model.gms  lo=3'); 
system(string);
results = read_gdx('results_base.gdx',results,2);
system('rm results_base.gdx');

results = prep_results(st,(st+hours(23)),results);

cost = result(s(1).Cost(:,1);
mgap = results(1).Cost(:,1);

price_table = results(1).Price(:,1);
price_table.Properties.VariableNames = {['Datetime']};

gen_table = results(1).Gen(:,1);
gen_table.Properties.VariableNames = {['Datetime']};

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));
name_list = {['DateTime']};
name_list(2:489) = guel1('g',1:488);

names = {};
costs = [];
gencost = [];
gen = [];
sucost = [];
d_s =[];

for i=size(results,2):-1:1
    results(i).Cost.Properties.VariableNames = [{'Datetime'},{results(i).model_name}];
    cost=[cost,results(i).Cost(:,2)];
    
    results(i).MIPGAP.Properties.VariableNames = [{'Datetime'},{results(i).model_name}];
    mgap=[mgap,results(i).MIPGAP(:,2)];
    
    results(i).GenCost.Properties.VariableNames = [{'Datetime'},{results(i).model_name}];
    results(i).SUCost.Properties.VariableNames = [{'Datetime'},{results(i).model_name}];
    
    results(i).Price.Properties.VariableNames = {['Datetime'],results(i).model_name};
    price_table = [price_table, results(i).Price(:,2)];
    
    results(i).IMR.Properties.VariableNames = name_list;
    results(i).Gen.Properties.VariableNames = name_list;
    gen = [gen,results(i).Gen(:,284)]
    results(i).FuelCost.Properties.VariableNames = name_list;
    
    names(size(results,2) + 1 - i) = {sprintf('%s',results(i).model_name)};
    costs = [costs;results(i).Cost(:,2).Variables];
    gencost = [gencost;results(i).GenCost(:,2).Variables];
    sucost = [sucost;results(i).SUCost(:,2).Variables];
    
end
dollar_savings = cost;
dollar_savings(:,2:end).Variables = -table2array(cost(:,2:end)) + table2array(cost(:,2));

mipgap=max(mgap(:,2:end).Variables);

d_m_savings = dollar_savings;
d_m_savings(:,2:end).Variables = d_m_savings(:,2:end).Variables - mipgap;

perc_savings = cost;
perc_savings(:,2:end).Variables = 100*(-table2array(cost(:,2:end)) + table2array(cost(:,2)))./table2array(cost(:,2));

cost_table = table(names',costs,gencost,sucost,dollar_savings(:,2:end).Variables',perc_savings(:,2:end).Variables',mgap(:,2:end).Variables');
cost_table.Properties.VariableNames = [{'Models'},{'Total_System_Cost'},{'Generation_Cost'},{'StartUp_Cost'},{'dollar_savings'},{'savings'},{'MIP_gap'}];

imr_table = table(names',[results(2).IMR(:,284).Variables;results(1).IMR(:,284).Variables]);

gen_table = results(1).Gen(:,1);
gen_table.Properties.VariableNames = {['Datetime']};
gen = [];
for i=size(results,2):-1:1
    results(i).Gen.Properties.VariableNames = name_list;
    gen = [gen,results(i).Gen(:,284).Variables];
end
gen_table = [gen_table, array2table(gen)];

cost_table
imr_table
price_table
gen_table

filename = 'results.xlsx';
writetable(cost_table,filename,'Sheet',1,'Range','A2');
writetable(imr_table,filename,'Sheet',2,'Range','A2');
writetable(price_table,filename,'Sheet',3,'Range','A2');
writetable(gen_table,filename,'Sheet',4,'Range','A2')
;


### V2
cost =[];
mgap = [];
gencost = [];
sucost = [];
imr = [];
price =[];
names = {};
for i=1:12
    names(i) = {sprintf('%s_case',results(i).model_name(9:end))};
    cost = [cost;results(i).Cost(:,2).Variables];
    gencost = [gencost;results(i).GenCost(:,2).Variables];
    sucost = [sucost;results(i).SUCost(:,2).Variables];
    mgap = [mgap;results(i).MIPGAP(:,2).Variables];
    imr = [imr;results(i).IMR(:,[284,285,234,235,241,118,254,263,264]).Variables];
    price = [price,results(i).Price(:,2).Variables];
end
sav =- cost(:,1)+ cost(1,1) - max(-mgap,[],1);
sav(sav < 0 ) = 0;
cost = table(names',cost,gencost,sucost,mgap,- cost(:,1) + cost(1,1),sav );
imr = [table(names'),array2table(imr)];
price = [results(1).Price(:,1),array2table(price)];

cost.Properties.VariableNames = {'Case';'Total_System_Cost';'Generation_Cost';'StartUp_Cost';'MIP_gap';'dollar_savings';'Savings_MIPGAP';};
imr.Properties.VariableNames = {'Case';'Forney1';'Forney2';'Lamar1';'Lamar2';'Rio_Nogales';'Barney';'Bastrop';'Odessa1';'Odessa2'};
price.Properties.VariableNames = [{'DateTime'},names];

st = (price(1,1).Variables);
filename = sprintf('results_%d_%d.xlsx',st.Month,st.Day);
writetable(cost,filename,'Sheet',sprintf('results_%d_%d',st.Month,st.Day),'Range','A3');
writetable(table({'IMR for all units in each case'}),filename,'Sheet',sprintf('results_%d_%d',st.Month,st.Day),'Range','A18','WriteVariableNames',false)
writetable(imr,filename,'Sheet',sprintf('results_%d_%d',st.Month,st.Day),'Range','A19');
writetable(table({'Price in each case'}),filename,'Sheet',sprintf('results_%d_%d',st.Month,st.Day),'Range','A34','WriteVariableNames',false)
writetable(price,filename,'Sheet',sprintf('results_%d_%d',st.Month,st.Day),'Range','A35');

for i=1:12
    gen =results(i).Gen(:,[1,284,285,234,235,241,118,254,263,264]);
    gen.Properties.VariableNames = {'Datetime';'Forney1';'Forney2';'Lamar1';'Lamar2';'Rio_Nogales';'Barney';'Bastrop';'Odessa1';'Odessa2'};
    writetable(table(names(i)),filename,'Sheet',sprintf('Gen_%d_%d',st.Month,st.Day),'Range',sprintf('A%d',(i-1)*26+2),'WriteVariableNames',false);
    writetable(gen,filename,'Sheet',sprintf('Gen_%d_%d',st.Month,st.Day),'Range',sprintf('A%d',(i-1)*26+3));
end


