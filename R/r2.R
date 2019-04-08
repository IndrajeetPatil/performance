#' Compute the model's R2
#'
#' Returns a list containing values related to the most appropriate R2 for the given model. See the list below:
#' \itemize{
#'   \item Logistic models (glm): \link[=r2_tjur]{Tjur's R2}
#'   \item General linear models (glm): \link[=r2_nagelkerke]{Nagelkerke's R2}
#'   \item Multinomial Logit (mlogit): \link[=r2_mcfadden]{McFadden's R2}
#'   \item Mixed models (merMod, glmmTMB): \link[=r2_nakagawa]{Nakagawa's R2}
#'   \item Bayesian models (brmsfit, stanreg): \link[=r2_bayes]{R2 bayes}
#' }
#'
#' @param model A statistical model.
#' @param ... Arguments passed to or from other methods.
#'
#' @examples
#' model <- glm(vs ~ wt + mpg, data = mtcars, family = "binomial")
#' r2(model)
#' \dontrun{
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Petal.Length + (1 | Species), data = iris)
#' r2(model)
#' }
#'
#' @export
r2 <- function(model, ...) {
  UseMethod("r2")
}




#' @export
r2.lm <- function(model, ...) {
  model_summary <- summary(model)
  out <- list()
  out$R2 <- model_summary$r.squared

  f.stat <- model_summary$fstatistic[1]
  DoF <- model_summary$fstatistic[2]
  DoF_residual <- model_summary$fstatistic[3]

  if (!is.null(f.stat)) {
    attr(out, "p_value") <- stats::pf(f.stat, DoF, DoF_residual, lower.tail = FALSE)
    attr(out, "F_statistic") <- f.stat
    attr(out, "DoF") <- DoF
    attr(out, "DoF_residual") <- DoF_residual
  }

  out$R2_adjusted <- model_summary$adj.r.squared
  out
}




#' @export
r2.glm <- function(model, ...) {
  if (insight::model_info(model)$is_logit) {
    list("R2_Tjur" = r2_tjur(model))
  } else {
    list("R2_Nagelkerke" = r2_nagelkerke(model))
  }
}




#' @export
r2.mlogit <- function(model, ...) {
  list("R2_McFadden" = r2_mcfadden(model))
}


#' @export
r2.polr <- function(model, ...) {
  list("R2_Nagelkerke" = r2_nagelkerke(model))
}


#' @export
r2.clm2 <- function(model, ...) {
  list("R2_Nagelkerke" = r2_nagelkerke(model))
}


#' @export
r2.clm <- function(model, ...) {
  list("R2_Nagelkerke" = r2_nagelkerke(model))
}


#' @export
r2.vglm <- function(model, ...) {
  list("R2_Nagelkerke" = r2_nagelkerke(model))
}


#' @export
r2.multinom <- function(model, ...) {
  list("R2_Nagelkerke" = r2_nagelkerke(model))
}


#' @export
r2.plm <- function(model, ...) {
  model_summary <- summary(model)
  list(
    "R2" = model_summary$r.squared[1],
    "R2_adjusted" = model_summary$r.squared[2]
  )
}


#' @export
r2.merMod <- function(model, ...) {
  r2_nakagawa(model)
}


#' @export
r2.glmmTMB <- function(model, ...) {
  r2_nakagawa(model)
}


#' @export
r2.MixMod <- function(model, ...) {
  r2_nakagawa(model)
}


#' @export
r2.mixed <- function(model, ...) {
  r2_nakagawa(model)
}


#' @export
r2.lme <- function(x, ...) {
  r2_nakagawa(x)
}


#' @export
r2.brmsfit <- function(model, ...) {
  r2_bayes(model)
}


#' @export
r2.stanreg <- function(model, ...) {
  r2_bayes(model)
}

#' #' @export
#' r2.stanmvreg <- function(x, ...) {
#'   NULL
#' }
#'