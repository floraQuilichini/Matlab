function [data, nb_bits_for_coding] = rle(x)
% data = rle(x) (de)compresses the data with the RLE-Algorithm
%   Compression:
%      if x is a numbervector data{1} contains the values
%      and data{2} contains the run lenths
%
%   Decompression:
%      if x is a cell array, data contains the uncompressed values
%
%      Version 1.0 by Stefan Eireiner (<a href="mailto:stefan-e@web.de?subject=rle">stefan-e@web.de</a>)
%      based on Code by Peter J. Acklam
%      last change 14.05.2004
if iscell(x) % decoding
    nb_bits_for_coding = 2*32 + 1 + length(dec2bin(max(x{2})))*length(x{2});
    
	i = cumsum([ 1 x{2} ]);
	j = zeros(1, i(end)-1);
	j(i(1:end-1)) = 1;
    l = length(i);
    if x{1}
        motif = [1 , 0];
    else
        motif = [0, 1];
    end
    symbols = repmat(motif, 1, fix(l/2.0));
    if mod(l, 2)
        symbols = [symbols, x{1}];
    end
        
	data = symbols(cumsum(j));
else % encoding
	if size(x,1) > size(x,2), x = x'; end % if x is a column vector, tronspose
    i = [ find(x(1:end-1) ~= x(2:end)) length(x) ];
	data{2} = diff([ 0 i ]);
	data{1} = x(1);
    nb_bits_for_coding = 2*32 + 1 + length(dec2bin(max(data{2})))*length(data{2});
end

