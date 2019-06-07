load('batch_results.mat')
%%%%  IMR Section
system('rm batch_IMR.xlsx');
system('rm batch_Cost.xlsx');
system('rm batch_extra.xlsx');


imr =struct('Generator',[],'IMR',[]);
gen_names = {'Forney1';'Forney2';'Lamar1';'Lamar2';'Rio_Nogales';'Barney';'Bastrop';'Odessa1';'Odessa2'};
for j=1:9;imr(j).Generator = gen_names(j);end;
gen_num = [284,285,234,235,241,118,254,263,264];
names = {};
names(1) = {'Datetime'};
dates = final_r(1).IMR(:,1);
for i=1:12
for j=1:9
    names(i+1) = {sprintf('%s_case',final_r(i).model_name(9:end))};
    imr(j).IMR=[imr(j).IMR,final_r(i).IMR(:,gen_num(j)).Variables];
end
end

for j=1:9
    imr(j).IMR=[dates,array2table(imr(j).IMR)];
    imr(j).IMR.Properties.VariableNames = names;
end

sheet_names ={'Forney1_IMR';'Forney2_IMR';'Lamar1_IMR';'Lamar2_IMR';'Rio_Nogales_IMR';'Barney_IMR';'Bastrop_IMR';'Odessa1_IMR';'Odessa2_IMR'};

filename ='batch_IMR.xlsx';
for j = 1:9
    writetable(imr(j).IMR,filename,'Sheet',string(sheet_names(j)),'Range','A3');
    diff =imr(j).IMR(:,2:end).Variables - imr(j).IMR(:,2).Variables;
    writetable(table(diff),filename,'Sheet',string(sheet_names(j)),'Range','O4','WriteVariableNames',false);
    writetable(array2table(sum(diff)),filename,'Sheet',string(sheet_names(j)),'Range','O304','WriteVariableNames',false);
    writetable(table({sprintf('IMR for %s in different Upgrade cases', cell2mat(gen_names(j)))}),filename,'Sheet',string(sheet_names(j)),'Range','A1','WriteVariableNames',false);
end

%%%% COST section

dates =final_r(1).Cost(:,1);
cost =[];
mgap = [];
names = {};
names(1) = {'Datetime'};
for i=1:12
    names(i+1) = {sprintf('%s_case',final_r(i).model_name(9:end))};
    cost = [cost,final_r(i).Cost(:,2).Variables];
    mgap = [mgap,final_r(i).MIPGAP(:,2).Variables];
end
cost = [dates,array2table(cost)];
cost.Properties.VariableNames = names;

mgap = [dates,array2table(mgap)];
mgap.Properties.VariableNames = names;

filename ='batch_Cost.xlsx';
writetable(cost,filename,'Sheet','TotalSystemCost','Range','A3');
diff = cost;
diff(:,2:end).Variables = - table2array(cost(:,2:end)) + table2array(cost(:,2));
writetable(diff,filename,'Sheet','Savings','Range','A3');

mipgap = mgap(:,2:end).Variables;
for i=1:12
    mipgap(:,i) = max(-mgap(:,[2,i+1]).Variables,[],2);
end
savings =table2array(diff(:,2:end)) - mipgap;
savings(savings < 0 ) = 0;
diff(:,2:end).Variables = savings;
writetable(mgap,filename,'Sheet','MIPGAP','Range','A3');
writetable(diff,filename,'Sheet','Savings-MIPGAP','Range','A3');

%%%%Start
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

for i=1:12
    total_hr = [total_hr;sum(final_r(i).Gen(:,gen_num).Variables > 0)];
    names(i) = {sprintf('%s_case',final_r(i).model_name(9:end))};
    starts = [starts;sum(final_r(i).Up(:,gen_num).Variables)];
    shutdowns = [shutdowns;sum(final_r(i).Down(:,gen_num).Variables)];
    
    pmax = ones(size(final_r(i).Gen(:,gen_num).Variables)).*data(i).Pmax;
    pmin = ones(size(final_r(i).Gen(:,gen_num).Variables)).*data(i).Pmin;
    hr_min =[hr_min;sum(round(final_r(i).Gen(:,gen_num).Variables) == round(pmin))];
    hr_full =[hr_full;sum(round(final_r(i).Gen(:,gen_num).Variables) == round(pmax))];
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
% Write initial condition to GDX

filename ='batch_extra.xlsx';
writetable(starts,filename,'Sheet','No_Startups');
writetable(shutdowns,filename,'Sheet','No_Shutdowns');
writetable(total_hr,filename,'Sheet','Total_hr_On');
writetable(hr_min,filename,'Sheet','No_hr_min');
writetable(hr_full,filename,'Sheet','No_hr_full');