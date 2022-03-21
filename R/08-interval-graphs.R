source(here::here("R/00-package-loading.R"))
load(file="data/processed-data/kr-data.rda")
load(file="data/processed-data/my-data.rda")
load(file="data/processed-data/res-data.rda")
load(file="data/processed-data/pi-data.rda")

ggplot(data=df1, aes(x=x, xend=x, y=lb, yend=ub)) +
    geom_segment(lwd=1.5, color="grey50", alpha=.7) +
    geom_point(size=14, color="transparent", shape=21, fill="indianred") +
    geom_point(aes(y=ub), size=14, color="transparent", fill="olivedrab",shape=21, alpha=.9) +
    geom_text(aes(label=round(lb,3)), col="black", size=3.5) +
    geom_text(aes(y=ub, label=round(ub,3)), col="black",size=3.5) +
    lims(y=c(-1.5,1.5)) +
    ylab("Error in meters") +
    xlab("Distance") +
    theme_ipsum_es() +
    geom_hline(yintercept = 0, color="orangered3", lty=2, lwd=1) +
    ggtitle("Prediction Intervals") +
    coord_flip()

ggsave(filename = here("output","prediction-intervals.png"))

