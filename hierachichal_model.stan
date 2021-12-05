// Stan Beta-binomial Hierarchical model 
data {
  int<lower=0> N; // Number of states
  real L;
  int<lower=0> y[N]; //Number of neonatal deaths
  int<lower=0> n[N]; //Number of births
  real aMean; //Mean a value
  real bMean; //Mean b Value
  real logn;

  
}

// The parameters accepted by the model
parameters {
  vector<lower=0, upper=1>[N] p;
  real mu;
  real loge;
}

transformed parameters{
  real a;
  real b;
  real e;
  
  e = exp(loge);
  a = mu*e;
  b = (1-mu)*e;
  
  
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  
  
  mu ~ beta(aMean,bMean);
  loge ~ logistic(logn, 1);
 
  
  //Prior
    for (j in 1:N) {
      p[j] ~ beta(a, b);
      
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
