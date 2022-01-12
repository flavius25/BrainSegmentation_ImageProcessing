% The purpose of this script is to segment the background in the images

% We load in the images to a matlab datastore for easy management
image_store = imageDatastore("Images_greyscale\*.png");

% Showing the background segmentation for all images to spot
% inconsistencies.
validation(image_store, @background_seg);