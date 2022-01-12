function u = LevelSetSegmentationCore(Img,u,mu)

% This Matlab program demomstrates the level set algorithm in paper:
%    "Active contours with selective local or global segmentation: a new variational approach and level set method" 
%    to appear in Image and Vision Computing, 2010. 
% Authors: Kaihua Zhang, Lei Zhang, Huihui Song and Wengang Zhou
% E-mail: zhkhua@mail.ustc.edu.cn, cslzhang@comp.polyu.edu.hk 
% URL: http://www4.comp.polyu.edu.hk/~cslzhang/

% Notes:Some parameters may need to be modified for different types of images. 
% Please contact the authors if any problem regarding the choice of parameters.
% Date: 5/11/2009

sigma = 1;
G = fspecial('gaussian', 5, sigma);

delt = 1;
% Iter = 1800;
% mu = 7.0;%this parameter needs to be tuned according to the images

[ux, uy] = gradient(u);

c1 = sum(sum(Img.*(u<0)))/(sum(sum(u<0)));% we use the standard Heaviside function which yields similar results to regularized one.
c2 = sum(sum(Img.*(u>=0)))/(sum(sum(u>=0)));

if(isnan(c1))
    c1 = 0;
end
if(isnan(c2))
    c2 = 0;
end

spf = Img - (c1 + c2)/2;
spf = spf/(max(abs(spf(:))));

u = u + delt*(mu*spf.*sqrt(ux.^2 + uy.^2));

u = (u >= 0) - ( u< 0);% the selective step.
u = conv2(u, G, 'same');


   