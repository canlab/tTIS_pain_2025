close all
clc
load('T_All_data_post.mat')

font_size = 20;
data = T_All_data_post;


%% Fit reduced model (excluding tTIS and run and trial to leave those effects in the data)
reducedModel = fitlme(data, ...
    'Pain_post ~ 1 + Pain_pre + stim_order  + age + gender + Session + (Temp * Side ) + (1 + Temp   | Sub)', 'DummyVarCoding', 'reference');

fitted_vals = fitted(reducedModel);
data.correctedPain = data.Pain_post - fitted_vals;

%%  Define conditions and trials
figure;
hold on;

runs = unique(data.Run);     % (mean-centered [1 2 3 4])
conds = unique(data.Stim_Type);   %Sham, 10, 20, 70

colors = [
    0.40 0.76 0.65;
    0.99 0.55 0.38;
    0.55 0.63 0.80;
    0.91 0.54 0.76
    ];

nTrials = 12;
totalX = nTrials * length(runs);

% Preallocate
raw_mean_seq = zeros(nTrials * length(runs), length(conds));
raw_sem_seq = zeros(nTrials * length(runs), length(conds));

conds = unique(data.Stim_Type);
runs = unique(data.Run);     % mean-centered [1 2 3 4]
trials = unique(data.Trial); % mean-centered [1:12]

nCond = length(conds);
nRun = length(runs);
nTrial = length(trials);

% Preallocate matrices
raw_mean_matrix  = nan(nCond, nRun, nTrial);
raw_sem_matrix   = nan(nCond, nRun, nTrial);
raw_count_matrix = zeros(nCond, nRun, nTrial);

for c = 1:nCond
    for r = 1:nRun
        for t = 1:nTrial
            mask = (data.Stim_Type == conds(c)) & (data.Run == runs(r)) & (data.Trial == trials(t));
            vals = data.correctedPain(mask);

            raw_mean_matrix(c, r, t)  = mean(vals, 'omitnan');
            raw_sem_matrix(c, r, t)   = std(vals, 'omitnan') / sqrt(sum(~isnan(vals)));
            raw_count_matrix(c, r, t) = sum(~isnan(vals));
        end
    end
end
% Plot corrected pain by condition across runs with trial separation
figure;
hold on;

nCond = size(raw_mean_matrix, 1);   % Number of conditions
nRun  = size(raw_mean_matrix, 2);   % Number of runs (e.g., 4)
nTrial = size(raw_mean_matrix, 3);  % Number of trials per run (e.g., 12)
totalX = nRun * nTrial;

% Loop through conditions
for c = 1:nCond
    for r = 1:nRun
        % Define X values for this run
        x_vals = ((r - 1) * nTrial + 1):(r * nTrial);

        % Extract Y values
        y_vals = squeeze(raw_mean_matrix(c, r, :));  % 12×1
        y_sem  = squeeze(raw_sem_matrix(c, r, :));   % 12×1

        % Plot this run segment for current condition
        errorbar(x_vals, y_vals, y_sem, ...
            'LineWidth', 2, 'Color', colors(c, :));
    end
end

% Add vertical lines to separate runs (no text)
xline(nTrial + 0.5, '--k');
xline(2 * nTrial + 0.5, '--k');    % Between Run 2 and 3

% Axis and formatting
xlabel('Trial Number');
ylabel('Pain Rating (Covariate-Adjusted)');
title('Post TI');
legend('Sham', '10 Hz', '20 Hz', '70 Hz', 'Location', 'Best');

xticks(1:totalX);
xticklabels(repmat(string(1:nTrial), 1, nRun));
xtickangle(0);

set(gca, 'FontSize', font_size, 'FontName', 'Helvetica-Narrow');
set(gcf, 'Units', 'inches', 'Position', [1, 1, 18, 8]);
