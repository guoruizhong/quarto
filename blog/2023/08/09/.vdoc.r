#
#
#
#
#
#
#
#
#
#
#
knitr::opts_chunk$set(
  # fig.width = 6, 
  # fig.height = 3.8, 
  # out.width = "85%", 
  # fig.retina = 3,
  fig.align = "center", 
  warning = FALSE,
  collapse = TRUE
)
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| warning: false
### Load packages
library(here)
library(tidyverse)
library(sva)
library(bladderbatch)
library(pamr)
library(limma)
library(survival)
#
#
#
### load data
data(bladderdata)
### variable data
pheno <- pData(bladderEset)
class(pheno)
head(pheno, n = 5)
### expression data matrix
edata <- exprs(bladderEset)
class(edata)
head(edata[, 1:5])
### create full model matrix, including both the adjustment variables and the variable of interest (cancer status)
mod <- model.matrix(~ as.factor(cancer), data = pheno)
### Create null model matrix, ontains only the adjustment variables.
mod0 <- model.matrix(~ 1, data = pheno) 
```
#
#
#
### identify the number of latent factors that need to be estimated
n_sv <- num.sv(edata, mod, method = "leek")
n_sv
## estimate the surrogate variables
svaobj <- sva(edata, mod, mod0, n.sv = n_sv)
str(svaobj)
summary(lm(svaobj$sv ~ pheno$batch))
boxplot(svaobj$sv[, 2] ~ pheno$batch)
points(svaobj$sv[, 2] ~ jitter(as.numeric(pheno$batch)), col = as.numeric(pheno$batch))
dev.off()
```
#
#
#
### calculate the parametric F-test p-values for each row of a data matrix
pvalues <- f.pvalue(edata, mod, mod0)
### adjust them for multiple teseting
qvalues <- p.adjust(pvalues, method = "BH")
```
#
#
#
#
#
### include the surrogate variables
modsv <- cbind(mod, svaobj$sv)
mod0sv <- cbind(mod0, svaobj$sv)
pvalues_sv <- f.pvalue(edata, modsv, mod0sv)
qvalues_sv <- p.adjust(pvalues, method = "BH")
```
#
#
#
### fit the linear model with the surrogate variabels
fit <- lmFit(edata, modsv)
### compute the contrasts between cancer/normal terms
contrast_matrix <- cbind(
  "C1" = c(-1, 1, 0, rep(0, svaobj$n.sv)),
  "C2" = c(0, -1, 1, rep(0, svaobj$n.sv))
)
fit_contrasts <- contrasts.fit(fit, contrast_matrix)

### calculate the test statistics
eb <- eBayes(fit_contrasts)
topTableF(eb, adjust = "BH")
#
#
#
#
#
#
#
#| warning: false
### get known batch variable
batch <- pheno$batch
### model matrix
modcombat <- model.matrix(~1, data = pheno)
modcancer <- model.matrix(~cancer, data = pheno)

### Using parametric empirical Bayesian adjustments.
combat_edata <- ComBat(
    dat = edata,
    batch = batch, 
    mod = modcombat,
    par.prior = TRUE, # performs parametric empirical Bayesian adjustment
    # par.prior = FALSE, # performs non-parametric empirical Bayesian adjustment
    prior.plots = FALSE,
    mean.only = FALSE, # only adjust the mean of the batch effects across batches
    ref.batch = NULL
)

### significance analysis
pvalue_combat <- f.pvalue(combat_edata, mod, mod0)
qvalue_combat <- p.adjust(pvalue_combat, method = "BH")

combat_fit <- lm.fit(modcancer, t(combat_edata))
hist(combat_fit$coefficients[2, ], col = 4, breaks = 100)
#
#
#
#
#
#
#
#
#
#| warning: false
mod_batch <- model.matrix(~as.factor(cancer) + as.factor(batch), data = pheno)
mod0_batch <- model.matrix(~as.factor(batch), data = pheno)
pvalues_batch <- f.pvalue(edata, mod_batch, mod0_batch)
qvalues_batch <- p.adjust(pvalues_batch, method = "BH")

