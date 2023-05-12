function resp = test_sat_limits(S)
% funcao para testar os limites de saturacao (fins de debug). Se os limites
% forem ultrapassados a funcao retorna true.

global obj;
global presc_sat;

resp = false(1,1);

[c, ia] = ismember(obj.volumes, presc_sat.volumes_saturation_defined);
c = ~c;

S_2 = S(c);

test1 = S_2 > obj.Swor;
test2 = S_2 < obj.Swr;

s1 = sum(test1);
s2 = sum(test2);

if s1 > 0 | s2 > 0
    resp(:) = 1;
end

end