function[results] = init_results()
results =struct('model_name',[],'Gen',[],'IMR',[],'IMR_Hr',[],'TotalCost',[],'Status',[],'Up',[],'Down',[],'Startup',[],'FuelCost',[],'VOMCost',[],'TotalGenCost',[],'TotalSUCost',[],'Aux',[],'Price',[],'NSE',[], 'LineFlow',[],'ZonalGen',[],'FuelGen',[],'TechGen',[],'MIPGAP',[],'Spread',[],'AVGcost',[]);
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
end