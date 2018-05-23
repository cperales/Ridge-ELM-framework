function [ method, metric ] = runAlgorithm( config )
%% READING DATA
nameAlgorithm = config.Algorithm.name;

dataset = config.Data.dataset;
n_folds = length(dataset);
metric = struct('accuracy', 0.0, 'rmse', 0.0,...
                'cross_runtime', 0.0);
metric_acc = [];
metric_time = [];
metric_rmse = [];

for n_f=1:n_folds
    train_name = fullfile(config.Data.folder, config.Data.dataset{n_f}{1});
    train = load(train_name);
    test_name = fullfile(config.Data.folder, config.Data.dataset{n_f}{2});
    test = load(test_name);

    methodConf = struct(config.Algorithm.hyperparameters);

    %% PREPROCESSING
    % Standarizing data
    % Split input and targerts
    trainData = train(:,1:end-1);
    trainTarg = train(:,end);
    testData = test(:,1:end-1);
    testTarg = test(:,end);
    if config.Data.standarized == false
        z_train_data = zscore(trainData);
        trainData = z_train_data;
        z_test_data = zscore(testData);
        testData = z_test_data;
    end

    % Encoding
    trainTencod = targetEncoding(trainTarg, nameAlgorithm);
    testTencod = targetEncoding(testTarg, nameAlgorithm, trainTencod);

    % Average metric
    nRun = 1;  % 5
    acc = 0;
    cross_runtime = 0;
    r = 0;
    for n_r=1:nRun
        %% ALGORITHM'S CONFIGURATION
        eval(['method = ' nameAlgorithm ';']);
        method.setConf(methodConf);
        t = cputime;  % Runtime
        method.config(trainData, trainTencod);
        e = cputime - t;

        %% METRICS
        metrics = config.Report.metrics;
        for i=1:length(metrics)
            metric_function = metrics{i};
            switch metric_function
                case "accuracy"
                    acc = acc + accuracy(method, testData, testTencod);
                case "cross_runtime"
                    cross_runtime = cross_runtime + e;
                case "rmse"
                    r = r + rmse(method, testData, testTencod);
            end
        end
        

    end
    acc = acc / nRun;
    cross_runtime = cross_runtime / nRun;
    r = r / nRun;
    fprintf('Accuracy with %i executions, in n_fold %i = %f\n', ...
            nRun, n_f, acc);
    metric_acc = [metric_acc, acc];
    metric_time = [metric_time, cross_runtime];
    metric_rmse = [metric_rmse, r];
end
metric_acc = mean(metric_acc);
metric_time = mean(metric_time);
metric_rmse = mean(metric_rmse);
fprintf('Accuracy with %i folds, %i executions per fold, algoritm %s and dataset %s = %f\n', ...
            n_folds, nRun, nameAlgorithm, config.Data.folder,  metric_acc);
metric.accuracy = metric_acc;
metric.rmse = metric_rmse;
metric.cross_runtime = metric_time;
end
