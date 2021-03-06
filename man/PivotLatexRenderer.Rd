% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PivotLatexRenderer.R
\docType{class}
\name{PivotLatexRenderer}
\alias{PivotLatexRenderer}
\title{A class that renders a pivot table in Latex.}
\format{\code{\link{R6Class}} object.}
\usage{
PivotLatexRenderer
}
\value{
Object of \code{\link{R6Class}} with properties and methods that
  render to Latex.
}
\description{
The PivotLatexRenderer class creates a Latex representation of a pivot table.
}
\section{Fields}{

\describe{
\item{\code{parentPivot}}{Owning pivot table.}
}}

\section{Methods}{

\describe{
  \item{Documentation}{For more complete explanations and examples please see
  the extensive vignettes supplied with this package.}
  \item{\code{new(...)}}{Create a new pivot table renderer, specifying the
  field value documented above.}

  \item{\code{clearIsRenderedFlags()}}{Clear the IsRendered flags that exist
  on the PivotDataGroup class.}
  \item{\code{resetVisibleRange()}}{Clears the visible range that has been
  set, so the next call to getTableLatex() will render the whole table.}
  \item{\code{setVisibleRange(fromRow=NULL, toRow=NULL, fromColumn=NULL,
  toColumn=NULL)}}{Specifies a subset of the pivot table to be rendered, e.g.
  for use when a pivot table will not fit into a single A4 page.}
  \item{\code{clearIsRenderedFlags()}}{}
  \item{\code{getTableLatex = function(caption=NULL, label=NULL,
  boldHeadings=FALSE, italicHeadings=FALSE, exportOptions=NULL))}}{Get
  a Latex representation of the pivot table, specifying the caption to
  appear above the table, the label to use when referring to the table
  elsewhere in the document and how headings should be styled.}
}
}

\examples{
# This class should only be created by the pivot table.
# It is not intended to be created outside of the pivot table.
}
\keyword{datasets}
