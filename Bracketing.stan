
data {
  int<lower=0> N; // number of observations
  int<lower=0> n; // number of participants
  int invest[N];
  vector[N] chi;
  vector[N] Part;
  vector[N] UseData;
  int<lower=1> ID[N];
  real priorR[4];
  real priorL[4];
}

transformed data {
  vector[100] Y;
  for (yy in 1:100) {
    Y[yy] = yy-1;
  }
}

//Define the model's parameters
parameters {
  real mu_r;
  real<lower=0> sigma_r;
  real mu_l;
  real<lower=0> sigma_l;
  vector<lower=0>[n] r;
  vector<lower=0>[n] lambda;
  
  
}

transformed parameters {
  
  
}


model {
  
  vector[N] log_lik;
  {
    for (ii in 1:N) {
      vector[100] U;
      vector[100] lpY;
      for (uu in 1:100) {
        U[uu] = 0.5*(100-Y[uu]+Y[uu] * chi[ii])^r[ID[ii]]+0.5*(100.0-Y[uu])^r[ID[ii]];
      }
      lpY=log_softmax(lambda[ID[ii]]*U);
      log_lik[ii] = lpY[invest[ii]];
    }
  }
  
  target+= log_lik;
  
  mu_r ~ lognormal(priorR[1],priorR[2]);
  sigma_r~ lognormal(priorR[3],priorR[4]);
  mu_l ~ lognormal(priorL[1],priorL[2]);
  sigma_l ~ lognormal(priorL[3],priorL[4]);
  
  r ~ lognormal(mu_r,sigma_r);
  lambda ~ lognormal(mu_l,sigma_l);
  
 
}

