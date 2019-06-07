load('batch_results.mat')
hFig = figure(1);
set(gcf,'PaperPositionMode','auto')
set(hFig, 'Position', [0 0 1000 500])
mat = sum(final_r(1).TechGen(:,2:end).Variables);
pie(mat)
dist = final_r(1).TechGen(:,2:end).Variables > 0;
CF = sum(dist)/size(dist,1)

title('ERCOT Generation by Technology ')
ylabel('Generation in MW') 
xlabel('Time') 
lgd = legend('Nuclear','Steam Turbine', 'Combustion Turbine', 'DC line' , 'Internal Combustion', 'Wind', 'Solar','Location','NorthEastOutside');
title(lgd,'Technology Type ','FontSize',10);
saveas(hFig,'Techtype.png')
save('Cf.mat','CF');