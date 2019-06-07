function[int_cond] = read_int_cond(gdx_file,int_cond,st)

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));

N.name='N';
N.uels = {(1:48)};
N.type='SET';

G.name='G';
G.uels = guel1('g',1:488);
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

lines.name='lines';
lines.uels = {(1:6)};
lines.type='SET';

zones.name='zones';
zones.uels = {(1:4)};
zones.type='SET';

dummygen.name='pbase_gen';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pbase_gen=X.val;
clear dummygen;

dummygen.name='pbase_hour';
dummygen.form='full';
dummygen.uels{1}=G.uels;
dummygen.uels{2}=N.uels;
X=rgdx(gdx_file,dummygen);
pbase_hour=X.val;
clear dummygen;

int_cond(1).commit =  pbase_hour(:,1)';
int_cond(1).gen = pbase_gen(:,1)';

dt =st-hours(1);
dt = array2table(dt');
dt.Properties.VariableNames = {['Datetime']};

int_cond(1).gen = [dt,array2table(int_cond(1).gen )];
int_cond(1).commit = [dt,array2table(int_cond(1).commit )];

end