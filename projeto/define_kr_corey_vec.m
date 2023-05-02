function [krw, kro] = define_kr_corey_vec(S, Swr, Swor, nw, no, k0w, k0o)
% retorna as permeabilidades relativas de oleo e agua de acordo com Brooks
% e Corey.

% S: saturacao de agua
% Swr: Saturacao residual de agua
% Swor: 1-(saturacao residual de oleo)
% nw: expoente da agua
% no: expoente do oleo
% k0w: permeabilidade relativa maxima de agua
% k0o: permeabilidade relativa maxima de oleo

% krw: permeabilidade relativa da agua
% kro: permeabilidade relativa do oleo

if test_sat_limits(S)
    error('Saturacao fora do intervalo')
end

n = length(S);
krw = zeros(n, 1);
kro = zeros(n, 1);

test3 = S > Swor;
krw(test3) = k0w;

test4 = S < Swr;
kro(test4) = k0o;

test5 = ~(test3 | test4);

swnorm = (S(test5) - Swr)./(Swor - Swr);
krw(test5) = k0w.*(swnorm.^nw);
kro(test5) = k0o.*((1-swnorm).^no);

end