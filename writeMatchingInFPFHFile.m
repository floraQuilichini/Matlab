function writeMatchingInFPFHFile(fpfh_file, index_matching_vector)
% function that writes index matching for fpfh file into the fpfh binary files

[~, ~, ext] = fileparts(fpfh_file);
if ~strcmp(ext, '.bin')
    error("you must write into a binary file; check the extension");
end

fileID = fopen(fpfh_file, 'a');
fwrite(fileID, index_matching_vector,'uint');
fclose(fileID);


end

