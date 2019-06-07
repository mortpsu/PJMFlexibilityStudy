function [dates, gen, spread, imr, index] = make_hourly_imr(casenum)

% Creates table for Afton's hourly IMR that can be sorted

PMIN1 = 96;
PMIN2 = 71;

switch(casenum)
    case 1
        PMIN = PMIN1;
    case 2
        PMIN = PMIN2;
    case 3
        PMIN = PMIN1;
    case 4
        PMIN = PMIN1;
    case 5
        PMIN = PMIN1;
    case 6
        PMIN = PMIN1;
    case 7
        PMIN = PMIN2;
    case 8
        PMIN = PMIN2;
    case 9
        PMIN = PMIN2;
end

    

VAROM = 4.80;

dates = [];
gen = [];
fuelcost = [];
%gencost = [];
%avgcost = [];
price = [];



for i=1:363
    
    % read in results file
    fname = sprintf('../exp_det_results/results_%d.mat',i);
    if (exist(fname,'file')==2)
        load(fname);
    else
        continue;
    end
    
    % pull out the relevant fields
    dates = [dates; results(casenum).Gen{1:24,1}];
    gen = [gen; results(casenum).Gen{1:24,2}];
    fuelcost = [fuelcost; results(casenum).FuelCost{1:24,2}];
    price = [price; results(casenum).Price{1:24,2}];
    
end

% calculate additional results
gencost = fuelcost + gen .* VAROM;

avgcost = zeros(length(gencost),1);
index = (gen >= PMIN);
avgcost(index) = gencost(index) ./ gen(index);

revenue = gen .* price;

imr = revenue - gencost;

spread = price - avgcost;

gen(~index) = 0;
imr(~index) = 0;
spread(~index) = 0;


end




