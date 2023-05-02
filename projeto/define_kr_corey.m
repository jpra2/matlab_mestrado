function [krw, kro] = define_kr_corey(S, Swr, Swor, nw, no, k0w, k0o)
% calcula as permeabilidades relativas de agua e oleo localmente
% S: saturacao de agua
% Swr: Saturacao residual de agua
% Swor: 1-(saturacao residual de oleo)
% nw: expoente da agua
% no: expoente do oleo
% k0w: permeabilidade relativa maxima de agua
% k0o: permeabilidade relativa maxima de oleo

% krw: permeabilidade relativa da agua
% kro: permeabilidade relativa do oleo

if S > Swor
    krw = k0w;
    kro = 0;
elseif S < Swr
    krw = 0;
    kro = k0o;
else
    swnorm = (S - Swr)./(Swor - Swr);
    krw = k0w.*(swnorm.^nw);
    kro = k0o.*((1 - swnorm).^no);
end

end