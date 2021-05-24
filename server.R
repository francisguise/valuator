
#
# Demo Shiny app, base for valuation tool
#
library(shiny)
library(simfinR)
library(tidyverse)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))
api_key <- readLines("./api_key.txt")
print("API_KEY: ")
print(api_key)

# get info
df_info_companies <- simfinR_get_available_companies(api_key)
# check it
#glimpse(df_info_companies)


getFinStats <- function(type) {
  
  id_companies <- 111052 # id of APPLE INC
  type_statements <- c(type) # profit/loss
  periods = 'FY' # final year
  years = 2010:2020

  if(type == "bs") {
    periods = "Q4"
    print("hi")
  }
  
  fin_stats <- simfinR_get_fin_statements(id_companies,
                                          type_statements = type_statements,
                                          periods = periods,
                                          year = years,
                                          api_key = api_key
                                          )
  
  glimpse(fin_stats)
  return(fin_stats)
}

getCashFlow <- function() {
  getFinStats("cf")
}

getBalanceSheet <- function() {
  getFinStats("bs")
}

getProfitNLoss <- function() {
  getFinStats("pl")
}

# Define server logic ----
server  <- function(input, output) {
  print(input)
  # Compute formulatext ----
  # Reactive expression shared by output$caption and output$mpgPlot
  formulaText <- reactive({
    paste("simId: ", input$variable)
  })
  
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    formulaText()
  })
  
  cash_flow <- getCashFlow()
  balance_sheet <- getBalanceSheet()
  profit_and_loss <- getProfitNLoss()
  
  net_income <- cash_flow %>% filter(acc_name == 'Cash from Operating Activities')
  print(net_income)
  # Generate a plot of the requested variable against mpg ----
  output$cfPlot <- renderPlot({
    ggplot(
            data = net_income,
            aes(x = ref_date, y = acc_value, colour = "class")
            ) + geom_line() + geom_point()
  })
  
  # Same for balance
  tot_liab_equit <- balance_sheet %>% filter(acc_name == 'Total Liabilities & Equity')
  print(tot_liab_equit)
  # Generate a plot of the requested variable against mpg ----
  output$bsPlot <- renderPlot({
    ggplot(
      data = tot_liab_equit,
      aes(x = ref_date, y = acc_value, colour = "class")
    ) + geom_line() + geom_point()
  })
  
  # Same for balance
  print(profit_and_loss)
  operating_income <- profit_and_loss %>% filter(acc_name == 'Operating Income (Loss)')
  print(operating_income)
  # Generate a plot of the requested variable against mpg ----
  output$plPlot <- renderPlot({
    ggplot(
      data = operating_income,
      aes(x = ref_date, y = acc_value)
    ) + geom_line() + geom_point()
  })

}

