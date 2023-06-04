function saturation_new = calculate_explicit_sat(vT)

global obj;
calculate = true(1,1);

while calculate
    [saturation_new, recal] = explicit_sat(vT);
    calculate(:) = recal;
    if recal
        obj.dt = obj.dt/2;
    end
end




end