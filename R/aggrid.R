# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @title
#'    Display a data frame in aggrid table
#' @description
#'    Create a HTML widget using the ag-grid-react library
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param df
#'    [data.frame] | [matrix]: data frame or matrix.
#' @param columnDefs
#'    [list]: List of Column / Column Group definitions. See <https://www.ag-grid.com/javascript-data-grid/column-definitions/>.
#' @param suppressFieldDotNotation
#'    [logical]: If TRUE, then dots in field names (e.g. 'address.firstLine') are not treated as deep references. Allows you to use dots in your field name if you prefer. `TRUE` or `FALSE`. <https://www.ag-grid.com/javascript-data-grid/grid-options/#reference-columns-suppressFieldDotNotation>.
#' @param width
#'    [integer], [character]: Width in pixels (optional, defaults to automatic sizing)
#' @param height
#'    [integer], [character]: Height in pixels (optional, defaults to automatic sizing)
#' @param elementId
#'    [character]: An id for the widget (a random character by default).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @section Returns:
#' \preformatted{
#'    Type: html widget
#' }
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' \dontrun{
#' aggrid::aggrid(iris)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export aggrid
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   aggrid
#' @rdname aggrid
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

aggrid <- function(df, columnDefs = NULL, suppressFieldDotNotation = TRUE, ..., width = NULL, height = NULL, elementId = NULL) {
   if (!is.data.frame(df) && !is.matrix(df)) {
      stop("`df` must be a data frame.")
   }
   else if (is.matrix(df)) {
      df <- as.data.frame(df)
   }

   if (!is.logical(suppressFieldDotNotation)) {
      stop("`suppressFieldDotNotation` must be TRUE or FALSE.")
   }

   if (is.null(columnDefs)) {
      columnDefs <- lapply(names(df), function(col_name) {
         list(field = col_name)
      })
   }
   else if (!is.list(columnDefs)) {
      stop(
         paste(
            "`columnDefs` must be NULL or a list like below:",
            "\taggrid::aggrid(",
            "\t\tdf = data_frame",
            "\t\tcolumnDefs = list(",
            '\t\t\tlist( field = "Column Name 1" ),',
            '\t\t\tlist( field = "Column Name 2" ),',
            "\t\t\t...",
            "\t\t)",
            "\t)",
            sep = "\n"
         )
      )
   }

   df <- jsonlite::toJSON(
      df,
      dataframe = "rows",
      auto_unbox = TRUE,
      na = "null",
      pretty = TRUE
   )

   x <- list(
      gridOptions = list(
         rowData = df,
         columnDefs = columnDefs,
         suppressFieldDotNotation = suppressFieldDotNotation
      )
   )

   x$gridOptions <- c(x$gridOptions, list(...))

   # describe a React component to send to the browser for rendering.
   component <- reactR::reactMarkup(
      reactR::component("Aggrid", list(
         x = x
      ))
   )

   # create widget
   htmlwidgets::createWidget(
      name = 'aggrid',
      component,
      width = width,
      height = height,
      package = 'aggrid',
      elementId = elementId
   )
}

#' Called by HTMLWidgets to produce the widget's root element.
#' @noRd
widget_html.aggrid <- function(id, style, class, ...) {
   htmltools::tagList(
      # Necessary for RStudio viewer version < 1.2
      reactR::html_dependency_corejs(),
      reactR::html_dependency_react(),
      reactR::html_dependency_reacttools(),
      htmltools::tags$div(id = id, class = class, style = style)
   )
}

#' Shiny bindings for aggrid
#'
#' Output and render functions for using aggrid within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a aggrid
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name aggrid-shiny
#'
#' @export
aggridOutput <- function(outputId, width = '100%', height = '400px'){
   htmlwidgets::shinyWidgetOutput(outputId, 'aggrid', width, height, package = 'aggrid')
}

#' @rdname aggrid-shiny
#' @export
renderAggrid <- function(expr, env = parent.frame(), quoted = FALSE) {
   if (!quoted) { expr <- substitute(expr) } # force quoted
   htmlwidgets::shinyRenderWidget(expr, aggridOutput, env, quoted = TRUE)
}
