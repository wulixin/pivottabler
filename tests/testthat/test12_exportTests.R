library(testthat)

# most common expectations:
# equality:        expect_equal() and expect_identical()
# regexp:          expect_match()
# catch-all:       expect_true() and expect_false()
# console output:  expect_output()
# messages:        expect_message()
# warning:         expect_warning()
# errors:          expect_error()

escapeString <- function(s) {
  t <- gsub("(\\\\)", "\\\\\\\\", s)
  t <- gsub("(\n)", "\\\\n", t)
  t <- gsub("(\r)", "\\\\r", t)
  t <- gsub("(\")", "\\\\\"", t)
  return(t)
}

prepStr <- function(s) {
  t <- escapeString(s)
  u <- eval(parse(text=paste0("\"", t, "\"")))
  if(s!=u) stop("Unable to escape string!")
  t <- paste0("\thtml <- \"", t, "\"")
  utils::writeClipboard(t)
  return(invisible())
}

evaluationMode <- "sequential"
processingLibrary <- "dplyr"
description <- "test: sequential dplyr"
countFunction <- "n()"

testScenarios <- function(description="test", releaseEvaluationMode="batch", releaseProcessingLibrary="dplyr", runAllForReleaseVersion=FALSE) {
  isDevelopmentVersion <- (length(strsplit(packageDescription("pivottabler")$Version, "\\.")[[1]]) > 3)
  if(isDevelopmentVersion||runAllForReleaseVersion) {
    evaluationModes <- c("sequential", "batch")
    processingLibraries <- c("dplyr", "data.table")
  }
  else {
    evaluationModes <- releaseEvaluationMode
    processingLibraries <- releaseProcessingLibrary
  }
  testCount <- length(evaluationModes)*length(processingLibraries)
  c1 <- character(testCount)
  c2 <- character(testCount)
  c3 <- character(testCount)
  c4 <- character(testCount)
  testCount <- 0
  for(evaluationMode in evaluationModes)
    for(processingLibrary in processingLibraries) {
      testCount <- testCount + 1
      c1[testCount] <- evaluationMode
      c2[testCount] <- processingLibrary
      c3[testCount] <- paste0(description, ": ", evaluationMode, " ", processingLibrary)
      c4[testCount] <- ifelse(processingLibrary=="data.table", ".N", "n()")
    }
  df <- data.frame(evaluationMode=c1, processingLibrary=c2, description=c3, countFunction=c4, stringsAsFactors=FALSE)
  return(df)
}


context("EXPORT TESTS")


scenarios <- testScenarios("export tests:  as Matrix (without row headings)")
for(i in 1:nrow(scenarios)) {
  evaluationMode <- scenarios$evaluationMode[i]
  processingLibrary <- scenarios$processingLibrary[i]
  description <- scenarios$description[i]
  countFunction <- scenarios$countFunction[i]

  test_that(description, {

    library(pivottabler)
    pt <- PivotTable$new(processingLibrary=processingLibrary, evaluationMode=evaluationMode)
    pt$addData(bhmtrains)
    pt$addColumnDataGroups("TrainCategory")
    pt$addColumnDataGroups("PowerType")
    pt$addRowDataGroups("TOC")
    pt$defineCalculation(calculationName="TotalTrains", summariseExpression=countFunction)
    pt$evaluatePivot()
    # pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE)
    # sum(pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE), na.rm=TRUE)
    # mean(pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE), na.rm=TRUE)
    # min(pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE), na.rm=TRUE)
    # max(pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE), na.rm=TRUE)
    # prepStr(paste(as.character(pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE)), sep=" ", collapse=" "))
    text <- "3079 22133 5638 2137 32987 NA NA 8849 6457 15306 NA 732 NA NA 732 3079 22865 14487 8594 49025 830 63 5591 NA 6484 NA NA 28201 NA 28201 830 63 33792 NA 34685 3909 22928 48279 8594 83710"

    expect_equal(sum(pt$cells$asMatrix(), na.rm=TRUE), 502260)
    expect_equal(mean(pt$cells$asMatrix(), na.rm=TRUE), 16742)
    expect_equal(min(pt$cells$asMatrix(), na.rm=TRUE), 63)
    expect_equal(max(pt$cells$asMatrix(), na.rm=TRUE), 83710)
    expect_identical(paste(as.character(pt$asMatrix(includeHeaders=FALSE, rawValue=TRUE)), sep=" ", collapse=" "), text)
  })
}


