function[results] = prep_results2(st,ed,results)

%for i =1:size(results,2)
for i =1:2
    dt =st:hours(1):ed;
    dt = array2table(dt');
    dt.Properties.VariableNames = {['Datetime']};
    
    % Generation levels 
    results(i).Gen = [dt,array2table(results(i).Gen)];
    
    %Inframarginal Rent levels - hourly
    results(i).IMR_Hr = [dt,array2table(results(i).IMR_Hr)];
    
    results(i).Spread = [dt,array2table(results(i).Spread)];
    
    results(i).AVGcost = [dt,array2table(results(i).AVGcost)];

    %Inframarginal Rent levels
    mt = array2table((st:ed)');
    mt.Properties.VariableNames = {['Datetime']};
    results(i).IMR =[mt,array2table(results(i).IMR)];

    % Price for each period
    results(i).Price = [dt,array2table(results(i).Price)];

    %Total System Cost
    results(i).Cost = [mt,array2table(results(i).Cost)];
    
    %Total System Cost
    results(i).MIPGAP = [mt,array2table(results(i).MIPGAP)];

    %Total Generation Cost
    results(i).GenCost=[mt,array2table(results(i).GenCost)];
    %Total start-up Cost
    results(i).SUCost= [mt,array2table(results(i).SUCost)];

    % commitment status
    results(i).Status = [dt,array2table(results(i).Status)];

    %Turn-on Variable
    results(i).Up  = [dt,array2table(results(i).Up)];

    %Turn-off Variable
    results(i).Down =  [dt,array2table(results(i).Down )];

    %Aux Variable
    results(i).Aux = [dt,array2table(results(i).Aux)];

    %Fuel cost for each generator for all periods
    results(i).FuelCost = [dt,array2table(results(i).FuelCost)];

    %start-up type variables
    SU = permute(results(i).Startup,[1 3 2]);
    %start-up type 1 
    Final_SU1=  [dt,array2table(SU(:,:,1)')];
    %start-up type 2
    Final_SU2=  [dt,array2table(SU(:,:,2)')];
    %start-up type 3 
    Final_SU3=  [dt,array2table(SU(:,:,3)')];
    results(i).Startup = struct('SU1',Final_SU1,'SU2',Final_SU2,'SU3',Final_SU3);

    %Non-served Energy
    results(i).NSE = [dt,array2table(results(i).NSE)];

    %Line flow
    results(i).Lineflow = [dt,array2table(results(i).LineFlow)];

    %Generation by zones
    results(i).ZonalGen = [dt,array2table(results(i).ZonalGen)];

    %Generation by Technology type
    results(i).TechGen = [dt,array2table(results(i).TechGen)];

    %Generation by Fuel type
    results(i).FuelGen = [dt,array2table(results(i).FuelGen)];
end
end