

input_image=image{10};

%Define an appropriate kernel HSIZE x HSIZE
HSIZE = 5; 
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
figure(7)
subplot(1,2,1)
bar(bins,histogram1)
title('original image', 'FontSize', 15);
subplot(1,2,2)
bar(bins,histogram2)
title('filtered image', 'FontSize', 15);
% 
% figure(8)
% plot(bins,histogram2)

%using otsu_threshold for segmentation
otsu_threshold = graythresh(filtered_image);
multi_threshold = multithresh(filtered_image,2);
BW = imbinarize(filtered_image,otsu_threshold);
MT1=imbinarize(filtered_image,multi_threshold(1));
MT2=imbinarize(filtered_image,multi_threshold(2));
%PosPix=imbinarize(filtered_image,0.15);
% Calculate the histogram maximum value
max_histogram = max(histogram2); 

% Display the threshold on the histogram in a new figure by overlaying the histogram with a vertical line 
figure(8),
plot(bins,histogram2),
hold on;
plot([otsu_threshold otsu_threshold],[0 max_histogram],'--r'); % Add a vertical red (dashed) line.
hold on;
plot([multi_threshold(1) multi_threshold(1)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
plot([multi_threshold(2) multi_threshold(2)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
%plot([multi_threshold(3) multi_threshold(3)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
%plot([multi_threshold(4) multi_threshold(4)],[0 max_histogram],'--g'); % Add a vertical red (dashed) line.
hold off;

MT_dif12=MT1-MT2;
MT1neg=imcomplement(MT1);

%show the binary image
% figure(9)
% subplot(2,3,1)
% imshow(filtered_image)
% title('filtered image')
% subplot(2,3,2)
% imshow(BW)
% title('otsu binarized')
% subplot(2,3,3)
% imshow(BW)
% title('otsu binarized')
% subplot(2,3,4)
% imshow(MT1)
% title('MT2-Threshold 1')
% subplot(2,3,5)
% imshow(MT2)
% title('MT2-Threshold 2')
% subplot(2,3,6)
% imshow(MT_dif12)
% title('Threshold 1 - Threshold 2')




% figure(9)
% subplot(2,2,1)
% imshow(filtered_image)
% title('filtered image')
% subplot(2,2,2)
% imshow(MT1neg)
% title('Cerebrospinal fluid')
% subplot(2,2,3)
% imshow(MT2)
% title('White Matter')
% subplot(2,2,4)
% imshow(MT_dif12)
% title('Grey Matter')







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

% Display the brain_mask in a new figure
% figure(12)
% imshow(complement_image,[])

MT2_bg=MT2-complement_image;
MTdif12_bg=MT_dif12-complement_image;
MT1neg_bg=MT1neg-complement_image;

figure(10)
subplot(2,2,1)
imshow(filtered_image)
title('filtered image')
subplot(2,2,2)
imshow(MT1neg_bg)
title('Cerebrospinal Fluid')
subplot(2,2,3)
imshow(MT2_bg)
title('White Matter')
subplot(2,2,4)
imshow(MTdif12_bg)
title('Grey Matter')




output_segmentations.background = complement_image;
output_segmentations.CF = MT1neg_bg;
output_segmentations.WM = MT2_bg;
output_segmentations.GM = MTdif12_bg;