scenarios <- testScenarios("export tests:  as Matrix (with row headings)")
for(i in 1:nrow(scenarios)) {
  evaluationMode <- scenarios$evaluationMode[i]
  processingLibrary <- scenarios$processingLibrary[i]
  description <- scenarios$description[i]
  countFunction <- scenarios$countFunction[i]

  test_that(description, {

    library(pivottabler)
    pt <- PivotTable$new(processingLibrary=processingLibrary, evaluationMode=evaluationMode)
    pt$addData(bhmtrains)
    pt$addColumnDataGroups("TrainCategory")
    pt$addColumnDataGroups("PowerType")
    pt$addRowDataGroups("TOC")
    pt$defineCalculation(calculationName="TotalTrains", summariseExpression=countFunction)
    pt$evaluatePivot()
    # prepStr(paste(as.character(pt$asMatrix(includeHeaders=TRUE)), sep=" ", collapse=" "))
    text <- "  Arriva Trains Wales CrossCountry London Midland Virgin Trains Total Express Passenger DMU 3079 22133 5638 2137 32987  EMU   8849 6457 15306  HST  732   732  Total 3079 22865 14487 8594 49025 Ordinary Passenger DMU 830 63 5591  6484  EMU   28201  28201  Total 830 63 33792  34685 Total  3909 22928 48279 8594 83710"

    expect_identical(paste(as.character(pt$asMatrix(includeHeaders=TRUE)), sep=" ", collapse=" "), text)
  })
}


scenarios <- testScenarios("export tests:  as Data Frame")
for(i in 1:nrow(scenarios)) {
  evaluationMode <- scenarios$evaluationMode[i]
  processingLibrary <- scenarios$processingLibrary[i]
  description <- scenarios$description[i]
  countFunction <- scenarios$countFunction[i]

  test_that(description, {

    library(pivottabler)
    pt <- PivotTable$new(processingLibrary=processingLibrary, evaluationMode=evaluationMode)
    pt$addData(bhmtrains)
    pt$addColumnDataGroups("TrainCategory")
    pt$addColumnDataGroups("PowerType")
    pt$addRowDataGroups("TOC")
    pt$defineCalculation(calculationName="TotalTrains", summariseExpression=countFunction)
    pt$evaluatePivot()

    # sum(pt$asDataFrame(), na.rm=TRUE)
    # prepStr(paste(as.character(pt$asDataFrame()), sep=" ", collapse=" "))
    text <- "c(3079, 22133, 5638, 2137, 32987) c(NA, NA, 8849, 6457, 15306) c(NA, 732, NA, NA, 732) c(3079, 22865, 14487, 8594, 49025) c(830, 63, 5591, NA, 6484) c(NA, NA, 28201, NA, 28201) c(830, 63, 33792, NA, 34685) c(3909, 22928, 48279, 8594, 83710)"

    expect_equal(sum(pt$asDataFrame(), na.rm=TRUE), 502260)
    expect_identical(paste(as.character(pt$asDataFrame()), sep=" ", collapse=" "), text)
  })
}


