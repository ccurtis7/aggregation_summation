%This script uses the function average_areas on multiple videos and
%averages these averages together.  It also plots the average particle
%areas and calculates a few relevant metrics for particle aggregation.

%The first section performs the calculations and takes a significant amount
%of compution time.
%The second section can be run separately to make the graphs and perform
%the analysis.  Analysis parameters are saved in a structure matlab file.

%Author: Chad Curtis
%Date: 07.13.17
%Modified: 07.17.17

clear; clc;
%%
%This block contains all the user inputs necessary for the aggregate data
%analysis, as well as the majority for visualization.
%It also performs the average area calculations using the function
%average_area_over_all_experiments.

numvideos = 4;
prefix = 'RED_nPEG_2mM_PH72_CO25_T37';
holder = '_';
suffix = '';
filetype = '.tif';
numframes = 151; %numframes - 1 must be divisible by 3
fps = 0.13;
micronsppix = 0.16;
cutframe = 2; %cutframe + 1 must be divisible by 3
numbins = 101;
vidnums = [1, 2, 3, 4];

time = linspace(1, numframes - 1, numframes)/fps;

%%
average_matrix = zeros(numvideos, numframes);
sum_areas_matrix = zeros(numvideos, numframes);
%std_matrix = zeros(numvideos, numframes);
area_hist_matrix_int = zeros(numbins, numframes);
area_hist_matrix = zeros(numbins, numframes);

h = waitbar(0, 'Please wait...');
for video = 1:numvideos
    filename = strcat(prefix, holder, int2str(vidnums(video)), suffix, filetype);
    [average_matrix(video, :), area_hist_matrix_int(:, :), bins, time_frames, sum_areas_matrix(video, :)] = average_areas(filename, numframes, numbins, micronsppix);
    area_hist_matrix = area_hist_matrix + area_hist_matrix_int;
    
    waitbar(video/numvideos);
end
close(h);

area_hist_matrix = bsxfun(@rdivide, area_hist_matrix, sum(area_hist_matrix, 1));
results_file = strcat(prefix, '.mat');
save(results_file, 'average_matrix');

%General plot parameters
fsize = 17;
fTsize = 13;
%%
%Average calculations
avg_area = nanmean(average_matrix, 1);
std_area = nanstd(average_matrix, 1);

avg_sum = nanmean(sum_areas_matrix, 1);
std_sum = nanstd(sum_areas_matrix, 1);

a = avg_area(cutframe:3:length(time)-3);
b = avg_area(cutframe+1:3:length(time)-2);
c = avg_area(cutframe+2:3:length(time)-1);
smooth_avg_area = mean(cat(3,a,b,c),3);

              %#create y values for out and then back
%Yd=[yd,fliplr(y1)];
%Yu=[y2,fliplr(yu)];
%%
%09.11.17 New fillin curve graph (average area)
xmax = 1200;
ymax = 6;

lower = avg_area - std_area;
upper = avg_area + std_area;
X=[time,fliplr(time)];                %#create continuous x value array for plotting
Y=[lower,fliplr(upper)];

fill(X,Y,'b');                  %#plot filled area
hold on
%fill(X,Yd,'g');
%fill(X,Yu,'g');
plot(time,avg_area,'k','LineWidth',3);
xlim([0, xmax])
ylim([0, ymax])
set(gca, 'Layer', 'top')

%%
%Fillin curve (average total area covered)
xmax = 1200;
ymax = 120000;

lower = avg_sum - std_sum;
upper = avg_sum + std_sum;
X=[time,fliplr(time)];                %#create continuous x value array for plotting
Y=[lower,fliplr(upper)]; 

fill(X,Y,'b');                  %#plot filled area
hold on
%fill(X,Yd,'g');
%fill(X,Yu,'g');
plot(time,avg_sum,'k','LineWidth',3);
hold off
xlim([0, xmax])
ylim([0, ymax])
set(gca, 'Layer', 'top')

