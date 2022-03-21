source(here::here("R/00-package-loading.R"))
source(here::here("R/kernel-regression-functions.R"))
load(file="data/processed-data/kr-data.rda")
load(file="data/processed-data/my-data.rda")
load(file="data/processed-data/res-data.rda")

x1 <- dist
y1 <- rep(0, length(dist))
for(i in 1:length(dist)){
    y1[i] <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2)*err)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2))
}
o.res <- y1 - err

sim <- 200
Ey <- matrix(0, nrow=sim, ncol=3)
for(k in 1:sim){
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
    #hist(y1)
    
    # Step 4. turn BS.yhat into BS.y by adding a random orig residual
    
    BS.y <- BS.yhat + sample(o.res, length(dist), replace=TRUE)
    #hist(BS.y)
    
    # Step 5. make new model, then use new model to predict expected y when x =  whatever number we want
    
    y_.1 <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((.1-BS.x)/h)^2)*BS.y)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((.1-BS.x)/h)^2))
    
    y_1 <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((1-BS.x)/h)^2)*BS.y)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((1-BS.x)/h)^2))
    
    y_10 <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((10-BS.x)/h)^2)*BS.y)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((10-BS.x)/h)^2))
    
    # Step 6. wrap steps 1-5 in a loop, do it 1000 times. 
    
    Ey[k,1] <- y_.1
    Ey[k,2] <- y_1
    Ey[k,3] <- y_10
}

Ey[is.na(Ey)] <- 0
sorted_Ey <- apply(Ey, 2, sort); sorted_Ey

lb_.1 <- sorted_Ey[.025*sim,1]
ub_.1 <- sorted_Ey[.975*sim,1]

lb_1 <- sorted_Ey[.025*sim,2]
ub_1 <- sorted_Ey[.975*sim,2]

lb_10 <- sorted_Ey[.025*sim,3]
ub_10 <- sorted_Ey[.975*sim,3]
# lb <- sort(Ey)[.025*sim,1]
# ub <- sort(Ey)[.975*sim,1]


plot(dist, err, xlim=c(0,11))
x1 <- seq(min(dist), max(dist), length.out=1400)
y1 <- rep(0, 1400)
for(i in 1:1400){
    y1[i] <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2)*err)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2))
}

lines(x1, y1, col=2, lwd=3)

lines(c(.1,.1), c(lb_.1,ub_.1), col=4, lwd=3)
lines(c(1,1), c(lb_1,ub_1), col=4, lwd=3)

Ey.1 <- Ey[,1]
Ey1 <- Ey[,2]
Ey10 <- Ey[,3]
Ey.1

# Prediction intervals

pred.1 <- Ey.1 + sample(o.res, 1000, replace=TRUE);
lb.1 <- sort(pred.1)[25]
ub.1 <- sort(pred.1)[975]

pred1 <- Ey1 + sample(o.res, 1000, replace=TRUE)
lb1 <- sort(pred1)[25]
ub1 <- sort(pred1)[975]


pred10 <- Ey10 + sample(o.res, 1000, replace=TRUE)
lb10 <- sort(pred10)[25]
ub10 <- sort(pred10)[975]

lines(c(.1,.1), c(lb.1,ub.1), col=4, lwd=3)
lines(c(1,1), c(lb1,ub1), col=4, lwd=3)


lb10;ub10

save(lb_.1, ub_.1, lb_1, ub_1, lb_10, ub_10, file="data/processed-data/ci-data.rda")
save(lb.1, ub.1, lb1, ub1, lb10, ub10, file="data/processed-data/ci-data.rda")








