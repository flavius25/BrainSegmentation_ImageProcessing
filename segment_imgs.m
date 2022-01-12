function segmentation_out = segment_imgs(images)
%SEGMENT_ALL_IMGS Calls the segmentation function on all images of the
%argument and returns the result.

segmentation_out = cell([length(images),1]);
for k = 1:length(images)
    % Executing segmentations and storing results
    segmentation_out{k} = BrainSegmentationFunction(images{k});
end

end

