source("renv/activate.R")
library(dplyr)
library(haven)
library(zeallot)

# **Generation of data.**
# Set the total number of shifts to `1029`,
#  where a third of
# them correspond to the morning shifts,
#  and all the rest to evening/night shifts.
# Denote the binary indicator of
# the morning shift by morning.
# Given morning = `1`
# generate a binary indicator Lucia
# of whether Lucia was on duty from `Bern(0.4)`,
# otherwise from `Bern(0.1)`.
# If you aggregate these two indicators into a 2-by-2 table,
#  you will get something
# similar to:

# You will get different numbers,
# but of the same order of magnitude.

shifts <- 1029

morning <- sample(c(FALSE, TRUE),
    size = shifts,
    replace = TRUE,
    prob = c(2 / 3, 1 / 3)
)

lucia <- ifelse(
    morning == TRUE,
    rbinom(n = shifts, size = 1, prob = 0.4),
    rbinom(n = shifts, size = 1, prob = 0.1)
) == 1

tb <- tibble(
    morning = morning,
    Lucia = lucia
)

tb |> count(Lucia, morning)

table(Lucia = tb$Lucia, Morning = tb$morning) |> addmargins()

# Now, generate the number of incidences (deaths)
#  occurred for each of the combi-
# nations of Lucia and morning,
#  from the following Poisson regression model
#  with a log link and an offset for the number of shifts

# $$
# log \big( \frac{\mu (x_1, x_2)}{t(x_1, x_2)} \big)
# = \beta_0 + \beta_1 x_1 + \beta_2 x_2 # nolint
# $$

# Where $X_1$ = _morning_, $X_2$=_Lucia_ $t(x_1, x_2)
# $ equals the number of shifts corre-
# sponding to $(x_1, x_2)$ and,
# with $\beta_0 = -4, \beta_1 = 1.7, \beta_2 = 0$.

c(beta_0, beta_1, beta_2) %<-% c(-4.0, 1.7, 0.0)

cell_counts <- tb |> count(morning, Lucia, name = "shift_count")
cell_counts


# We want to find $\mu (x_1, x_2) = $ Expected number of deaths
# $$
# log \big( \frac{\mu (x_1, x_2)}{t(x_1, x_2)} \big)
# = \beta_0 + \beta_1 x_1 + \beta_2 x_2
# $$
# $$
# \implies \frac{\mu (x_1, x_2)}{t(x_1, x_2)}
# = e^{\beta_0 + \beta_1 x_1 + \beta_2 x_2}
# $$
# $$
# \implies \mu (x_1, x_2)
# = e^{\beta_0 + \beta_1 x_1 + \beta_2 x_2}\cdot t(x_1, x_2)
# $

tb2 <- cell_counts |>
    mutate(mu = shift_count * exp(beta_0 + beta_1 * morning + beta_2 * Lucia))

# Now apply the poission to the $\mu$
tb2 <- tb2 |> mutate(deaths = rpois(n = n(), lambda = mu))
tb2

lucia_marginal <- tb2 |>
    group_by(Lucia) |>
    summarise(
        deaths = sum(deaths),
        shifts = sum(shift_count),
    )


# (b) **Careful analysis**.
# Analyze the obtained count data
# using the Poisson log-linear regression with an
#  intercept and 2 factors
# $X_1 = morning$ and $X_2 = Lucia$, and
# include an offset term to account for the
# different number of shifts between Lucia
# de Berk and the rest of the nurses.
# Keep the pvalue corresponding to the effect of $X_2$.
tb2 <- tb2 |>
    mutate(
        morning = as.integer(morning),
        Lucia   = as.integer(Lucia)
    )

y <- tb2$deaths

fit_b <- glm(
    deaths ~ morning + Lucia,
    family = poisson(link = "log"),
    data = tb2,
    offset = log(shift_count)
)


lucia_pvalue <- summary(fit_b)$coefficients["Lucia", "Pr(>|z|)"]
morning_pvalue <- summary(fit_b)$coefficients["morning", "Pr(>|z|)"]
cat(
    "P values:\n======\n",
    sprintf("Morning: %s Lucia: %s", morning_pvalue, lucia_pvalue)
)


# (c) **Less careful analysis.** Aggregate the data over
# $X_1 = morning$ in order to obtain similar data as
#  the real data set in Lucia de Berk’s trial.
# Analyze the obtained count data using again
# the Poisson log-linear regression with an intercept,
# a factor of $X_2 = Lucia$, and also include
# an offset term to account for the different
# number of shifts between Lucia de Berk
# and the rest of the nurses. Keep the pvalue
# corresponding to the effect of $X_2$.

agg <- tb2 |>
    group_by(Lucia) |>
    summarise(
        deaths = sum(deaths),
        shift_count = sum(shift_count)
    )


fit_c <- glm(
    deaths ~ Lucia,
    family = poisson(link = "log"),
    data = agg,
    offset = log(shift_count)
)

fit_c
summary(fit_c)$coefficients["Lucia", "Pr(>|z|)"]

# (d) **Original analysis.**
# Under the null hypothesis that there is no difference between
# Lucia de Berk and other nurses, and under several additional assumptions, with
# one of them being that there are no other imoportant factors to be taken into
# account (aka confounders)
# (and also under blinded/fair data collection process),
# the conditional probability
# (given the total number of incidents and the total number
# of shifts) of observing the number of incidences
# (q) which was observed, or more,
# 3(7) (."2)/ ("Ee")
# could be calculated using the hypergeometric
# distribution (see page 235 in Meester
# et al. (2006)) summed up for all $x$ values which are $\geq x$ and $\leq k$:

