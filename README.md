# MATLAB framework for ELM / Kernel Ridge research

Main motivation of this repository is to create a whole framework (preprocessing functions, parallelizations) for running tests related with research done in [Universidad Loyola Andalucía] with Ridge Classification / ELM.

## Data

A folder with `data` is mandatory. It can be created with [uci-download-process repository](https://github.com/cperales/uci-download-process), as it is pointed at its [README](https://github.com/cperales/uci-download-process/blob/master/README.md)

## JSON configuration files

The config files can be created by running

```bash
python utils/writing_json.py
```

These config files have

- Running parameters (datasets, where to find them, ...)
- Hyperparameters for cross validation, which are selected from `utils/template.py`.

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
