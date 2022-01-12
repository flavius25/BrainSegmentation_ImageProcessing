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

    %plot (t=just to check)
%     figure(ck), imshow(image{ck}); %imagesc only for png, now we converted it
    
    % insert your own code here
    
end


%image AX_1
image1 = BrainSegmentationFunction(image{1});
%image AX_2
image2 = BrainSegmentationFunction(image{2});
%image AX_3
image3 = BrainSegmentationFunction(image{3});
%image AX_4
image4 = BrainSegmentationFunction(image{4});
%image COR_1
image5 = BrainSegmentationFunction(image{5});
%image COR_2
image6 = BrainSegmentationFunction(image{6});
%image COR_3
image7 = BrainSegmentationFunction(image{7});
%image SAG_1
image8 = BrainSegmentationFunction(image{8});
%image SAG_2
image9 = BrainSegmentationFunction(image{9});
%image SAG_3
image10 = BrainSegmentationFunction(image{10});

% % matlab2019b
% tlo=tiledlayout(4,5,'TileSpacing','none','Padding','none');
% for i = 1:4
% Segments = BrainSegmentationFunction(image{i});
% 
% nextTile,imshow(image{i})
% nextTile,imshow(Segments.background)
% nextTile,imshow(Segments.CF)
% nextTile,imshow(Segments.WM)
% nextTile,imshow(Segments.GM)    
% end
% set(tlo.Children,'XTick',[], 'YTick', []);



figure(101)
subplot(4,6,1)
imshow(image{1});
title('Input image')
subplot(4,6,2)
imshow(image1.background);
title('Background')
subplot(4,6,3)
imshow(image1.skull);
title('Skull')
subplot(4,6,4)
imshow(image1.CF);
title('Cerebrospinal fluid')
subplot(4,6,5)
imshow(image1.WM);
title('White Matter')
subplot(4,6,6)
imshow(image1.GM);
title('Grey Matter')
subplot(4,6,7)
imshow(image{2});
subplot(4,6,8)
imshow(image2.background);
subplot(4,6,9)
imshow(image2.skull);
subplot(4,6,10)
imshow(image2.CF);
subplot(4,6,11)
imshow(image2.WM);
subplot(4,6,12)
imshow(image2.GM);
subplot(4,6,13)
imshow(image{3});
subplot(4,6,14)
imshow(image3.background);
subplot(4,6,15)
imshow(image3.skull);
subplot(4,6,16)
imshow(image3.CF);
subplot(4,6,17)
imshow(image3.WM);
subplot(4,6,18)
imshow(image3.GM);
subplot(4,6,19)
imshow(image{4});
subplot(4,6,20)
imshow(image4.background);
subplot(4,6,21)
imshow(image4.skull);
subplot(4,6,22)
imshow(image4.CF);
subplot(4,6,23)
imshow(image4.WM);
subplot(4,6,24)
imshow(image4.GM);

figure(102)
subplot(3,6,1)
imshow(image{5});
title('Input image')
subplot(3,6,2)
imshow(image5.background);
title('Background')
subplot(3,6,3)
imshow(image5.skull);
title('Skull')
subplot(3,6,4)
imshow(image5.CF);
title('Cerebrospinal fluid')
subplot(3,6,5)
imshow(image5.WM);
title('White Matter')
subplot(3,6,6)
imshow(image5.GM);
title('Gray Matter')
subplot(3,6,7)
imshow(image{6});
subplot(3,6,8)
imshow(image6.background);
subplot(3,6,9)
imshow(image6.skull);
subplot(3,6,10)
imshow(image6.CF);
subplot(3,6,11)
imshow(image6.WM);
subplot(3,6,12)
imshow(image6.GM);
subplot(3,6,13)
imshow(image{7});
subplot(3,6,14)
imshow(image7.background);
subplot(3,6,15)
imshow(image7.skull);
subplot(3,6,16)
imshow(image7.CF);
subplot(3,6,17)
imshow(image7.WM);
subplot(3,6,18)
imshow(image7.GM);

figure(103)
subplot(3,6,1)
imshow(image{8});
title('Input image')
subplot(3,6,2)
imshow(image8.background);
title('Background')
subplot(3,6,3)
imshow(image8.skull);
title('Skull')
subplot(3,6,4)
imshow(image8.CF);
title('Cerebrospinal fluid')
subplot(3,6,5)
imshow(image8.WM);
title('White Matter')
subplot(3,6,6)
imshow(image8.GM);
title('Grey Matter')
subplot(3,6,7)
imshow(image{9});
subplot(3,6,8)
imshow(image9.background);
subplot(3,6,9)
imshow(image9.skull);
subplot(3,6,10)
imshow(image9.CF);
subplot(3,6,11)
imshow(image9.WM);
subplot(3,6,12)
imshow(image9.GM);
subplot(3,6,13)
imshow(image{10});
subplot(3,6,14)
imshow(image10.background);
subplot(3,6,15)
imshow(image10.skull);
subplot(3,6,16)
imshow(image10.CF);
subplot(3,6,17)
imshow(image10.WM);
subplot(3,6,18)
imshow(image10.GM);

