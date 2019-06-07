function [] = one_lamar(m,d)
addpath('./lib');
addpath('./data');
day2 = datetime(sprintf('2016-%d-%d 12:00 AM',1,1));
day1 =datetime(sprintf('2016-%d-%d 12:00 AM',m,d));
no_day =days(day1-day2)
filename = sprintf('../ercot_lamar/results_%d.mat',no_day);
load(filename);

load('arrdata.mat')

cost =[];
mgap = [];
gencost = [];
sucost = [];
imr = [];
gen =[];
price =[];
names = {};
gen_names = {'Case';'Lamar1'};
gen_num = 234;
for i=1:5
    names(i) = {sprintf('%s',results(i).model_name)};
    cost = [cost;results(i).Cost(:,2).Variables];
    gencost = [gencost;results(i).GenCost(:,2).Variables];
    sucost = [sucost;results(i).SUCost(:,2).Variables];
    mgap = [mgap;results(i).MIPGAP(:,2).Variables];
    imr = [imr;results(i).IMR(:,gen_num).Variables];
    price = [price,results(i).Price(:,2).Variables];
    gen =[gen,results(i).Gen(:,gen_num).Variables];
end

mipgap = mgap;
for i=1:5
    mipgap(i) = max(-mgap(i),mgap(1));
end



