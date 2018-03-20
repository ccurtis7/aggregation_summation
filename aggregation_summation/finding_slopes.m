PEG_2mM = load('RED_PEG_2mM_PH72_CO25_T37_props.mat');
PEG_0mM = load('RED_PEG_0mM_PH72_CO25_T37_props.mat');
nPEG_2mM = load('RED_nPEG_2mM_PH72_CO25_T37_props.mat');
nPEG_0mM = load('RED_nPEG_0mM_PH72_CO25_T37_props.mat');

PEG_2mM.props.std_sum = nanstd(PEG_2mM.props.sum_matrix, 1)./sqrt(3);
PEG_0mM.props.std_sum = nanstd(PEG_0mM.props.sum_matrix, 1)./sqrt(3);
nPEG_2mM.props.std_sum = nanstd(nPEG_2mM.props.sum_matrix, 1)./sqrt(4);
nPEG_0mM.props.std_sum = nanstd(nPEG_0mM.props.sum_matrix, 1)./sqrt(4);

numframes = 151; %numframes - 1 must be divisible by 3
fps = 0.13;
time = linspace(1, numframes - 1, numframes)/fps;
numvideos = 3;
repsfit = zeros(numvideos, 2);
cutframe = 21;

for video = 1:numvideos
repsfit(video, :) = polyfit(time(cutframe:length(time)), PEG_2mM.props.sum_matrix(video, cutframe:length(time)), 1);
end
%%
tot_area = 2100*2100*0.16*0.16;


%%
%Fillin curve (average total area covered)
xmax = 1200;
ymax = 1;

lower = PEG_2mM.props.sum_avg(cutframe:length(time)) - PEG_2mM.props.std_sum(cutframe:length(time))/tot_area;
upper = PEG_2mM.props.sum_avg(cutframe:length(time)) + PEG_2mM.props.std_sum(cutframe:length(time))/tot_area;
X=[time(cutframe:length(time)),fliplr(time(cutframe:length(time)))];                %#create continuous x value array for plotting
Y=[lower,fliplr(upper)]; 

h1 = fill(X,Y,'b', 'facealpha', 0.5);                  %#plot filled area

hold on
%fill(X,Yd,'g');
%fill(X,Yu,'g');
h2 = plot(time(cutframe:length(time)),PEG_2mM.props.sum_avg(cutframe:length(time))/tot_area,'b','LineWidth',3);
xlim([0, xmax])
ylim([0, ymax])
set(gca, 'Layer', 'top')
%
lower = nPEG_2mM.props.sum_avg(cutframe:length(time)) - nPEG_2mM.props.std_sum(cutframe:length(time))/tot_area;
upper = nPEG_2mM.props.sum_avg(cutframe:length(time)) + nPEG_2mM.props.std_sum(cutframe:length(time))/tot_area;
X=[time(cutframe:length(time)),fliplr(time(cutframe:length(time)))];                %#create continuous x value array for plotting
Y=[lower,fliplr(upper)]; 

h3 = fill(X,Y,'g', 'facealpha', 0.5);                  %#plot filled area
hold on
%fill(X,Yd,'g');
%fill(X,Yu,'g');
h4 = plot(time(cutframe:length(time)),nPEG_2mM.props.sum_avg(cutframe:length(time))/tot_area,'g','LineWidth',3);
%
lower = PEG_0mM.props.sum_avg(cutframe:length(time)) - PEG_0mM.props.std_sum(cutframe:length(time))/tot_area;
upper = PEG_0mM.props.sum_avg(cutframe:length(time)) + PEG_0mM.props.std_sum(cutframe:length(time))/tot_area;
X=[time(cutframe:length(time)),fliplr(time(cutframe:length(time)))];                %#create continuous x value array for plotting
Y=[lower,fliplr(upper)]; 

h5 = fill(X,Y,'r', 'facealpha', 0.5);                  %#plot filled area
hold on
%fill(X,Yd,'g');
%fill(X,Yu,'g');
h6 = plot(time(cutframe:length(time)),PEG_0mM.props.sum_avg(cutframe:length(time))/tot_area,'r','LineWidth',3);
alpha(0.5);
%
lower = nPEG_0mM.props.sum_avg(cutframe:length(time)) - nPEG_0mM.props.std_sum(cutframe:length(time))/tot_area;
upper = nPEG_0mM.props.sum_avg(cutframe:length(time)) + nPEG_0mM.props.std_sum(cutframe:length(time))/tot_area;
X=[time(cutframe:length(time)),fliplr(time(cutframe:length(time)))];                %#create continuous x value array for plotting
Y=[lower,fliplr(upper)]; 

h7 = fill(X,Y,'c', 'facealpha', 0.5);                  %#plot filled area
hold on
%fill(X,Yd,'g');
%fill(X,Yu,'g');
h8 = plot(time(cutframe:length(time)),nPEG_0mM.props.sum_avg(cutframe:length(time))/tot_area,'c','LineWidth',3);

[BL,BLicons] = legend([h8 h4 h6 h2], {'PS-COOH/0mM', 'PS-COOH/2mM', 'PS-PEG/0mM', 'PS-PEG/2mM'},'location','northwest', ...
    'FontSize',12);
PatchInLegend = findobj(BLicons, 'type', 'patch');
set(PatchInLegend, 'facea', 0.5)

fsize = 60;
xlabel('Time (s)', 'FontSize', fsize, 'FontWeight', 'bold');
ylabel('Fraction Area Covered', 'FontSize', fsize, 'FontWeight', 'bold');
% % %sum_filename = strcat(prefix, '_sum_graph', '.png');
% % %saveas(gcf, sum_filename);

hold off