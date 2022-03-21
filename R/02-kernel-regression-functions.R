kernel_norm <- function(x, h){
    sum((1/(h*sqrt(2*pi)))*exp(-.5*((x-dist)/h)^2)*err)/
        sum((1/(h*sqrt(2*pi)))*exp(-.5*((x-dist)/h)^2))
}

kernel_reg <- function(x, h){
    sapply(x, kernel_norm, h)
}
