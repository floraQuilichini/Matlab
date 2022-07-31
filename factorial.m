function res = factorial(n)
if (n > 1)
	res = n*factorial(n - 1);
else
	res = 1;
end
end

