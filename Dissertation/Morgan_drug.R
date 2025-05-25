file <- 'Drug Death Data.csv'
dat  <- read.csv(file)
dat$Drugs <- as.factor(dat$Drugs)
contrasts(dat$Drugs) <- contr.sum(length(levels(dat$Drugs)))

z0 <- lm(DeathNumbers ~ Drugs + Year + Drugs:Year, data = dat)
z1 <- lm(DeathNumbers ~ Drugs + Year + Drugs:Year + I(Year^2), data = dat)
z2 <- lm(DeathNumbers ~ Drugs + Year + Drugs:Year + I(Year^2) + Drugs:I(Year^2), data = dat)
anova(z2, z1)
summary(z2)

#Mixed-effect model
library(nlme)

z2 <- lme(DeathNumbers ~ Year + I(Year^2),
  data   = dat,
  random = ~ 1 + Year + I(Year^2)|Drugs,    #Drugs for grouping level
  method = 'REML')
