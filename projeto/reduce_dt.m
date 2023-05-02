function reduce_dt()
% reduz o passo de tempo da simulacao pela metade caso demore a convergir

global obj;
obj.dt = 0.5*obj.dt;
disp('DT OBJ DIMINUIU!!!!!!!!!!!');
disp(obj.dt);
end