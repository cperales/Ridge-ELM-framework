## Parameters
C_grid = [10**i for i in range(-2, 3)]
D_grid = C_grid
k_grid = C_grid
hidden_neurons_grid = [10*i for i in range(1, 21)]
ensemble_size = 5
lambda_grid = [0.25, 0.5, 1, 5, 10]
r_grid = [0.1, 0.2, 0.3, 0.4, 0.5]
ensemble_metrics = ["accuracy",
                    "diversity",
                    "kernel_diversity",
                    "rmse",
                    "cross_runtime"]
simple_metrics = ["accuracy",
                  "rmse",
                  "cross_runtime"]


## KELM
kernel_config_name = 'KELM_multiprueba.json'

kernel_json_template = {
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "KELM",  # KSVM, NELM, NELM
    "hyperparameters": {
      "type": "CCA",
      "C": C_grid,
      "k": k_grid,
      "kernelFun": "rbf",
      "type": "kernel"
    }
   },
   "Report": {
     "folder": "experiment/",
     "report_name": "experiment",
     "metrics": simple_metrics
   }
}

kernel_tuple = kernel_config_name, kernel_json_template


## NELM
neural_config_name = 'NELM_multiprueba.json'

neural_json_json_template = {
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "NELM",  # KSVM, NELM, NELM
    "hyperparameters": {
      "C": C_grid,
      "hiddenNeurons": hidden_neurons_grid,
      "neuronFun": "sigmoid",
      "type": "neuralNetwork"
    }
   },
   "Report": {
     "folder": "experiment/",
     "report_name": "experiment",
     "metrics": simple_metrics
   }
}

neural_tuple = neural_config_name, neural_json_json_template

## Adaboost
adaboost_json_template = {  # Also BRNELM
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "AdaBoostNELM",  # KSVM, NELM, NELM
    "hyperparameters": {
      "C": C_grid,
      "hiddenNeurons": hidden_neurons_grid,
      "ensembleSize": ensemble_size,
      "neuronFun": "sigmoid",
      "type": "neuralNetwork"
    }
   },
   "Report": {
     "folder": "experiment/",
     "report_name": "experiment",
     "metrics": ensemble_metrics
   }
}

adaboost_config_name = 'AdaBoostNELM_multiprueba.json'

adaboost_tuple = adaboost_config_name, adaboost_json_template

## Adaboost Boosting Ridge
adaboost_br_json_template = adaboost_json_template
adaboost_br_config_name = 'AdaBoostBRNELM_multiprueba.json'
adaboost_br_tuple = adaboost_br_config_name, adaboost_br_json_template

## Adaboost Negative Correlation
adaboost_nc_json_template = {
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "AdaBoostNCNELM",
    "hyperparameters": {
      "C": C_grid,
      "hiddenNeurons": hidden_neurons_grid,
      "lambda": lambda_grid,
      "ensembleSize": ensemble_size,
      "neuronFun": "sigmoid",
      "type": "neuralNetwork"
    }
   },
   "Report": {
     "folder": "experiment/",
     "report_name": "experiment",
     "metrics": ensemble_metrics
   }
}

adaboost_nc_config_name = 'AdaBoostNCNELM_multiprueba.json'
adaboost_nc_tuple = adaboost_nc_config_name, adaboost_nc_json_template


## Bagging NELM
bagging_json_template = {
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "BaggingNELM",
    "hyperparameters": {
      "C": C_grid,
      "hiddenNeurons": hidden_neurons_grid,
      "ensembleSize": ensemble_size,
      "neuronFun": "sigmoid",
      "type": "neuralNetwork"
    }
   },
   "Report": {
     "folder": "experiment/",
     "report_name": "experiment",
     "metrics": ensemble_metrics
   }
}

bagging_config_name = 'BaggingNELM_multiprueba.json'
bagging_tuple = bagging_config_name, bagging_json_template

algorithms_dict = {'NELM': neural_tuple,
                   'AdaBoostNCNELM': adaboost_nc_tuple,
                   'AdaBoostBRNELM': adaboost_br_tuple,
                   'AdaBoostNELM': adaboost_tuple,
                   'BaggingNELM': bagging_tuple,
                   'KELM': kernel_tuple}
