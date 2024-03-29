# -*- coding: utf-8 -*-
"""PreProcessedData.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1Bs3p9GgNd8FlsavqYOcX65RmFTrhj12M
"""

# Code to add in a "time_delayed" column into the CSV
# Code breaks for 100k and flights_full due to one row having time of "5" which
#   is meant to represent 00:05

import pandas as pd

files = ["flights2k.csv", "flights10k.csv"]


def add_delay_column(df):
  print(df.head())
  # calculate the delay time as the difference between actual departure time and scheduled departure time
  df['time_delayed'] = pd.to_datetime(df['DEP_TIME'], format='%H%M', errors='coerce') - pd.to_datetime(df['CRS_DEP_TIME'], format='%H%M')
  df['time_delayed'] = df['time_delayed'].dt.total_seconds().div(60).astype(float)
  return df


for file in files:
  print(file)
  df = add_delay_column(pd.read_csv("/content/drive/MyDrive/ProgrammingProject/" + file))
  df.to_csv(file + "_new", index=False)
  print(df.head())
