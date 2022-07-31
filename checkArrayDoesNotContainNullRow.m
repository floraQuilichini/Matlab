function answer = checkArrayDoesNotContainNullRow(array)
%check that the input array does not contain a zero row vector
%(array are of dimension 1 or 2)

[n, m] = size(array);
s = sum(sum(array==0, 2));
if (s == n)
    answer = 1;
else
    answer = 0;
end

end