fit <- lm.fit(mod_batch, t(edata))
hist(fit$coefficients[2, ], col = 4, breaks = 100)
#
#
#
#
#
#
#
#
#| warning: false
plot(
  fit$coefficients[2, ], combat_fit$coefficients[2, ], col = 4,
  xlab = "Linear Model", ylab = "Combat", xlim = c(-5, 5), ylim = c(-5, 5)
)
abline(c(0, 1), col = 2, lwd = 3)
#
#
#
#
### Add the surrogate variables to the model matrix and perform model fit
modsv <- cbind(mod, sva1$sv)
fitsv <- lm.fit(modsv, t(edata))

### Compare the fit from surrogate variable analysis to the other two
par(mfrow = c(1, 2))
plot(
  fitsv$coefficients[2,], combat_fit$coefficients[2, ], 
  col = 2, xlab = "SVA", ylab = "Combat", xlim = c(-5, 5), ylim = c(-5, 5)
)
abline(c(0, 1), col = 1, lwd = 3)
plot(
  fitsv$coefficients[2,], fit$coefficients[2, ], 
  col = 2, xlab = "SVA", ylab = "Linear model", xlim = c(-5, 5), ylim = c(-5, 5)
)
abline(c(0, 1), col = 1, lwd = 3)
``` 
#
#
#
### expression matrix
count_matrix <- matrix(
  rnbinom(400, size = 10, prob =  0.1),
  nrow = 50, ncol = 8
)
### batch
batch <- c(rep(1, 4), rep(2, 4))

### adjust
adjusted <- ComBat_seq(
  count_matrix, 
  batch = batch, 
  group = NULL
)

### specify one biological variable
group <- rep(c(0, 1), 4)
adjusted_counts <- ComBat_seq(
  count_matrix, 
  batch = batch, 
  group = group
)

### multiple biological variabels
cov1 <- rep(c(0, 1), 4)
cov2 <- c(0, 0, 1, 1, 0, 0, 1, 1)
covar_mat <- cbind(cov1, cov2)
adjusted_counts <- ComBat_seq(
  count_matrix, 
  batch = batch, 
  group = NULL, 
  covar_mod = covar_mat
)
#
#
#
#
#
n_sv <- num.sv(edata, mod, vfilter = 2000, method = "leek")
svaobj <- sva(edata, mod, mod0, n.sv = n_sv, vfilter = 2000)
```
#
#
#
### seprate data to traning and test set
set.seed(12354)
train_indicator <- sample(1:57, size = 30, replace = FALSE)
test_indicator <- (1:57)[-train_indicator]
train_data <- edata[, train_indicator]
test_data <- edata[, test_indicator]
train_pheno <- pheno[train_indicator, ]
test_pheno <- pheno[test_indicator, ]

### pamr package can be used to train a predictive model and test that prediction
mydata <- list(x = train_data, y = train_pheno$cancer)
mytrain <- pamr.train(mydata)
table(
  pamr.predict(mytrain, test_data, threshold = 2),
  test_pheno$cancer
)

### calculate surrogate variables for training set
train_mod <- model.matrix(~cancer, data = train_pheno)
train_mod0 <- model.matrix(~1, data = train_pheno)
train_sv <- sva(train_data, train_mod, train_mod0)

### adjust both the training data and the test data
fsvaobj <- fsva(train_data, train_mod, train_sv, test_data)
mydata_sv <- list(x = fsvaobj$db, y = train_pheno$cancer)
mytrain_sv <- pamr.train(mydata_sv)
#
#
#
#
#
#
#
#| warning: false

### Fit the linear model with surrogate variables
fit <- lmFit(edata, modsv)

### Compute the contrasts between pairs of cancer/normal terms
contrast_matrix <- cbind(
  "C1" = c(-1, 1, 0, rep(0, sva1$n.sv)),
  "C2" = c(0, -1, 1, rep(0, sva1$n.sv))
)
fitcontrasts <- contrasts.fit(fit, contrast_matrix)

### Calculate the test statistics
eb <- eBayes(fitcontrasts)
topTableF(eb, adjust = "BH")
#
#
#
#
#
#
#
#
#
