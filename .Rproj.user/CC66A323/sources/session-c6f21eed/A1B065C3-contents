library(tidyverse)
library(ggplot2)
library(here)

cars_data <- read.csv(here("cleaned_data.csv"))
cars_data <- cars_data |> select(-c("X"))

plot_counts <- function(data, variable, color = "purple", rotate = 0){
  data |> group_by(data[variable]) |>
    ggplot() +
    geom_bar(aes_string(x = variable), fill = color,
             alpha = 0.5, ) +
    theme_bw() + 
    labs(x = variable, y = "Count", 
         title = paste("Counts of", variable)) +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x = element_text(angle = rotate))
}





boxplot_against_responses <- function(data, variable, color = "purple"){
  data |> select(variable, price_usd, log_price) |>
    pivot_longer(price_usd:log_price, names_to = "price_type", 
                 values_to = "price") |> ggplot(aes(y = price)) + 
    geom_boxplot(aes_string(x = variable), fill = color,
                 alpha = 0.3) + 
    facet_wrap(~price_type, ncol = 2, scales = "free",
      labeller = as_labeller(c(log_price = "log(Price USD)",
                              price_usd = "Price USD")) ) + 
    coord_flip() + 
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5))
}


scatterplot_against_responses <- function(data, variable, color = "purple"){
  data |> select(variable, price_usd, log_price) |>
    pivot_longer(price_usd:log_price, names_to = "price_type", 
                 values_to = "price") |> ggplot(aes(y = price)) + 
    geom_point(aes_string(x = variable), fill = color,
                 alpha = 0.3) + 
    facet_wrap(~price_type, ncol = 2, scales = "free",
               labeller = as_labeller(c(log_price = "log(Price USD)",
                                        price_usd = "Price USD")) ) + 
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5))
}

scatterplot_against_responses(cars_data, "year_produced")
scatterplot_against_responses(cars_data, "odometer_value")

