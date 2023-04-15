function [pressure, loop_p] = define_pressure_iteration()
global obj;
global presc;

n = length(obj.x0_press);
continue_pressure = true(1,1);
x_press = myAD(obj.x0_press);

local_p_tol = 100;
loop_p = 0;
residuo = myAD(zeros(n, 1));

while continue_pressure
    loop_p = loop_p + 1;
    result = define_residuo(x_press, residuo, presc);
    J = getderivs(result);
    resp = -getvalue(result);
    dx = J\resp;
    x_press = x_press + dx;
    local_p_tol = max(abs(dx));
    
    if local_p_tol <= obj.p_tol 
        continue_pressure(:) = 0;
    elseif loop_p > obj.max_it_pressure
        error('Divergiu no calculo da pressao');
    end
end

pressure = getvalue(x_press);
    

end