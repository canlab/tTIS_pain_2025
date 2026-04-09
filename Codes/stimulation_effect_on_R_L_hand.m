%% Left and right hand for different stimulation
close all
clear
clc

load('T_All_data_post.mat')
T = T_All_data_post;

cnames_all = {'Sham-R','Sham-L','10 Hz-R','10 Hz-L', ...
              '20 Hz-R','20 Hz-L','70 Hz-R','70 Hz-L'};
font_size = 20;

c = [
    0.40 0.76 0.65;   % sham-R
    0.40 0.76 0.65;   % sham-L
    0.99 0.55 0.38;   % 10Hz-R
    0.99 0.55 0.38;   % 10Hz-L
    0.55 0.63 0.80;   % 20Hz-R
    0.55 0.63 0.80;   % 20Hz-L
    0.91 0.54 0.76;   % 70Hz-R
    0.91 0.54 0.76    % 70Hz-L
];

T.Delta = T.Pain_post - T.Pain_pre;

% Normalize Stim to numeric values (0,10,20,70)
if iscategorical(T.Stim_Type) || isstring(T.Stim_Type)
    sstr = string(T.Stim_Type);
    snum = str2double(regexprep(sstr,'[^0-9]',''));
    snum(isnan(snum)) = 0;   % sham -> 0
    T.Stim_TypeNum = snum;
else
    T.Stim_TypeNum = T.Stim_Type;
end

% Ensure Side is categorical
T.Side = categorical(string(T.Side));

subs = unique(T.Sub,'stable');
nS   = numel(subs);
stim_order = [0 10 20 70];
side_order = ["R","L"];

Delta = nan(nS,8);

for i = 1:nS
    sid = subs(i);
    row = T(T.Sub==sid,:);

    col_idx = 0;
    for s = 1:numel(stim_order)
        for r = 1:numel(side_order)
            col_idx = col_idx + 1;

            mask = row.Stim_TypeNum == stim_order(s) & row.Side == side_order(r);
            Delta(i,col_idx) = nanmean(row.Delta(mask));
        end
    end
end

% subject-mean centering
Delta = Delta - mean(Delta,2,'omitnan');

pain_change_sides = cell(1,8);
for k = 1:8
    pain_change_sides{k} = Delta(:,k);
end

figure
hold on

h1 = daviolinplot(pain_change_sides, ...
    'colors', c, ...
    'outsymbol', 'k+', ...
    'violin', 'half2', ...
    'violinwidth', 6, ...
    'box', 2, ...
    'boxcolors', 'same', ...
    'boxalpha', 0.6, ...
    'scatter', 1, ...
    'scattersize', 30, ...
    'scatteralpha', 0.4, ...
    'jitter', 1, ...
    'xtlabels', cnames_all, ...
    'outliers', 0);

% --- Better custom x positions ---
% Increase spacing between R and L within each frequency
% and larger gap between frequency groups
newpos = [1 2.2 3.6 4.8 6.2 7.4 8.8 10];

ax = gca;
objs = ax.Children;

for k = 1:numel(objs)

    % only objects with XData can be shifted
    if ~isprop(objs(k),'XData')
        continue
    end

    xd = objs(k).XData;

    if isempty(xd) || ~isnumeric(xd)
        continue
    end

    % detect which original group this object belongs to
    for i = 1:8
        oldpos = i;

        % if object's x-location is around original group center
        if all(abs(xd - oldpos) < 0.35) || abs(mean(xd,'omitnan') - oldpos) < 0.35
            shift = newpos(i) - oldpos;
            objs(k).XData = xd + shift;
            break
        end
    end
end

set(gca,'XTick',newpos,'XTickLabel',cnames_all)

title('')
ylabel('Post - Pre pain rating ')

xlim([0 10.5])
ylim([-25 30])

set(gca, 'FontSize', font_size, 'FontName', 'Helvetica')
set(gcf, 'Units', 'inches', 'Position', [1, 1, 18, 8])
box off