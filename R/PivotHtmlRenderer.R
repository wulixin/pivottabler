#' A class that renders a pivot table in HTML.
#'
#' The PivotHtmlRenderer class creates a HTML representation of a pivot table.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @import htmltools
#' @return Object of \code{\link{R6Class}} with properties and methods that
#'   render to HTML.
#' @format \code{\link{R6Class}} object.
#' @examples
#' # This class should only be created by the pivot table.
#' # It is not intended to be created outside of the pivot table.
#' @field parentPivot Owning pivot table.

#' @section Methods:
#' \describe{
#'   \item{Documentation}{For more complete explanations and examples please see
#'   the extensive vignettes supplied with this package.}
#'   \item{\code{new(...)}}{Create a new pivot table renderer, specifying the
#'   field value documented above.}
#'
#'   \item{\code{clearIsRenderedFlags()}}{Clear the IsRendered flags that exist
#'   on the PivotDataGroup class.}
#'   \item{\code{getTableHtml(styleNamePrefix=NULL, includeHeaderValues=FALSE,
#'   includeRCFilters=FALSE, includeCalculationFilters=FALSE,
#'   includeWorkingData=FALSE, includeEvaluationFilters=FALSE,
#'   includeCalculationNames=FALSE, includeRawValue=FALSE,
#'   includeTotalInfo=FALSE, exportOptions=NULL)}}{Get a HTML
#'   representation of the pivot table,
#'   optionally including additional detail for debugging purposes.}
#' }

