%% For profiling
maxNumCompThreads(1);
clear;
% NELM
tic;
profile on
maxNumCompThreads(1);
Experiment('NELM', 'prueba');
profile off
toc;
profsave(profile('info'), 'profiling/NELM_prueba')
clear;
% DiverseNELM
tic;
profile on
maxNumCompThreads(1);
Experiment('DiverseNELM', 'prueba');
profile off
toc;
profsave(profile('info'), 'profiling/KELM_prueba')
clear;