sum_filename = strcat(prefix, '_sum_graph', '.png');
saveas(gcf, sum_filename);
%%
%Graphs of individual video sum areas
plot(time, sum_areas_matrix(1, :), 'k', 'LineWidth', 3);
hold on 
plot(time, sum_areas_matrix(2, :), 'g', 'LineWidth', 3);
plot(time, sum_areas_matrix(3, :), 'b', 'LineWidth', 3);
%plot(time, sum_areas_matrix(4, :), 'r', 'LineWidth', 3);
hold off
xlim([0, xmax])
ylim([0, ymax])
set(gca, 'Layer', 'top')

sums_filename = strcat(prefix, '_sum_graphs', '.png');
saveas(gcf, sums_filename);
%%
xmax = 400;
ymax = 60;


longbehav1 = polyfit(time(cutframe:length(time)), avg_area(cutframe:length(time)), 1);
longline = polyval(longbehav1, time(cutframe:length(time)));
figure, plot(time(cutframe:3:length(time)-4), smooth_avg_area, 'LineWidth', 3);
%xlim([0, xmax])
%ylim([0, ymax])

set(gca, 'LineWidth', 3, 'FontSize', fTsize, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', fsize, 'FontWeight', 'bold');
ylabel('Average Area (square microns)', 'FontSize', fsize, 'FontWeight', 'bold');

hold on
plot(time(cutframe:length(time)), longline, 'LineWidth', 3);

longplot_name = strcat(prefix, '_longplot', '.png');
saveas(gcf, longplot_name);
hold off

%props.maxdif = maxdif;
%props.wheremax = wheremax;
%props.shortline = shortbehav1;
%props.shortexp = shortbehav3;
props.longline = longbehav1;

results_filename = strcat(prefix, '_props', '.mat');
save(results_filename, 'props');

%%
%This section examines behavior of individual replicates, plots them, and
%calculates linear fit parameters for each.  Linear fit parameters are
%saved in teh variable repsfit.
%--------------------------------------------------------------------------
xmax = 400;
ymax = 60;


repsfit = zeros(numvideos, 2);
for video = 1:numvideos
repsfit(video, :) = polyfit(time(cutframe:length(time)), average_matrix(video, cutframe:length(time)), 1);

line = polyval(repsfit(video, :), time(cutframe:length(time)));
figure, plot(time(cutframe:length(time)), average_matrix(video, cutframe:length(time)), 'LineWidth', 3);
xlim([0, xmax])
ylim([0, ymax])

set(gca, 'LineWidth', 3, 'FontSize', fTsize, 'FontWeight', 'bold');
xlabel('Time (frames)', 'FontSize', fsize, 'FontWeight', 'bold');
ylabel('Average Area (square microns)', 'FontSize', fsize, 'FontWeight', 'bold');

hold on
plot(time(cutframe:length(time)), line, 'LineWidth', 3);

lineplot_name = strcat(prefix, '_testplot', int2str(video), '.png');
saveas(gcf, lineplot_name);
hold off
end

%%
%This section creates a structure, props, that contains all the analysis
%parameters of interest.
%--------------------------------------------------------------------------
%props.maxdif = maxdif;
%props.wheremax = wheremax;
%props.shortline = shortbehav1;
%props.shortexp = shortbehav3;

%props.longline = longbehav1;
%props.repsfit = repsfit;

props.hist_matrix = area_hist_matrix;
props.average_matrix = average_matrix;
props.average = avg_area;
props.bins = bins;
props.time = time;
props.sum_matrix = sum_areas_matrix;
props.sum_avg = avg_sum;

results_filename = strcat(prefix, '_props', '.mat');
save(results_filename, 'props');

%%
figure (1)
hfig = figure(1);
set(gcf, 'PaperPositionMode', 'auto');
set(hfig, 'Position', [0, 0, 1000, 500]);
contourf(time, bins, area_hist_matrix, 20, 'LineColor', 'none');
caxis([0, 0.08]);
colorbar;
ylim([-1, 10]);
set(gca, 'LineWidth', 3, 'FontSize', fTsize, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', fsize, 'FontWeight', 'bold');
ylabel('log(Area)', 'FontSize', fsize, 'FontWeight', 'bold');
intensityplot_name = strcat(prefix, 'intensity', '.png');
saveas(gcf, intensityplot_name);

