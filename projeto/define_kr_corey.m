function [krw, kro] = define_kr_corey(S, Swr, Swor, nw, no, k0w, k0o)
% S = saturacao de agua
% krw = permeabilidade relativa da agua
% kro = permeabilidade relativa do óleo

if S > 1 | S < 0
    error('Saturacao fora do intervalo');
elseif S > Swor
    krw = k0w;
    kro = 0;
elseif S < Swr
    krw = 0;
    kro = k0o;
else
    swnorm = (S - Swr)./(Swor - Swr);
    krw = k0w*(swnorm^nw);
    kro = k0o*((1 - swnorm)^no);
end

end