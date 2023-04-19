clear all;
clc;

x = linspace(-4,4);
n = length(x);
fx = zeros(n,1);
for i =1:n
    if x(i)>=0 && x(i)<=1
        fx(i) = f1(x(i));
    elseif x(i)>1 && x(i)<2
        fx(i) = f2(x(i));
    end
end
plot(x,fx)

function f = f1(x)
    f = x;
end

function f = f2(x)
    f = 2-x;
end