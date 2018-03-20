function [ average_area, areas_hist, bins, time, sum_areas ] = average_areas( video, numframes, numbins, micronsppix )
%Calculates the average area of particle aggregates at each timepoint from
%an input video.
%   Inputs:
%   video: multipage tiffs are verified.  I haven't tried other types.
%   numframes: number of frames in the tiff file.
%   numbins: the desired number of bins for the size histogram at each time
%       point.
%   micronsppix: the conversion factor relating microns to pixels.
%   
%   Outputs:
%   average_area: a vector of length numframes containing the average
%   particle area at each timepoint.
%   std_area: a vector of length numframes containing the standard
%       deviation of particle areas at each timepoint.
%   areas_hist: A matrix with dimensions numbins x numframes that contains
%       the area histogram at each timepoint.  Can be used to construct a
%       contour plot.
%   time: A vector containing the frames numbers (not converted to 
%       seconds).
%
%
%   Author: Chad Curtis
%   Date: 07.12.17
%   Modified: 07.18.17

average_area = zeros(1, numframes);
%std_area = zeros(1, numframes);
areas_hist = zeros(numbins, numframes);
sum_areas = zeros(1, numframes);

for frame = 1:numframes
    %Read in image and perform filtering
    f = imread(video, frame);
    h = fspecial('average', [3,3]);
    hback = fspecial('average', [50 50]);
    %f2 = imfilter(f, h);
    f2 = imfilter(f, h) - imfilter(f, hback);
    
    %Perform thresholding
    %See 12.1.1 and 12.4.1 for info on thresholding.
    %g = f2 > 30;
    %[T] = graythresh(f2);
    %g = im2bw(f2, T);
    
    meank = 0.8;
    stdk = 2;

    g = localthresh(f2, ones(3), meank, stdk, 'global');
    se = strel('square', 3);
    g = imopen(imclose(g, se), se);

    %Extract regions
    [regions, numagg] = bwlabel(g, 8);
    D = regionprops(regions, 'area');
    
    geo = 1;
    logscalar = 0;
    
    if logscalar
%         Areas = log(micronsppix*[D.Area])+1;
%         bins = linspace(-10, 10, numbins);
%         areas_hist(:, frame) = hist(Areas-1, bins)/(sum(hist(Areas-1, bins))+1);
        Areas = micronsppix*[D.Area];
        bins = linspace(-10, 10, numbins);
        areas_hist(:, frame) = hist(log(Areas), bins);
        %/(sum(hist(log(Areas), bins))+1);
    else
        Areas = micronsppix*[D.Area];
        bins = linspace(0, 1000, numbins);
        areas_hist(:, frame) = hist(Areas, bins);
        %/(sum(hist(Areas, bins))+1);
    end
    
    if geo
        rAreas = isnan(Areas);
        average_area(1, frame) = geomean(Areas(~rAreas));
    else
        average_area(1, frame) = nanmean(Areas);
        %std_area(1, frame) = nanstd(Areas);
    end
    
    time = linspace(1, numframes - 1, numframes);
    sum_areas(frame) = sum(Areas(~rAreas));
end


end

