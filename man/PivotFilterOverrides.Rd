% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PivotFilterOverrides.R
\docType{class}
\name{PivotFilterOverrides}
\alias{PivotFilterOverrides}
\title{A class that defines a set of filter overrides}
\format{\code{\link{R6Class}} object.}
\usage{
PivotFilterOverrides
}
\value{
Object of \code{\link{R6Class}} with properties and methods that
  define a set of filters and associated override actions
}
\description{
The PivotFilterOverrides class contains multiple  \code{\link{PivotFilter}}
objects that can be used later to override a set of filters, e.g. in a
pivot table calculation.
}
\section{Fields}{

\describe{
\item{\code{parentPivot}}{Owning pivot table.}

\item{\code{removeAllFilters}}{TRUE to remove all existing filters before applying
any other and/replace/or filters.}

\item{\code{keepOnlyFiltersFor}}{Specify the names of existing variables to retain
the filters for.  All other filters will be removed.}

\item{\code{removeFiltersFor}}{Specify the names of variables to remove filters for.}

\item{\code{overrideFunction}}{A custom function to amend the filters in each cell.}

\item{\code{countIntersect}}{The number of PivotFilters that will be combined with other
pivot filters by intersecting their lists of allowed values.}

\item{\code{countReplace}}{The number of PivotFilters that will be combined with other
pivot filters by entirely replacing existing PivotFilter objects.}

\item{\code{countUnion}}{The number of PivotFilters that will be combined with other
pivot filters by unioning their lists of allowed values.}

\item{\code{countTotal}}{The total number of PivotFilters that will be combined with
other pivot filters.}

\item{\code{intersectFilters}}{The PivotFilters that will be combined with other
pivot filters by intersecting their lists of allowed values.}

\item{\code{replaceFilters}}{The PivotFilters that will be combined with other
pivot filters by entirely replacing existing PivotFilter objects.}

\item{\code{unionFilters}}{The PivotFilters that will be combined with other
pivot filters by unioning their lists of allowed values.}

\item{\code{allFilters}}{The complete set of PivotFilters that will be combined with
other pivot filters.}
}}

\section{Methods}{

\describe{
  \item{Documentation}{For more complete explanations and examples please see
  the extensive vignettes supplied with this package.}
  \item{\code{new(...)}}{Create a new pivot filter overrides object, specifying
  the field values documented above.}

  \item{\code{add(filter=NULL, variableName=NULL, type="ALL", values=NULL,
  action="intersect")}}{Add a pivot filter override, either from an existing
  PivotFilter object or by specifying a variableName and values.}
  \item{\code{apply(filters)}}{Apply the filter overrides to a PivotFilters
  object.}
  \item{\code{asList()}}{Get a list representation of this PivotFilterOverrides
  object.}
  \item{\code{asJSON()}}{Get a JSON representation of this PivotFilterOverrides
  object.}
  \item{\code{asString(includeVariableName=TRUE, seperator=", ")}}{Get a text
  representation of this PivotFilterOverrides object.}
}
}

\examples{
pt <- PivotTable$new()
# ...
# PivotFilterOverrides constructor allows a filter to be defined
# e.g. to enable \%of row or column type calculations
filterOverrides <- PivotFilterOverrides$new(pt, keepOnlyFiltersFor="Volume")
# Alternatively/in addition, create a new filter
filter <- PivotFilter$new(pt, variableName="Country", values="England")
# Add the filter to the set of overrides
filterOverrides$add(filter=filter, action="replace")
}
\keyword{datasets}
