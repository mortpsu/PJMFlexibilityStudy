function [] = write_gcc_set(j)

guel1 = @(s,v) strcat(s,strsplit(num2str(v)));

if j == 1
    ses = [262];
elseif j ==2
    ses = [262,263];
elseif j ==3
    ses = [224];
elseif j ==4
    ses = [224,225];
elseif j ==5
    ses = [262,263,224,225];
elseif j ==6
    ses = [228];
elseif j ==7
    ses = [109];
elseif j ==8
    ses = [237];
elseif j ==9
    ses = [228,109,237];
elseif j ==10
    ses = [242];
elseif j ==11
    ses = [242,243];
else
    ses = [];
end

if j==0
    ses = [262,263,224,225,228,109,237,242,243];
end

GCC.name='GCC';
GCC.uels = guel1('G',ses);
GCC.type='SET';

wgdx('GCC_set',GCC);
end