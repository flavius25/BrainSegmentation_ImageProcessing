% Initialization steps.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 18;

grayImage=imread('Images\AX_2.png');
grayImage = rgb2gray(grayImage);
%grayImage = im2double(grayImage);

%figure(120)
% %filter the image 
% DoS = 1000; %degree of smoothing
% grayImage = imbilatfilt(grayImage,DoS);
% imshow(grayImage,[])


figure(100)
[pixelCounts, grayLevels] = imhist(grayImage);
pixelCounts(1)=0
faceColor = [0, 60, 190]/255; % Our custom color - a bluish color.
bar(grayLevels, pixelCounts, 'BarWidth', 1, 'FaceColor', faceColor);
% Find the last gray level and set up the x axis to be that range.
% lastGL = find(pixelCounts>0, 1, 'last');
% xlim([0, lastGL]);
grid on;
% Set up tick marks every 50 gray levels.
% ax = gca;
% ax.XTick = 0 : 50 : lastGL;
title('Histogram of Non-Black Pixels', 'FontSize', fontSize, 'Interpreter', 'None', 'Color', faceColor);
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Counts', 'FontSize', fontSize);

figure(1)
subplot(2, 2, 1)
imshow(grayImage); 
axis('on', 'image');
impixelinfo;
title('Original Image', 'FontSize', fontSize);
lowThreshold = 20;
highThreshold = 255;
% Interactive threshold using Image Analyst's utility.
% https://www.mathworks.com/matlabcentral/fileexchange/29372-thresholding-an-image?s_tid=srchtitle
% [lowThreshold, highThreshold] = threshold(lowThreshold, highThreshold, grayImage)
mask = grayImage >= lowThreshold & grayImage <= highThreshold;
% Don't let top of skull touch top edge of image.
mask(1, :) = false;

% figure(120)
% grayImage = imgradient(grayImage,'sobel');
% imshow(grayImage,[])
% 
% %find edge using canny filter
% figure(130)
% grayImage = edge(grayImage,'Canny',[0 0.15]); %compared this with 'prewitt' filter and this one was much better
% imshow(grayImage,[])

subplot(2, 2, 2)
imshow(mask); 
title('Initial Mask Image', 'FontSize', fontSize);



% Erode the mask some
radius = 33;
se = strel('disk', radius);
mask = imfill(mask, 'holes'); %we do that to unify underlying skull discontinuities.
mask = imerode(mask, se);
% radius_dil = 60;
% se_dil = strel('disk', radius_dil);
% mask = imdilate(mask, se_dil);
% Don't erase face and neck.
%mask(913:end, 1:1200) = true;
%mask = imfill(mask, 'holes'); %we do that to unify underlying skull discontinuities.
subplot(2, 2, 3)
imshow(mask); 
title('Final Mask Image', 'FontSize', fontSize);
% 
% labeledImage = bwlabel(grayImage);		% Assign label ID numbers to all blobs.
% grayImage = ismember(labeledImage, 1);	% Use ismember() to extract blob #1.
% % Thicken it a little with imdilate().
% grayImage = imdilate(grayImage, true(5));

% Mask out the skull from the original gray scale image.
skullFreeImage = grayImage; % Initialize
skullFreeImage(mask) = 0; % Mask out
subplot(2, 2, 4)
imshow(skullFreeImage, []);
title('Final Gray Scale Image', 'FontSize', fontSize);

g = gcf;
g.WindowState = 'maximized'


figure(2)
% Erase gray image
grayImage(~mask) = 0;
%grayImage = grayImage - mask;
imshow(grayImage); 




figure(3)
% background = background_seg(grayImage);
% grayImage(background) = 0;
simplethresh = imbinarize(grayImage);

% simplethresh = im2double(simplethresh)

% radius = 8;
% se_levelset = strel('disk', radius);
% simplethresh = imerode(simplethresh, se_levelset);

% radius_open = 12;
% se_levelopen = strel('disk', radius_open);
% simplethresh = imclose(simplethresh, se_levelopen);

imshow(simplethresh)


% figure(4)
% % connected component analysis with 8 neighbours
% %CC = bwconncomp(Images(:,:,IMAGE_2_SEGMENT)) can be used also
% [L,N] = bwlabeln(simplethresh,8);
% imagesc(L,[0,N]) %display L in ingenious way
% colormap("hsv")
% 
% % Compute the number of voxels for each label
% NofVoxels = zeros(N,1);
% for ij=1:N
%     
%    NofVoxels(ij) = length(find(L==ij));
% end
% 
% %Find the maximum component
% 
% [location, IX] = max(NofVoxels);  %~ not gonna store that variable but it can be location 
% 
% figure(5)
% skull_p1 = L==IX;
% for ij=1:N
%     
%    if NofVoxels(ij)>45496 
%        skull_p2 = L==2;
%    end
% end


penalty = 10; %important , if this is very small it will start going beyond...

grayImage = im2double(grayImage);
%Derive an initial segmentation at 60%
Threshold = 0.6;
RoughSegmentation = grayImage > Threshold;
figure(11)
imshow(RoughSegmentation)
RoughSegmentation = imopen(RoughSegmentation, strel('disk',2)); % COMPLETE % (morphologic operation)
figure(12)
imshow(RoughSegmentation)

Image2Segment  = grayImage;
imggradient = -1*ones(size(Image2Segment));
imggradient(RoughSegmentation) = 1.0;


%COMPLETE % Encapsulate this function in an appropriate loop to achieve the segmentation
imggradient = LevelSetSegmentationCore(Image2Segment,imggradient,penalty);

figure(1000)
imshow(imggradient)
hold on
%contour(skull_p1 > 0,'r')
% if exist('skull_p2','var')==1
% contour(skull_p2 > 0,'r')
% end



