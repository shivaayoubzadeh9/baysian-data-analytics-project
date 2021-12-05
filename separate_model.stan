// Stan Separate model
data {
  int<lower=0> N; // Number of states
  int<lower=0> y[N]; //Number of neonatal deaths
  int<lower=0> n[N]; //Number of births
  real aMean[N]; //Minimun a value
  real bMean[N]; //Minimun b Value

}

// The parameters accepted by the model
parameters {
  vector<lower=0, upper=1>[N] p;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  //Priors  

    
    for (j in 1:N) {
     p[j] ~ beta(aMean[j], bMean[j]);
    }
      
    //Likelihood 
    for (k in 1:N){
      y[k] ~ binomial(n[k], p[k]);
    }

}

generated quantities {
    //Prediction capital city
    real ypred;
    //Log Likelihood ratios
    vector[N] log_lik;
    //Predictive distribution of the capital city
    ypred = binomial_rng(n[6],p[6]);
    
      for(j in 1:N){
        log_lik[j] = binomial_lpmf(y[j] | n[j], p[j]);
      }
      
}// The posterior predictive distribution
