function[] = write_initcond(st,gen_hist)

NumGens = 213;

% Read in data for current start time 
TargetDay = datetime(sprintf('2016-%d-%d 00:00 ',st.Month,st.Day));
rowPrev = gen_hist.Var1 >= TargetDay - 1 & gen_hist.Var1 <= (TargetDay - 1 + hours(23)) ;
dayPrev= gen_hist(rowPrev,:);
Status = dayPrev(end,2:end).Variables >0;
mat =  dayPrev(:,2:end).Variables >0;
Up=zeros(1,NumGens);
Down=zeros(1,NumGens);
for n=1:NumGens
    dcount =0;
    ucount =0;
    for m =1:24
        if mat(m,n) >0
            dcount =0;
            ucount = 1+ ucount;
        else
            dcount =dcount +1;
            ucount =0;
        end
    end
    Down(1,n) =dcount;
    Up(1,n) = ucount;
end

% Write initial condition to GDX
Int_C =[Up;Down;Status]'  ;

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));
guel2 = @(s,v) strcat(s,strsplit(num2str(v)));
G.name='G';
G.uels = gen_hist.Properties.VariableNames(2:end) ; 
G.type='SET';

N.name='N';
N.uels = {(1:25)};
N.type='SET';

INT.name='INT';
INT.uels = {'TU','TD','pU'};
INT.type='SET';

Int_Cond.name='Int_Cond';
Int_Cond.type='parameter';
Int_Cond.val=Int_C;
Int_Cond.form='full';
Int_Cond.uels{1}= G.uels;
Int_Cond.uels{2}= INT.uels;
wgdx('Int_Cond',G,INT,Int_Cond);


rowTarget = gen_hist.Var1 >= TargetDay & gen_hist.Var1 <= (TargetDay + hours(24)) ;
dayTarget= gen_hist{rowTarget,2:end};
UFIXdata = double(dayTarget >0);

UFIX.name='UFIX';
UFIX.type='parameter';
UFIX.val=UFIXdata';
UFIX.form='full';
UFIX.uels{1}= G.uels;
UFIX.uels{2}= N.uels;
wgdx('UFIX',G,N,UFIX);

UOFFdata = zeros(NumGens,1);
UOFFflag = sum(double(dayTarget >0));
UOFFdata(81:149) = double(UOFFflag(81:149) == 0);



UOFF.name='UOFF';
UOFF.type='parameter';
UOFF.val=UOFFdata';
UOFF.form='full';
UOFF.uels{1}= G.uels;
wgdx('UOFF',G,N,UOFF);



end
     