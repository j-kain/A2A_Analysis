source(here::here("R/00-package-loading.R"))

load(file="data/processed-data/my-data.rda")


#EDA
scatter1 <- ggplot(data, aes(x=dist, y=err, fill=abs(err))) +
            geom_point(shape=21, size=abs(data$err)*2, alpha=1/abs(data$err)) +
            scale_fill_viridis(option="D") +
            lims(x=c(0,8.5), y=c(-9,9)) +
            xlab("Distance ( km )") +
            ylab("Error ( m )") +
            ggtitle("Errors vs distance") +
            labs(fill="Absolute error") +
            theme_ipsum_es()
ggsave(filename = here("output","eda-scatter1.png"))

    
box1 <- data %>% 
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
box1
ggsave(filename = here("output","eda-box1.png"))



            
           
           
           
           