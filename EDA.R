library(tidyverse)
library(ggplot2)
library(here)

cars_data <- read.csv(here("cleaned_data.csv"))
cars_data <- cars_data |> select(-c("X"))

plot_counts <- function(data, variable, color = "purple", 
                        rotate = 0, add_unif = F){
  my_plot <- data |> group_by(!!sym(variable)) |>
    ggplot() +
    geom_bar(aes(x = !!sym(variable)), fill = color,
             alpha = 0.5, ) +
    theme_bw() + 
    labs(x = variable, y = "Count", 
         title = paste("Counts of", variable)) +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x = element_text(angle = rotate))
  if(add_unif){
    y_int = nrow(data)/length(unique(data[,variable]))
    my_plot + geom_hline(yintercept = y_int, linetype = "dashed",
                         color = color)
  }
  else{
    my_plot
  }
}


get_proportions <- function(data, variable){
  data |> group_by(!!sym(variable)) |>
    summarise(n = n()) |>
    mutate(proportion = 100*n/sum(n)) |>
    select(-c(n))
}


boxplot_against_responses <- function(data, variable, color = "purple"){
  data |> select(variable, price_usd, log_price) |>
    pivot_longer(price_usd:log_price, names_to = "price_type", 
                 values_to = "price") |> ggplot() + 
    geom_boxplot(aes(x = reorder(!!sym(variable), price), y = price), fill = color,
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
    geom_point(aes(x = !!sym(variable)), fill = color,
                 alpha = 0.3) + 
    facet_wrap(~price_type, ncol = 2, scales = "free",
               labeller = as_labeller(c(log_price = "log(Price USD)",
                                        price_usd = "Price USD")) ) + 
    theme_bw() + 
    theme(plot.title = element_text(hjust = 0.5))
}


cars_data |> group_by(manufacturer_name) |> 
  summarise(avg_price = mean(price_usd), avg_year_prod = round(mean(year_produced)),
            avg_odom = mean(odometer_value)) |> 
  arrange(-avg_price) |> print(n=50)


summary_table <- function(data, variable, highest_first = T){
  tab <- data |> group_by(!!sym(variable)) |>
    summarise(avg_price = mean(price_usd), avg_year = round(mean(year_produced)),
              avg_odom = mean(odometer_value)) |>
    arrange((-1)^highest_first * avg_price)
  
  tab["prop"] <- get_proportions(data, variable)[,2]
  
  tab |> print(n = nrow(cars_data))
}


cars_data |> mutate(transmission = recode(transmission, "mechanical" = "manual")) |>
  group_by(color) |>
  ggplot() +
  geom_boxplot(aes(x = color, y = log_price, fill = transmission)) +
  theme_bw() + 
  labs(x = "Vehicle Color", y = "log(Price USD)", 
       title = "log(Price USD) Across Vehicle Colors by Transmission") + 
  theme(plot.title = element_text(hjust = 0.5))



cars_data |> mutate(transmission = recode(transmission, "mechanical" = "manual")) |>
  group_by(manufacturer_name) |>
  ggplot() +
  geom_boxplot(aes(x = manufacturer_name, y = price, fill = transmission)) + 
  theme_bw() +
  labs(x = "Vehicle Manufacturer", y = "log(Price USD)",
       title = "log(Price USD) against Manufacturer across Transmission") +
  theme(plot.title = element_text(hjust = 0.5)) +
  coord_flip()
  

##################################################################################
############################# FUNCTION CALLS #####################################
##################################################################################

plot_counts(cars_data, "color")

boxplot_against_responses(cars_data, "body_type")

scatterplot_against_responses(cars_data, "year_produced")
scatterplot_against_responses(cars_data, "odometer_value")

summary_table(cars_data, "manufacturer_name")
get_proportions(cars_data, "state")
summary_table(cars_data, "manufacturer_name")

  
