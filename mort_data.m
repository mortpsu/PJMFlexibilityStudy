function [] = mort_data(m,d)
asize =6;


addpath('./lib');
addpath('./data');
day2 = datetime(sprintf('2016-%d-%d 12:00 AM',1,1));
day1 =datetime(sprintf('2016-%d-%d 12:00 AM',m,d));
no_day =days(day1-day2)
filename = sprintf('../ercot_forney/results_%d.mat',no_day);
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
gen_names = {'Case';'Forney1'};
gen_num = 284;
for i=1:asize
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
for i=1:asize
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

filename = sprintf('./mort/results_%d_%d.xlsx',day1.Month,day1.Day);
system(sprintf('rm %s',filename));
writetable(cost,filename,'Sheet','Costs','Range','A3');
writetable(imr,filename,'Sheet','Forney_IMR','Range','A3');
writetable(price,filename,'Sheet','Price','Range','A3');
writetable(gen,filename,'Sheet','Forney_Gen','Range','A3');

%for i=1:asize
%    writetable([int_cond(1).gen;results(i).Gen],filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A3');
%end



case_names = {'Index'};
for c = 1:asize ; case_names = [case_names, results(c).model_name]; end
index = { 'NUC';'ST';'Forney';'CC';'CT';'DC';'IC';'WT';'PV'};
gen_tech = zeros(9,asize);
G_CC = [gen_CC,284,233,234,240,117,253,262,263] ;
for i=1:asize
    gen = results(i).Gen(:,2:end).Variables;
    gen_tech(1,i) = sum(sum(gen(:,gen_Nuc)));
    gen_tech(2,i) = sum(sum(gen(:,gen_ST)));
    gen_tech(3,i) = sum(sum(gen(:,[283])));
    gen_tech(4,i) = sum(sum(gen(:,G_CC)));
    gen_tech(5,i) = sum(sum(gen(:,gen_CT)));
    gen_tech(6,i) = sum(sum(gen(:,gen_DC)));
    gen_tech(7,i) = sum(sum(gen(:,gen_IC)));
    gen_tech(8,i) = sum(sum(gen(:,gen_WT)));
    gen_tech(9,i) = sum(sum(gen(:,gen_PV)));
    
end
gen_tech = [array2table(index),array2table(gen_tech)];
gen_tech.Properties.VariableNames = case_names;
writetable(gen_tech,filename,'Sheet','Agg_Gen','Range','A3');
writetable(table({'Total generation'}),filename,'Sheet','Agg_Gen','Range','A2','WriteVariableNames',false);

for i=1:asize
    gen_tech = zeros(24,asize);
    gen = results(i).Gen(:,2:end).Variables;
    gen_tech(:,1) = sum(gen(:,gen_Nuc),2);
    gen_tech(:,2) = sum(gen(:,gen_ST),2);
    gen_tech(:,3) = sum(gen(:,[283]),2);
    gen_tech(:,4) = sum(gen(:,G_CC),2);
    gen_tech(:,5) = sum(gen(:,gen_CT),2);
    gen_tech(:,6) = sum(gen(:,gen_DC),2);
    gen_tech(:,7) = sum(gen(:,gen_IC),2);
    gen_tech(:,8) = sum(gen(:,gen_WT),2);
    gen_tech(:,9) = sum(gen(:,gen_PV),2);
    case_names = { 'DateTime';'NUC';'ST';'Forney';'CC';'CT';'DC';'IC';'WT';'PV'};
    gen_tech = [results(i).Gen(:,1),array2table(gen_tech)];
    gen_tech.Properties.VariableNames = case_names;
    writetable(gen_tech,filename,'Sheet','Agg_Gen','Range',sprintf("A%d",(i*27)));
    writetable(table({results(i).model_name}),filename,'Sheet','Agg_Gen','Range',sprintf("A%d",(i*27-1)),'WriteVariableNames',false);
end


G_CC = [gen_CC,284,233,234,240,117,253,262,263] ;
for i=1:asize
    gen_tech = results(i).Gen(:,gen_ST+1);
    writetable(results(i).Gen(:,1),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A3');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','B3');
    writetable(table({'Steam Generation'}),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A2','WriteVariableNames',false);
    
    gen_tech = results(i).Gen(:,284);
    writetable(results(i).Gen(:,1),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A31');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','B31');
    writetable(table({'Forney Generation'}),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A30','WriteVariableNames',false);
    
    gen_tech = results(i).Gen(:,G_CC+1);
    writetable(results(i).Gen(:,1),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A59');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','B59');
    writetable(table({'CC Generation'}),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A58','WriteVariableNames',false);
    
    gen_tech = results(i).Gen(:,gen_CT+1);
    writetable(results(i).Gen(:,1),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A87');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','B87');
    writetable(table({'CT Generation'}),filename,'Sheet',sprintf("gen_%s",results(i).model_name),'Range','A86','WriteVariableNames',false);

end

G_CC = [gen_CC,284,233,234,240,117,253,262,263] ;
for i=1:asize
    Gen_cost = [results(i).AVGcost(:,1),array2table(results(i).AVGcost(:,2:end).Variables .* results(i).Gen(:,2:end).Variables)];
    
    gen_tech = Gen_cost(:,gen_ST+1);
    writetable(Gen_cost(:,1),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A3');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','B3');
    writetable(table({'Steam Generation'}),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A2','WriteVariableNames',false);
    
    gen_tech = Gen_cost(:,284);
    writetable(Gen_cost(:,1),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A31');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','B31');
    writetable(table({'Steam Generation'}),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A30','WriteVariableNames',false);
    
    gen_tech = Gen_cost(:,G_CC+1);
    writetable(Gen_cost(:,1),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A59');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','B59');
    writetable(table({'Steam Generation'}),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A58','WriteVariableNames',false);

    gen_tech = Gen_cost(:,gen_CT+1);
    writetable(Gen_cost(:,1),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A87');
    writetable(gen_tech,filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','B87');
    writetable(table({'Steam Generation'}),filename,'Sheet',sprintf("gen_cost_%s",results(i).model_name),'Range','A86','WriteVariableNames',false);
end

G_CC = [gen_CC,284,233,234,240,117,253,262,263] ;
for i=1:asize
    gen_tech = results(i).IMR_Hr(:,gen_ST+1);
    writetable(results(i).IMR_Hr(:,1),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A3');
    writetable(gen_tech,filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','B3');
    writetable(table({'Steam Generation'}),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A2','WriteVariableNames',false);
    
    gen_tech = results(i).IMR_Hr(:,284);
    writetable(results(i).IMR_Hr(:,1),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A31');
    writetable(gen_tech,filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','B31');
    writetable(table({'Forney Generation'}),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A30','WriteVariableNames',false);
    
    gen_tech = results(i).IMR_Hr(:,G_CC+1);
    writetable(results(i).IMR_Hr(:,1),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A59');
    writetable(gen_tech,filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','B59');
    writetable(table({'CC Generation'}),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A58','WriteVariableNames',false);
    
    gen_tech = results(i).IMR_Hr(:,gen_CT+1);
    writetable(results(i).IMR_Hr(:,1),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A87');
    writetable(gen_tech,filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A87');
    writetable(table({'CT Generation'}),filename,'Sheet',sprintf("imr_%s",results(i).model_name),'Range','A86','WriteVariableNames',false);

end



case_names = {'Index'};
for c = 1:asize ; case_names = [case_names, results(c).model_name]; end
index = { 'NUC';'ST';'Forney';'CC';'CT';'DC';'IC';'WT';'PV'};
imr_tech = zeros(9,asize);
for i=1:asize
    G_CC = [gen_CC,284,233,234,   240,   117,   253,   262,   263] ;
    imr = results(i).IMR(:,2:end).Variables;
    imr_tech(1,i) = sum((imr(:,gen_Nuc)));
    imr_tech(2,i) = sum((imr(:,gen_ST)));
    imr_tech(3,i) = sum((imr(:,[283])));
    imr_tech(4,i) = sum((imr(:,G_CC)));
    imr_tech(5,i) = sum((imr(:,gen_CT)));
    imr_tech(6,i) = sum((imr(:,gen_DC)));
    imr_tech(7,i) = sum((imr(:,gen_IC)));
    imr_tech(8,i) = sum((imr(:,gen_WT)));
    imr_tech(9,i) = sum((imr(:,gen_PV)));
end
imr_tech = [array2table(index),array2table(imr_tech)];
imr_tech.Properties.VariableNames = case_names;
writetable(imr_tech,filename,'Sheet','Agg_IMR','Range','A3');



wind_gen = sum(results(1).Gen(:,gen_WT+1).Variables,2);
pv_gen = sum(results(1).Gen(:,gen_PV+1).Variables,2);
demand = sum(results(1).Gen(:,2:end).Variables,2);
net_load = demand - wind_gen - pv_gen;
index = results(1).Gen(:,1);
Time_Series = [index,array2table(demand),array2table(wind_gen),array2table(pv_gen),array2table(net_load)];
writetable(Time_Series,filename,'Sheet','Time_Series','Range','A3');






%%%%%%%%% IMR by Spark Spread
data =struct('Pmin',[],'Pmax',[],'Case',[]);
names = {};
for i=1:asize;names(i) = {sprintf('%s_case',results(i).model_name(9:end))};end
for j=[1,5];
    data(j).Case = names(j);
    data(j).Pmax = 919;
    data(j).Pmin = 367.6; 
end
if asize == 5
    j=2;
    data(j).Case = names(j);
    data(j).Pmax = 1102.8;
    data(j).Pmin = 220.56; 
else
    for j=[2,6];
        data(j).Case = names(j);
        data(j).Pmax = 1102.8;
        data(j).Pmin = 220.56; 
    end
end

j=3;
data(j).Case = names(j);
data(j).Pmax = 919;
data(j).Pmin = 220.56; 
j=4;
data(j).Case = names(j);
data(j).Pmax = 1102.8;
data(j).Pmin = 367.6; 

vom=4.5;

gen_num = 284;


mdw = struct('dates',[],'gen',[],'spread',[],'imr',[]);

for casenum=1:asize
    dates = results(casenum).Gen(:,1).Variables;
    gen = results(casenum).Gen(:,gen_num).Variables;
    fuelcost = results(casenum).FuelCost(:,gen_num).Variables;
    price = results(casenum).Price(:,2).Variables;
    spread = results(casenum).Spread(:,gen_num).Variables;
    imr = results(casenum).IMR_Hr(:,gen_num).Variables;

    mdw(casenum).dates = dates; mdw(casenum).gen = gen; mdw(casenum).spread = spread; mdw(casenum).imr =imr ;
end

case_names = {'Index'};
for c = 1:asize ; case_names = [case_names, results(c).model_name]; end
index = { 'Spark Spread < 1';'1 <= Spark Spread < 10';'10 <= Spark Spread < 20';'20 <= Spark Spread < 30';'30 <= Spark Spread < 40';'Spark Spread > 40'};
unit = 1;
spread_imr = zeros(6,asize);
for i =1:asize
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
writetable(spread_imr,filename,'Sheet','IMR_SparkSpread','Range','A3');



end