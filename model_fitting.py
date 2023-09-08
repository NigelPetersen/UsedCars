import pandas as pd
import numpy as np
import sklearn
from random import sample
from itertools import compress
import rpy2.robjects as robjects
from sklearn.neighbors import KNeighborsRegressor

raw_cars_data = pd.get_dummies(raw_cars_data)
cars_data = raw_cars_data.reset_index().drop("index", axis = 1)

indices = np.array(list(robjects.r("""
set.seed(666)
indices <- sample(c(0, 1), size = 37660,
            replace = T, prob = c(0.8, 0.2))
""")))

training_data = cars_data.loc[np.where(indices < 1)[0], :]
test_data = cars_data.loc[np.where(indices > 0)[0], :]

X_train = training_data.drop(["price_usd", "log_price"], axis = 1)
y_train = training_data.loc[:, ["log_price"]]
X_test = test_data.drop(["price_usd", "log_price"], axis = 1)
y_test = test_data.loc[:, ["log_price"]]
