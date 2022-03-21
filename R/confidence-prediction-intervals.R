source(here::here("R/00-package-loading.R"))
source(here::here("R/kernel-regression-functions.R"))
load(file="data/processed-data/kr-data.rda")
load(file="data/processed-data/my-data.rda")
load(file="data/processed-data/res-data.rda")


Ey.x5 <- rep(0, 1000)
for(k in 1:1000){
    # Step 1. fit model, compute original residuals
    
    # ALREADY DID THAT
    
    # Step 2. resample the x's with replacement
    
    BS.x <- sample(dist, length(dist), replace=TRUE)
    
    # Step 3. computer BS.yhat by pluggig BS.x into original model. Can't use predict function anymore
    
    x1 <- BS.x
    y1 <- rep(0, length(dist))
    for(i in 1:length(dist)){
        y1[i] <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2)*err)/
                 sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2))
    }
    BS.yhat <- y1
    hist(y1)
    
    # Step 4. turn BS.yhat into BS.y by adding a random orig residual
    
    BS.y <- BS.yhat + sample(orig_res, length(dist), replace=TRUE)
    hist(BS.y)
    
    # Step 5. make new model, then use new model to predict expected y when x =  whatever number we want
    
    x_pred <- 8
    y_pred <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x_pred-BS.x)/h)^2)*BS.y)/
              sum((1/(h*sqrt(2*pi)))*exp(-.5*((x_pred-BS.x/h)^2)))

    y_pred
    
    # Step 6. wrap steps 1-5 in a loop, do it 1000 times. 
    
    Ey.x5[k] <- y_pred 
}

lb <- sort(Ey.x5)[25]
ub <- sort(Ey.x5)[975]

plot(dist, err)
x1 <- seq(min(dist), max(dist), length.out=1400)
y1 <- rep(0, 1400)
for(i in 1:1400){
    y1[i] <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2)*err)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2))
}

lines(x1, y1, col=2, lwd=3)

lines(c(7,7), c(lb,ub), col=4, lwd=3)










