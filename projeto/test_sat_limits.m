function resp = test_sat_limits(S)
global obj;

resp = false(1,1);

test1 = S > obj.Swor;
test2 = S < obj.Swr;

s1 = sum(test1);
s2 = sum(test2);

if s1 > 0 | s2 > 0
    resp(:) = 1;
end

end