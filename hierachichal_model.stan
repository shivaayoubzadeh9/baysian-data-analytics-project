// Stan Beta-binomial Hierarchical model 
data {
  int<lower=0> N; // Number of states
  int<lower=0> y[N]; //Number of neonatal deaths
  int<lower=0> n[N];
  real aMean; //Mean a value
  real bMean; //Number of births
}

// The parameters accepted by the model
parameters {
 real theta;
}


// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  theta ~ beta(aMean,bMean);
    for (k in 1:N){
      y[k] ~ binomial(n[k], theta);
    }
}

generated quantities {
vector[N] log_lik;
  for(i in 1:N){
        log_lik[i] = binomial_lpmf(y[i]|n[i], theta);
      }

    }// The posterior predictive distribution
