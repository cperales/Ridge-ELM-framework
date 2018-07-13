## Parameters
c = 2
C_grid = [10**i for i in range(-c, c + 1)]
D_grid = C_grid
k_grid = C_grid
hidden_neurons_grid = [10*i for i in range(1, 5 + 1)]
ensemble_size = 5
lambda_grid = [0.25, 0.5, 1, 5, 10]
ensemble_metrics = ["accuracy",
                    "diversity",
                    "rmse",
                    "cross_runtime"]
simple_metrics = ["accuracy",
                  "rmse",
                  "cross_runtime"]


## KELM
kernel_config_name = 'KELM'

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
neural_config_name = 'NELM'

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

adaboost_config_name = 'AdaBoostNELM'
adaboost_tuple = adaboost_config_name, adaboost_json_template

## Adaboost Boosting Ridge
adaboost_br_json_template = {
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "AdaBoostBRNELM",
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
adaboost_br_json_template = adaboost_br_json_template
adaboost_br_config_name = 'AdaBoostBRNELM'
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

adaboost_nc_config_name = 'AdaBoostNCNELM'
adaboost_nc_tuple = adaboost_nc_config_name, adaboost_nc_json_template

## Diverse NELM
diverse_json_template = {
  "Data": {
    "dataset": ".",
    "folder": ".",
    "standarized": False
    },
  "Algorithm": {
    "name": "DiverseNELM",
    "hyperparameters": {
      "C": C_grid,
      "hiddenNeurons": hidden_neurons_grid,
      "D": D_grid,
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

diverse_config_name = 'DiverseNELM'
diverse_tuple = diverse_config_name, diverse_json_template

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

bagging_config_name = 'BaggingNELM'
bagging_tuple = bagging_config_name, bagging_json_template

algorithms_dict = {'DiverseNELM': diverse_tuple,
                   'AdaBoostNCNELM': adaboost_nc_tuple,
                   'AdaBoostBRNELM': adaboost_br_tuple,
                   'AdaBoostNELM': adaboost_tuple,
                   'NELM': neural_tuple,
                   'Miller_NELM': miller_neural_tuple,
                   'KELM': kernel_tuple,
                   'BaggingNELM': bagging_tuple}
