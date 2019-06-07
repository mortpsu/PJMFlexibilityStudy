
Table pGenData(G,GEN_PARAMS)
      GenType  HRType  AvgHR  Fprice  VarOM  Pmax  Pmin  MINUP  MINDOWN  Zone  FuelType  Ramp  AvgOpCost
g1
;
$gdxin GenData.gdx
$loaddcm  pGenData = GenData
$gdxin

Scalar pVarOMincr  /0.5/;

* Make the cost of Pearsall ICs not identical
pGenData('g220','VarOM') = pGenData('g219','VarOM') + pVarOMincr;
pGenData('g221','VarOM') = pGenData('g220','VarOM') + pVarOMincr;
pGenData('g222','VarOM') = pGenData('g221','VarOM') + pVarOMincr;
pGenData('g223','VarOM') = pGenData('g222','VarOM') + pVarOMincr;
pGenData('g224','VarOM') = pGenData('g223','VarOM') + pVarOMincr;
pGenData('g225','VarOM') = pGenData('g224','VarOM') + pVarOMincr;
pGenData('g226','VarOM') = pGenData('g225','VarOM') + pVarOMincr;
pGenData('g227','VarOM') = pGenData('g226','VarOM') + pVarOMincr;
pGenData('g228','VarOM') = pGenData('g227','VarOM') + pVarOMincr;
pGenData('g229','VarOM') = pGenData('g228','VarOM') + pVarOMincr;
pGenData('g230','VarOM') = pGenData('g229','VarOM') + pVarOMincr;

* Make the cost of Power Lane ICs not identical
pGenData('g232','VarOM') = pGenData('g231','VarOM') + pVarOMincr;
pGenData('g233','VarOM') = pGenData('g232','VarOM') + pVarOMincr;


* Make the cost of Red Gate ICs not identical
pGenData('g235','VarOM') = pGenData('g234','VarOM') + pVarOMincr;
pGenData('g236','VarOM') = pGenData('g235','VarOM') + pVarOMincr;
pGenData('g237','VarOM') = pGenData('g236','VarOM') + pVarOMincr;
pGenData('g238','VarOM') = pGenData('g237','VarOM') + pVarOMincr;
pGenData('g239','VarOM') = pGenData('g238','VarOM') + pVarOMincr;
pGenData('g240','VarOM') = pGenData('g239','VarOM') + pVarOMincr;
pGenData('g241','VarOM') = pGenData('g240','VarOM') + pVarOMincr;
pGenData('g242','VarOM') = pGenData('g241','VarOM') + pVarOMincr;
pGenData('g243','VarOM') = pGenData('g242','VarOM') + pVarOMincr;
pGenData('g244','VarOM') = pGenData('g243','VarOM') + pVarOMincr;
pGenData('g245','VarOM') = pGenData('g244','VarOM') + pVarOMincr;

Parameter pTurnDown (g);
$gdxin TurnDown.gdx
$loaddcm  pTurnDown = TurnDown
$gdxin

Parameter pAvail (g);
$gdxin Avail.gdx
$loaddcm  pAvail = Avail
$gdxin

Parameter pUOFF (g);
$gdxin UOFF.gdx
$loaddcm  pUOFF = UOFF
$gdxin


Table pTrajectory(G,SU,L)
                 L1        L2         L3        L4        L5        L6
g1.SU1
g1.SU2
g1.SU3
;
$gdxin Trajectory.gdx
$loaddcm  pTrajectory = Trajectory
$gdxin


Table pGShut(G,L)
                 L1        L2
g1
;
$gdxin GShut.gdx
$loaddcm  pGShut = GShut
$gdxin

Table pDownTime(G,SU)
                  SU1       SU2       SU3
g1
;
$gdxin DownTime.gdx
$loaddcm  pDownTime = DownTime
$gdxin


Table pSUcost(G,SU)
                  SU1       SU2       SU3
g1
;
$gdxin StartupCost.gdx
$loaddcm  pSUcost = StartupCost
$gdxin


Table pSUTime(G,SU)
                  SU1       SU2       SU3
g1
;
$gdxin StartupTime.gdx
$loaddcm  pSUTime = StartupTime
$gdxin





table pPowPnt(G,k)
          k0        k1        k2        k3        k4
g1
;

$gdxin PowPnt.gdx
$loaddcm  pPowPnt = PowPnt
$gdxin


table pIHR(G,K)
                 k0                  k1                  k2                  k3                  k4
g1
;

$gdxin IHR.gdx
$loaddcm  pIHR = IHR
$gdxin


SET INT /TU,TD,pU/
;
Table Int_Cond(G,Int)
             TU          TD          pU
g1
;

$gdxin Int_Cond.gdx
$loaddcm  Int_Cond =Int_Cond
$gdxin

display Int_Cond ;

