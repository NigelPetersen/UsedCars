library(ggpubr)

source(here("EDA.R"))

# train test split

indices <- sample(c("train", "test"), size = nrow(cars_data),
                  replace = T, prob = c(0.8, 0.2))

training_data <- cars_data[which(indices == "train"), ]
test_data <- cars_data[which(indices == "test"), ]

full_model <- lm(log_price ~., data = training_data)
summary(full_model)
par(mfrow = c(2,2))
plot(full_model)

reduced_model <- step(full_model, direction = "backward",
                      trace = 0)
summary(reduced_model)
plot(reduced_model)


reduced_residuals <- reduced_model$residuals
reduced_fitted <- reduced_model$fitted.values

res_df_plot <- data.frame(fitted = reduced_fitted, 
          residuals = reduced_residuals,
  stnd_res = (reduced_residuals - mean(reduced_residuals))/sd(reduced_residuals)) |>
  ggplot() 

res_v_fitt <- res_df_plot + 
  geom_point(aes(x = fitted, y = residuals)) + 
  theme_bw() + 
  labs(x = "Fitted values", y = "Residuals",
       title = "Residual Diagnostic Plot") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_hline(yintercept = 0, color = "red")

qq <- res_df_plot + 
  geom_qq(aes(sample = stnd_res)) + 
  theme_bw() + 
  labs(x = "Theoretical Quantiles", y = "Residuals",
       title = "QQ Diagnostic Plot") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_abline(color = "red") + 
  coord_fixed()



