% Code to remove the outer bright skull from a CT cross sectional image.
%clc;    % Clear the command window.
%close all;  % Close all figures (except those of imtool.)
%clear;  % Erase all existing variables. Or clearvars if you want.
%workspace;  % Make sure the workspace panel is showing.
%format long g;
%format compact;
fontSize = 20;

%===========================================================================================================
% Get the name of the image the user wants to use.



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

for i = 10
    
grayImage=image{i};

%===========================================================================================================
% Read in a demo image.
% grayImage = dicomread(fullFileName);
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorChannels] = size(grayImage);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale by taking only the green channel.
	grayImage = grayImage(:, :, 2); % Take green channel.
end
% Display the image.
figure(i)
subplot(2, 3, 1);
imshow(grayImage, []);
axis on;
caption = sprintf('Original Grayscale Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo();
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 

% Make the pixel info status line be at the top left of the figure.
hp.Units = 'Normalized';
hp.Position = [0.01, 0.97, 0.08, 0.05];

%===========================================================================================================



%===========================================================================================================
% Threshold the image to make a binary image.
grayImage = im2double(grayImage);
thresholdValue = graythresh(grayImage)-0.01;
%thresholdValue=thresholdValue(1);
binaryImageBW = grayImage > thresholdValue;
binaryImageBW2 = imbinarize(grayImage,thresholdValue);

figure(1)
imshowpair(binaryImageBW, binaryImageBW2,'montage')


% If it's a screenshot instead of an actual image, the background will be a big square, like with image sc4.
% So call imclearborder to remove that.
% If it's not a screenshow (which it should not be, you can skip this step).
binaryImage = imclearborder(binaryImageBW);
% Display the image.
figure(i)
subplot(2, 3, 2);
imshow(binaryImage, []);
axis on;
caption = sprintf('Initial Binary Image\nThresholded at %d Gray Levels', thresholdValue);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%===========================================================================================================
% Extract the two largest blobs, which will either be the skull and brain,
% or the skull/brain (if they are connected) and small noise blob.
binaryImageC = imclose(binaryImage,true(5));
%binaryImageC = bwareafilt(binaryImageC, 2);		% Extract 2 largest blobs.
binaryImage = bwareafilt(binaryImage,2);

% Erode it a little with imdilate().
%binaryImageC = imopen(binaryImageC,true(5));
binaryImage = imopen(binaryImage, true(5));
%figure(100+i)
%imshowpair(binaryImage,binaryImageC,'montage')
% Now brain should be disconnected from skull, if it ever was.
% So extract the brain only - it's the largest blob.
binaryImage = bwareafilt(binaryImage, 1);		% Extract largest blob.
%binaryImage=binaryImage-binaryImageBrain;
% Fill any holes in the brain.
%binaryImage = imfill(binaryImage, 'holes');
R = 40;
structuring_element = strel('disk',R);
binaryImage = imclose(binaryImage,structuring_element);
R2=5;
structuring_element2 = strel('disk',R2);
% Dilate mask out a bit in case we've chopped out a little bit of brain.
binaryImage = imdilate(binaryImage, structuring_element2);

% Display the final binary image.
figure(i)
subplot(2, 3, 3);
imshow(binaryImage, []);
axis on;
caption = sprintf('Final Binary Image\nof Brain Alone');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

%===========================================================================================================
comp=imcomplement(binaryImage);
skull=grayImage;
skull(~comp) = 0;

figure(i)
subplot(2, 3, 4);
imshow(skull, []);
axis on;
caption = sprintf('Gray Scale Image\nwith Brain Stripped Away');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');


% 
% subplot(2, 3, 5);
% imshow(skullFreeImage, []);
% axis on;
% caption = sprintf('Gray Scale Image\nwith Skull Stripped Away');
% title(caption, 'FontSize', fontSize, 'Interpreter', 'None');




% Mask out the skull from the original gray scale image.
skullFreeImage = grayImage; % Initialize
skullFreeImage(~binaryImage) = 0; % Mask out.
% Display the image.
figure(i)
subplot(2, 3, 5);
imshow(skullFreeImage, []);
axis on;
caption = sprintf('Gray Scale Image\nwith Skull Stripped Away');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

skullbw=binaryImageBW;

skullbw(~comp)=0;

% skull_otsu=graythresh(skullFreeImage);
% skullbw=imbinarize(skull,skull_otsu);
 R3=3;
 structuring_element3 = strel('disk',R3);
 skullbw=imopen(skullbw,structuring_element3);
 %skullbw=imclose(skullbw,strel('disk',3));

figure(i)
subplot(2, 3, 6);
imshow(skullbw, []);
axis on;
caption = sprintf('Gray Scale Image\nwith Skull Stripped Away');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

end