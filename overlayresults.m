

images=load_images();

% Calling the segmentation function over all the images
segmentation_out = segment_imgs(images);

% Plotting Axial scans and segmentations
overlayplot(images(1:4),segmentation_out(1:4),"Axial");

% Plotting Saggital scans and segmentations
overlayplot(images(5:7),segmentation_out(5:7),"Coronal");

% Plotting coronal scans and segmentations
overlayplot(images(8:10),segmentation_out(8:10),"Saggital");

%--------------------------------------------------------------------------
function overlayplot(images,segmentations,orientation)
    
    
    im_num = length(images);
    
    montagearray = cell(im_num,2);
    for k=1:im_num
        labels = get_labeld_seg(segmentations{k});
        overlay = labeloverlay(images{k},labels,'Colormap','lines');
        montagearray{k,1} = images{k};
        montagearray{k,2} = overlay;
    end
    
    f = figure("Name",sprintf("%s scans",orientation));
    montage(montagearray,"Size",[2,im_num]);
    exportgraphics(f,sprintf("Results/%s.jpg",orientation))
end

function labeldmatrix =get_labeld_seg(segmentation)
% In this function we compute the label matrix, i.e. a matrix where every
% segmentation has a different integer as label
    
    % Getting the names of our segmentation
    fn = fieldnames(segmentation);
    fieldnum = length(fn);
    
    % preallocating an array for the labels
    labeldmatrix = zeros(size(segmentation.(fn{1})), 'uint16');
    for k =1:fieldnum
    %     Every field gets a unique label
        labeldmatrix(segmentation.(fn{k})) = k;
    end
end




