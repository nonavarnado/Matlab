%Global Warming: significance of CO2 emissions in the USA 2019 vs 2020.
%116Lab Final.
%
%co2emissions.m
%Nona Varnado
%June 3, 2020

% extracts data from a txt file using textscan
%open file
file = 'USCO2emissions.txt';
fid = fopen (file);

%read file
cellmat = textscan(fid,'%f %f %f','headerlines', 10);

%close file
fclose(fid);

%extract col1 to be time (in decimal year)
TimeinDeciYr = cellmat{1};

%determine col2 to be MassChange
CO2measure19 = cellmat{2};

%determine col3 to be MassChange
CO2measure20 = cellmat{3};

%plot like the example
plot(TimeinDeciYr, CO2measure19, 'b-');

hold on
plot(TimeinDeciYr,CO2measure20, 'r-');
xlabel('Time (yr)');
ylabel('Emissions(MtCO2/Day)');
title(['US Daily Emissions (MtCO2/Day']);
legend('CO2measure19', 'CO2measure20');

%count number of days for US CO2 emissions < 12 MtCO2/day 2019 
count19 = 0;
    for i=1:length(TimeinDeciYr)
        if CO2measure19(i) < 12
            count19 = count19+1;
        end
    end
    
    %count number of days for US CO2 emissions < 12 MtCO2/day 2020 
count20 = 0;
    for i=1:length(TimeinDeciYr)
        if CO2measure20(i) < 12
            count20 = count20+1;
        end
    end
    
    fprintf('C2019: Found %d days for which the emissions of CO2 were < 12 MtCO2/day \n', count19);
    fprintf('C2020: Found %d days for which the emissions of CO2 were < 12 MtCO2/day \n', count20);

%define the vector of the paired differences
d = CO2measure19 - CO2measure20;
n = length(d);
alpha = 0.01;
dof = n - 1;

tcrit = tinv(1 - alpha, dof);
tstat = mean(d)/(std(d)/sqrt(n));

fprintf('tstat = %.2f > tcrit = %.2f US CO2 emissions have significantly decreased between 2019 and 2020 \n', tstat, tcrit);


