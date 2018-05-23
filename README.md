# MATLAB framework for ELM / Kernel Ridge research

Main motivation of this repository is to create a whole framework (preprocessing functions, paralelizations) for running tests related with research done in [Universidad Loyola Andalucía] with Ridge Classification / ELM.

## Data

A folder with `data` is mandatory. It can be created with [uci-download-process repository](https://github.com/cperales/uci-download-process), as it is pointed at its [README](https://github.com/cperales/uci-download-process/blob/master/README.md)

## JSON configuration files

The config files can be created by running

```bash
python utils/writing_json.py
```

These config files have

- Running parameters (datasets, where to find them, ...)
- Hyperparameters for cross validation.

## Paralelization

For paralelization, [PYLM](https://pypi.org/project/pylm/) library is used. Bash files from `pylm_scripts` folder are used.
