function [krw, kro] = define_kr_corey_vec(S, Swr, Swor, nw, no, k0w, k0o)
% S = saturacao de agua
% krw = permeabilidade relativa da agua
% kro = permeabilidade relativa do óleo

test1 = S > 1;
test2 = S < 0;
if sum(test1) > 0 | sum(test2) > 0
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