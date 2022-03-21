source(here::here("R/00-package-loading.R"))
load(file="data/processed-data/my-data.rda")


kernel_norm <- function(x_ts, x_tr, y_tr, h){
    sum((1/(h*sqrt(2*pi)))*exp(-.5*((x_ts-x_tr)/h)^2)*y_tr)/
    sum((1/(h*sqrt(2*pi)))*exp(-.5*((x_ts-x_tr)/h)^2))
}

kernel_reg <- function(x_ts, h){
    sapply(x_ts, kernel_norm, x_tr, y_tr, h)
}

dist <- data$dist
err <- data$err

RSS.KR <- function(h){
    x1 <- dist
    x <- dist
    y <- err
    y1 <- rep(0, length(x))
    for(i in 1:length(x)){
        y1[i] <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-x[-i])/h)^2)*y[-i])/
            sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-x[-i])/h)^2))
    }
    res <- y - y1
    RSS <- sum(res^2)
    RSS
}


h <- optim(1, RSS.KR)$par; h
