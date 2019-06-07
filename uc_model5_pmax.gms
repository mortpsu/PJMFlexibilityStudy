$set periods 25

Sets
G total generators /g1*g245/
N no of periods /1*%periods%/
k Power Points /k0*k4/
KLOW(K) /k0*k2/

SU no of startup types                 /SU1*SU3/
l linear power trajectory              /l1*l8/
START_PARAM colums of start-up         /Cost,Startup-T,TurnDown/
GEN_PARAMS columns in pGenData table   /GenType,HRType,AvgHR,Fprice,VarOM,Pmax,Pmin, MINUP,MINDOWN,Zone,FuelType,Ramp,AvgOpCost/
zones     "demand zones (North=1, Houston=2, South=3, West=4"                       /1*4/
lines     "lines between pairs of zones (1 = nh, 2 = nw, 3 = sn, 4 = wn, 5 = ns, 6 = hn)"  /1*6/

* Define Useful subsets
GCOAL(G) Coal Units                    /g1*g25/
GNGCC(G) NGCC Units                    /g26*g80/
GNGCT(G) NGCT Units                    /g81*g149/
GNGST(G) NGST Units                    /g150*g190/
GCOGEN(G) COGEN gas units              /g191*g212/
GBIO(G) Bio ST unit                    /g213/
GIC(G)   Diesel IC units               /g219*g245/
GTINY(G) Very small CTs and ICs        /g84*g91,g94*g109,g125,g126,g129*g135,g142*g150,g214*g245/
GSLOW(G) Slower starting units         /g1*g213/
GFAST(G) Fast Aero GTs and ICs         /g81*g149,g214*g245/
GFIX(G)  Fixed commitment units (Coal and cogen) /g1*g25/
GCOMMIT(G) Units that need a binary commit variable /g26*g190,g213/
GSURAMP(G) Units that require startup ramping /g1*g80,g150*g190,g213/
GDISP(G) Dispatchable units (not cogen) /g1*g190,g213*g245/
GGAS(G)  All Gas Units                  /g26*g212/
GCGS(G)  Coal NGCC and Gas-ST only      /g1*g80, g150*g190/

*GOFF(G)   Temporary offline units       /g81*g85,g88*g103,g106*g126,g136*g142,g144*g149/
GOFF(G)   Temporary offline units        /g145/

GFORNEY(G)                                 /g35/
GLAMAR(G)                                  /g50/

*GCC(G)  CC generators upgraded            /g35/
*GCC(G)  CC generators upgraded            /g35,g36/
*Lamar - g50,g51
*Forney - g35,g36
*Rio Nogales - g69
*Barney  -  g27
*Bastrop - g28
*Odessa -g61,g62
;
Alias (NN,N);
Alias (kk,k);

$include upgrade.gms

$include data2.gms

$include reserves_pjm_old.gms

display pGenData;

pAvail(G)$GOFF(G) = 0;
pAvail(G)$pUOFF(G) = 0;

pGenData(G,'Pmin')$GIC(G) = pGenData(G,'Pmax') * 0.8;

* Adjust Costs between technologies
pGenData(G,'Fprice')$GCOAL(G) = 1.8;


* Adjust Costs between technologies
pGenData(G,'VarOM')$GNGST(G) = 7.0;

pSUcost(G,SU)$GNGST(G) = pSUcost(G,SU) * 0.25;


pGenData('g50','VarOM') = pGenData('g50','VarOM') * 2;

pIHR('g28',K) = pIHR('g28',K) *0.88;
pGenData('g28','VarOM') = pGenData('g28','VarOM') * 2;

$ontext
pGenData(G,'Fprice')$GGAS(G) = 2.5;

pGenData(G,'VarOM')$GCOAL(G) = 2.5;

pGenData(G,'VarOM')$GNGCC(G) = 3.5;

pSUcost(G,SU) = pSUcost(G,SU) * 0.1;

pSUcost('g35',SU) = pSUcost('g35',SU) * 1.5;


pIHR('g35','k1') =  9374.4;
pIHR('g35','k2') =  8332.8;
pIHR('g35','k3') =  8332.8;
pIHR('g35','k4') =  6770.4;



*pSUcost('g35',SU) = 0;

*pGenData('g50','VarOM') = 4.6;


*pGenData('g35','VarOM') = 5;
*pSUcost('g35',SU) = pSUcost('g35',SU) * 0.0;

