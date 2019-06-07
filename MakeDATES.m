% Make vector of 2016 datetimes

Jan1 = datetime(2016,1,1,0,0,0);


DATES(1:8784,1) = Jan1;

for i=2:8784
   DATES(i) = DATES(i-1) + 1/24;  
end