PivotHtmlRenderer <- R6::R6Class("PivotHtmlRenderer",
  public = list(
   initialize = function(parentPivot) {
     if(parentPivot$argumentCheckMode > 0) {
       checkArgument(parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "initialize", parentPivot, missing(parentPivot), allowMissing=FALSE, allowNull=FALSE, allowedClasses="PivotTable")
     }
     private$p_parentPivot <- parentPivot
     if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotHtmlRenderer$new", "Creating new Html Renderer...")
     if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotHtmlRenderer$new", "Created new Html Renderer.")
   },
   clearIsRenderedFlags = function() {
     if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotHtmlRenderer$clearIsRenderedFlags", "Clearing isRendered flags...")
     clearFlags <- function(dg) {
       grp <- dg
       while(!is.null(grp)) {
         grp$isRendered <- FALSE
         grp <- grp$parentGroup
       }
     }
     rowGroups <- private$p_parentPivot$rowGroup$getDescendantGroups(includeCurrentGroup=TRUE)
     lapply(rowGroups, clearFlags)
     columnGroups <- private$p_parentPivot$columnGroup$getDescendantGroups(includeCurrentGroup=TRUE)
     lapply(columnGroups, clearFlags)
     if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotHtmlRenderer$clearIsRenderedFlags", "Cleared isRendered flags...")
     return(invisible())
   },
   getTableHtml = function(styleNamePrefix=NULL, includeHeaderValues=FALSE, includeRCFilters=FALSE,
                           includeCalculationFilters=FALSE, includeWorkingData=FALSE, includeEvaluationFilters=FALSE,
                           includeCalculationNames=FALSE, includeRawValue=FALSE, includeTotalInfo=FALSE,
                           exportOptions=exportOptions) {
     if(private$p_parentPivot$argumentCheckMode > 0) {
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", styleNamePrefix, missing(styleNamePrefix), allowMissing=TRUE, allowNull=TRUE, allowedClasses="character")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeHeaderValues, missing(includeHeaderValues), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeRCFilters, missing(includeRCFilters), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeCalculationFilters, missing(includeCalculationFilters), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeWorkingData, missing(includeWorkingData), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeEvaluationFilters, missing(includeEvaluationFilters), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeCalculationNames, missing(includeCalculationNames), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeRawValue, missing(includeRawValue), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", includeTotalInfo, missing(includeTotalInfo), allowMissing=TRUE, allowNull=FALSE, allowedClasses="logical")
       checkArgument(private$p_parentPivot$argumentCheckMode, FALSE, "PivotHtmlRenderer", "getTableHtml", exportOptions, missing(exportOptions), allowMissing=TRUE, allowNull=TRUE, allowedClasses="list")
     }
     if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotHtmlRenderer$getTableHtml", "Getting table HTML...")
     # get the style names
     styles <- names(private$p_parentPivot$styles$styles)
     defaultTableStyle = private$p_parentPivot$styles$tableStyle
     defaultRootStyle = private$p_parentPivot$styles$rootStyle
     defaultRowHeaderStyle = private$p_parentPivot$styles$rowHeaderStyle
     defaultColHeaderStyle = private$p_parentPivot$styles$colHeaderStyle
     defaultCellStyle = private$p_parentPivot$styles$cellStyle
     defaultTotalStyle = private$p_parentPivot$styles$totalStyle
     # get the actual style names to use, including the styleNamePrefix
     tableStyle <- paste0(styleNamePrefix, defaultTableStyle)
     rootStyle <- paste0(styleNamePrefix, defaultRootStyle)
     rowHeaderStyle <- paste0(styleNamePrefix, defaultRowHeaderStyle)
     colHeaderStyle <- paste0(styleNamePrefix, defaultColHeaderStyle)
     cellStyle <- paste0(styleNamePrefix, defaultCellStyle)
     totalStyle <- paste0(styleNamePrefix, defaultTotalStyle)
     # get the data groups:  these are the leaf level groups
     rowGroups <- private$p_parentPivot$cells$rowGroups
     columnGroups <- private$p_parentPivot$cells$columnGroups
     # clear the isRendered flags
     self$clearIsRenderedFlags()
     # get the dimensions of the various parts of the table...
     # ...headings:
     rowGroupLevelCount <- private$p_parentPivot$rowGroup$getLevelCount(includeCurrentLevel=FALSE)
     columnGroupLevelCount <- private$p_parentPivot$columnGroup$getLevelCount(includeCurrentLevel=FALSE)
     # ...cells:
     rowCount <- private$p_parentPivot$cells$rowCount
     columnCount <- private$p_parentPivot$cells$columnCount
     # compatibility to keep the explicit row/col span even if span is only 1
     o2n <- !isTRUE(private$p_parentPivot$compatibility$explicitHeaderSpansOfOne)
     # special case of no rows and no columns, return a blank empty table
     if((rowGroupLevelCount==0)&&(columnGroupLevelCount==0)) {
       tbl <- htmltools::tags$table(class=tableStyle, htmltools::tags$tr(
         htmltools::tags$td(class=cellStyle, style="text-align: center; padding: 6px", htmltools::HTML("(no data)"))))
       return(tbl)
     }
     # there must always be at least one row and one column
     insertDummyRowHeading <- (rowGroupLevelCount==0) & (columnGroupLevelCount > 0)
     insertDummyColumnHeading <- (columnGroupLevelCount==0) & (rowGroupLevelCount > 0)
     # build the table up row by row
     trows <- list()
     # render the column headings, with a large blank cell at the start over the row headings
     if(insertDummyColumnHeading) {
       trow <- list()
       trow[[1]] <- htmltools::tags$th(class=rootStyle, rowspan=oneToNULL(columnGroupLevelCount, o2n), colspan=oneToNULL(rowGroupLevelCount, o2n), htmltools::HTML("&nbsp;"))
       trow[[2]] <- htmltools::tags$th(class=colHeaderStyle, htmltools::HTML("&nbsp;"))
       trows[[1]] <- htmltools::tags$tr(trow)
     }
     else {
       for(r in 1:columnGroupLevelCount) {
         trow <- list()
         if(r==1) { # generate the large top-left blank cell
           trow[[1]] <- htmltools::tags$th(class=rootStyle, rowspan=oneToNULL(columnGroupLevelCount, o2n), colspan=oneToNULL(rowGroupLevelCount, o2n), htmltools::HTML("&nbsp;"))
         }
         # get the groups at this level
         grps <- private$p_parentPivot$columnGroup$getLevelGroups(level=r)
         for(c in 1:length(grps)) {
           grp <- grps[[c]]
           chs <- colHeaderStyle
           if(!is.null(grp$baseStyleName)) chs <- paste0(styleNamePrefix, grp$baseStyleName)
           colstyl <- NULL
           if(!is.null(grp$style)) colstyl <- grp$style$asCSSRule()
           if(includeHeaderValues||includeTotalInfo) {
             detail <- list()
             if(includeHeaderValues) {
               lst <- NULL
               if(is.null(grp$filters)) { lst <- "No filters" }
               else {
                 lst <- list()
                 if(grp$filters$count > 0) {
                   for(i in 1:grp$filters$count){
                     lst[[length(lst)+1]] <- htmltools::tags$li(grp$filters$filters[[i]]$asString(seperator=", "))
                   }
                 }
               }
               detail[[length(detail)+1]] <- htmltools::tags$p(style="text-align: left; font-size: 75%;", "Filters: ")
               detail[[length(detail)+1]] <- htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst)
             }
             if(includeTotalInfo) {
               lst <- list()
               lst[[length(lst)+1]] <- htmltools::tags$li(paste0("isTotal = ", grp$isTotal))
               lst[[length(lst)+1]] <- htmltools::tags$li(paste0("isLevelSubTotal = ", grp$isLevelSubTotal))
               lst[[length(lst)+1]] <- htmltools::tags$li(paste0("isLevelTotal = ", grp$isLevelTotal))
               detail[[length(detail)+1]] <- htmltools::tags$p(style="text-align: left; font-size: 75%;", "Totals: ")
               detail[[length(detail)+1]] <- htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst)
             }
             trow[[length(trow)+1]] <- htmltools::tags$th(class=chs, style=colstyl,  colspan=oneToNULL(length(grp$leafGroups), o2n), htmltools::tags$p(exportValueAs(grp$sortValue, grp$caption, exportOptions, blankValue="")), detail) # todo: check escaping
           }
           else trow[[length(trow)+1]] <- htmltools::tags$th(class=chs, style=colstyl, colspan=oneToNULL(length(grp$leafGroups), o2n), exportValueAs(grp$sortValue, grp$caption, exportOptions, blankValue="")) # todo: check escaping
         }
         trows[[length(trows)+1]] <- htmltools::tags$tr(trow)
       }
     }
     # render the rows
     for(r in 1:rowCount) {
       trow <- list()
       # render the row headings
       if(insertDummyRowHeading) {
         trow[[1]] <- htmltools::tags$th(class=rowHeaderStyle, htmltools::HTML("&nbsp;"))
       }
       else {
         # get the leaf row group, then render any parent data groups that haven't yet been rendered
         rg <- rowGroups[[r]]
         ancrgs <- rg$getAncestorGroups(includeCurrentGroup=TRUE)
         for(c in (length(ancrgs)-1):1) { # 2 (not 1) since the top ancestor is parentPivot private$rowGroup, which is just a container
           ancg <- ancrgs[[c]]
           if(ancg$isRendered==FALSE) {
             rhs <- rowHeaderStyle
             if(!is.null(ancg$baseStyleName)) rhs <- paste0(styleNamePrefix, ancg$baseStyleName)
             rwstyl <- NULL
             if(!is.null(ancg$style)) rwstyl <- ancg$style$asCSSRule()
             if(includeHeaderValues||includeTotalInfo) {
               detail <- list()
               if(includeHeaderValues) {
                 lst <- NULL
                 if(is.null(ancg$filters)) { lst <- "No filters" }
                 else {
                   lst <- list()
                   if(ancg$filters$count > 0) {
                     for(i in 1:ancg$filters$count){
                       lst[[length(lst)+1]] <- htmltools::tags$li(ancg$filters$filters[[i]]$asString(seperator=", "))
                     }
                   }
                 }
                 detail[[length(detail)+1]] <- htmltools::tags$p(style="text-align: left; font-size: 75%;", "Filters: ")
                 detail[[length(detail)+1]] <- htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst)
               }
               if(includeTotalInfo) {
                 lst <- list()
                 lst[[length(lst)+1]] <- htmltools::tags$li(paste0("isTotal = ", ancg$isTotal))
                 lst[[length(lst)+1]] <- htmltools::tags$li(paste0("isLevelSubTotal = ", ancg$isLevelSubTotal))
                 lst[[length(lst)+1]] <- htmltools::tags$li(paste0("isLevelTotal = ", ancg$isLevelTotal))
                 detail[[length(detail)+1]] <- htmltools::tags$p(style="text-align: left; font-size: 75%;", "Totals: ")
                 detail[[length(detail)+1]] <- htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst)
               }
               trow[[length(trow)+1]] <- htmltools::tags$th(class=rhs, style=rwstyl,  rowspan=oneToNULL(length(ancg$leafGroups), o2n), htmltools::tags$p(exportValueAs(ancg$sortValue, ancg$caption, exportOptions, blankValue="")), detail) # todo: check escaping
             }
             else trow[[length(trow)+1]] <- htmltools::tags$th(class=rhs, style=rwstyl, rowspan=oneToNULL(length(ancg$leafGroups), o2n), exportValueAs(ancg$sortValue, ancg$caption, exportOptions, blankValue="")) # todo: check escaping
             ancg$isRendered <- TRUE
           }
         }
       }
       # render the cell values
       for(c in 1:columnCount) {
         cell <- private$p_parentPivot$cells$getCell(r, c)
         if(cell$isTotal) cssCell <- totalStyle
         else cssCell <- cellStyle
         if(!is.null(cell$baseStyleName)) cssCell <- paste0(styleNamePrefix, cell$baseStyleName)
         cllstyl <- NULL
         if(!is.null(cell$style)) cllstyl <- cell$style$asCSSRule()
         detail <- list()
         if(includeRCFilters|includeCalculationFilters|includeWorkingData|includeEvaluationFilters|includeCalculationNames|includeRawValue)
         {
           if(includeRawValue) {
             detail[[length(detail)+1]] <- htmltools::tags$p(style="text-align: left; font-size: 75%;", paste0("raw value = ", cell$rawValue))
           }
           if(includeRCFilters) {
             lst <- NULL
             if(is.null(cell$rowColFilters)) { lst <- "No RC filters" }
             else {
               lst <- list()
               if(cell$rowColFilters$count > 0) {
                 for(i in 1:cell$rowColFilters$count){
                   lst[[length(lst)+1]] <- htmltools::tags$li(cell$rowColFilters$filters[[i]]$asString(seperator=", "))
                 }
               }
             }
             detail[[length(detail)+1]] <- list(htmltools::tags$p(style="text-align: left; font-size: 75%;", "RC Filters: "),
                                                htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst))
           }
           if(includeCalculationNames) {
             cstr <- paste0("Calc: ",  cell$calculationGroupName, ": ", cell$calculationName)
             detail[[length(detail)+1]] <- list(htmltools::tags$p(style="text-align: left; font-size: 75%;", cstr))
           }
           if(includeCalculationFilters) {
             lst <- NULL
             if(is.null(cell$calculationFilters)) { lst <- "No calculation filters" }
             else {
               lst <- list()
               if("PivotFilters" %in% class(cell$calculationFilters)) {
                 if(cell$calculationFilters$count > 0) {
                   for(i in 1:cell$calculationFilters$count){
                     lst[[length(lst)+1]] <- htmltools::tags$li(cell$calculationFilters$filters[[i]]$asString(seperator=", "))
                   }
                 }
               }
               else if("PivotFilterOverrides" %in% class(cell$calculationFilters)) {
                 if(length(cell$calculationFilters) > 0) {
                   lst[[length(lst)+1]] <- htmltools::tags$li(cell$calculationFilters$asString(seperator=", "))
                 }
               }
             }
             detail[[length(detail)+1]] <- list(htmltools::tags$p(style="text-align: left; font-size: 75%;", "Calc. Filters: "),
                                                htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst))
           }
           if(includeWorkingData) {
             if(length(cell$workingData)>0) {
               wdNames <- names(cell$workingData)
               for(w in 1:length(cell$workingData)) {
                 wd <- cell$workingData[[w]]
                 if(is.null(wd)) next
                 lst <- list()
                 if(is.null(wd$batchName)) lst[[length(lst)+1]] <- htmltools::tags$li("No batch")
                 else {
                   lst[[length(lst)+1]] <- htmltools::tags$li(paste0("Batch = ", wd$batchName))
                 }
                 if(is.null(wd$workingFilters)) { lst[[length(lst)+1]] <- htmltools::tags$li("No working filters") }
                 else {
                   if(wd$workingFilters$count > 0) {
                     for(i in 1:wd$workingFilters$count){
                       lst[[length(lst)+1]] <- htmltools::tags$li(wd$workingFilters$filters[[i]]$asString(seperator=", "))
                     }
                   }
                 }
                 detail[[length(detail)+1]] <- list(htmltools::tags$p(style="text-align: left; font-size: 75%;",
                                                                      paste0("Working Data for ", wdNames[w], ":")),
                                                    htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst))
               }
             }
           }
           if(includeEvaluationFilters) {
             lst <- NULL
             if(is.null(cell$evaluationFilters)) { lst <- "No evaluation filters" }
             else {
               lst <- list()
               if(cell$evaluationFilters$count > 0) {
                 for(i in 1:cell$evaluationFilters$count){
                   lst[[length(lst)+1]] <- htmltools::tags$li(cell$evaluationFilters$filters[[i]]$asString(seperator=", "))
                 }
               }
             }
             detail[[length(detail)+1]] <- list(htmltools::tags$p(style="text-align: left; font-size: 75%;", "Eval. Filters: "),
                                                htmltools::tags$ul(style="text-align: left; font-size: 75%; padding-left: 1em;", lst))
           }
           trow[[length(trow)+1]] <- htmltools::tags$td(class=cssCell, style=cllstyl, htmltools::tags$p(exportValueAs(cell$rawValue, cell$formattedValue, exportOptions, blankValue="")), detail) # todo: check escaping
         }
         else { trow[[length(trow)+1]] <- htmltools::tags$td(class=cssCell, style=cllstyl, exportValueAs(cell$rawValue, cell$formattedValue, exportOptions, blankValue="")) } # todo: check escaping
       }
       # finished this row
       trows[[length(trows)+1]] <- htmltools::tags$tr(trow)
     }
     tbl <- htmltools::tags$table(class=tableStyle, trows)
     if(private$p_parentPivot$traceEnabled==TRUE) private$p_parentPivot$trace("PivotHtmlRenderer$getTableHtml", "Got table HTML.")
     return(invisible(tbl))
   }
  ),
  private = list(
    p_parentPivot = NULL
  )
)
