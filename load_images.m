function images = load_images()

% We start by loading the images
imageds = imageDatastore("Images\*.png");
images = readall(imageds);
% Converting to proper data type
for k=1:length(images)
    images{k} = im2double(im2gray(images{k}));
end

end