scenarios <- testScenarios("export tests:  as Tidy Data Frame")
for(i in 1:nrow(scenarios)) {
  evaluationMode <- scenarios$evaluationMode[i]
  processingLibrary <- scenarios$processingLibrary[i]
  description <- scenarios$description[i]
  countFunction <- scenarios$countFunction[i]

  test_that(description, {

    library(pivottabler)
    pt <- PivotTable$new(processingLibrary=processingLibrary, evaluationMode=evaluationMode)
    pt$addData(bhmtrains)
    pt$addColumnDataGroups("TrainCategory")
    pt$addColumnDataGroups("PowerType")
    pt$addRowDataGroups("TOC")
    pt$defineCalculation(calculationName="TotalTrains", summariseExpression=countFunction)
    pt$evaluatePivot()

    # sum(pt$asTidyDataFrame()$rawValue, na.rm=TRUE)
    # prepStr(paste(as.character(pt$asTidyDataFrame(stringsAsFactors=FALSE)), sep=" ", collapse=" "))
    text <- paste0("c(1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5) c(1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8) c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE) c(\"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"Virgin Trains\", \"Virgin Trains\", \"Virgin Trains\", \n\"Virgin Trains\", \"Virgin Trains\", \"Virgin Trains\", \"Virgin Trains\", \"Virgin Trains\", \"Total\", \"Total\", \"Total\", \"Total\", \"Total\", \"Total\", \"Total\", \"Total\") c(\"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Total\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Total\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Total\", \"Express Passenger\", \"Express Passenger\", \n\"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Total\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Total\") c(\"DMU\", \"EMU\", \"HST\", \"Total\", \"DMU\", \"EMU\", \"Total\", \"\", \"DMU\", \"EMU\", \"HST\", \"Total\", \"DMU\", \"EMU\", \"Total\", \"\", \"DMU\", \"EMU\", \"HST\", \"Total\", \"DMU\", \"EMU\", \"Total\", \"\", \"DMU\", \"EMU\", \"HST\", \"Total\", \"DMU\", \"EMU\", \"Total\", \"\", \"DMU\", \"EMU\", \"HST\", \"Total\", \"DMU\", \"EMU\", \"Total\", \"\") c(\"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"Arriva Trains Wales\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"CrossCountry\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"London Midland\", \"Virgin Trains\", \"Virgin Trains\", \"Virgin Trains\", \n\"Virgin Trains\", \"Virgin Trains\", ",
                   "\"Virgin Trains\", \"Virgin Trains\", \"Virgin Trains\", \"NA\", \"NA\", \"NA\", \"NA\", \"NA\", \"NA\", \"NA\", \"NA\") c(\"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"NA\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"NA\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"NA\", \"Express Passenger\", \"Express Passenger\", \n\"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"NA\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Express Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"Ordinary Passenger\", \"NA\") c(\"DMU\", \"EMU\", \"HST\", \"NA\", \"DMU\", \"EMU\", \"NA\", \"NA\", \"DMU\", \"EMU\", \"HST\", \"NA\", \"DMU\", \"EMU\", \"NA\", \"NA\", \"DMU\", \"EMU\", \"HST\", \"NA\", \"DMU\", \"EMU\", \"NA\", \"NA\", \"DMU\", \"EMU\", \"HST\", \"NA\", \"DMU\", \"EMU\", \"NA\", \"NA\", \"DMU\", \"EMU\", \"HST\", \"NA\", \"DMU\", \"EMU\", \"NA\", \"NA\") c(\"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \n\"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\", \"TotalTrains\") c(\"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\", \"default\") c(3079, NA, NA, 3079, 830, NA, 830, 3909, 22133, NA, 732, 22865, 63, NA, 63, 22928, 5638, 8849, NA, 14487, 5591, 28201, 33792, 48279, 2137, 6457, NA, 8594, NA, NA, NA, 8594, 32987, 15306, 732, 49025, 6484, 28201, 34685, 83710) c(\"3079\", NA, NA, \"3079\", \"830\", NA, \"830\", \"3909\", \"22133\", NA, \"732\", \"22865\", \"63\", NA, \"63\", \"22928\", \"5638\", \"8849\", NA, \"14487\", \"5591\", \"28201\", \"33792\", \"48279\", \"2137\", \"6457\", NA, \"8594\", NA, NA, NA, \"8594\", \"32987\", \"15306\", \"732\", \"49025\", \"6484\", \"28201\", \"34685\", \"83710\")")

    expect_equal(sum(pt$asTidyDataFrame()$rawValue, na.rm=TRUE), 502260)
    expect_identical(paste(as.character(pt$asTidyDataFrame(stringsAsFactors=FALSE)), sep=" ", collapse=" "), text)
  })
}


