%call output_segmentation

%images=load("Images\Images.mat");

%read .png files from Images folder
imagefiles = dir('Images/*.png');      % as example : only png files with "AX_" in the filename
% main loop
for ck = 1:length(imagefiles)
    Filename = imagefiles(ck).name;
    %read the image
    image{ck} = imread(Filename);
    %convert rgb to gray
    image{ck} = rgb2gray(image{ck});
    %convert to double
    image{ck} = im2double(image{ck});

    % plot (t=just to check)
    %figure(ck), imshow(image{ck}); %imagesc only for png, now we converted it
    
    % insert your own code here
    
end

%only for visibility of orientations, later we can move these in the for loop.
%image AX_1
image1 = MySegmentationFunction(image{1});
%image AX_2
image2 = MySegmentationFunction(image{2});
%image AX_3
image3 = MySegmentationFunction(image{3});
%image AX_4
image4 = MySegmentationFunction(image{4});
%image COR_1
image5 = MySegmentationFunction(image{5});
%image COR_2
image6 = MySegmentationFunction(image{6});
%image COR_3
image7 = MySegmentationFunction(image{7});
%image SAG_1
image8 = MySegmentationFunction(image{8});
%image SAG_2
image9 = MySegmentationFunction(image{9});
%image SAG_3
image10 = MySegmentationFunction(image{10});

figure(1)
subplot(2,2,1)
imshow(image1.background);
subplot(2,2,2)
imshow(image2.background);
subplot(2,2,3)
imshow(image3.background);
subplot(2,2,4)
imshow(image4.background);

figure(2)
subplot(2,2,1)
imshow(image5.background);
subplot(2,2,2)
imshow(image6.background);
subplot(2,2,3)
imshow(image7.background);

figure(3)
subplot(2,2,1)
imshow(image8.background);
subplot(2,2,2)
imshow(image9.background);
subplot(2,2,3)
imshow(image10.background);

