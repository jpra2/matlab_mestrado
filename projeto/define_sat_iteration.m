function [saturation, loop_sat] = define_sat_iteration()
% retorna a saturacao e a quantidade de iteracoes

global obj;
global presc_sat;

n = length(obj.x0_sat);
continue_sat = true(1,1);
loop_sat = 0;
local_sat_tol = 100;

x_sat = myAD(obj.x0_sat);
while continue_sat
    residuo = myAD(zeros(n, 1));
    result = define_residuo_sat(x_sat, residuo, presc_sat);
    J = getderivs(result);
    resp = -getvalue(result);
    ds = J\resp;
    x_sat = x_sat + ds;
    local_sat_tol = norm(ds);
    
    if local_sat_tol <= obj.sat_tol
        continue_sat = 0;    
    elseif loop_sat > obj.max_it_sat
        continue_sat = 0;
        error('Divergiu no calculo da saturacao');
    end
    loop_sat = loop_sat + 1;
    
end

saturation = getvalue(x_sat);

end