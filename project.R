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

s = 12345
path2 =  file.path(getwd(),"Bayesian","Project", "separate.stan" )
sm <- rstan::stan_model(file = path2)
deaths = dfData$Late.perinatal.and.neonatal.mortality.2020
births = dfData$Late.perinatal.and.neonatal.mortality.2020 + dfData$Live.births.to.2020
stan_data <- list(
  N = 37,
  L = 1,
  y = deaths,
  n = births,
  aMean = dfA$Mean,
  aStd = dfA$Std,
  bMean = dfB$Mean,
  bStd = dfB$Std
    
)
model <- rstan::sampling(sm, data = stan_data)
print(summary(model, probs = c(0.1, 0.9))$summary)
monitor(model)