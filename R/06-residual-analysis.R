source(here::here("R/00-package-loading.R"))
source(here::here("R/kernel-regression-functions.R"))
load(file="data/processed-data/kr-data.rda")
load(file="data/processed-data/my-data.rda")


# compute original residuals with non-parametric model (kernel regression)
err_hat <- kernel_reg(dist, h)
orig_res <- err_hat - err

x1 <- dist
y1 <- rep(0, length(dist))
for(i in 1:length(dist)){
    y1[i] <- sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2)*err)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((x1[i]-dist)/h)^2))
}
o.res <- y1 - err

# residual plots to check constant variance
ggplot(data, aes(x=err_hat, y=o.res)) +
    geom_point(alpha=.5) +
    stat_smooth(method="loess", color = "red", se = FALSE, lwd=.7) +
    ylab("Residuals") +
    xlab("Fitted error values ( m )") +
    ggtitle("Residual Analysis - Constant Variance") +
    theme_ipsum_es()
ggsave(filename = here("output","residual-variance-plot.png"), width = 10, height = 6)

# qq plot to check constant variance and non-normality
ggplot(data, aes(sample=o.res)) +
    stat_qq(shape=21) +
    ylab("Sample Quantiles") +
    xlab("Theoretical Quantiles") +
    ggtitle("Normal Q-Q Plot") +
    theme_ipsum_es()
ggsave(filename = here("output","residual-normality-plot.png"), width = 10, height = 6)

# residual plot to check mean = 0, non-linearity
ggplot(data, aes(x=err_hat, y=o.res)) +
    geom_point(alpha=.5) +
    geom_hline(yintercept=0, color = "red",lwd=.7, lty=2) +
    ylab("Residuals") +
    xlab("Fitted error values ( m )") +
    ggtitle("Residual Analysis - Linearity") +
    theme_ipsum_es()
ggsave(filename = here("output","residual-linearity-plot.png"), width = 10, height = 6)



save(o.res, file="data/processed-data/res-data.rda")
