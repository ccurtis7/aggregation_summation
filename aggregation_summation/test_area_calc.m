clear; clc;

frames = 1201;
average_area = zeros(1, frames);
std_area = zeros(1, frames);

for frame = 1:frames
    %Read in image and perform filtering
    f = imread('10mM_4_C1.tif', frame);
    h = fspecial('average', [3,3]);
    f2 = imfilter(f, h);

    %Perform thresholding
    %See 12.1.1 and 12.4.1 for info on thresholding.
    %g = f2 > 30;
    %[T] = graythresh(f2);
    %g = im2bw(f2, T);
    g = localthresh(f2, ones(3), 4, 1.2, 'global');

    %Extract regions
    [regions, numagg] = bwlabel(g, 8);
    D = regionprops(regions, 'area');
    Areas = [D.Area];

    %Compile averages and SDs
    average_area(1, frame) = average(Areas);
    std_area(1, frame) = std(Areas);
end

