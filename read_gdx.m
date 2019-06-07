function[results] = read_gdx(gdx_file,results,i)

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));

N.name='N';
N.uels = {(1:48)};
N.type='SET';

G.name='G';
G.uels = guel1('g',1:245);
G.type='SET';

Fuel.name='Fuel';
Fuel.uels = {(1:8)};
Fuel.type='SET';

Tech.name='Tech';
Tech.uels = {(1:7)};
Tech.type='SET';

INT.name='INT';
INT.uels = {'TU','TD','pU'};
INT.type='SET';

SU.name='SU';
SU.uels = guel1('SU',1:3);
SU.type='SET';

% lines.name='lines';
% lines.uels = {(1:6)};
% lines.type='SET';

zones.name='zones';
zones.uels = {(1:4)};
zones.type='SET';

dummygen.name='Z';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
vTotalCost=X.val;
clear dummygen;

dummygen.name='vGenCost';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
vGenCost=X.val;
clear dummygen;

dummygen.name='vStartUpCost';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
vStartUpCost=X.val;
clear dummygen;

dummygen.name='vPenaltyCost';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
vPenaltyCost=X.val;
clear dummygen;

dummygen.name='pGenCost';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pGenCost=X.val;
clear dummygen;

dummygen.name='pGenSUCost';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pGenSUCost=X.val;
clear dummygen;



dummygen.name='vPower';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vPower=X.val;
clear dummygen;

dummygen.name='vU';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vU=X.val;
clear dummygen;

dummygen.name='vW';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vW=X.val;
clear dummygen;

dummygen.name='vUP';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vUP=X.val;
clear dummygen;

dummygen.name='vDown';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vDown=X.val;
clear dummygen;

dummygen.name='vSU_TYPE';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=SU.uels;
dummygen.uels{3}=N.uels;
X=rgdx(gdx_file,dummygen);
vSU_TYPE=X.val;
clear dummygen;

dummygen.name='vNse';
dummygen.form='full';
%dummygen.uels{1}=zones.uels;
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
vNse=X.val;
clear dummygen;

% dummygen.name='vLineflow';
% dummygen.form='full';
% dummygen.uels{1}=lines.uels;
% dummygen.uels{2}=N.uels;
% X=rgdx(gdx_file,dummygen);
% vLineflow=X.val;
% clear dummygen;

dummygen.name='GenZone';
dummygen.form='full';
dummygen.uels{1}=zones.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
GenZone=X.val;
clear dummygen;

dummygen.name='vGenFuelCost';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vGenFuelCost=X.val;
clear dummygen;

dummygen.name='pVOMCost';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pVOMCost=X.val;
clear dummygen;


dummygen.name='pFuelGen';
dummygen.form='full';
dummygen.uels{1}=N.uels;
dummygen.uels{2}=Fuel.uels;
X=rgdx(gdx_file,dummygen);
pFuelGen=X.val;
clear dummygen;

dummygen.name='pTechGen';
dummygen.form='full';
dummygen.uels{1}=N.uels;
dummygen.uels{2}=Tech.uels;
X=rgdx(gdx_file,dummygen);
pTechGen=X.val;
clear dummygen;

dummygen.name='pExpNetRev';
dummygen.form='full';
dummygen.uels{1}=G.uels;
X=rgdx(gdx_file,dummygen);
pExpNetRev=X.val;
clear dummygen;

dummygen.name='pIMR_Hr';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pIMR_Hr=X.val;
clear dummygen;

dummygen.name='pSpread';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pSpread=X.val;
clear dummygen;

dummygen.name='pAVGcost';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pAVGcost=X.val;
clear dummygen;

dummygen.name='pPrice';
dummygen.form='full';
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
pPrice=X.val;
clear dummygen;

dummygen.name='pMIPGAP';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
pMIPGAP=X.val;
clear dummygen;

dummygen.name='pModelStat';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
pModelStat=X.val;
clear dummygen;

if pModelStat == 10
    exit
end


results(i).TotalCost = [results(i).TotalCost;vTotalCost]  ; 
results(i).TotalGenCost = [results(i).TotalGenCost;vGenCost];
results(i).TotalSUCost = [results(i).TotalSUCost;vStartUpCost];
results(i).TotalPenaltyCost = [results(i).TotalPenaltyCost;vPenaltyCost];
results(i).GenCost = [results(i).GenCost;pGenCost(:,2:25)'];
results(i).GenSUCost = [results(i).GenSUCost;pGenSUCost(:,2:25)'];
results(i).Gen = [results(i).Gen;vPower(:,2:25)']  ; 
results(i).Startup = cat(3,results(i).Startup,vSU_TYPE(:,:,2:25));
results(i).IMR = [results(i).IMR;pExpNetRev']  ; 
results(i).FuelCost = [results(i).FuelCost;vGenFuelCost(:,2:25)'];
results(i).VOMCost = [results(i).VOMCost;pVOMCost(:,2:25)'];
results(i).Status = [results(i).Status;vU(:,2:25)']  ; 
results(i).Up = [results(i).Up;vUP(:,2:25)']  ; 
results(i).Aux = [results(i).Aux;vW(:,2:25)'];
results(i).Down = [results(i).Down;vDown(:,2:25)']  ; 
results(i).Price = [results(i).Price;pPrice(2:25,:)];
results(i).FuelGen = [results(i).FuelGen;pFuelGen(2:25,:)]; 
results(i).TechGen = [results(i).TechGen;pTechGen(2:25,:)];
results(i).NSE=[results(i).NSE;vNse(2:25)'];
% results(i).LineFlow =cat(1,results(i).LineFlow,vLineflow(:,2:25)') ;
results(i).ZonalGen=cat(1,results(i).ZonalGen,GenZone(:,2:25)'); 
results(i).MIPGAP = [results(i).MIPGAP;pMIPGAP] ;
results(i).IMR_Hr = [results(i).IMR_Hr;pIMR_Hr(:,2:25)'] ;
results(i).AVGcost = [results(i).AVGcost;pAVGcost(:,2:25)'] ;
results(i).Spread = [results(i).Spread;pSpread(:,2:25)'] ;

end