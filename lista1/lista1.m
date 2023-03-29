clear all
clc

% 1
x = 20^0;
p = cos(x);

x=1;
f = atan(x);

x = sqrt(3)/2;
g = cos(asin(x));

% 2
x = 1/4;
y = log(2*x + sqrt(2*(x^3) + 1));

x = 1/3;
y = log(2*x + sqrt(2*(x^3) + 1));

x = pi/4;
y = (2*x)/((x+1)*tan(x));

x = pi/6;
y = (2*x)/((x+1)*tan(x));

% 3
x = [0.7 1/4 0.25 1/7 1.85 -1.13];
round(x)
ceil(x)
floor(x)
fix(x)

% 4
x = 2:0.02:7;
y = x./((x+1)./(x.^3));

x = linspace(-4, -1, 31);
y = 1./(x.^3) + 2./(3 + x) + 1./(x.^2);