
#
# Demo Shiny app, base for valuation tool
#
library(shiny)
library(shinythemes)

api_key <- readLines("./api_key.txt")
print("API_KEY: ")
print(api_key)

# get info
df_info_companies <- simfinR_get_available_companies(api_key)
# check it
glimpse(df_info_companies)

v <- c(
  "Cylinders" = "cyl",
  "Transmission" = "am",
  "Gears" = "gear"
)

print(v)
print("-------------------------------------------------")
#print(df_info_companies[,2:3])
#print(typeof(df_info_companies))

choices <- df_info_companies$ticker
choices <- df_info_companies$simId

names(choices) <- df_info_companies$name
#print(choices)

#print(n)

# Define UI for mpg app
ui <- fluidPage(
  theme = shinytheme("superhero"),
  
  # Title
  titlePanel("Miles Per Gallon"),
  
  sidebarLayout(
    # Sidebar Panel for inputs
    sidebarPanel(
      
      selectInput(
        "variable",
        "Company:",
        choices
      ),

      # Checkbox input
      checkboxInput("outliers","Show outliers", TRUE),
      # Theme selector - umcomment to test
      #themeSelector()
    ),
    # Main panel for displaying outputs
    mainPanel(
      
      # Output: formatted text for caption ----
      h3(textOutput("caption")),
      
      # Output: Plot of the requested variable against mpg
      #plotOutput("mpgPlot")
      tabsetPanel(
        tabPanel("Cashflow", plotOutput("cfPlot")),
        tabPanel("Balance", plotOutput("bsPlot")),
        tabPanel("P&L", plotOutput("plPlot")),
        tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  )
)

