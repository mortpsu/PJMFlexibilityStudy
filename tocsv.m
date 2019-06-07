final_r =struct('model_name',[],'Gen',[],'IMR',[],'IMR_Hr',[],'Cost',[],'Status',[],'Up',[],'Down',[],'Startup',[],'FuelCost',[],'GenCost',[],'SUCost',[],'Aux',[],'Price',[],'NSE',[], 'LineFlow',[],'ZonalGen',[],'FuelGen',[],'TechGen',[],'MIPGAP',[],'Spread',[],'AVGcost',[]);
final_r(1).model_name = 'results_base';
final_r(2).model_name = 'results_forney1';
final_r(3).model_name = 'results_forney2';
final_r(4).model_name = 'results_lamar1';
final_r(5).model_name = 'results_lamar2';
final_r(6).model_name = 'results_north';
final_r(7).model_name = 'results_rio';
final_r(8).model_name = 'results_barney';
final_r(9).model_name = 'results_bastrop';
final_r(10).model_name = 'results_south';
final_r(11).model_name = 'results_odessa1';
final_r(12).model_name = 'results_odessa2';


for i=1:358
    filename =sprintf('../ercot_results/results_%d.mat',i);
    if exist(filename,'file') == 2
        load(filename);
        for j =1:12
            final_r(j).Gen = [final_r(j).Gen;results(j).Gen];
            final_r(j).IMR = [final_r(j).IMR;results(j).IMR];
            final_r(j).IMR_Hr = [final_r(j).IMR_Hr;results(j).IMR_Hr];
            final_r(j).Cost = [final_r(j).Cost;results(j).Cost];
%            final_r(j).Status = [final_r(j).Status;results(j).Status];
            final_r(j).Up = [final_r(j).Up;results(j).Up];
            final_r(j).Down = [final_r(j).Down;results(j).Down];
            final_r(j).Startup = [final_r(j).Startup;results(j).Startup];
            final_r(j).FuelCost = [final_r(j).FuelCost;results(j).FuelCost];
%            final_r(j).GenCost = [final_r(j).GenCost;results(j).GenCost];
%            final_r(j).SUCost = [final_r(j).SUCost;results(j).SUCost];
%            final_r(j).Aux = [final_r(j).Aux;results(j).Aux];
            final_r(j).Price = [final_r(j).Price;results(j).Price];
%            final_r(j).NSE = [final_r(j).NSE;results(j).NSE];
%            final_r(j).LineFlow = [final_r(j).LineFlow;results(j).LineFlow];
%            final_r(j).ZonalGen = [final_r(j).ZonalGen;results(j).ZonalGen];
%            final_r(j).FuelGen = [final_r(j).FuelGen;results(j).FuelGen];
%            final_r(j).TechGen = [final_r(j).TechGen;results(j).TechGen];
            final_r(j).MIPGAP = [final_r(j).MIPGAP;results(j).MIPGAP];
            final_r(j).Spread = [final_r(j).Spread;results(j).Spread];
            final_r(j).AVGcost = [final_r(j).AVGcost;results(j).AVGcost];

        end
    end
end
results =final_r;

cost = results(1).Cost(:,1);
mgap = results(1).MIPGAP(:,1);
cost.Properties.VariableNames = {['Datetime']};
mgap.Properties.VariableNames = {['Datetime']};
for i=1:12
    results(i).Cost.Properties.VariableNames = {['Datetime'],results(i).model_name};
    results(i).MIPGAP.Properties.VariableNames = {['Datetime'],results(i).model_name};
    cost = [cost, results(i).Cost(:,2)];
    mgap = [mgap, results(i).MIPGAP(:,2)];
end

dollar_savings = cost;
dollar_savings(:,2:end).Variables = -table2array(cost(:,2:end)) + table2array(cost(:,2));

mipgap = mgap(:,2:end).Variables;
for i=1:12
    mipgap(:,i) = max(-mgap(:,[2,i+1]).Variables,[],2);
end
savings =dollar_savings(:,2:end).Variables - mipgap;
savings(savings < 0 ) = 0;
sav = dollar_savings;
sav(:,2:end).Variables = savings;

Price = results(1).Price(:,1);
Price.Properties.VariableNames = {['Datetime']};
for i=1:12
    results(i).Price.Properties.VariableNames = {['Datetime'],results(i).model_name};
    Price = [Price, results(i).Price(:,2)];
end

filename = './results/results_ercot_2017.xlsx';
system(sprintf('rm %s',filename));
writetable(cost,filename,'Sheet','Total_System_Cost','Range','A2');
writetable(sav,filename,'Sheet','Savings','Range','A2');
writetable(Price,filename,'Sheet','Price','Range','A2');

imr =struct('Case',[],'IMR',[]);
gen_names = {'Datetime';'Forney1';'Forney2';'Lamar1';'Lamar2';'Rio_Nogales';'Barney';'Bastrop';'Odessa1';'Odessa2'};
gen_num = [1,284,285,234,235,241,118,254,263,264];


for i=1:12
    imr(i).Case = results(i).model_name(9:end);
    imr(i).IMR=final_r(i).IMR(:,gen_num);
    imr(j).IMR.Properties.VariableNames = gen_names;
end


filename ='results/batch_IMR.xlsx';
system(sprintf('rm %s',filename));
for j = 1:12
    writetable(imr(j).IMR,filename,'Sheet',imr(j).Case,'Range','A3');
end


