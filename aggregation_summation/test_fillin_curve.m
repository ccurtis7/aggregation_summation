x=linspace(0,6,100);                  %#initialize x array
y=3.25*x+2+rand(1,100)*1.5-0.75;
y1=y-0.05*x-0.6;                     %#create first curve
y2=y+0.06*x+0.6;                   %#create second curve
yu=y+0.16*x+1.6;
yd=y-0.15*x-1.5;
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
Yd=[yd,fliplr(y1)];
Yu=[y2,fliplr(yu)];

xmax=6;

fill(X,Y,'b');                  %#plot filled area
hold on
fill(X,Yd,'g');
fill(X,Yu,'g');
plot(x,y,'k','LineWidth',3);
xlim([0, xmax])
%ylim([0, ymax])
set(gca, 'Layer', 'top')

%Secondary plot
y=0.5*x+0.5+rand(1,100)*1.5-0.75;
y1=y-0.05*x-0.6;                     %#create first curve
y2=y+0.06*x+0.6;                   %#create second curve
yu=y+0.16*x+1.6;
yd=y-0.15*x-1.5;
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
Yd=[yd,fliplr(y1)];
Yu=[y2,fliplr(yu)];

fill(X,Y,'b');                  %#plot filled area
fill(X,Yd,'g');
fill(X,Yu,'g');
plot(x,y,'k','LineWidth',3);

hold off
alpha(0.4)