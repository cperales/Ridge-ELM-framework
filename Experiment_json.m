function [result_json] = Experiment_json(json_str)
% This function is used along PYLM library, in order to paralelize
% the experiments.

addpath('./algorithm')
addpath('./ensemble')
addpath('./generic')
addpath('./metric')
addpath('./utils')
addpath('./experiment')
addpath('./target_encode')
addpath('addons/jsonlab-1.5');

try
    config = loadjson(json_str);
catch ME
    fprintf('JSON %s no es válido\n', json_str);
    throw(ME)
end

str = [config.Report.folder, config.Algorithm.name, '_', ...
    config.Report.report_name, '_', datestr(datetime('today')), '.csv'];
fprintf('File to save: %s\n', str);
fid = fopen(str, 'w');
fprintf(fid, 'Dataset;');
metric_fields = [];
for index_metric=1:length(config.Report.metrics)
    metric = config.Report.metrics{index_metric};
    fprintf(fid, '%s;', metric);
    metric_fields = [metric_fields, metric];
end
fprintf(fid, 'runtime;');
fprintf(fid, '\n');
% try
t = cputime;
[algorithm, metric] = runAlgorithm(config);
e = cputime - t;
dataset_name = config.Report.report_name;
algorithm_json = struct('Algorithm', config.Algorithm.name, ...
                        'Dataset', dataset_name, ...
                        'Runtime', e);
fprintf(fid, '%s;', dataset_name);
metric_struct = struct();
for j=1:length(metric_fields)
    metric_field = metric_fields{j};
    metric_value = getfield(metric, metric_field);
    fprintf('Metric: %s, value = %f\n', metric_field, metric_value);
    metric_struct = setfield(metric_struct, metric_field, metric_value);
    fprintf(fid, '%f;', metric_value);
end
fprintf(fid, '%f;', e);
algorithm_json.Metrics = metric_struct;
fprintf(fid, '\n');
fclose(fid);
result_json = jsonencode(algorithm_json);
end