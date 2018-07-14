# MATLAB framework for ELM / Kernel Ridge research

Main motivation of this repository is to create a whole framework with preprocessing functionsa and parallelizations for running tests related with my thesis research done in [Universidad Loyola Andalucía](https://www.uloyola.es/investigacion/departamentos/metodos-cuantitativos) with Extreme Learning Machine, a.k.a. Kernel Ridge Classification.

A preliminary study about diversity in ensembles where sended to HAIS 2018. Paper can be read [here](https://link.springer.com/chapter/10.1007/978-3-319-92639-1_25) and presentation is online available [here](https://www.slideshare.net/CarlosPerales/a-preliminary-study-of-diversity-in-elm-ensembles-hais-2018).

## Data

A folder with `data` is mandatory. This folder contains subfolders, each one with k-folds for cross validation. All this structure can be created with [uci-download-process repository](https://github.com/cperales/uci-download-process) just running the script in the repository, as it is pointed at its [README](https://github.com/cperales/uci-download-process/blob/master/README.md).

## JSON configuration files

The config files can be created by running

```bash
python utils/writing_json.py
```

The python script read the templates from `utils/template.py`, the selected datasets from `utils/selected_datasets` and data available in the `data/` folder. If no dataset is specified, then the config files will cointain all the datasets.

These config files have

- Running parameters (datasets, where to find them, where report the CSV with the metrics...)
- Hyperparameters for cross validation, which are selected from `utils/template.py`.

## Example

To run an example, just open MATLAB and run `script_experiment.m`. It will read config files from `config/`, calculate some metrics in a 10 stratified fold cross validation with 5 nested fold cross validation for hyperparameters, and store the metric results in CSV format in `experiment/`.

## Parallelization

For parallelization, [PYLM](https://pypi.org/project/pylm/) library is used. Bash files from `pylm_scripts` folder are used.

```bash
bash pylm_scripts/set_up.sh
bash pylm_scripts/run_all_config.sh
```

And, when finished,

```bash
bash pylm_scripts/kill_workers.sh
```

But first MATLAB engine for python must be installed, as described in MATLAB documentation [here](https://es.mathworks.com/help/matlab/matlab-engine-for-python.html) and [here](https://es.mathworks.com/help/matlab/matlab_external/install-matlab-engine-api-for-python-in-nondefault-locations.html).

## Documentation

Documentation of the code can be readed [here](https://cperales.github.io/Ridge-ELM-framework/)

## Bibliography

Algorithms have been implemented from different papers:

* ELM (neuronal and kernel versions) [1]
* Diverse ELM [2]
* AdaBoost ELM [3]
* Bagging ELM [4]
* Adaboost Negative Correlation ELM [5]
* Adaboost Boosting Ridge [6]


[1] G.-B. Huang, H. Zhou, X. Ding, and R. Zhang, “Extreme learning machine for regression and multiclass classification,” IEEE Transactions on Systems, Man, and Cybernetics. Part B, Cybernetics, vol. 42, no. 2, pp. 513–29, 2012.
[2] C. Perales-Gonz´alez, M. Carbonero-Ruz, D. Becerra-Alonso, and F. Fern´andez-Navarro, “A preliminary study of diversity in extreme learning machines ensembles,” in Lecture Notes in Computer Science, pp. 302–314, Springer International Publishing, 2018
[3] A. Riccardi, F. Fern´andez-Navarro, and S. Carloni, “Cost-sensitive AdaBoost algorithm for ordinal regression based on extreme learning machine,” IEEE Transactions on Cybernetics, vol. 44, no. 10, pp. 1898–1909, 2014.
[4] H. Tian and B. Meng, “A new modeling method based on bagging elm for day-ahead electricity price prediction,” in Bio-Inspired Computing: Theories and Applications (BIC-TA), 2010 IEEE Fifth International Conference on, pp. 1076–1079, IEEE, 2010.
[5] S. Wang, H. Chen, and X. Yao, “Negative correlation learning for classification ensembles,” Proceedings of the International Joint Conference on Neural Networks, 2010.
[6] Y. Ran, X. Sun, H. Sun, L. Sun, X. Wang, and W. X. Ran Y, Sun X, Sun H, Sun L, “Boosting Ridge Extreme Learning Machine,” Proceedings - 2012 IEEE Symposium on Robotics and Applications, ISRA 2012, pp. 881–884, 2012.