$ontext
SET TS /GrossLoad, WindGen, PVGen, NucGen, NetLoad, DispGen, Resid, Cogen,NetLoad2 /;
Table pTimeSeries(N,TS)
        GrossLoad    WindGen    PVGen    NucGen    NetLoad    DispGen    Resid    Cogen   NetLoad2
1
;

*$gdxin TimeSeries.gdx
*$loaddcm  pTimeSeries =TimeSeries
*$gdxin

$offtext

Parameter pDemandInput(N);

$gdxin Demand.gdx
$loaddcm  pDemandInput =Demand
$gdxin


Table pUFIX(G,N)
  1   2   3   4   5   6   7   8   9   10  11 12 13 14 15 16 17 18 19 20 21 22 23 24
g1
;

$gdxin UFIX.gdx
$loaddcm  pUFIX =UFIX
$gdxin



Parameter pLinesources(lines)
/
1        1
2        1
3        3
4        4
5        1
6        2
/;

Parameter pLinesinks(lines)
/
1        2
2        4
3        1
4        1
5        3
6        1
/;

Table pLinecapacs(N,lines)
             1              2              3              4                 5              6
1        3194.511        703.833        583.738        1028.187        1412.608        3194.511
2        3203.407        825.823        660.690        952.047        1421.081        3203.407
3        3207.766        828.224        708.262        907.649        1421.221        3207.766
4        3213.789        816.047        654.396        962.796        1429.729        3213.789
5        3222.921        873.854        726.361        1017.586        1431.732        3222.921
6        3226.964        807.881        701.383        1033.032        1435.273        3226.964
7        3240.839        702.733        695.273        1044.669        1437.233        3240.839
8        3242.230        746.806        627.127        1048.822        1450.291        3242.230
9        3280.441        759.770        670.243        1074.507        1456.363        3280.441
10        3245.753        769.067        736.598        1120.318        1445.740        3245.753
11        3216.640        820.019        686.195        1109.741        1434.051        3216.640
12        3194.070        814.202        617.873        1090.069        1423.836        3194.070
13        3167.620        729.060        534.500        1153.320        1413.500        3167.620
14        3144.020        738.640        466.800        1132.400        1404.200        3144.020
15        3129.715        756.172        416.026        1081.776        1392.184        3129.715
16        3138.300        754.727        364.658        1031.049        1383.584        3138.300
17        3124.586        752.300        341.463        1027.014        1377.714        3124.586
18        3123.321        758.227        335.052        1043.084        1379.762        3123.321
19        3128.900        761.700        333.500        1048.700        1382.200        3128.900
20        3134.287        766.127        332.380        1063.687        1388.440        3134.287
21        3150.498        789.568        363.461        1091.891        1399.594        3150.498
22        3164.546        826.784        412.124        1056.530        1406.768        3164.546
23        3170.638        851.782        441.131        1022.052        1413.731        3170.638
24        3175.871        872.227        501.937        963.343        1418.659        3175.871
25        3196.757        916.286        582.312        892.788        1421.089        3196.757
$ontext
26        3211.200        916.674        491.622        822.675        1423.114        3211.200
27        3214.685        914.575        644.607        809.725        1428.086        3214.685
28        3220.377        894.750        721.077        838.468        1430.178        3220.377
29        3220.230        900.490        719.271        868.251        1472.681        3220.230
30        3217.897        911.339        666.477        920.341        1476.467        3217.897
31        3230.583        897.601        662.479        964.548        1431.342        3230.583
32        3237.303        885.574        728.456        990.216        1431.466        3237.303
33        3248.762        853.755        797.133        1028.107        1432.725        3248.762
34        3241.560        835.760        764.720        1030.940        1428.660        3241.560
35        3203.056        864.044        684.916        987.984        1415.933        3203.056
36        3181.463        906.436        606.887        910.953        1407.707        3181.463
37        3157.600        911.900        543.600        860.600        1406.600        3157.600
38        3137.205        878.629        499.306        927.699        1396.784        3137.205
39        3143.236        843.282        443.882        968.613        1390.287        3143.236
40        3096.158        804.195        404.714        1024.363        1370.021        3096.158
41        3142.300        803.300        371.500        981.900        1355.900        3142.300
42        3127.480        816.315        328.750        962.710        1343.360        3127.480
43        3120.460        735.967        327.280        1009.973        1334.120        3120.460
44        3144.386        712.219        336.614        1040.047        1351.917        3144.386
45        3148.162        679.655        353.433        1050.294        1367.155        3148.162
46        3163.671        719.012        429.866        993.908        1389.721        3163.671
47        3179.511        759.525        472.869        987.110        1399.438        3179.511
48        3193.739        842.894        547.511        955.470        1409.246        3193.739
$offtext
;

Parameter  pLinelimit(lines)
/
1 3500
2 1500
3 1500
4 1500
5 1500
6 3350
/;
