# Set Working Directory
#Open data and view 
drug.deaths <- read.csv("Drug Related Death Data/Dataset Use/Drug-related deaths in total with all data.csv")
View(drug.deaths)
summary(drug.deaths)
# Linear model All drugs deaths and plot
z1 <- lm(All.drug.related.deaths ~ Year, data = drug.deaths)
summary(z1)
z1a <- lm(All.drug.related.deaths ~ Year + I(Year^2), data = drug.deaths)
summary(z1a)
anova(z1, z1a)
plot(drug.deaths$Year, drug.deaths$All.drug.related.deaths, type = "b", 
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "All Drug Deaths in Scotland between 2008 to 2020", 
     ylim = c(250,1350))
abline(z1, col = "green")
newx <- seq(2008, 2020, by = .1)
newy1 <- predict(z1a, data.frame(Year = newx))
lines(newx, newy1, col = "deeppink")
# new par
par(mfrow = c(2,2))
# Linear Model Prescription Benzodiazepines 
z2 <- lm(Prescribable.Benzodiazepines ~ Year, data = drug.deaths)
summary(z2)
z2a <- lm(Prescribable.Benzodiazepines ~ Year + I(Year^2), data = drug.deaths)
summary(z2a)
anova(z2, z2a)
plot(drug.deaths$Year, drug.deaths$Prescribable.Benzodiazepines, type = "b", 
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Prescription Benzodiazepines", ylim = c(50,250))
abline(z2, col = "green")
newy2 <- predict(z2a, data.frame(Year = newx))
lines(newx, newy2, col = "deeppink")
# Linear model Diazepam
z3 <- lm(Diazepam ~ Year, data = drug.deaths)
summary(z3)
z3a <- lm(Diazepam ~ Year + I(Year^2), data = drug.deaths)
summary(z3a)
anova(z3, z3a)
plot(drug.deaths$Year, drug.deaths$Diazepam, type = "b", col = "darkblue",
     xlab = "Year", ylab = "Number of Deaths", main = "Diazepam",
     ylim = c(0, 240))
abline(z3, col = "green")
newy3 <- predict(z3a, data.frame(Year = newx))
lines(newx, newy3, col = "deeppink")
# Linear Model Street Benzodiazepines
z4 <- lm(Street.Benzodiazepines~ Year, data = drug.deaths)
summary(z4)
z4a <- lm(Street.Benzodiazepines ~ Year + I(Year^2), data = drug.deaths)
summary(z4a)
anova(z4, z4a)
plot(drug.deaths$Year, drug.deaths$Street.Benzodiazepines, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Street Benzondiazepines", ylim = c(-100, 700))
abline(z4, col = "green")
newy4 <- predict(z4a, data.frame(Year = newx))
lines(newx, newy4, col = "deeppink")
# Linear Model Etizolam
z5 <- lm(Etizolam ~ Year, data = drug.deaths)
summary(z5)
z5a <- lm(Etizolam ~ Year + I(Year^2), data = drug.deaths)
summary(z5a)
anova(z5, z5a)
plot(drug.deaths$Year, drug.deaths$Etizolam, type = "b", xlab = "Year", 
     ylab = "Number of Deaths", main = "Etizolam", ylim = c(-50, 600))
abline(z5, col = "green")
newy5 <- predict(z5a, data.frame(Year = newx))
lines(newx, newy5, col = "deeppink")
# Linear Model Heroin and/or Morphine 
z6 <- lm(Heroin...morphine ~ Year, data = drug.deaths)
summary(z6)
z6a <- lm(Heroin...morphine ~ Year + I(Year^2), data = drug.deaths)
summary(z6a)
anova(z6, z6a)
plot(drug.deaths$Year, drug.deaths$Heroin...morphine, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Heroin and Morphine", ylim = c(50, 700))
abline(z6, col = "green")
newy6 <- predict(z6a, data.frame(Year = newx))
lines(newx, newy6, col = "deeppink")
# Linear Model Methadone
z7 <- lm(Methadone ~ Year, data = drug.deaths)
summary(z7)
z7a <- lm(Methadone ~ Year + I(Year^2), data = drug.deaths)
summary(z7a)
anova(z7, z7a)
plot(drug.deaths$Year, drug.deaths$Methadone, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Methadone", ylim = c(50, 790))
abline(z7, col = "green")
newy7 <- predict(z7a, data.frame(Year = newx))
lines(newx, newy7, col = "deeppink")
# Linear Model Codeine 
z8 <- lm(Codeine.or.a.compound ~ Year, data = drug.deaths)
summary(z8)
z8a <- lm(Codeine.or.a.compound ~ Year + I(Year^2), data = drug.deaths)
summary(z8a)
anova(z8, z8a)
plot(drug.deaths$Year, drug.deaths$Codeine.or.a.compound, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Codeine", ylim = c(-50, 120))
abline(z8, col = "green")
newy8 <- predict(z8a, data.frame(Year = newx))
lines(newx, newy8, col = "deeppink")
# Linear Model Dihydrocodeine
z9 <- lm(Dihydrocodeine.or.a.compound ~ Year, data = drug.deaths)
summary(z9)
z9a <- lm(Dihydrocodeine.or.a.compound ~ Year + I(Year^2), data = drug.deaths)
summary(z9a)
anova(z9, z9a)
plot(drug.deaths$Year, drug.deaths$Dihydrocodeine.or.a.compound, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Dihydrocodeine", ylim = c(50, 210))
abline(z9, col = "green")
newy9 <- predict(z9a, data.frame(Year = newx))
lines(newx, newy9, col = "deeppink")
# Linear Model Gabapentin and Pregabalin
z10 <- lm(Gabapentin.and.or.pregabalin ~ Year, data = drug.deaths)
summary(z10)
z10a <- lm(Gabapentin.and.or.pregabalin ~ Year + I(Year^2), data = drug.deaths)
summary(z10a)
anova(z10, z10a)
plot(drug.deaths$Year, drug.deaths$Gabapentin.and.or.pregabalin, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Gabapentin and Pregabalin", ylim = c(-50, 600))
abline(z10, col = "green")
newy10 <- predict(z10a, data.frame(Year = newx))
lines(newx, newy10, col = "deeppink")
# Linear Model Cocaine
z11 <- lm(Cocaine ~ Year, data = drug.deaths)
summary(z11)
z11a <- lm(Cocaine ~ Year + I(Year^2), data = drug.deaths)
summary(z11a)
anova(z11, z11a)
plot(drug.deaths$Year, drug.deaths$Cocaine, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Cocaine", ylim = c(-50, 500))
abline(z11, col = "green")
newy11 <- predict(z11a, data.frame(Year = newx))
lines(newx, newy11, col = "deeppink")
#Linear Model Ecstasy
z12 <- lm(Ecstasy.type.drugs ~ Year, data = drug.deaths)
summary(z12)
z12a <- lm(Ecstasy.type.drugs ~ Year + I(Year^2), data = drug.deaths)
summary(z12a)
anova(z12, z12a)
plot(drug.deaths$Year, drug.deaths$Ecstasy.type.drugs, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Ecstasy", ylim = c(-50, 50))
abline(z12, col = "green")
newy12 <- predict(z12a, data.frame(Year = newx))
lines(newx, newy12, col = "deeppink")
# Linear Model Amphetamines
z13 <- lm(Amphetamines ~ Year, data = drug.deaths)
summary(z4)
z13a <- lm(Amphetamines ~ Year + I(Year^2), data = drug.deaths)
summary(z13a)
anova(z6, z6a)
plot(drug.deaths$Year, drug.deaths$Amphetamines, type = "b",
     col = "darkblue", xlab = "Year", ylab = "Number of Deaths",
     main = "Amphetamines", ylim = c(-50, 100))
abline(z13, col = "green")
newy13 <- predict(z13a, data.frame(Year = newx))
lines(newx, newy13, col = "deeppink")
# Linear Model Alcohol
z14 <- lm(Alcohol ~ Year, data = drug.deaths)
summary(z14)
z14a <- lm(Alcohol ~ Year + I(Year^2), data = drug.deaths)
summary(z14a)
anova(z14, z14a)
plot(drug.deaths$Year, drug.deaths$Alcohol, type = "b", col = "darkblue",
     xlab = "Year", ylab = "Number of Deaths",
     main = "Alcohol", ylim = c(50, 200))
abline(z14, col = "green")
newy14 <- predict(z14a, data.frame(Year = newx))
lines(newx, newy14, col = "deeppink")



