# import data and view 
gender <- read.csv("Drug Related Death Data/Drug-related deaths by sex.csv")
View(gender)

# explore the data 
summary(gender)
plot(gender$Year, gender$Total, type = "b", col = "navyblue", xlab = "Year",
     ylab = "Number of Deaths", ylim = c(0, 1500), 
     main = "Total Number of Deaths between 1996 to 2020")
lines(gender$Year, gender$Males, type = "b", col = "green3")
lines(gender$Year, gender$Females, type = "b", col = "deep pink")
legend("topleft", legend=c("Total", "Males", "Females"), 
       col=c("navyblue", "green3", "deep pink"), lty = 1:3, cex=0.8)
