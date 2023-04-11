function [mean,stdev] = mediaedesvio(x)
	[m,n] = size(x);
	if  m==1
		m=n;
	end
	mean = sum(x)/m;
	stdev = sqrt(sum(x .^ 2)/m - mean .^ 2);
end