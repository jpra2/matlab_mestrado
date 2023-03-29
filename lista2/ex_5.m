clear all
clc

polinomio = poly([1,2]);
raizes = roots(polinomio);

polinomio = poly([-1,2]);
raizes = roots(polinomio);

polinomio = poly([1i,2i]);
raizes = roots(polinomio);

polinomio = poly([2+1i,-2i]);
raizes = roots(polinomio);
