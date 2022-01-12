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
    %figure(ck), imshow(image{ck}); %imagesc only for png, now we converted it
    
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

for i=1:10
    
img2 = image{i};
img = BrainSegmentationFunction(img2);
maskCF = img.CF;
maskWM = img.WM;
maskGM = img.GM;
maskSkull = img.skull;

green = cat(3, zeros(size(maskCF)), ones(size(maskCF)), zeros(size(maskCF))); 
red = cat(3, ones(size(maskWM)), zeros(size(maskWM)), zeros(size(maskWM))); 
blue = cat(3, zeros(size(maskWM)), zeros(size(maskWM)), ones(size(maskWM)));
other = cat(3, ones(size(maskWM)), zeros(size(maskWM)), ones(size(maskWM)));



figure(i)
subplot(1,2,1)
imshow(img2)
subplot(1,2,2)
imshow(img2)
hold on
g = imshow(green);
r = imshow(red);
b = imshow(blue);
o = imshow(other);
hold off
set(g, 'AlphaData', maskCF)
set(r, 'AlphaData', maskWM)
set(b, 'AlphaData', maskGM)
set(o, 'AlphaData', maskSkull)

end
