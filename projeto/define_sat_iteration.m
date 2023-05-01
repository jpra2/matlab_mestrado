function [saturation, loop_sat] = define_sat_iteration()
% retorna a saturacao e a quantidade de iteracoes

global obj;
global presc_sat;

n = length(obj.x0_sat);
continue_sat = true(1,1);
loop_sat = 0;
local_sat_tol = 100;
local_sat_tol_ant = 0;

local_loop_sat = 0;
loop_test_limits = 0;
max_loop_test_limits = 3;

x_sat = myAD(obj.x0_sat);
dt_obj = obj.dt;

while continue_sat
    residuo = myAD(zeros(n, 1));
%     result = define_residuo_sat(x_sat, residuo, presc_sat);
    result = define_residuo_sat_2(x_sat, residuo, presc_sat);
    J = getderivs(result);
    resp = -getvalue(result);
    ds = J\resp;
    x_sat = x_sat + ds;
%     local_sat_tol = norm(ds);
    local_sat_tol = max(abs(ds));
    disp(local_sat_tol);
    
    if loop_sat > obj.max_it_sat
        continue_sat = 0;
        error('Divergiu no calculo da saturacao');
    end
    
    if local_sat_tol > local_sat_tol_ant + obj.delta_for_local_sat_tolerance
        local_loop_sat = 0;
        x_sat = myAD(obj.x0_sat);
        reduce_dt();
        loop_sat = loop_sat + 1;
        local_loop_sat = local_loop_sat + 1;
        local_sat_tol_ant = local_sat_tol;
        continue;
        
    elseif local_loop_sat > obj.max_it_for_local_loop_sat
        local_loop_sat = 0;
        x_sat = myAD(obj.x0_sat);
        reduce_dt();
        loop_sat = loop_sat + 1;
        local_loop_sat = local_loop_sat + 1;
        local_sat_tol_ant = local_sat_tol;
        continue;
        
    end
    
%     if test_sat_limits(getvalue(x_sat)) && (loop_test_limits < max_loop_test_limits)
%         % saturacao fora dos intervalos
%         loop_test_limits = loop_test_limits + 1;
%         continue_sat(:) = 1;    
    if local_sat_tol < obj.sat_tol
        % convergiu
        if test_sat_limits(getvalue(x_sat)) && (loop_test_limits < max_loop_test_limits)
            % mais 3 iteracoes para ajustar a saturacao nos limites
            loop_test_limits = loop_test_limits + 1;
        else
            continue_sat(:) = 0;
        end
    end
    loop_sat = loop_sat + 1;
    local_loop_sat = local_loop_sat + 1;
    local_sat_tol_ant = local_sat_tol;
    
end

saturation = getvalue(x_sat);

if test_sat_limits(saturation)
    saturation(saturation < obj.Swr) = obj.Swr;
    saturation(saturation > obj.Swor) = obj.Swor;
    
end


% if test_sat_limits(saturation)
%     global gresp;
%     n_sat = size(gresp.all_saturations);
%     gresp.all_pressures(n_sat(1),:) = obj.x0_press;
%     gresp.all_pressures(n_sat(1)+1,:) = gresp.all_pressures(n_sat(1),:);
%     gresp.all_saturations(n_sat(1)+1,:) = saturation;
%     
%     gresp.all_dt(n_sat(1)+1) = obj.dt;
%     gresp.all_times(n_sat(1)+1) = 0;
%     gresp.sat_iterations(n_sat(1)+1) = loop_sat;
%     gresp.all_vpi(n_sat(1)+1) = 0;
%     gresp.cumulative_oil_prod(n_sat(1)+1) = 0;
%     gresp.all_wor_ratio(n_sat(1)+1) = 0;
%     gresp.all_qo_flux(n_sat(1)+1) = 0;
%     gresp.qw_volumes(n_sat(1)+1,:) = 0;
%     
%     save('dados/resp.mat', '-struct', 'gresp');
%     error('Saturacao fora do intervalo');
% end
% 
% % saturation(saturation < obj.Swr) = obj.Swr;

end