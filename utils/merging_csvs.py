import os
import copy
import pandas as pd
import csv


def merging_csv(directory, output):
    """
    """
    files = [f for f in os.listdir(directory) if os.path.isfile(f)]
    merged = []

    header = None
    for f in files:
        file_name, ext = os.path.splitext(f)
        if ext == '.csv':
            read = pd.read_csv(f)
            merged.append(read)

    result = pd.concat(merged)
    result.to_csv(output)