sav =- cost(:,1)+ cost(1,1) - mipgap;
sav(sav < 0 ) = 0;
cost = table(names',cost,gencost,sucost,mgap,- cost(:,1) + cost(1,1),sav );
imr = [table(names'),array2table(imr)];
price = [results(1).Price(:,1),array2table(price)];
gen = [results(1).Gen(:,1),array2table(gen)];

cost.Properties.VariableNames = {'Case';'Total_System_Cost';'Generation_Cost';'StartUp_Cost';'MIP_gap';'dollar_savings';'Savings_MIPGAP';};
imr.Properties.VariableNames = gen_names;
price.Properties.VariableNames = [{'DateTime'},names];
gen.Properties.VariableNames = [{'DateTime'},names];

filename = sprintf('./lamar_results/results_%d_%d.xlsx',day1.Month,day1.Day);
system(sprintf('rm %s',filename));
writetable(cost,filename,'Sheet',1,'Range','A3');
writetable(imr,filename,'Sheet',2,'Range','A3');
writetable(price,filename,'Sheet',3,'Range','A3');
writetable(gen,filename,'Sheet',4,'Range','A3');

for i=1:5
    writetable([int_cond(1).gen;results(i).Gen],filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A3');
end

case_names = {'Index'};
for c = 1:5 ; case_names = [case_names, results(c).model_name]; end
index = { 'NUC';'ST';'Lamar';'CC';'CT';'DC';'IC';'WT';'PV'};
gen_tech = zeros(9,5);
for i=1:5
    G_CC = [gen_CC,284,283,234,240,117,253,262,263] ;
    gen = results(i).Gen(:,2:end).Variables;
    gen_tech(1,i) = sum(sum(gen(:,gen_Nuc)));
    gen_tech(2,i) = sum(sum(gen(:,gen_ST)));
    gen_tech(3,i) = sum(sum(gen(:,[233])));
    gen_tech(4,i) = sum(sum(gen(:,G_CC)));
    gen_tech(5,i) = sum(sum(gen(:,gen_CT)));
    gen_tech(6,i) = sum(sum(gen(:,gen_DC)));
    gen_tech(7,i) = sum(sum(gen(:,gen_IC)));
    gen_tech(8,i) = sum(sum(gen(:,gen_WT)));
    gen_tech(9,i) = sum(sum(gen(:,gen_PV)));
    
end
gen_tech = [array2table(index),array2table(gen_tech)];
gen_tech.Properties.VariableNames = case_names;
writetable(gen_tech,filename,'Sheet','gen_tech','Range','A3');

index = results(1).Gen(:,1);
wind_gen = sum(results(1).Gen(:,gen_WT+1).Variables,2);
wind_gen = [index,array2table(wind_gen)];
writetable(wind_gen,filename,'Sheet','wind_gen','Range','A3');

index = results(1).Gen(:,1);
pv_gen = sum(results(1).Gen(:,gen_PV+1).Variables,2);
pv_gen = [index,array2table(pv_gen)];
writetable(pv_gen,filename,'Sheet','pv_gen','Range','A3');

index = results(1).Gen(:,1);
demand = sum(results(1).Gen(:,2:end).Variables,2);
demand = [index,array2table(demand)];
writetable(demand,filename,'Sheet','demand','Range','A3');

case_names = {'Index'};
for c = 1:5 ; case_names = [case_names, results(c).model_name]; end
index = { 'NUC';'ST';'Lamar';'CC';'CT';'DC';'IC';'WT';'PV'};
imr_tech = zeros(9,5);
for i=1:5
    G_CC = [gen_CC,284,283,234,   240,   117,   253,   262,   263] ;
    imr = results(i).IMR(:,2:end).Variables;
    imr_tech(1,i) = sum(sum(imr(:,gen_Nuc)));
    imr_tech(2,i) = sum(sum(imr(:,gen_ST)));
    imr_tech(3,i) = sum(sum(imr(:,[233])));
    imr_tech(4,i) = sum(sum(imr(:,G_CC)));
    imr_tech(5,i) = sum(sum(imr(:,gen_CT)));
    imr_tech(6,i) = sum(sum(imr(:,gen_DC)));
    imr_tech(7,i) = sum(sum(imr(:,gen_IC)));
    imr_tech(8,i) = sum(sum(imr(:,gen_WT)));
    imr_tech(9,i) = sum(sum(imr(:,gen_PV)));
end
imr_tech = [array2table(index),array2table(imr_tech)];
imr_tech.Properties.VariableNames = case_names;
writetable(imr_tech,filename,'Sheet','imr_tech','Range','A3');



%%%%%%%%% IMR by Spark Spread
data =struct('Pmin',[],'Pmax',[],'Case',[]);
names = {};
for i=1:5;names(i) = {sprintf('%s_case',results(i).model_name(9:end))};end
for j=[1,5];
data(j).Case = names(j);
data(j).Pmax = 919;
data(j).Pmin = 367.6; 
end
j=2;
data(j).Case = names(j);
data(j).Pmax = 1102.8;
data(j).Pmin = 220.56; 
j=3;
data(j).Case = names(j);
data(j).Pmax = 919;
data(j).Pmin = 220.56; 
j=4;
data(j).Case = names(j);
data(j).Pmax = 1102.8;
data(j).Pmin = 367.6; 

vom=4.5;

gen_num = 234;


mdw = struct('dates',[],'gen',[],'spread',[],'imr',[]);

for casenum=1:5
    dates = results(casenum).Gen(:,1).Variables;
    gen = results(casenum).Gen(:,gen_num).Variables;
    fuelcost = results(casenum).FuelCost(:,gen_num).Variables;
    price = results(casenum).Price(:,2).Variables;
    spread = results(casenum).Spread(:,gen_num).Variables;
    imr = results(casenum).IMR_Hr(:,gen_num).Variables;

    mdw(casenum).dates = dates; mdw(casenum).gen = gen; mdw(casenum).spread = spread; mdw(casenum).imr =imr ;
end

case_names = {'Index'};
for c = 1:5 ; case_names = [case_names, results(c).model_name]; end
index = { 'Spark Spread < 1';'1 <= Spark Spread < 10';'10 <= Spark Spread < 20';'20 <= Spark Spread < 30';'30 <= Spark Spread < 40';'Spark Spread > 40'};
unit = 1;
spread_imr = zeros(6,5);
for i =1:5
    imr = mdw(i).imr(:,unit);
    spread = mdw(i).spread(:,unit);
    spread_imr(1,i) = sum(imr(spread <1));
    spread_imr(2,i) = sum(imr(spread >=1  & spread < 10));
    spread_imr(3,i) = sum(imr(spread >=10 & spread < 20));
    spread_imr(4,i) = sum(imr(spread >=20 & spread < 30));
    spread_imr(5,i) = sum(imr(spread >=30 & spread < 40));
    spread_imr(6,i) = sum(imr(spread >=40));
end
spread_imr = [array2table(index),array2table(spread_imr)];
spread_imr.Properties.VariableNames = case_names;
writetable(spread_imr,filename,'Sheet','IMR_SS','Range','A3');



end