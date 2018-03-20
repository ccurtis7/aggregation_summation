%Contains code with similar language in the function average_areas. This
%code can be used to perform a visual check of the thresholding being
%performed on the videos. Includes three different methods for thres-
%holding.  Default is a local threshold using user-defined parameters.

%This tool should be used before performing any area analyses on videos
%just to make sure that nothing is going wrong with the filtering.

%This code uses functions and concepts found in "Digital Image Processing
%Using MATLAB" (2nd Ed.) by R. C. Gonzalez, R. E. Woods, and S. L. Eddins.
%In order to run the code, these functions must be in the user's working
%directory.

%Author: Chad Curtis
%Date: 07.13.17
%Modified: 07.13.17

%%
%Read in image and perform filtering.
%h --> average-filtered image.
%hback --> average-filtered image to be used as background image.

f = imread('RED_PEG_2mM_PH72_CO25_T37_1.tif', 21);
h = fspecial('average', [2,2]);
hback = fspecial('average', [50 50]);
%f2 = imfilter(f, h);
f2 = imfilter(f, h) - imfilter(f, hback);

%%
%Perform thresholding
%See 12.1.1 and 12.4.1 in Digital for info on image registration.
%See 11.3 for information on image thresholding.

%Some intuition for meank and stdk: increasing either will decrease the
%amount of particles detected in your image.  The function uses an AND
%statement that has to satsify both average intensity and spread of 
%intensities over a neighborhood of the image.  

%g = f2 > 30;
[T] = graythresh(f2);
%g = im2bw(f2, T);

medintensity = mean(mean(f));
threshintensity = 20;

%if medintensity > threshintensity
%    meank = 10;
%    stdk = 1.5;
%else
%    meank = 0.01;
%    stdk = 1.8;
%end
%meank = 0.2502*medintensity + 3.2446;
%stdk = 0.0825*medintensity - 0.7275;

meank = 0.8;
stdk = 2;

g = localthresh(f2, ones(3), meank, stdk, 'global');
se = strel('square', 3);
g = imopen(imclose(g, se), se);
g = imopen(imclose(g, se), se);

%%
%Extract regions
[regions, numagg] = bwlabel(g, 8);
D = regionprops(regions, 'area');
Areas = [D.Area];

imshow(g);
figure, imshow(imadjust(f2));
figure, imshow(imadjust(f));