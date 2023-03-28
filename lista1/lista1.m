clear all
clc

% 1

x = p(20^0)
x = f(1)
x = g(sqrt(3)/2)

% 2
x = f2_1(1/4)
x = f2_1(1/3)

x = f2_2(pi/4)
x = f2_2(pi/6)

% 3
x = [0.7 1/4 0.25 1/7 1.85 -1.13]
round(x)
ceil(x)
floor(x)
fix(x)

% 4
x = 2:0.02:7;
f4_1(x)
x = linspace(-4, -1, 31)
f4_2(x)


% 1
function y = p(x)
    y = cos(x);
end

function y = f(x)
    y = atan(x);
end

function y = g(x)
    y = cos(asin(x));
end

% 2
function y = f2_1(x)
    y = log(2*x + sqrt(2*(x^3) + 1));
end

function y = f2_2(x)
    y = (2*x)/((x+1)*tan(x));
end

% 4
function y = f4_1(x)
    y = x./((x+1)./(x.^3));
end

function y = f4_2(x)
    y = 1./(x.^3) + 2./(3 + x) + 1./(x.^2);
end

