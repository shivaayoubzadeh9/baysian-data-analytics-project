# Read Excel file and convert it to DataFrame
library("readxl")
library("rstan")

path <- file.path(getwd(),"Bayesian","Project", "NeonatalDeathColombia.xlsx" )
exceldata = read_excel(path)                                                                            
dfData= data.frame(exceldata)

path <- file.path(getwd(),"Bayesian","Project", "a.xlsx" )
exceldata = read_excel(path)                                                                            
dfA= data.frame(exceldata)

path <- file.path(getwd(),"Bayesian","Project", "b.xlsx" )
exceldata = read_excel(path)                                                                            
dfB= data.frame(exceldata)

#Running the model
s = 12345
path2 =  file.path(getwd(),"Bayesian","Project", "hierarchical.stan" )
sm <- rstan::stan_model(file = path2)
deaths = dfData$Late.perinatal.and.neonatal.mortality.2020
births = dfData$Late.perinatal.and.neonatal.mortality.2020 + dfData$Live.births.to.2020
l = log(100)
stan_data <- list(
  N = 37,
  L = 1,
  y = deaths,
  n = births,
  aMean = mean(dfA$Mean),
  bMean = mean(dfB$Mean),
  logn = l

)
model <- rstan::sampling(sm, data = stan_data)

#Printing summary
print(summary(model, probs = c(0.1, 0.9))$summary)

#Monitor Rhat and divergence
monitor(model)