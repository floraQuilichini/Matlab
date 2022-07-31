function [out, header] = extract_data(filename)

% import data 
delimiterIn = ' ';
headerlinesIn = 5;
data = importdata(filename,delimiterIn,headerlinesIn);

% get output and header
out = data.data;
header = data.textdata;

end