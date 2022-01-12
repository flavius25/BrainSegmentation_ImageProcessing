function output = BrainSegmentationFunction(input_image)
% This function segments a T1w greyscale image in the following categories
% 1.) background
% 2.) skull
% 3.) CSF
% 4.) White matter (WM)
% 5.) Grey matter (GM)
% Note that 3,4,5 combined are often referred to as "brain".
% -------------------------------------------------------------------------


% BACKGROUND
% Getting background and removing it from input image.
output.background = getbackground(input_image);
img_nobg = setminus(input_image,output.background);

% SKULL/BRAIN
% We are using multilevel thresh holding to get some initial masks.
multi_threshold = multithresh(img_nobg,2);

brain = getbrain(img_nobg);
brain_dilated=imdilate(brain,true(40));

% First threshold removes the CSF (i.e. it contains GM,WM and skull)
firstThresh=imbinarize(img_nobg,multi_threshold(1));
output.skull = getskull(firstThresh,brain);

% The second thresh mostly contains skull and a bit of white matter
% I suspect this might also contain GM?
secondThresh=imbinarize(img_nobg,multi_threshold(2));

% WHITE MATTER
WM = setminus(secondThresh,output.skull);
WM = setminus(WM,~brain);
output.WM = WM;

% GREY MATTER
MT_dif12=setminus(firstThresh,secondThresh); 
GM = setminus(MT_dif12,output.skull);
GM = setminus(GM,~brain_dilated);
GM = setminus(GM,WM);
output.GM = GM;

% CSF
CF = setminus(~firstThresh,output.skull);
CF = setminus(CF,~brain_dilated);
CF = setminus(CF,GM);
CF = setminus(CF,WM);
output.CF = CF;

end

function skullbw = getskull(firstThresh,brain)
    % This function gets the skull mask (Note dependency on brain mask)
    skullbw = setminus(firstThresh,brain);
    
    % We try to connect parts of the skull that are disconnected  
    skullbw=imclose(skullbw,strel('disk',4));
    
    % We remove the brain regions that were not picked up in the brain
    % segmentation so that they dont pollute the skull mask.
    skullbw = bwareafilt(skullbw,[10000,1000000000]);
    
    % Think more about neccesity of this step if time allows
    skullbw=imclose(skullbw,strel("disk",7));
end

function bg = getbackground(img)
    % This function retreives the background using otsu thresholding
    otsuthreshd = imbinarize(img);
    
    % First clean the segmentation for small objects
    otsu_clean = imopen(otsuthreshd,strel('disk',1));
    
    head_mask = imclose(otsu_clean,strel("disk",70)); 
    
    % Compliment the image: (wow you look so good image, i love u)
    bg = ~head_mask; 
end

function brain_undilated = getbrain(img)
    % Gets the undilated brain mask from the image!
    otsu_threshold = graythresh(img);

    % Trial and error 
    brain = imbinarize(img,otsu_threshold-0.09);
    
    % We observe that the two largest connected areas (8-connectivity) are
    % skull and brain, and so CCA is applied.
    brain = bwareafilt(brain,2);
    
    % Erode it a little to seperate brain and skull (we probably should find an
    % alternative to this if we have the time to do so)
    brain = imerode(brain, true(10));
    brain = bwareafilt(brain, 1);	% largest object is the brain
    brain = imdilate(brain,true(10));
    
    % Fill any holes in the brain.(I should do this morphological operation to
    % myself)
    brain = imclose(brain,strel("disk",40));
    
    brain_undilated=imdilate(brain,strel("disk",5));
end

function setdiff = setminus(set1,set2)
    % Executes the setsubstraction: set1\set2
    setdiff = set1;
    setdiff(set2) = 0;
end
