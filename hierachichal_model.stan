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
real<lower=0,upper=1> mu;
real<lower=0> eta;
}

transformed parameters{
real<lower=0> alpha;
real<lower=0> beta;
alpha = eta * mu;
beta = eta * (1-mu);
  
  
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  mu ~ beta(aMean,bMean);
 
  eta ~ exponential(logn);
y ~ beta_binomial(n,alpha,beta);

}

generated quantities {
real<lower=0,upper=1> log_lik[N];
for (i in 1:N) log_lik[i] = beta_rng(alpha+y[i], beta+n[i]-y[i]);
      
    }// The posterior predictive distribution
