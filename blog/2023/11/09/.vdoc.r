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
knitr::opts_chunk$set(
    # fig.width = 6, 
    # fig.height = 3.8,
    fig.align = "center", 
    # fig.retina = 3,
    out.width = "100%", 
    warning = FALSE,
    # evaluate = FALSE,
    collapse = TRUE
)
#
#
#
#
#
#
### Set pseudorandom number generator
set.seed(1233)

### Load packages
library(here)         # relative path
library(tidyverse)    # data manipulation and visualization
library(kernlab)      # SVM methodology
library(e1071)        # SVM methodology
library(ISLR)         # contains example dataset "Khan"
library(RColorBrewer) # customized coloring of plots
#
#
#
#
#
### Construct sample data set- completely separated
x <- matrix(rnorm(20*2), ncol = 2)
y <- c(rep(-1, 10), rep(1, 10))
x[y==1, ] <- x[y == 1, ] + 3/2
dat  <- data.frame(x = x, y = as.factor(y))

### Plot data
ggplot(dat, aes(x = x.2, y = x.1, color = y, shape = y)) +
    geom_point(size = 2) +
    scale_color_manual(values = c("#000000", "#FF0000")) +
    theme(legend.position = "none")

### Fit svm to data set
svmfit <- svm(y ~., data = dat, kernel = "linear", scale = FALSE)

### Plot results
plot(svmfit, dat)
#
#
#
### Fit model and produce plot
kernfit <- ksvm(x, y, type = "C-svc", kernel = "vanilladot")
plot(kernfit, data = x)
#
#
#
#
#
### Construct sample data set - not completely separated
x <- matrix(rnorm(20*2), ncol = 2)
y <- c(rep(-1,10), rep(1,10))
x[y==1,] <- x[y==1,] + 1
dat <- data.frame(x=x, y=as.factor(y))

### Plot data
ggplot(data = dat, aes(x = x.2, y = x.1, color = y, shape = y)) + 
  geom_point(size = 2) +
  scale_color_manual(values=c("#000000", "#FF0000")) +
  theme(legend.position = "none")
#
#
#
### Fit Support Vector Machine model to data set
svmfit <- svm(y~., data = dat, kernel = "linear", cost = 10)
# Plot Results
plot(svmfit, dat)
#
#
#
### Fit Support Vector Machine model to data set
kernfit <- ksvm(x,y, type = "C-svc", kernel = 'vanilladot', C = 100)
# Plot results
plot(kernfit, data = x)
#
#
#
### Find optimal cost of misclassification
tune_out <- tune(svm, y~., data = dat, kernel = "linear",
                 ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)))

### Extract the best model
bestmod <- tune_out$best.model
bestmod

### Create a table of misclassified observations
ypred <- predict(bestmod, dat)

misclass <- table(predict = ypred, truth = dat$y)
misclass
#
#
#
#
#
### Construct larger random data set
x <- matrix(rnorm(200*2), ncol = 2)
x[1:100,] <- x[1:100,] + 2.5
x[101:150,] <- x[101:150,] - 2.5
y <- c(rep(1,150), rep(2,50))
dat <- data.frame(x=x,y=as.factor(y))

# Plot data
ggplot(data = dat, aes(x = x.2, y = x.1, color = y, shape = y)) + 
  geom_point(size = 2) +
  scale_color_manual(values=c("#000000", "#FF0000")) +
  theme(legend.position = "none")
#
#
#
### Set pseudorandom number generator
set.seed(123)

### Sample training data and fit model
train <- base::sample(200,100, replace = FALSE)
svmfit <- svm(y~., data = dat[train,], kernel = "radial", gamma = 1, cost = 1)

# Plot classifier
plot(svmfit, dat)
#
#
#
# Fit radial-based SVM in kernlab
kernfit <- ksvm(x[train,],y[train], type = "C-svc", kernel = 'rbfdot', C = 1, scaled = c())

# Plot training data
plot(kernfit, data = x[train,])
#
#
#
### Tune model to find optimal cost, gamma values
tune_out <- tune(svm, y~., data = dat[train,], kernel = "radial",
                 ranges = list(cost = c(0.1,1,10,100,1000),
                 gamma = c(0.5,1,2,3,4)))
### Show best model
tune_out$best.model

### Validate model performance
valid <- table(
    true = dat[-train,"y"], 
    pred = predict(tune_out$best.model, newx = dat[-train,])
)
valid
#
#
#
#
#
# construct data set
x <- rbind(x, matrix(rnorm(50*2), ncol = 2))
y <- c(y, rep(0,50))
x[y==0,2] <- x[y==0,2] + 2.5
dat <- data.frame(x=x, y=as.factor(y))
# plot data set
ggplot(data = dat, aes(x = x.2, y = x.1, color = y, shape = y)) + 
  geom_point(size = 2) +
  scale_color_manual(values=c("#000000","#FF0000","#00BA00")) +
  theme(legend.position = "none")
#
#
#
#
#
#
#
