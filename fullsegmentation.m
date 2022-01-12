function [s] = fullsegmentation(img)
%FULLSEGMENTATION This function returns the segmented brain regions from a
%greyscale MRI image 
%   The segmented regions (background, skull, white matter, grey matter, CSF, other) 
%   are returned as fields of the output argument in the form of binary
%   images.
s.background = simplebackground(img);
s.skull = skull_seg(img, s.background);

% Keep adding fields for the other segmentations
end