# $$
# \frac{\binom{m}{x}\binom{n}{k-x}}{\binom{m+n}{k}}
# $$

# where $k$ is the number of incidents occurred,
# $n$ is the number of shifts of other
# nurses, $m$ is the number of shifts of Lucia,
# $x$ is the number of incidents ocurred
# during the shifts of Lucia. Keep the obtained pvalue.

# Summarize the results of 200 replications by calculating
#  the proportion of times you
# rejected the null hypothesis that there is no difference
#  between Lucia de Berk and other
# nurses (i.e., no nurse effect),
# for each type of the 3 analyses separately. Use the 0.05
# significance level for rejection of the null hypothesis.


# Breakdown:

# - $n = $  number of shifts worked by Lucia
# - $m = $  number of shifts worked by Other Nurses
# - Total shifts $= m+n$
# - $k = $  number of incidents
# - $x = $  number of incidents in Lucia's shift

# $H_0 = $ Lucia has the same rate as Other Nurses

# $$
# P(X=x)=\frac{\binom{m}{x}\binom{n}{k-x}}{\binom{m+n}{k}}
# $$

# Explanation:

# 1. $\binom{m}{x}$: choose which $x$ of Lucia's $m$ shifts had incidents
# 2. $\binom{n}{k-x}$: choose which
# $k-x$ of the other nurseses $n$ shifts had incidents
# 3. divide by $\binom{m+n}{k}$: all ways to place $k$
# incidents among all shifts

n <- tb2 |>
    filter(Lucia == FALSE) |>
    summarise(shift_count = sum(shift_count)) |>
    pull()

m <- tb2 |>
    filter(Lucia == TRUE) |>
    summarise(shift_count = sum(shift_count)) |>
    pull()

x <- tb2 |>
    filter(Lucia == TRUE) |>
    summarise(deaths = sum(deaths)) |>
    pull()


k <- tb2 |>
    summarise(deaths = sum(deaths)) |>
    pull()

cat(n, m, x, k, sep = "\n")

p_value <- phyper(x - 1, m, n, k, lower.tail = FALSE)

p_value

# ========================
# == Simulation section ==
# ========================

NUM_SIMULATIONS <- 200
P_THRESH <- 0.05

gen_data <- function(shifts = 1029,
                     beta_0 = -4.0,
                     beta_1 = 1.7,
                     beta_2 = 0.0,
                     mornings_part = 1 / 3) {
    morning <- sample(c(FALSE, TRUE),
        size = shifts,
        replace = TRUE,
        prob = c(2 / 3, 1 / 3)
    )
    lucia <- ifelse(
        morning == TRUE,
        rbinom(n = shifts, size = 1, prob = 0.4),
        rbinom(n = shifts, size = 1, prob = 0.1)
    ) == 1

    data <- tibble(
        morning = as.integer(morning),
        Lucia = as.integer(lucia)
    )

    data <- data |> count(morning, Lucia, name = "shift_count")

    data <- data |> mutate(mu = shift_count * exp(beta_0 + beta_1 * morning + beta_2 * Lucia))

    # Now apply the poission to the $\mu$
    data <- data |> mutate(deaths = rpois(n = n(), lambda = mu))
    data
}

sim_b <- function(data) {
    fit_b <- glm(
        deaths ~ morning + Lucia,
        family = poisson(link = "log"),
        data = data,
        offset = log(shift_count)
    )

    summary(fit_b)$coefficients["Lucia", "Pr(>|z|)"]
}
sim_c <- function(data) {
    agg <- data |>
        group_by(Lucia) |>
        summarise(
            deaths = sum(deaths),
            shift_count = sum(shift_count)
        )


    fit_c <- glm(
        deaths ~ Lucia,
        family = poisson(link = "log"),
        data = agg,
        offset = log(shift_count)
    )

    summary(fit_c)$coefficients["Lucia", "Pr(>|z|)"]
}

sim_d <- function(data) {
    n <- data |>
        filter(Lucia == FALSE) |>
        summarise(shift_count = sum(shift_count)) |>
        pull()

    m <- data |>
        filter(Lucia == TRUE) |>
        summarise(shift_count = sum(shift_count)) |>
        pull()

    x <- data |>
        filter(Lucia == TRUE) |>
        summarise(deaths = sum(deaths)) |>
        pull()


    k <- data |>
        summarise(deaths = sum(deaths)) |>
        pull()


    phyper(x - 1, m, n, k, lower.tail = FALSE)
}

counter_b <- 0
counter_c <- 0
counter_d <- 0
# We the number of simlutations that cross our P value Threshhold.
for (i in 1:NUM_SIMULATIONS) {
    d <- gen_data()
    counter_b <- counter_b + as.integer(sim_b(data = d) < P_THRESH)
    counter_c <- counter_c + as.integer(sim_c(data = d) < P_THRESH)
    counter_d <- counter_d + as.integer(sim_d(data = d) < P_THRESH)
}

cat(
    sprintf("Number of pvalues below threshhold (%s)\n", P_THRESH),
    "=====\n",
    sprintf(
        "Simulation b: %s/%s (%s percent)\n",
        counter_b, NUM_SIMULATIONS, (counter_b / NUM_SIMULATIONS) * 100
    ),
    sprintf(
        "Simulation c: %s/%s (%s percent)\n",
        counter_c, NUM_SIMULATIONS, (counter_c / NUM_SIMULATIONS) * 100
    ),
    sprintf(
        "Simulation d: %s/%s (%s percent)\n",
        counter_d, NUM_SIMULATIONS, (counter_d / NUM_SIMULATIONS) * 100
    )
)
