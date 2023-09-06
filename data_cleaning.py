import pandas as pd
import numpy as np
import sklearn
from random import sample
from itertools import compress

raw_cars_data = pd.read_csv("https://raw.githubusercontent.com/NigelPetersen/STA2101-data/main/cleaned_cars.csv")
raw_cars_data = raw_cars_data.dropna()
raw_cars_data = raw_cars_data.drop("location_region", axis = 1)

def get_proportions(var):
    d = {}
    for value in list(raw_cars_data[var].unique()):
        d[value] = [100*len(raw_cars_data.loc[raw_cars_data[var] == value])/len(raw_cars_data)]
    return pd.DataFrame(d)
get_proportions("engine_fuel")
raw_cars_data["engine_fuel"] = raw_cars_data["engine_fuel"].replace("gas", "gasoline")
raw_cars_data["engine_fuel"] = raw_cars_data["engine_fuel"].replace(["hybrid-petrol", "hybrid-diesel", "electric"], "other")
get_proportions("engine_type")
raw_cars_data = raw_cars_data.drop("engine_type", axis = 1)
raw_cars_data["body_type"] = raw_cars_data["body_type"].replace("cabriolet", "convertible")
raw_cars_data = raw_cars_data.drop("model_name", axis = 1)

raw_cars_data = raw_cars_data.loc[raw_cars_data["price_usd"] >= 100]
raw_cars_data["log_price"] = np.log(raw_cars_data["price_usd"])

# count number of additional features
columns = list(raw_cars_data.columns)
start = columns.index("feature_0")
stop = columns.index("feature_9") + 1


raw_cars_data["feature_count"] = raw_cars_data.loc[:,columns[start:stop]].sum(axis = 1)
raw_cars_data = raw_cars_data.drop(columns = columns[start:stop])
raw_cars_data = raw_cars_data.drop("up_counter", axis = 1)

