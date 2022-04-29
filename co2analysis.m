%Global Warming: Analyze 2020 CO2 output decrease in atmosphere concentrations.
%116Lab Final.
%
%co2analysis.m
%Nona Varnado
%June 3, 2020


% extracts data from a txt file using textscan
%open file
file = 'co2_weekly_mlo.txt';
fid = fopen (file);

%read file
cellmat = textscan(fid,'%d %d %d %f %f %d %f %f %f','headerlines', 49);

%close file
fclose(fid);

%extract col1 to be time - but what is time and "since?"
time = cellmat{4};

%determine col2 to be MassChange
co2 = cellmat{5};

%remove -999.99 from the dataset
pos = find(co2 == -999.99);

co2(pos) = [];
time(pos) = [];

%plot to check - yes, it does!


%create the design matrix
n = length(time);
X = [ones(n,1) time time.^2 cos(2*pi/1*time) sin(2*pi*time)];

%fit the curve between datapoints A + B + C + ^2 + D cos() + E sin ()
beta = inv(X'*X)*X'*co2;

%use beta to create trend
trend = beta(1) + beta(2) * time + beta(3) * time.^2;

%use beta to create Seasonal Cycle
seasonal = beta(4) * cos(2*pi/1*time) + beta(5) * sin(2*pi/1*time);

%use beta to create noise
noise = co2 - trend - seasonal;

%plotting demonstration! All the things! 
%Plot in top left corner
subplot(2,2,1);
%plot raw data & model
plot(time,co2, 'r-');

hold on
plot(time, trend + seasonal,'g-');

%enforce common axis limits -Temperature
axis([2018,2021,404,418]);
title('raw data & model');
legend('Measured CO2', 'Model');

%Plot in top right corner
subplot(2,2,2);
%plot trend
plot(time, trend,'r-');
title('trend');

%Plot in bottom left corner
subplot(2,2,3);
%plot seasonal cycle
plot(time, seasonal,'r-');
title('seasonal cycle only');

%Plot in bottom right corner
subplot(2,2,4);
%plot noise
plot(time, noise,'r-');
title('noise');

fprintf('No, it does not look like the ongoing reduction in CO2 emissions has any significant effect on global CO2 concentration.\n');