scenarios <- testScenarios("export tests:  NA, NaN, -Inf and Inf")
for(i in 1:nrow(scenarios)) {
  evaluationMode <- scenarios$evaluationMode[i]
  processingLibrary <- scenarios$processingLibrary[i]
  description <- scenarios$description[i]
  countFunction <- scenarios$countFunction[i]

  test_that(description, {

    someData <- data.frame(Colour=c("Red", "Yellow", "Green", "Blue", "White", "Black"),
                           SomeNumber=c(1, 2, NA, NaN, -Inf, Inf))

    library(pivottabler)
    pt <- PivotTable$new(processingLibrary=processingLibrary, evaluationMode=evaluationMode)
    pt$addData(someData)
    pt$addRowDataGroups("Colour")
    pt$defineCalculation(calculationName="Total", summariseExpression="sum(SomeNumber)")
    pt$evaluatePivot()

    # pt$renderPivot()
    # prepStr(as.character(pt$getHtml()))
    html <- "<table class=\"Table\">\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\" colspan=\"1\">&nbsp;</th>\n    <th class=\"ColumnHeader\" colspan=\"1\">Total</th>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Black</th>\n    <td class=\"Cell\">Inf</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Blue</th>\n    <td class=\"Cell\">NaN</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Green</th>\n    <td class=\"Cell\">NA</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Red</th>\n    <td class=\"Cell\">1</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">White</th>\n    <td class=\"Cell\">-Inf</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Yellow</th>\n    <td class=\"Cell\">2</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Total</th>\n    <td class=\"Cell\">NA</td>\n  </tr>\n</table>"
    expect_identical(as.character(pt$getHtml()), html)

    # pt$renderPivot(exportOptions=list(skipNegInf=TRUE, skipPosInf=TRUE, skipNA=TRUE, skipNaN=TRUE))
    # prepStr(as.character(pt$getHtml(exportOptions=list(skipNegInf=TRUE, skipPosInf=TRUE, skipNA=TRUE, skipNaN=TRUE))))
    html <- "<table class=\"Table\">\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\" colspan=\"1\">&nbsp;</th>\n    <th class=\"ColumnHeader\" colspan=\"1\">Total</th>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Black</th>\n    <td class=\"Cell\"></td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Blue</th>\n    <td class=\"Cell\"></td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Green</th>\n    <td class=\"Cell\"></td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Red</th>\n    <td class=\"Cell\">1</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">White</th>\n    <td class=\"Cell\"></td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Yellow</th>\n    <td class=\"Cell\">2</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Total</th>\n    <td class=\"Cell\"></td>\n  </tr>\n</table>"
    expect_identical(as.character(pt$getHtml(exportOptions=list(skipNegInf=TRUE, skipPosInf=TRUE, skipNA=TRUE, skipNaN=TRUE))), html)

    # pt$renderPivot(exportOptions=list(exportNegInfAs="-Infinity", exportPosInfAs="Infinity",
    #                                   exportNAAs="Nothing", exportNaNAs="Not a Number"))
    # prepStr(as.character(pt$getHtml(exportOptions=list(exportNegInfAs="-Infinity", exportPosInfAs="Infinity",
    #                                 exportNAAs="Nothing", exportNaNAs="Not a Number"))))
    html <- "<table class=\"Table\">\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\" colspan=\"1\">&nbsp;</th>\n    <th class=\"ColumnHeader\" colspan=\"1\">Total</th>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Black</th>\n    <td class=\"Cell\">Infinity</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Blue</th>\n    <td class=\"Cell\">Not a Number</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Green</th>\n    <td class=\"Cell\">Nothing</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Red</th>\n    <td class=\"Cell\">1</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">White</th>\n    <td class=\"Cell\">-Infinity</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Yellow</th>\n    <td class=\"Cell\">2</td>\n  </tr>\n  <tr>\n    <th class=\"RowHeader\" rowspan=\"1\">Total</th>\n    <td class=\"Cell\">Nothing</td>\n  </tr>\n</table>"
    expect_identical(as.character(pt$getHtml(exportOptions=list(exportNegInfAs="-Infinity", exportPosInfAs="Infinity",
                                                                exportNAAs="Nothing", exportNaNAs="Not a Number"))), html)

  })
}