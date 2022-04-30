%GRACE time variable gravity time series: Greenland ice sheet mass change
%since 2002.
%
%GRACE_timeseries.m
%Nona Varnado
%May 31, 2020

% extracts data from a txt file using textscan
%open file
file = 'Greenland_GRACE_TimeSeries.txt';
fid = fopen (file);

%read file
cellmat = textscan(fid,'%f %f','headerlines', 1);

%close file
fclose(fid);

%extract col1 to be time - but what is time and "since?"
DaysSince2002 = cellmat{1};

%determine col2 to be MassChange
MassChange = cellmat{2};

%plot DaysSince2002 and MassChange - original
plot(DaysSince2002,MassChange);

%use polynomial fit to detrend the time-series. Poly degree1, assign
%slope(m) and intercept(p) to variables.
y = MassChange;
p = polyfit(DaysSince2002,y,1);
m = polyval(p,DaysSince2002);

%detrend data
y_prime = y - m;

%plot y_prime detrended
plot(DaysSince2002,y_prime);

%plot m (slope)
plot(DaysSince2002,m);

%construct the design matrix
n = length(y);
X = [cos(2*pi*DaysSince2002/365) sin(2*pi*DaysSince2002/365)];

%Find coefficients (A,B)
beta = inv(X'*X)*X'*y_prime;

%Seasonal Cycle
A = beta(1); 
B = beta (2);
s = A*cos(2*pi*DaysSince2002/365) + B*sin(2*pi*DaysSince2002/365);

%plot s
plot(DaysSince2002, s);

%calculate residuals
residuals = y_prime - X*beta;

%calculate the Root-Mean-Square error (RMS)
RMS = sqrt(mean(residuals.^2));

%plot the results: original, detrended and seasonal fit on one plot
plot(DaysSince2002,MassChange, 'b--');
hold on

plot(DaysSince2002,y_prime, 'g--');
hold on

plot(DaysSince2002, s, 'r--');

%label the plot 
ylabel('Mass Change (cmWE)');
xlabel('Days Since January 1, 2002');
title('GRACE time-series for Greenland (66.5''N 308.5''E) Ice Mass Change');
legend('Original time-series', 'Detrended time-series', 'Seasonal Fit');
%print the fit parameters
fprintf('Seasonal Signal\n');
fprintf('Cosine Coefficient: %.2f cmWE\n', A);
fprintf('Sine Coefficient:    %.2f cmWE\n', B);
fprintf('Linear Trend:      \n');
fprintf('Slope:              %.2f cmWE\n', p(1));
fprintf('Intercept:          %.2f cmWE\n', p(2));
fprintf('RMS:                 %.2f cmWE\n', RMS);