*pIHR('g35',K) =  pIHR('g35',K) * 1.02;
*pIHR('g35',KLOW) =  pIHR('g35',KLOW) * 0.94;
$offtext
************************************************************************
pGenData(GCC, 'Pmax') = pGenData(GCC, 'Pmax')*1.2;
*pGenData(GCC, 'Pmin') = pGenData(GCC, 'Pmax')*0.2;
*pGenData(GCC, 'Ramp') = pGenData(GCC, 'Ramp')*2;
************************************************************************
*$ontext
Sets
PmaxUp /'PowPnt','IHR'/
CC(G)
;

CC(G)$[not GCC(G)] = yes;

Parameter pUpgrd(GCC,PmaxUp) ;
pUpgrd(GCC,'PowPnt') = pGenData(GCC, 'Pmax');
pUpgrd(GCC,'IHR') =(pUpgrd(GCC,'PowPnt')*(pGenData(GCC,'AvgHR')) -pGenData(GCC,'AvgHR')*pPowPnt(GCC,'k4'))
                    /(pUpgrd(GCC,'PowPnt')-pPowPnt(GCC,'k4'));


Parameter pXFC(GCC);
*pXFC(GCC) = (pUpgrd(GCC,'IHR')/1000) * pGenData(GCC,'Fprice');

Binary variable Xbin(GCC,N);
Positive Variables Xpwl(GCC,N);
*$offtext

$ontext
************************************************************************
pSUtime(GCC,'SU1') = 0;
pSUtime(GCC,'SU2') = 1;
pSUtime(GCC,'SU3') = 2;

pSUcost(GCC,SU) = pSUcost(GCC,SU)*0.25;

pTrajectory(GCC,'SU1','L1') = 0;
pTrajectory(GCC,'SU1','L2') = 0;
pTrajectory(GCC,'SU1','L3') = 0 ;
pTrajectory(GCC,'SU1','L4') = 0 ;
pTrajectory(GCC,'SU1','L5') = 0 ;
pTrajectory(GCC,'SU1','L6') = 0 ;
***********************************
pTrajectory(GCC,'SU2','L1') = pGenData(GCC, 'Pmin');
pTrajectory(GCC,'SU2','L2') = 0 ;
pTrajectory(GCC,'SU2','L3') = 0 ;
pTrajectory(GCC,'SU2','L4') = 0 ;
pTrajectory(GCC,'SU2','L5') = 0 ;
pTrajectory(GCC,'SU2','L6') = 0 ;
************************************
pTrajectory(GCC,'SU3','L1') = pGenData(GCC, 'Pmin')*0.5 ;
pTrajectory(GCC,'SU3','L2') = pGenData(GCC, 'Pmin') ;
pTrajectory(GCC,'SU3','L3') = 0 ;
pTrajectory(GCC,'SU3','L4') = 0 ;
pTrajectory(GCC,'SU3','L5') = 0 ;
pTrajectory(GCC,'SU3','L6') = 0 ;
pGShut(GCC,'L1')=pGenData(GCC, 'Pmin') ;
pGShut(GCC,'L2')=0 ;
************************************************************************
$offtext

*******************************************************************

Scalars
ZoneFracNorth     /0.3770/
ZoneFracHouston   /0.2773/
ZoneFracSouth     /0.2766/
ZoneFracWest      /0.0691/
scCnse /10000/
;




Parameter pDemand(N,ZONES), pDemandAll(N);

pDemandAll(N) = pDemandINPUT(N);

pDemand(N,'1') = pDemandAll(N) * ZoneFracNorth;
pDemand(N,'2') = pDemandAll(N) * ZoneFracHouston;
pDemand(N,'3') = pDemandAll(N) * ZoneFracSouth;
pDemand(N,'4') = pDemandAll(N) * ZoneFracWest;

Display pDemandAll;

Parameter pAvailMax(N), pAvailMin(N), pAvailMin2(N);
pAvailMax(N) = sum(GDISP,pGenData(GDISP,'Pmax')*pUFIX(GDISP,N));
pAvailMax(N) = sum(GDISP,pGenData(GDISP,'Pmin')*pUFIX(GDISP,N));
pAvailMax(N) = sum(GCOAL,pGenData(GCOAL,'Pmin')*pUFIX(GCOAL,N));

Parameter pSpinreserves(N);
pSpinreserves(N)=sum(zones,pDemand(N,zones))*0.05;


