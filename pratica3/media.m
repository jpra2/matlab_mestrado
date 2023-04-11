function y=media(x)
	[m,n] = size(x);
	if m==1
		m=n;
	end
	y = sum(x)/m;
end