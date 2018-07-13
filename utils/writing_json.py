import os
import json
import copy
from template import *
from selected_datasets import datasets

# # Folder to search the data
data_folder = 'data'
config_folder = 'config'

# # Francisco's tests
francisco_tests = os.listdir(data_folder)

# List of the pair directory / data
pair_dir_files = []

values = [str(i) for i in range(10)]

copy_data_folder = os.listdir(data_folder)

rejected = []
for dirname in os.listdir(data_folder):
    name = dirname
    dirname = os.path.join(data_folder, dirname)
    possible_file = os.path.join(dirname, name)
    if name in datasets or len(datasets) == 0:
        valid_filenames = []
        copy_data_folder.remove(name)
        for filename in os.listdir(dirname):
            if filename[-1] in values:
                valid_filenames.append(filename)
        if len(valid_filenames) > 0:
            pair_dir_files.append((dirname, valid_filenames))
    else:
        rejected.append(name)

for dirname, filenames in pair_dir_files:
    print('{} is valid'.format(dirname))

for name in rejected:
    print('{} not in selected datasets'.format(name))

print('There are {} datasets'.format(len(pair_dir_files)))
if len(pair_dir_files) == 1:
    dataset_name = pair_dir_files[0][0].split('/')[1]
else:
    dataset_name = 'multiprueba'

if len(copy_data_folder) > 0:
    print('These folders have not been analyzed')
    print(copy_data_folder)
    print()

algorithms = ['AdaBoostNCNELM',
              'AdaBoostBRNELM',
              'AdaBoostNELM',
              'NELM',
              'KELM',
              'BaggingNELM']

# All the train-test file names are stored, along their directory name.
for algorithm in algorithms:
    algorithm_tuple = algorithms_dict[algorithm]
    config_name, dict_template = algorithm_tuple
    config_name = '.'.join(['_'.join([config_name, dataset_name]), 'json'])

    # A list of tests in a JSON
    list_of_experiments = []

    for dirname, file_names in pair_dir_files:
        each_dict = copy.deepcopy(dict_template)

        list_train_file_names = [file_name for file_name in file_names
                                 if 'train' in file_name]

        list_test_file_names = [file_name for file_name in file_names
                                if 'test' in file_name]

        name_dataset = list_train_file_names[0][:-2]
        name_dataset = name_dataset.replace('train_', '')

        dataset = []
        for train_file in list_train_file_names:
            number_train_file = train_file[-1]
            test_file = train_file  # If no test file has been found
            
            for t in list_test_file_names:
                if number_train_file in t:
                    test_file = t
                    list_test_file_names.remove(t)
                    break

            dataset.append([train_file, test_file])

        # if dataset in francisco_tests:
        each_dict["Data"]["dataset"] = dataset
        each_dict["Data"]["folder"] = dirname
        each_dict["Report"]["report_name"] = name_dataset

        list_of_experiments.append(each_dict)

    with open(os.path.join(config_folder, config_name), 'w') as outfile:
        json.dump(list_of_experiments, outfile)
