# server.R
# PROJECT 4
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(gridExtra)

shinyServer(function(input, output) {
  
  
  # PROCESSING INPUT VARIABLES
  bar_chart_filter <- reactive({input$bar_chart_filter})
  scatter_plot_filter <- reactive({input$scatter_plot_filter})    
  crosstab_filter <- reactive({input$crosstab_filter})
  
  df <- readRDS("../01 Data/walmart_data.rds")
  
  subset(df)

  output$barPlot <- renderPlot({
    d1 = c()
    if (input$bar_chart_filter == 'All Years') {
      d1 <- data %>% group_by(STORE_ID, TYPE_OF_STORE, ISHOLIDAY) %>% 
        summarise(SUM_OF_SALES = mean(WEEKLY_SALES))
    } else {
      d1 <- data %>% group_by(STORE_ID, TYPE_OF_STORE, ISHOLIDAY) %>% 
        filter(substring(DATE_OF_WEEK, 0, 4) == input$bar_chart_filter) %>% 
        summarise(SUM_OF_SALES = mean(WEEKLY_SALES))
    }

   
    ggplot() +
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_grid(ISHOLIDAY~TYPE_OF_STORE, labeller=label_both) +
      labs(title=paste('Average Sales for', input$bar_chart_filter)) +
      labs(x="Store ID", y=paste("Average Sales")) +
      layer(data=d1, 
            mapping=aes(x=reorder(STORE_ID, SUM_OF_SALES), y=as.numeric(as.character(SUM_OF_SALES))), 
            stat="identity", 
            geom="bar",
            position=position_jitter(width=0, height=0)
      )+theme(axis.text=element_text(size=5))
  })
  
  output$scatterPlot <- renderPlot({
    d2 <- c()
    if (input$scatter_plot_filter == 'Type A') {
      d2 <- data %>% filter(TYPE_OF_STORE == 'A') %>% group_by(DATE_OF_WEEK, ISHOLIDAY) %>% summarise(SUM_OF_SALES = sum(WEEKLY_SALES))
    }
    else if (input$scatter_plot_filter == 'Type B') {
      d2 <- data %>% filter(TYPE_OF_STORE == 'B') %>% group_by(DATE_OF_WEEK, ISHOLIDAY) %>% summarise(SUM_OF_SALES = sum(WEEKLY_SALES))
    }
    else {
      d2 <- data %>% group_by(DATE_OF_WEEK, ISHOLIDAY) %>% summarise(SUM_OF_SALES = sum(WEEKLY_SALES))
    }
    
    ggplot() +
      coord_cartesian() + 
      scale_x_date() +
      scale_y_continuous() +
      labs(title='Weekly total Sales') +
      labs(x="Date", y=paste("Sales")) +
      layer(data=d2, 
            mapping=aes(color=ISHOLIDAY, x=DATE_OF_WEEK, y=as.numeric(as.character(SUM_OF_SALES))), 
            stat="identity", 
            geom="point",
            position=position_jitter(width=0, height=0)
      )
  })
  
  
  output$crosstabPlot1 <- renderPlot({

    filterMin = input$crosstab_filter[1]
    filterMax = input$crosstab_filter[2]
    d_ <- data %>% filter(WEEKLY_SALES >= filterMin & WEEKLY_SALES <= filterMax) %>%
      group_by(STORE_ID, TYPE_OF_STORE, ISHOLIDAY) %>%
      summarise(SUM_OF_SALES = mean(WEEKLY_SALES))

    d3 = filter(d_, TYPE_OF_STORE == 'A')
    MIN <- min(d_$SUM_OF_SALES)
    MAX <- max(d_$SUM_OF_SALES)
    
    ggplot(d3, aes(ISHOLIDAY, STORE_ID)) +
      labs(title='Weekly Average Sales based on Store ID and Holiday For Store Type A')+
      geom_tile(aes(fill = SUM_OF_SALES), colour = "grey50") +
      scale_fill_gradientn(limits = c(MIN, MAX), colors=c("white", "steelblue")) +
      geom_text(size = 3, aes(fill = floor(SUM_OF_SALES), label = floor(SUM_OF_SALES)))
   
  })
  
  
  output$crosstabPlot2 <- renderPlot({
    print(crosstab_filter)
    filterMin = input$crosstab_filter[1]
    filterMax = input$crosstab_filter[2]
    d_ <- data %>% filter(WEEKLY_SALES >= filterMin & WEEKLY_SALES <= filterMax) %>%
      group_by(STORE_ID, TYPE_OF_STORE, ISHOLIDAY) %>%
      summarise(SUM_OF_SALES = mean(WEEKLY_SALES))

    d4 = filter(d_, TYPE_OF_STORE == 'B')
    d4
    MIN <- min(d_$SUM_OF_SALES)
    MAX <- max(d_$SUM_OF_SALES)
   
    ggplot(d4, aes(ISHOLIDAY, STORE_ID)) +
      labs(title='Weekly Average Sales based on Store ID and Holiday For Store Type B')+
      geom_tile(aes(fill = SUM_OF_SALES), colour = "grey50") +
      scale_fill_gradientn(limits = c(MIN, MAX), colors=c("white", "steelblue")) +
      geom_text(size = 3, aes(fill = floor(SUM_OF_SALES), label = floor(SUM_OF_SALES)))
  })
  
})