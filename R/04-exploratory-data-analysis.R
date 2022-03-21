source(here::here("R/00-package-loading.R"))
load(file="data/processed-data/my-data.rda")


#EDA
# plain scatter plot
ggplot(data, aes(x=dist, y=err)) +
    geom_point(shape=21, size=3, fill="transparent") +
    lims(x=c(0,8.5), y=c(-10,10)) +
    xlab("Distance ( km )") +
    ylab("Error ( m )") +
    ggtitle("Errors vs distance") +
    labs(fill="Absolute error") +
    theme_ipsum_es()
ggsave(filename = here("output","eda-plain-scatter.png"), width = 10, height = 6)

# colored, transparent, and size scatter plot
ggplot(data, aes(x=dist, y=err, fill=abs(err))) +
    geom_point(shape=21, size=abs(data$err)*2, alpha=1/abs(data$err)) +
    scale_fill_viridis(option="D") +
    lims(x=c(0,8.5), y=c(-10,10)) +
    xlab("Distance ( km )") +
    ylab("Error ( m )") +
    ggtitle("Errors vs distance") +
    labs(fill="Absolute error") +
    theme_ipsum_es()
ggsave(filename = here("output","eda-color-size-scatter.png"), width = 10, height = 6)

# box plots of binned distance and errors  
data %>% 
    mutate(bins=cut_interval(dist, length=1)) %>%
    ggplot( aes(x=bins, y=err, fill=3)) +
        geom_boxplot(show.legend=F, outlier.color="red", lwd=.7) +
        scale_fill_viridis(option="G") +
        lims(y=c(-10,10)) +
        xlab("Distance ( km ) intervals") +
        ylab("Error ( m )") +
        stat_summary(fun=mean, geom="point", shape=20, size=2, color="orange", fill="orange") +
        ggtitle("Errors for 1-km intervals of distance") +
        theme_ipsum_es()
ggsave(filename = here("output","eda-box1.png"), width = 10, height = 6)



summary <- as_tibble(apply(data, 2, fivenum))

summary <- summary %>%
    add_column(stat=c("Min", "Q1", "Median", "Q2", "Max"), .before = "dist")

summary$err <- format(summary$err, digits=3,scientific=TRUE)
summary$dist <- format(summary$dist, digits=3,scientific=TRUE)

#table stuff
f1 <- formattable(summary,
            align=c("l","c","c"),
            list(
                err = color_tile("#ffafa3", "#FA614B"),
                dist = color_tile("#DeF7E9", "#71CA97")
            ))



f1





           
           
           