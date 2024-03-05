import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsRegressor
from sklearn import ensemble
from sklearn.metrics import mean_squared_error

my_data = pd.read_csv("https://raw.githubusercontent.com/NigelPetersen/UsedCars/main/cleaned_data.csv")
my_data = my_data.drop(columns = ["Unnamed: 0", "price_usd"], axis = 1)
my_data[my_data.select_dtypes("bool").columns] = my_data.select_dtypes('bool').astype("str")

def get_RMSE(array1, array2):
    return np.sqrt(np.mean((array1 - array2)**2))

log_price = my_data["log_price"]
features = my_data.drop(columns = ["log_price"], axis = 1)
my_features = pd.get_dummies(features)
X_train, X_test, y_train, y_test = train_test_split(my_features, log_price, test_size = 0.3, random_state = 666)

k_values = np.arange(1,51, 1)
d = {"K": k_values, "Training Error": [], "Test Error": []}
for k in k_values:
    model = KNeighborsRegressor(n_neighbors = k, weights = "distance").fit(X_train, y_train)
    d["Training Error"].append(get_RMSE(model.predict(X_train), y_train))
    d["Test Error"].append(get_RMSE(model.predict(X_test), y_test))

plt.plot(d["K"], d["Test Error"])
plt.xlabel("K: Number of Nearest Neighbours")
plt.ylabel("Test Error (RMSE)")
plt.title("Test Error against Number of Nearest Neighbours")
plt.show()


params = {
    "n_estimators": 500,
    "max_depth": 10,
    "min_samples_split": 2,
    "learning_rate": 0.01,
    "loss": "squared_error",
} 
my_model = ensemble.GradientBoostingRegressor(**params).fit(X_train, y_train)
test_score = np.zeros((params["n_estimators"],), dtype=np.float64)
for i, y_pred in enumerate(my_model.staged_predict(X_test)):
    test_score[i] = mean_squared_error(y_test, y_pred)

fig = plt.figure(figsize=(6, 6))
plt.subplot(1, 1, 1)
plt.plot(
    np.arange(params["n_estimators"]) + 1,
    my_model.train_score_,
    "blue",
    label="Training Set Deviance",)

plt.plot(
    np.arange(params["n_estimators"]) + 1, 
    test_score, 
    "red", 
    label="Test Set Deviance")
plt.legend(loc="upper right")
plt.xlabel("Boosting Iterations")
plt.ylabel("Deviance")
plt.title("Deviance")
fig.tight_layout()
plt.show()