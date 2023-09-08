library(gridExtra)

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

get_diagnostic_plots <- function(model, superimpose = T){
  resid <-model$residuals
  fitted <- model$fitted.values
  std_res <- (resid-mean(resid))/sd(resid)
  
  res_df_plot <- data.frame(fitted_values = fitted, 
        residuals = resid,
        standardized_residuals = std_res) |>
    ggplot() 
  
  res_v_fitt <- res_df_plot + 
    geom_point(aes(x = fitted_values, y = residuals)) + 
    theme_bw() + 
    labs(x = "Fitted values", y = "Residuals",
         title = "Residual Diagnostic Plot") + 
    theme(plot.title = element_text(hjust = 0.5))
  
  qq <- res_df_plot + 
    geom_qq(aes(sample = standardized_residuals)) + 
    theme_bw() + 
    labs(x = "Theoretical Quantiles", y = "Standardized Residuals",
         title = "QQ Diagnostic Plot") + 
    theme(plot.title = element_text(hjust = 0.5)) 
  
  if(superimpose){
    res_v_fitt <- res_v_fitt + geom_hline(yintercept = 0, color = "red")
    qq <- qq + geom_abline(color = "red") 
  }
  grid.arrange(res_v_fitt, qq, nrow = 1)
}

get_diagnostic_plots(reduced_model)



