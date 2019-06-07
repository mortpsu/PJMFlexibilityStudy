function[results] = read_gdx5(gdx_file,results,i)

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

dummygen.name='vReserveCost';
dummygen.form='full';
X=rgdx(gdx_file,dummygen);
vReserveCost=X.val;
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

dummygen.name='vRS10';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vRS10=X.val;
clear dummygen;

dummygen.name='vRN10';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
vRN10=X.val;
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

dummygen.name='vOverGen';
dummygen.form='full';
%dummygen.uels{1}=zones.uels;
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
vOverGen=X.val;
clear dummygen;

dummygen.name='pShortRS10';
dummygen.form='full';
%dummygen.uels{1}=zones.uels;
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
pShortRS10=X.val;
clear dummygen;

dummygen.name='pShortRP10';
dummygen.form='full';
%dummygen.uels{1}=zones.uels;
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
pShortRP10=X.val;
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

dummygen.name='pPriceRS10';
dummygen.form='full';
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
pPriceRS10=X.val;
clear dummygen;

dummygen.name='pPriceRP10';
dummygen.form='full';
dummygen.uels{1}=N.uels;
X=rgdx(gdx_file,dummygen);
pPriceRP10=X.val;
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
results(i).TotalReserveCost = [results(i).TotalReserveCost;vReserveCost];
results(i).TotalPenaltyCost = [results(i).TotalPenaltyCost;vPenaltyCost];
results(i).GenCost = [results(i).GenCost;pGenCost(:,2:25)'];
results(i).GenSUCost = [results(i).GenSUCost;pGenSUCost(:,2:25)'];
results(i).Gen = [results(i).Gen;vPower(:,2:25)']  ; 
results(i).RS10 = [results(i).RS10;vRS10(:,2:25)']  ; 
results(i).RN10 = [results(i).RN10;vRN10(:,2:25)']  ; 
results(i).Startup = cat(3,results(i).Startup,vSU_TYPE(:,:,2:25));
results(i).FuelCost = [results(i).FuelCost;vGenFuelCost(:,2:25)'];
results(i).VOMCost = [results(i).VOMCost;pVOMCost(:,2:25)'];
results(i).Status = [results(i).Status;vU(:,2:25)']  ; 
results(i).Up = [results(i).Up;vUP(:,2:25)']  ; 
results(i).Aux = [results(i).Aux;vW(:,2:25)'];
results(i).Down = [results(i).Down;vDown(:,2:25)']  ; 
results(i).Price = [results(i).Price;pPrice(2:25,:)];
results(i).PriceRS10 = [results(i).PriceRS10;pPriceRS10(2:25,:)];
results(i).PriceRP10 = [results(i).PriceRP10;pPriceRP10(2:25,:)];
results(i).NSE=[results(i).NSE;vNse(2:25)'];
results(i).OverGen=[results(i).OverGen;vOverGen(2:25)'];
results(i).RS10_SHORT=[results(i).RS10_SHORT;pShortRS10(2:25)'];
results(i).RP10_SHORT=[results(i).RP10_SHORT;pShortRP10(2:25)'];
results(i).MIPGAP = [results(i).MIPGAP;pMIPGAP] ;
results(i).AVGcost = [results(i).AVGcost;pAVGcost(:,2:25)'] ;

end