data =struct('Pmin',[],'Pmax',[],'Case',[]);
names = {};
for i=1:12;names(i) = {sprintf('%s_case',final_r(i).model_name(9:end))};end
data(1).Case = names(1);
data(1).Pmax = [919,919,500,516,785,633,525,492,496];
data(1).Pmin = [367.6,367.6,200,206.4,314,253.2,210,196.8,198.4]; 

data(2).Case = names(2);
data(2).Pmax = [1102.8,919,500,516,785,633,525,492,496];
data(2).Pmin = [220.56,367.6,200,206.4,314,253.2,210,196.8,198.4]; 

data(3).Case = names(3);
data(3).Pmax = [1102.8,1102.8,500,516.19,785,633,525,492,496];
data(3).Pmin = [220.56,220.56,200,206.4,314,253.2,210,196.8,198.4]; 

data(4).Case = names(4);
data(4).Pmax = [919,919,600,516,785,633,525,492,496];
data(4).Pmin = [367.6,367.6,120,206.4,314,253.2,210,196.8,198.4]; 

data(5).Case = names(5);
data(5).Pmax = [919,919,600,619.19,785,633,525,492,496];
data(5).Pmin = [367.6,367.6,120,123.84,314,253.2,210,196.8,198.4]; 

data(6).Case = names(6);%north
data(6).Pmax = [1102.8,1102.8,600,619.19,785,633,525,492,496];
data(6).Pmin = [220.56,220.56,120,123.84,314,253.2,210,196.8,198.4]; 

data(7).Case = names(7);
data(7).Pmax = [919,919,500,516,942,633,525,492,496];
data(7).Pmin = [367.6,367.6,200,206.4,188.4,253.2,210,196.8,198.4]; 

data(8).Case = names(8);
data(8).Pmax = [919,919,500,516,785,759.6,525,492,496];
data(8).Pmin = [367.6,367.6,200,206.4,314,151.92,210,196.8,198.4]; 

data(9).Case = names(9);
data(9).Pmax = [919,919,500,516,785,633,630,492,496];
data(9).Pmin = [367.6,367.6,200,206.4,314,253.2,126,196.8,198.4]; 

data(10).Case = names(10);%south
data(10).Pmax = [919,919,500,516,942,759.6,525,492,496];
data(10).Pmin = [367.6,367.6,200,206.4,188.4,151.92,126,196.8,198.4]; 

data(11).Case = names(11);
data(11).Pmax = [919,919,500,516,785,633,525,590.4,496];
data(11).Pmin = [367.6,367.6,200,206.4,314,253.2,210,118.08,198.4,]; 

data(12).Case = names(12);
data(12).Pmax = [919,919,500,516,785,633,525,590.4,595.2];
data(12).Pmin = [367.6,367.6,200,206.4,314,253.2,210,118.08,119.04,]; 


starts =[];
shutdowns =[];
total_hr = [];
names ={};
gen_num = [284,285,234,235,241,118,254,263,264];
hr_min =[];
hr_full =[];
hr_low=[];
hr_high=[];

for i=1:12
    total_hr = [total_hr;sum(final_r(i).Gen(:,gen_num).Variables > 0)];
    names(i) = {sprintf('%s_case',final_r(i).model_name(9:end))};
    starts = [starts;sum(final_r(i).Up(:,gen_num).Variables)];
    shutdowns = [shutdowns;sum(final_r(i).Down(:,gen_num).Variables)];
    
    pmax = ones(size(final_r(i).Gen(:,gen_num).Variables)).*data(i).Pmax;
    pmin = ones(size(final_r(i).Gen(:,gen_num).Variables)).*data(i).Pmin;
    hr_min =[hr_min;sum(round(final_r(i).Gen(:,gen_num).Variables) == round(pmin))];
    hr_full =[hr_full;sum(round(final_r(i).Gen(:,gen_num).Variables) == round(pmax))];
    hr_low = [hr_low; sum(round(results(i).Gen(:,gen_num).Variables) > round(pmin) & round(results(i).Gen(:,gen_num).Variables) <= round(pmax*0.7))];
    hr_high = [hr_high;sum(round(results(i).Gen(:,gen_num).Variables) < round(pmax) & round(results(i).Gen(:,gen_num).Variables) >= round(pmax*0.9))];
end
gen_names = {'Cases';'Forney1';'Forney2';'Lamar1';'Lamar2';'Rio_Nogales';'Barney';'Bastrop';'Odessa1';'Odessa2'};

starts = [names',array2table(starts)];
starts.Properties.VariableNames = gen_names;

shutdowns = [names',array2table(shutdowns)];
shutdowns.Properties.VariableNames = gen_names;

total_hr = [names',array2table(total_hr)];
total_hr.Properties.VariableNames = gen_names;

hr_min = [names',array2table(hr_min)];
hr_min.Properties.VariableNames = gen_names;

hr_full = [names',array2table(hr_full)];
hr_full.Properties.VariableNames = gen_names;

hr_low = [names',array2table(hr_low)];
hr_low.Properties.VariableNames = gen_names;

hr_high = [names',array2table(hr_high)];
hr_high.Properties.VariableNames = gen_names;

% Write initial condition to GDX
filename ='./results/extra_results.xlsx';
system(sprintf('rm %s',filename));
writetable(starts,filename,'Sheet','No_Startups');
writetable(shutdowns,filename,'Sheet','No_Shutdowns');
writetable(total_hr,filename,'Sheet','Total_hr_On');
writetable(hr_min,filename,'Sheet','No_hr_min');
writetable(hr_full,filename,'Sheet','No_hr_full');
writetable(hr_low,filename,'Sheet','No_hr_low');
writetable(hr_high,filename,'Sheet','No_hr_high');