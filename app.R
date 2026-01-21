library(shiny)
library(aggrid)

ui <- bslib::page_fillable(
   padding = 2,
   aggridOutput('table', height = "100%")
)

server <- function(input, output, session) {
   output$table <- renderAggrid(
      aggrid(warpbreaks, rowSelection = list(
         mode = "multiRow",
         headerCheckbox = TRUE,
         checkboxes = TRUE,
         enableClickSelection = TRUE,
         enableSelectionWithoutKeys = TRUE
      ))
   )
}

shinyApp(ui, server)
