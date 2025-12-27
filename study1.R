source("renv/activate.R")
library(dplyr)
library(tidyverse)
library(haven)

# -1- Loading the data
path <- "datasources-time-travel/Study\ 1/ETT_ESM_Study1.sav"
print(sprintf("Reading %s", path))
tib <- haven::read_sav(path)
colnames(tib)

# -2- Initial cleaning
tib_clean <- tib |>
  select(where(~ !all(is.na(.))))

# - Poisson regression analysis
tib_clean |> group_by(Subject)
length(tib_clean)

### Poisson Regression Analysis

# Use Poisson regression to assess
#  whether thinking about the future is related to age,
# sex, and the so-called Big Five personality traits,
#  denoted by A, C, E, N and O

# (a) Create a subject-level data set (492 rows)
#  with the following variables: the above
# seven predictors, the number of observations
# for the given subject (up to 18), and his/her
# number of future thoughts (i.e., number of observations
# for which future=1). (Hint: The
# aggregate() function or dplyr::group by() may be useful.)
subj_level <- tib_clean |>
  group_by(Subject) |>
  summarise(
    age = first(age, na_rm = TRUE),
    sex = first(sex, na_rm = TRUE),
    O = first(O, na_rm = TRUE),
    C = first(C, na_rm = TRUE),
    E = first(E, na_rm = TRUE),
    A = first(A, na_rm = TRUE),
    N = first(N, na_rm = TRUE),
    n_obs = n(),
    n_futures = sum(time_3, na.rm = TRUE)
  ) |>
  drop_na(age, sex, O, C, E, A, N)

#  Use descriptFive statistics
# and graphs to inspect these variables,
# and describe any missing data.
table(subj_level$age, useNA = "ifany")
table(subj_level$sex, useNA = "ifany")
sapply(
  subj_level[, c("age", "O", "C", "E", "A", "N", "n_obs", "n_futures")],
  function(x) {
    c(
      Mean = mean(x, na.rm = TRUE),
      SD = sd(x, na.rm = TRUE),
      Min = min(x, na.rm = TRUE),
      Max = max(x, na.rm = TRUE)
    )
  }
)
par(mfrow = c(3, 3))
hist(subj_level$age, main = "Age", xlab = "Age", col = "darkblue")
hist(subj_level$O, main = "O", xlab = "O", col = "purple")
hist(subj_level$C, main = "C", xlab = "C", col = "brown")
hist(subj_level$E, main = "E", xlab = "E", col = "green")
hist(subj_level$A, main = "A", xlab = "A", col = "yellow")
hist(subj_level$N, main = "N", xlab = "N", col = "pink")

# (b) Using your favorite model selection method,
#  find an appropriate Poisson regression
# with number of future thoughts as response
# and a subset of the above seven predictors.
# Include an offset term to account for the different
#  numbers of observations per person.

model <- glm(n_futures ~ age + sex + O + C + E + A + N,
  data = subj_level,
  family = poisson(link = "log"),
  offset = log(n_obs)
)
summary(model)


# (c) Test for overdispersion in the chosen model,
#  and refit the same model with the “quasipoisson” family.
#  Does this change the model results? Why or why not?

disp <- deviance(model) / df.residual(model)
if (disp > 1.5) {
  print(sprintf("Overdispersion detected: (%s)", disp))
} else {
  print(sprintf("No Overdispersion detected: (%s)", disp))
}

quasi_model <- glm(n_futures ~ age + sex + O + C + E + A + N,
  data = subj_level,
  family = quasipoisson(link = "log"),
  offset = log(n_obs),
)

summary(quasi_model)$dispersion

quasi_disp <- summary(quasi_model)$dispersion
if (quasi_disp > 1.5) {
  print(sprintf("Quasi: Overdispersion detected: (%s)", quasi_disp))
} else {
  print(sprintf("Quasi: No Overdispersion detected: (%s)", quasi_disp))
}
