function [algorithm_cell] = Experiment(algorithm_name, json_file_name, output_file_name)
% This function run the cross validation for
% the algorithm name, searching the data specified in the JSON

addpath('./algorithm')
addpath('./ensemble')
addpath('./generic')
addpath('./metric')
addpath('./utils')
addpath('./experiment')
addpath('./target_encode')
addpath('addons/jsonlab-1.5');

% Values are obtained from a JSON file

% If it is not specified, output file name is same as json file
if nargin < 3
    output_file_name = json_file_name;
end

json_name = ['config/', algorithm_name, '_', json_file_name, '.json'];

try
    config = loadjson(json_name);
catch ME
    fprintf('Fichero %s no existe\n', json_name);
    throw(ME)
end

str = ['experiment/', algorithm_name, '_', output_file_name, '_', ...
    datestr(datetime('today')), '.csv'];
fid = fopen(str, 'w');
fprintf(fid, 'Dataset;');

% JSON configurations are added as list of JSONs, i.e.: [ {...}, {...}] in
% the same file. Even if there is just one configuration, i.e.: [ {...} ]
config_cell = config;
algorithm_cell = cell(length(config_cell), 3);
metric_fields = [];
for index_metric=1:length(config_cell{1}.Report.metrics)
    metric = config_cell{1}.Report.metrics{index_metric};
    fprintf(fid, '%s;', metric);
    metric_fields = [metric_fields, metric];
end
fprintf(fid, 'runtime;');
fprintf(fid, '\n');
n = size(config_cell, 2);
for i=1:n
    try
        t = cputime;
        [algorithm, metric] = runAlgorithm(config_cell{1, i});
        e = cputime - t;
        dataset_name = config_cell{1, i}.Report.report_name;
        fprintf(fid, '%s;', dataset_name);
        for j=1:length(metric_fields)
            metric_value = getfield(metric, metric_fields{j});
            fprintf(fid, '%f;', metric_value);
        end
        fprintf(fid, '%f;', e);
        fprintf(fid, '\n');
    catch e
        warning('Algorithm %i failed, due to %s\n', i, e.message);
        warning('File %s, line %i\n', i, e.stack(1).file, e.stack(1).line);
    end
end
fclose(fid);