Variables
z                Total Cost
vGenCost         Total cost from generation
vStartUpCost     Startup Cost of reserve unit
vPenaltyCost     Total Penlaty cost for non=-served energy and curtailments
vReserveCost     Total Penalty for Reserve Scarcity
;

Binary variables
vU(G,N)          Unit commitment state for unit G in period N [0 1]
vSU_TYPE(G,SU,N)  Binary variable which indicates the type of start [0 1]
vBin(GNGCC,N)
;

Positive variables
vW(G,N)
vGenFuelCost(G,N)
vPower(G,N)
vUp(G,N)         Binary variable to start up [0 1]
vDown(G,N)       Binary variable to shut down [0 1

*vLineflow(lines,N)       "flow over lines per hour (GW)"
*vNse(zones,N)
vNse(N)
*vOverGen(zones)
vOverGen(N)
pwl(G,N,k)    variables for piece-wise linear constraint

* Variables for PJM ORDC curves
vRS10(G,N)          Amount of 10 min spinning reserves provided (MW)
vRS10_SHORT(N,J)    Volume not met of 10 min spinning reserves
vRN10(G,N)          Amount of 10 min non-spinning reserves provided (MW)
vRP10_SHORT(N,J)    Volume not met of 10 min primary reserves
;

* Set stepsize for ORDC - Spinning Reserves (10 min)
vRS10_SHORT.UP(N,J)$[ORD(J) LT CARD(J)] = pRS10_BlockSize(J) ;
vRP10_SHORT.UP(N,J)$[ORD(J) LT CARD(J)] = pRP10_BlockSize(J) ;


Parameter pIncrFuelCost(k,G);
pIncrFuelCost(k,G) = (pIHR(G,k)/1000) * pGenData(G,'Fprice');
pXFC(GCC) = pIncrFuelCost('k4',GCC) * 1.2;

display pPowPnt;
display  pIncrFuelCost;

Parameter TDR(G) ,TUR(G);
TUR(G) = max(0,(pGenData(G, 'MinUp') - Int_Cond (G,'TU'))* Int_Cond (G,'pU') );
TDR(G) = max(0,(pGenData(G, 'MinDown') - Int_Cond (G,'TD'))*(1- Int_Cond (G,'pU')) );




Equation
eCost                Objective function
eGenCost             Total generation cost
eStartUpcost         Startup cost for reserve unit
ePenaltyCost         Total cost for non-served energy and curtailment
eReserveCost         Total Cost for reserve Scarcity
*eDemand(zones,N)
eDemand(N)
eState(G,N)
eAux(G,N)
ePower(G,N)
eSG(G,N)
eGenFuelCost(G,N)
eMinUp(G,n)
eMinDown(G,N)
eRampUpConst(G,N)      Ramp-Up limit for Committed Units
eRampDownConst(G,N)    Ramp-Down limit for Committed Units
eInitalCond(G,N)
eSUtype(G,SU,N)
eSumStart(G,N)
eSU3type(G,SU,N)
*eSpinReserves(N)

enforce1(G,N)
enforce2(G,N)

eAuxFX(G,N)
ePowerFX(G,N)
eGenFuelCostFX(G,N)
eRampUpConstFX(G,N)
eRampDownConstFX(G,N)

eStateFST(G,N)
eAuxFST(G,N)
ePowerFST(G,N)
eGenFuelCostFST(G,N)
eGenFuelCostFST2(G,N)

enforce3(GCC,N)
enforce4(GCC,N)
eXSG(GCC,N)
eXGenFC(GCC,N)


eReqSR10(N)           Enforce total system requirement for spinning reserves 10 min
eReqSP10(N)           Enforce total system requirement for Primary reserves 10 min

eCapLimRS10(G,N)
eRampLimRS10(G,N)
eLimRN10
eLimRN10a
;

eCost..           z =E=(vGenCost + vStartUpcost + vPenaltyCost + vReserveCost);

eGenCost..        vGenCost =E= sum((G,N), vGenFuelCost(G,N) + vPower(G,N)* pGenData(G,'VarOM'))  ;

eStartUpcost..    vStartUpCost =E= sum((N,G,SU)$(GSURAMP(G)),pSUcost(G,SU)*vSU_TYPE(G,SU,N))
                                     + sum((N,GFAST), vUp(GFAST,N) * 500  ) ;

*ePenaltyCost..    vPenaltyCost =E= sum((zones,N),scCnse*vNse(zones,N)) + sum(zones,vOverGen(zones)*scCnse) ;

ePenaltyCost..    vPenaltyCost =E= sum(N,scCnse*vNse(N)) + sum(N,vOverGen(N)*scCnse) ;

eReserveCost..    vReserveCost =E= sum((N,J), vRS10_SHORT(N,J)*pRS10_Price(J))+sum((N,J), vRP10_SHORT(N,J)*pRP10_Price(J));



*eDemand(zones,N).. sum(g$[pGenData(g,'Zone')=ord(zones)],vPower(G,N)) - sum(lines$[pLinesources(lines)=ord(zones)],vLineflow(lines,N))
*                    + sum(lines$[pLinesinks(lines)=ord(zones)],vLineflow(lines,N)) + vNse(zones,N) + vOverGen(zones)$[ord(N) =1] =e= pDemand(N,zones);

eDemand(N).. sum(g,vPower(G,N)) + vNse(N) - vOverGen(N) =e= pDemandAll(N);

eSG(G,N)$(CC(G))..           sum(k, pwl(G,N,k)) =e= vPower(G,N) ;

*eSpinReserves(N)..     sum(GDISP, vU(GDISP,N) * pGenData(GDISP,'Pmax') - vPower(GDISP,N)) =G= pSpinreserves(N);


* Constraints only for gens with commitment variable
eState(G,N)$[Ord(N) > 1 and GCOMMIT(G)]..   vU(G,N)     =e=  vU(G,N-1) + vUP(G,N) - vDown(G,N);

eAux(G,N)$GCOMMIT(G).. vW(G,N) =l= (pGenData(G,'Pmax')-pGenData(G,'Pmin'))*(vU(G,N)-vDown(G,N+1)) ;

ePower(G,N)$GCOMMIT(G).. vPower(G,N) =e=  vU(G,N)*pGenData(G,'Pmin')  + vW(G,N)
                            +sum(L$[[Ord(L) <= pTurnDown(G)  ]], pGShut(G,L)*vDown(G,N+(-Ord(L)+1)))
                            +sum(SU,sum(L$[[Ord(L) <= pSUtime(G,SU)]], pTrajectory(G,SU,L)*vSU_TYPE(G,SU,N+(-Ord(L)+1+pSUtime(G,SU))) ))  ;

eGenFuelCost(G,N)$[GCOMMIT(G) and CC(G)]..  vGenFuelCost(G,N)  =e= sum(k$[ord(k) >2],pwl(G,N,k)*pIncrFuelCost(K,G))
                                            + (vU(G,N) +sum(L$[[Ord(L) <= pTurnDown(G)  ]], vDown(G,N+(-Ord(L)+1)))
                                            + sum(SU,sum(L$[[Ord(L) <= pSUtime(G,SU)]],
                                            vSU_TYPE(G,SU,N+(-Ord(L)+1+pSUtime(G,SU))) )))*pIncrFuelCost('k1',G)* pPowPnt(G,'k1')  ;

eMinUp(G,N)$[ord(N) > pGenData(G,'MinUp') and GCOMMIT(G)]..  vU(G,N) =g= sum(NN$[[ord(NN)>(ord(N) - pGenData(G,'MinUp'))] and [ord(NN) <= ord(N)]], vUP(G,NN));

eMinDown(G,N)$[ord(N) > pGenData(G,'MinDown') and GCOMMIT(G)]..    (1 - vU(G,N)) =g= sum(NN$[[ord(NN)>(ord(N) - pGenData(G,'MinDown'))] and [ord(NN) <= ord(N)]], vDown(G,NN));

eRampUpConst(G,N)$[ORD(N)<%periods% and GCOMMIT(G)]..       vW(G,N+1)- vW(G,N) =l= pGenData(G,'Ramp') * 60 * vU(G,N) ;

eRampDownConst(G,N)$[ORD(N)<%periods% and GCOMMIT(G)]..     vW(G,N) - vW(G,N+1) =l= pGenData(G,'Ramp') * 60 * vU(G,N) ;

eInitalCond(G,N)$[ORD(N) <= (1+(TUR(G)+TDR(G))) and Int_Cond(G,'pU') = 1 and [GNGCC(G) or GNGST(G)]]..     vU(G,N) =e= Int_Cond(G,'pU');

eSUtype(G,SU,N)$[Ord(SU)<3 and GCOMMIT(G)]..   vSU_TYPE(G,SU,N) =l= sum(NN$[[Ord(NN) <=(Ord(N)- pDownTime(G,SU))] and [Ord(NN) >=(Ord(N) - pDownTime(G,SU+1) + 1 )]], vDown(G,NN)) +1$[(Ord(N)-pDownTime(G,SU))>=(1 -Int_Cond (G,'TD')) and (Ord(N)-pDownTime(G,SU+1) +1 )<=(1 -Int_Cond (G,'TD'))  ];

eSU3type(G,SU,N)$[Ord(SU) eq 3 and (Ord(N) + Int_Cond (G,'TD')) < pDownTime(G,SU) and GCOMMIT(G)].. vSU_TYPE(G,SU,N) =l= 0;

eSumStart(G,N)$GCOMMIT(G)..         sum(SU,vSU_TYPE(G,SU,N))  =e= vUp(G,N) ;


enforce1(GNGCC,N)..         vbin(GNGCC,N) =l= pwl(GNGCC,N,'k2')/(pPowPnt(GNGCC,'k2') - pPowPnt(GNGCC,'k1')) ;

enforce2(GNGCC,N)..         sum(k$[ord(k) >3],pwl(GNGCC,N,k)) =l= vbin(GNGCC,N)*(pPowPnt(GNGCC,'k4') - pPowPnt(GNGCC,'k2')) ;


* Constraints for fixed commitment units (Coal, cogen)
eAuxFX(G,N)$GFIX(G).. vW(G,N) =l= (pGenData(G,'Pmax')-pGenData(G,'Pmin'))*pUFIX(G,N) ;

ePowerFX(G,N)$GFIX(G).. vPower(G,N) =e=  pUFIX(G,N)*pGenData(G,'Pmin')  + vW(G,N);

eGenFuelCostFX(G,N)$GFIX(G)..  vGenFuelCost(G,N)  =e= sum(k$[ord(k) >2],pwl(G,N,k)*pIncrFuelCost(K,G))
                                            + pUFIX(G,N)*pIncrFuelCost('k1',G)* pPowPnt(G,'k1')  ;

eRampUpConstFX(G,N)$[ORD(N)<%periods% and GFIX(G)]..       vW(G,N+1)- vW(G,N) =l= pGenData(G,'Ramp') * 60 * vU(G,N) ;

eRampDownConstFX(G,N)$[ORD(N)<%periods% and GFIX(G)]..     vW(G,N) - vW(G,N+1) =l= pGenData(G,'Ramp') * 60 * vU(G,N) ;


* Constraints for fast starting units (CTs, ICs)

eStateFST(G,N)$[Ord(N) > 1 and GFAST(G)]..   vU(G,N)     =e=  vU(G,N-1) + vUP(G,N) - vDown(G,N);

eAuxFST(G,N)$GFAST(G).. vW(G,N) =l= (pGenData(G,'Pmax')-pGenData(G,'Pmin'))*(vU(G,N)-vDown(G,N+1)) ;

ePowerFST(G,N)$GFAST(G).. vPower(G,N) =e=  vU(G,N)*pGenData(G,'Pmin')  + vW(G,N)  ;

eGenFuelCostFST(G,N)$GNGCT(G)..  vGenFuelCost(G,N)  =e= sum(k$[ord(k) >2],pwl(G,N,k)*pIncrFuelCost(K,G))
                                            + vU(G,N)*pIncrFuelCost('k1',G)* pPowPnt(G,'k1')  ;

eGenFuelCostFST2(G,N)$GTINY(G)..  vGenFuelCost(G,N)  =e= vPower(G,N) * pGenData(G,'AvgOpCost') ;


enforce3(GCC,N).. Xbin(GCC,N) =l= vPower(GCC,N)/pPowPnt(GCC,'k4');
enforce4(GCC,N).. Xpwl(GCC,N) =l= Xbin(GCC,N)*(pGenData(GCC,'Pmax')-pPowPnt(GCC,'k4'));


eXSG(GCC,N)..      sum(k, pwl(GCC,N,k) ) + Xpwl(GCC,N)  =e= vPower(GCC,N) ;
eXGenFC(GCC,N)..  vGenFuelCost(GCC,N)  =e= sum(k$[ord(k) >2],pwl(GCC,N,k)*pIncrFuelCost(K,GCC))  +
                                               Xpwl(GCC,N)*pXFC(GCC) +
                                               (vU(GCC,N) +sum(L$[[Ord(L) <= pTurnDown(GCC)  ]], vDown(GCC,N+(-Ord(L)+1)))
                                               +sum(SU,sum(L$[[Ord(L) <= pSUtime(GCC,SU)]], vSU_TYPE(GCC,SU,N+(-Ord(L)+1+pSUtime(GCC,SU)))
                                               )))*pIncrFuelCost('k1',GCC)* pPowPnt(GCC,'k1')  ;


*Contribution of unit g to Spinning Reserves  10 min
eCapLimRS10(G,N)$[ORD(N) > 1]..  vW(G,N) + vRS10(G,N) =L= (pGenData(G,'Pmax') - pGenData(G,'Pmin')) * vU(G,N);
eRampLimRS10(G,N)$[ORD(N) > 1]..  vRS10(G,N) =L= pGenData(G,'Ramp') * 10 * vU(G,N);

*Contribution of Non-Spinning Reserves 10 min
eLimRN10(G,N)$[ORD(N) > 1 and GTINY(G)]..    vRN10(G,N)=L= (1 - vU(G,N)) * pGenData(G,'Pmax') * (pAvail(G));
eLimRN10a(G,N)$[ORD(N) > 1 and not(GTINY(G))]..    vRN10(G,N)=L= 0;

*Requirement of the spinning reserves for 10 minutes
eReqSR10(N)$[ORD(N) > 1]..          sum(G, vRS10(G,N)) + sum(J,vRS10_SHORT(N,J)) =G= pReqRS10;

*Requirement of the primary reserves for 10 minutes
eReqSP10(N)$[ORD(N) > 1]..  sum(G, vRS10(G,N)) + sum(GTINY, vRN10(GTINY,N)) + sum(J,vRP10_SHORT(N,J)) =G= pReqRP10;



*******************************************************

* Set Bounds on Variables
vPower.up(G,N)  = pGenData(G,'Pmax');

pwl.up(G,N,k) = pPowPnt(G,K) - pPowPnt(G,K-1);
*vLineflow.up(lines,N) =  pLinecapacs(N,lines);


vUP.FX(G,N)$[ORD(N) <= 1 ] = 0;
vDown.FX(G,N)$[ORD(N) <= 1 ] = 0;

* Fix Coal units to their historical status
vU.fx(GCOAL,N) = pUFIX(GCOAL,N);

* Turn off COGEN in this version
vU.fx(GCOGEN,N) = 0;
vPower.fx(GCOGEN,N) = 0;

* Turn off unavailable generators
vU.FX(G,N)$[not pAvail(G)] = 0;


vSU_TYPE.FX(G,SU,N)$[ORD(N) <=1+ pSUtime(G,SU)] = 0;
vSU_TYPE.FX(G,SU,N)$[ORD(N) >= pDownTime(G,SU+1) - Int_Cond (G,'TU') and ORD(N) <= pDownTime(G,SU+1)] = 0;



*$include prior.gms

Model ERCOT includes all equations /all/;
ERCOT.optfile=1;
ERCOT.prioropt= 1;
*option optcr = 0.0000000000001;
*option optcr = 0.01;
ERCOT.savepoint = 2;
execute_loadpoint 'ERCOT_p1';
solve ERCOT using MIP minimizing z ;


****************************************************************************

set Fuel /1*8/;
Parameter pFuelGen(N,Fuel);
pFuelGen(N,Fuel) = sum(G$[pGenData(G,'FuelType') eq Ord(Fuel)], vPower.l(G,N));

set Tech /1*7/;
Parameter pTechGen(N,Tech);
pTechGen(N,Tech) = sum(G$[pGenData(G,'GenType') eq Ord(Tech)], vPower.l(G,N));

Parameter GenZone(zones,N);
GenZone(zones,N) = sum(G$[pGenData(G,'Zone')=ord(zones)],vPower.l(G,N));

Parameter GenCap(zones);
GenCap(zones) =  sum(G$[pGenData(G,'Zone')=ord(zones)],pGenData(G,'Pmax'));
**************************************************************************************************************************************
Parameter
pVOMCost(G,N)
pGenCost(G,N)
pGenSUCost(G,N)
pGenRev(G,N)
pGenNetRev(G,N)
pExpNetRev(G)
pPrice(N)
pPrice2(N)
pCost(G)
pRev(G)
pVARcost(G,N)
pValidN(G,N)
pModelStat
pIMR_Hr(G,N)
pSpread(G,N)
pAVGcost(G,N)
pMCG(G,N)
pMC(N)
pPriceRS10(N)
pPriceRP10(N)
pShortRS10(N)
pShortRP10(N)
;

pMCG(G,N) =0;
pMC(N) =0;

pVARcost(G,N) =0;
pExpNetRev(G)  =0;

pVOMCost(G,N) =  pGenData(G,'VarOM') * vPower.l(G,N);
pGenCost(G,N) =  vGenFuelCost.l(G,N) + pVOMCost(G,N);
pVarCost(G,N) =  0;
pVarCost(G,N)$[floor(vPower.l(G,N)) > 0] =  (pGenCost(G,N)/vPower.l(G,N));

*pGenSUCost(G,N)$[GSURAMP(G)] = sum(SU$[vSU_TYPE.L(G,SU,N) and GSURAMP(G)], pSUcost(G,SU)*vSU_TYPE.L(G,SU,N)/pSUtime(G,SU));
pGenSUCost(G,N) = sum(SU$[vSU_TYPE.L(G,SU,N) and GSURAMP(G)], pSUcost(G,SU)*vSU_TYPE.L(G,SU,N)*vUp.L(G,N));

pMCG(G,N)$[vPower.L(G,N) GT 0] = smin(K$[pwl.l(G,N,K)], pIncrFuelCost(K,G));

pMC(N) = smax(G, pMCG(G,N));


* Get Energy and Reserve
pPrice(N)$[ord(N) >1] = eDemand.m(N);
pPrice2(N)$[ord(N) >1]  = smax(G$[ ceil(vPower.l(G,N)) >= (pGenData(G,'Pmin'))], pVarCost(G,N) )  ;

pPriceRS10(N)$[ord(N) >1]  = eReqSR10.m(N);
pPriceRP10(N)$[ord(N) >1]  = eReqSP10.m(N);

pShortRS10(N)$[ord(N) >1] = sum(J,vRS10_SHORT.L(N,J));
pShortRP10(N)$[ord(N) >1] = sum(J,vRP10_SHORT.L(N,J));


pGenRev(G,N) =  vPower.l(G,N)* pPrice(N)  ;
pGenNetRev(G,N) =  pGenRev(G,N) - pGenCost(G,N);
pValidN(G,N)$[ord(N) >1] = 1;
pValidN(G,N)$[vPower.l(G,N) < pGenData(G,'Pmin') ] = 0 ;
pExpNetRev(G) = sum(N$[pValidN(G,N) = 1], pGenNetRev(G,N));

pIMR_Hr(G,N) = pGenNetRev(G,N)$[pValidN(G,N) = 1];

pAVGcost(G,N) = pVarCost(G,N)$[ ceil(vPower.l(G,N)) >= (pGenData(G,'Pmin')) ];
pSpread(G,N) = pPrice(N) - pAVGcost(G,N) ;

pModelStat = ercot.modelstat;


Parameter pMIPGAP;
pMIPGAP = ercot.objEst - ercot.objVal;

display Z.L, vGenCost.L, vStartupCost.L, vReserveCost.L, vPenaltyCost.L, pGenCost, pGenSUCost, pFuelGen, pTechGen, vPower.l, vRS10.l, vRN10.l, vW.l , vU.l , vUP.l,vDown.l,vSU_TYPE.l,vNse.l,vOverGen.L,pShortRS10, pShortRP10, pAVGcost,pPrice,pPriceRS10,pPriceRP10,vGenFuelCost.l,pVOMCost,pMIPGAP,pModelStat;

execute_unload "results_pmax.gdx" Z.L, vGenCost.L, vStartupCost.L, vReserveCost.L, vPenaltyCost.L, pGenCost, pGenSUCost, pFuelGen, pTechGen, vPower.l, vRS10.l, vRN10.l, vW.l , vU.l , vUP.l,vDown.l,vSU_TYPE.l,vNse.l,vOverGen.L,pShortRS10, pShortRP10, pAVGcost,pPrice,pPriceRS10,pPriceRP10,vGenFuelCost.l,pVOMCost,pMIPGAP,pModelStat;

