
#
# Demo Shiny app, base for valuation tool
#
library(shiny)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))
api_key <- readLines("./api_key.txt")
print("API_KEY: ")
print(api_key)

# get info
df_info_companies <- simfinR_get_available_companies(api_key)
# check it
glimpse(df_info_companies)

source(server.R)
source(app.R)

shinyApp(ui, server)
