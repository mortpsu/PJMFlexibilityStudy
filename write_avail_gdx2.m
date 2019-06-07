function [] = write_avail_gdx2(doy)

NumGens = 245;

% load Avail_CT and Avail_Index from file
load('avail2.mat');

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));
G.name='G';
G.uels = guel1('G',1:NumGens);
G.type='SET';

avail_all = zeros(NumGens,1);

for i=1:NumGens
row = Avail_Index(i);

if (row)
    avail_all(i) = Avail_CT(row,doy);
else
    avail_all(i) = 1.0;
end




Avail.name='Avail';
Avail.type='parameter';
Avail.val=avail_all;
Avail.form='full';
Avail.uels{1}= G.uels;
wgdx('Avail',G,Avail);

end

