clear all;
clc;

x=-1:.001:2;
xz1=fzero(@humps,0);
xz2=fzero(@humps,1);

plot(x,humps(x),xz1,humps(xz1),'*', xz2, humps(xz2),'+')	
grid

