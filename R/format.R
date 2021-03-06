#' @export
format.compare_performance <- function(x, digits = 2, ...) {
  # if we have ranking, add score and remove incomplete indices in print
  if ("Performance_Score" %in% colnames(x)) {
    x$Performance_Score <- insight::format_value(x$Performance_Score, as_percent = TRUE)
    x <- x[!sapply(x, anyNA)]
  }
  if ("BF" %in% colnames(x)) {
    x$BF[is.na(x$BF)] <- 1
    # x$BF <- insight::format_bf(x$BF)
  }
  insight::format_table(x, digits = digits, ...)
}


#' @export
format.performance_model <- function(x, digits = 2, ...) {
  # format p-values for meta-analysis
  insight::format_table(x, digits = digits, ...)
}
