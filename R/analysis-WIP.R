source(here::here("R/00-package-loading.R"))
source(here::here("R/kernel-regression-functions.R"))
load(file="data/processed-data/my-data.rda")


# LOOCV function to find h that minimizes RSS
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
# find optimal h
h <- optim(1, RSS.KR)$par

# xi are for plotting the fitted line
xi <- seq(min(dist), max(dist), length.out=length(dist))

# use kernel regression to find fitted values (fitted error values)
err_hat <- kernel_reg(xi, h)


# graph the scatterplot plus kernel regression model
ggplot(data, aes(x=dist, y=err)) +
    geom_point(shape=21, size=3, fill="black",alpha=.4)  +
    geom_line(aes(x=xi, y=err_hat), color="sienna1", lwd=.7) +
    lims(x=c(0,8.5), y=c(-10,10)) +
    xlab("Distance ( km )") +
    ylab("Error ( m )") +
    ggtitle("Kernel Regression Model") +
    theme_ipsum_es()
ggsave(filename = here("output","kernel-model.png"))


save(h, xi, file="data/processed-data/kr-data.rda")

(max(dist)-min(dist))/99
