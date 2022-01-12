% This is the main script calling the segmentation function for all the
% images. 
% -------------------------------------------------------------------------


images=load_images();

% Calling the segmentation function over all the images
segmentation_out = segment_imgs(images);

% Plotting Axial scans and segmentations
tileplot(images(1:4),segmentation_out(1:4),"Axial");

% Plotting Saggital scans and segmentations
tileplot(images(5:7),segmentation_out(5:7),"Coronal");

% Plotting coronal scans and segmentations
tileplot(images(8:10),segmentation_out(8:10),"Saggital");

%--------------------------------------------------------------------------

function tileplot(images, segmentations, orientation)
% This function helps with visualising the output fields of the
% segmentation function. 

fn = fieldnames(segmentations{1}); % The names of the segmentations we did
field_num = numel(fn); % the count of these categories
im_num = length(images); % The number of images we plot in this tile.
c=1; % counter for tracking the subplot index.
figure("Name",sprintf("%s scans",orientation))


for k=1:im_num
    % Plotting the original image
    subplot(im_num,field_num+1,c)
    imshow(images{k});
    title('Input image')

    % Plotting the images stored in the output fields.
    for j=1:field_num
        subplot(im_num,field_num+1,c+j)
        imshow(segmentations{k}.(fn{j}));
        title(sprintf('%s',fn{j})) % formatting figure label using field name
    end
    c=c+field_num+1;
end

end

