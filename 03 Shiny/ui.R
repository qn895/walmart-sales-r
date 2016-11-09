#ui.R 
# PROJECT 4

library(shiny)
require(shinydashboard)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Project 5!"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    
    # Dropdown to decide which colum to plot the histogram of 
    h3("Bar Chart Options"),
    selectInput('bar_chart_filter', 'Select Which Year To Show', list("All Years", "2010","2011","2012"),selected="All Years"),
    actionButton(inputId="plotBarChart", label="Plot or Update Bar Chart"),
    
    
    # Dropdown to decide which colum to plot the k-means of _
    h3("Weekly Sales Sum Options"),
    selectInput('scatter_plot_filter', 'Which Store Type', list("Both Types", 'Type A', 'Type B'), selected = 'Both Types'),
    actionButton(inputId="plotScatterPlot", label="Plot or Update Scatter Plot"),
    
    
    h3("Eliminate Weekly Sales Outliers From Data"),
    sliderInput("crosstab_filter", 
                label = ("When performing sales averages for the stores, eliminate outliers from the data"), 
                min = -5000, 
                max = 600000, 
                value = c(-5000, 600000)),
    actionButton(inputId="plotCrossTab", label="Plot or Update Cross Tab")
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("barPlot"),
    plotOutput("scatterPlot"),
    plotOutput("crosstabPlot1"),
    plotOutput("crosstabPlot2")
  )
))
