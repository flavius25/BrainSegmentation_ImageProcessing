function output_segmentations = BrainSegmentationFunction(input_image)
output_segmentations = struct();

%Define an appropriate kernel HSIZE x HSIZE
HSIZE = 4; 
%Create an averaging filter H of size HSIZE
element = fspecial('average',HSIZE);

% Filter the noise using the above defined kernel
filtered_image = imfilter(input_image,element);
% figure(6)
% imshowpair(input_image,filtered_image,'montage')
% Iblur1 = imgaussfilt(first_image,6);
% noisy_image = imnoise(first_image,'Gaussian',0, 0.01);
% 
% filtered_image = imfilter(noisy_image,element);
% 
% figure(7)
% imshow(filtered_image,[]);
% 
% %plotting histograms
[histogram1,bins] = hist(input_image(:),0:0.01:1);
[histogram2,bins] = hist(filtered_image(:),0:0.01:1);
histogram1(1)=0;
histogram2(1)=0;
% 
% figure(7)
% subplot(1,2,1)
% bar(bins,histogram1)
% title('original image', 'FontSize', 15);
% subplot(1,2,2)
% bar(bins,histogram2)
% title('filtered image', 'FontSize', 15);
% 
% figure(8)
% plot(bins,histogram2)

%using otsu_threshold for segmentation
otsu_threshold = graythresh(filtered_image);
multi_threshold = multithresh(filtered_image,2);
SkullBW = imbinarize(filtered_image,otsu_threshold-0.09);

BW = imbinarize(filtered_image,otsu_threshold);
MT1=imbinarize(filtered_image,multi_threshold(1));
MT2=imbinarize(filtered_image,multi_threshold(2));
%PosPix=imbinarize(filtered_image,0.15);
% Calculate the histogram maximum value
max_histogram = max(histogram2); 

% Display the threshold on the histogram in a new figure by overlaying the histogram with a vertical line 
% figure(8),
% plot(bins,histogram2),
% hold on;
% plot([otsu_threshold otsu_threshold],[0 max_histogram],'--r'); % Add a vertical red (dashed) line.
% hold on;
% plot([multi_threshold(1) multi_threshold(1)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
% plot([multi_threshold(2) multi_threshold(2)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
% %plot([multi_threshold(3) multi_threshold(3)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
% %plot([multi_threshold(4) multi_threshold(4)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
% hold off;

MT_dif12=MT1-MT2;
MT1neg=imcomplement(MT1);


%%skull segmentation
binaryImage = imclearborder(SkullBW);
%binaryImage = imclose(binaryImage,true(3));
%%extract 2 largest areas
binaryImage = bwareafilt(binaryImage,2);
%output_segmentations.skull=binaryImage;
% Erode it a little to seperate brain and skull
binaryImage = imerode(binaryImage, true(10));
binaryImage = bwareafilt(binaryImage, 1);		% Extract largest blob = brain
binaryImage = imdilate(binaryImage, true(10));
%output_segmentations.CF=binaryImage;

% Fill any holes in the brain.
R = 40;
structuring_element = strel('disk',R);
binaryImage = imclose(binaryImage,structuring_element);
R2=5;
structuring_element2 = strel('disk',R2);
% Dilate mask out a bit in case we've chopped out a little bit of brain.
binaryImage = imdilate(binaryImage, structuring_element2);
%%complement of brain = mask of everything except the brain area
brain=binaryImage;
brain=imdilate(binaryImage,true(40));
compbrain=imcomplement(brain);
comp=imcomplement(binaryImage);

skull=filtered_image;
skull(~comp) = 0;

skullbw=MT1;
skullbw(~comp) = 0;

%output_segmentations.skull=skullbw;

R3 = 4;
structuring_element3 = strel('disk',R3);
skullbw=imclose(skullbw,structuring_element3);
skullbw = bwareafilt(skullbw,[10000,1000000000]);
R4 = 7;
structuring_element4 = strel('disk',R4);
skullbw=imclose(skullbw,structuring_element4);
%skullbw = bwareafilt(skullbw,1,'largest');
%skullbw = bwareafilt(skullbw,2,'largest');
%skullbw=imclose(skullbw,structuring_element3);

%skullbw=imopen(skullbw,structuring_element2);
%skullbw(~comp)=0;
%output_segmentations.CF=skullbw;




% Apply the thresholding
segmented_image = filtered_image > otsu_threshold; % segmented_image = ..


% Display the result in a new figure
% figure(10)
% imshow(segmented_image,[]);

% Complement the image
complement_image = imcomplement(segmented_image); 

% Display the complement in a new figure
% figure(11)
% imshow(complement_image,[])

% Define an appropriate structuring element to fill the original segmentation
R = 52;
structuring_element = strel('disk',R);


% Perform the closing to fill the segmentated brain using the defined structuring element
% First clean the segmentation for small objects
segmented_image_clean = imopen(segmented_image,strel('disk',1));

brain_mask = imclose(segmented_image_clean,structuring_element); 

% Complement the image
complement_image = imcomplement(brain_mask); 

%%fit GM,WM and CF within the biggest cavity of the skull -> doesnt work
%%well
% brainMaskSkull=imclose(skullbw,R4);
% brainMaskSkull=imcomplement(brainMaskSkull);
% brainMaskSkull=brainMaskSkull-complement_image;
% brainMaskSkull=imbinarize(brainMaskSkull);
% brainMaskSkull=bwareafilt(brainMaskSkull, 1);
% brainMaskSkull=imcomplement(brainMaskSkull);

% Display the brain_mask in a new figure
% figure(12)
% imshow(complement_image,[])
MT2_bg=MT2-complement_image;
MTdif12_bg=MT_dif12-complement_image;
MT1neg_bg=MT1neg-complement_image;

% WM = MT2_bg-skullbw;
% GM = MTdif12_bg-skullbw;
% GM = GM-compbrain;
% CF = MT1neg_bg-skullbw;
% CF = CF-compbrain;

WM = MT2_bg-skullbw;
WM = MT2_bg-compbrain;
GM = MTdif12_bg-skullbw;
GM = GM-compbrain;
CF = MT1neg_bg-skullbw;
CF = CF-compbrain;


% R = 5;
% structuring_element = strel('disk',R);
% MT1neg_open = imopen(MT1neg,strel('disk',5));
% MT1neg_close = imclose(MT1neg_open,structuring_element); 

%MT1neg_bg=MT1neg_close-complement_image;

% figure(100)
% imshowpair(MT1neg,MT1neg_bg)



% figure(10)
% subplot(2,2,1)
% imshow(filtered_image)
% title('filtered image')
% subplot(2,2,2)
% imshow(MT1neg_bg)
% title('Cerebrospinal Fluid')
% subplot(2,2,3)
% imshow(MT2_bg)
% title('White Matter')
% subplot(2,2,4)
% imshow(MTdif12_bg)
% title('Grey Matter')




output_segmentations.background = complement_image;
output_segmentations.skull = skullbw;
output_segmentations.CF = CF;
output_segmentations.WM = WM;
output_segmentations.GM = GM;

end