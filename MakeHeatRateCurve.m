function [hrx,hry] = MakeHeatRateCurve(pmax,ahr,typenum,HRTypes)

% Make Power Interval vector
hrx = pmax * HRTypes.X(typenum,:);

% Make vector of average HRs
heatrates = ahr * HRTypes.Y(typenum,:);

% Get energy input per block
btuin = hrx .* heatrates;

% Calculate Incremental heat rate
hry(1) = 0;
hry(2) = heatrates(2);

for i=3:5
   hry(i) = (btuin(i) - btuin(i-1)) / (hrx(i) - hrx(i-1)); 
end


% Correction for NGCC to maintain monotonicity
% hry(2:5) = sort(hry(2:5),'descend');

% if (hry(4) - hry(5) < 0)
%    tmp = hry(5);
%    hry(5) = hry(4);
%    hry(4) = tmp;
% end

% Now check the resulting HR curve




end

