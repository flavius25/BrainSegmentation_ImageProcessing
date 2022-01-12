clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
% clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 18;

folder = pwd; % Current folder.
baseFileName = 'fruit.png';
% % Have user browse for a file, from a specified "starting folder."
% % For convenience in browsing, set a starting folder from which to browse.
% startingFolder = pwd;  % or 'C:\wherever';
% if ~exist(startingFolder, 'dir')
% 	% If that folder doesn't exist, just start in the current folder.
% 	startingFolder = pwd;
% end
% % Get the name of the file that the user wants to use.
% defaultFileName = fullfile(startingFolder, '01.png');
% [baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
% if baseFileName == 0
% 	% User clicked the Cancel button.
% 	return;
% end
fullFileName = fullfile(folder, baseFileName)

%===============================================================================
% Check if file exists.
if ~exist(fullFileName, 'file')
	% The file doesn't exist -- didn't find it there in that folder.
	% Check the entire search path (other folders) for the file by stripping off the folder.
	fullFileNameOnSearchPath = baseFileName; % No path this time.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
[indexedImage, storedColorMap] = imread(fullFileName);
rgbImage = ind2rgb(f,storedColorMap); %convert index image to RGB image

% Get the dimensions of the image.
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(rgbImage)
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Use weighted sum of ALL channels to create a gray scale image.
	% 	grayImage = rgb2gray(rgbImage);
	% ALTERNATE METHOD: Convert it to gray scale by taking only the green channel,
	% which in a typical snapshot will be the least noisy channel.
	grayImage = rgbImage(:, :, 2); % Take green channel.
else
	grayImage = rgbImage; % It's already gray scale.
end
% Now it's gray scale with range of 0 to 255.

% Display the image.
subplot(2, 2, 1);
imshow(grayImage, []);
title('Original Image', 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');
hp = impixelinfo();

%------------------------------------------------------------------------------
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
% Get rid of tool bar and pulldown menus that are along top of figure.
% set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')
drawnow;

% Display the histogram.
subplot(2, 2, 2);
histogram(grayImage, 256);
title('Histogram of image', 'FontSize', fontSize, 'Interpreter', 'None');
grid on;
drawnow;

% Mask the image.
% mask = imbinarize(grayImage);
mask = grayImage > 0;
% Fill holes
mask = imfill(mask, 'holes');
% Count the blobs
[labeledImage, numBlobs] = bwlabel(mask);
% Display the mask.
subplot(2, 2, 3);
imshow(mask, []);
caption = sprintf('Binary Image with %d Fruits', numBlobs);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
axis('on', 'image');

% Measure areas
props = regionprops(mask, 'Area');
allAreas = sort([props.Area])

msgbox('Done!');