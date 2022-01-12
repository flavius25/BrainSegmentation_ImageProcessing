function validation(image_store, seg_fun)
figure("Name","Axial images");
for n=1:4
    img = read(image_store); %reading from the datastore
    img = im2gray(img);
    segmentation = seg_fun(img); %Executing segmentation script from toolbox    
    subplot(4,1,n); % easy visualisation
    imshowpair(img,segmentation,'montage')
end

figure("Name","Coronal");
for n=5:7
    img = read(image_store); %reading from the datastore
    img = im2gray(img);
    segmentation = seg_fun(img); %Executing segmentation script from toolbox    
    subplot(3,1,n-4); % easy visualisation
    imshowpair(img,segmentation,'montage')
end

figure("Name","Sagital");
for n=8:10
    img = read(image_store); %reading from the datastore
    img = im2gray(img);
    segmentation = seg_fun(img); %Executing segmentation script from toolbox    
    subplot(3,1,n-7); % easy visualisation
    imshowpair(img,segmentation,'montage')
end
end