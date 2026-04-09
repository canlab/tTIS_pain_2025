load("Post_vs_Pre_change.mat")
font_size = 20;

color = [
    0.40 0.76 0.65;   % teal    0.50 0.50 0.50;   % Sham – gray (neutral)
    0.99 0.55 0.38;   % 10 Hz – blue
    0.55 0.63 0.80;   % 20 Hz – green
    0.91 0.54 0.76    % 70 Hz – purple
    ];

%% Post vs Pre for high temp

cnames_all = {'Sham','10 Hz','20 Hz','70 Hz'};
tem_high{1,1} = pain_change_high(:,1);
tem_high{1,2} = pain_change_high(:,2);
tem_high{1,3} = pain_change_high(:,3);
tem_high{1,4} = pain_change_high(:,4);

create_figure('Post vs Pre - Violin for high temp')
h1 = daviolinplot(tem_high, 'colors',color, 'outsymbol','k+','violin', 'half2', 'violinwidth', 4, 'boxcolors','same',...
    'box' ,2, 'boxcolors','same','boxalpha', 0.6, 'scatter',1,'scattersize',30,'scatteralpha' , 0.4,'jitter',1 , 'xtlabels', cnames_all,'outliers',0);
ylabel('Post - Pre pain rating')
ylim([-25 30])
xlim([-.01 4.2])
set(gca, 'FontSize', font_size,'FontName', 'Helvetica-Narrow')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 8 7]);
hl = yline(0,'Color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',1.5);
uistack(hl,'bottom')

%% Post vs Pre for low temp
tem_low{1,1} = pain_change_low(:,1);
tem_low{1,2} = pain_change_low(:,2);
tem_low{1,3} = pain_change_low(:,3);
tem_low{1,4} = pain_change_low(:,4);

cnames_all = {'Sham','10 Hz','20 Hz','70 Hz'};
create_figure('Post vs Pre - Violin for low temp')
h2 = daviolinplot(tem_low, 'colors',color,'outsymbol','k+','violin', 'half2', 'violinwidth', 4, 'boxcolors','same',...
    'box' ,2, 'boxcolors','same','boxalpha', 0.6, 'scatter',1,'scattersize',30,'scatteralpha' , 0.4,'jitter',1 , 'xtlabels', cnames_all,'outliers',0);
ylabel('Post - Pre pain rating')
ylim([-25 30])
xlim([-.01 4.2])
set(gca, 'FontSize', font_size,'FontName', 'Helvetica-Narrow')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 8 7]);
hl = yline(0,'Color',[0.4 0.4 0.4],'LineStyle','--','LineWidth',1.5);
uistack(hl,'bottom')

%% Effect Size

All_rates = [pain_change_high pain_change_low];   % sham_high 10 Hz_high 20 Hz_high 70 Hz_high sham_low 10 Hz_low 20 Hz_low 70 Hz_low
c=[-1 1 0 0 -1 1 0 0; -1 0 1 0 -1 0 1 0;-1 0 0 1 -1 0 0 1; 0 1 0 -1 0 1 0 -1;0 0 1 -1 0 0 1 -1;0 1 -1 0 0 1 -1 0]/2; %contrast

effect_all = All_rates*c';
effectsize{1,1} = effect_all(:,1);
effectsize{1,2} = effect_all(:,2);
effectsize{1,3} = effect_all(:,3);
effectsize{1,4} = effect_all(:,4);
effectsize{1,5} = effect_all(:,5);
effectsize{1,6} = effect_all(:,6);

cnames_effectsize = {'10 vs. Sham','20 vs. Sham','70 vs. Sham','10 vs. 70','20 vs. 70', '10 vs. 20'};
create_figure('Effect size')

color_effect_size = [
    0.80 0.45 0.20;   % 10 vs Sham
    0.10 0.65 0.85;   % 20 vs Sham
    0.55 0.15 0.80;   % 70 vs Sham
    0.90 0.20 0.50;   % 10 vs 70
    0.20 0.70 0.45;   % 20 vs 70
    0.65 0.60 0.35  ]  % 10 vs 20

h3_new = daviolinplot(effectsize, 'colors',color_effect_size, 'outsymbol','k+','violin', 'half2', 'violinwidth', 4, 'boxcolors','same',...
    'box' ,2, 'boxcolors','same','boxalpha', 0.6, 'scatter',1,'scattersize',30,'scatteralpha' , 0.4,'jitter',1 , 'xtlabels', cnames_effectsize,'outliers',0);

ylabel('Stimulation effects on pain sensation')
xlim([0.3 6.2])
ylim([-45 32])
set(gca, 'FontSize', font_size,'FontName', 'Helvetica-Narrow')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 15 8]);

hl = yline(0,'Color',[0.1 0.1 0.1],'LineStyle','--','LineWidth',1.5);
uistack(hl,'bottom')