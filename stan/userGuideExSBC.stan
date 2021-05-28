transformed data {
  real mu_sim = normal_rng(0, 1);
  real<lower = 0> sigma_sim = lognormal_rng(0, 1);
  int<lower = 0> J = 10;
  real y_sim[J];
  for (j in 1:J) 
    y_sim[j] = normal_rng(mu_sim, sigma_sim);
}

parameters {
  real mu;
  real<lower = 0> sigma;
}

model {
  mu ~ normal(0, 1);
  sigma ~ lognormal(0, 1);
  y_sim ~ normal(mu, sigma);
}

generated quantities {
  int<lower = 0, upper = 1> lt_sim[2] = {mu < mu_sim, sigma < sigma_sim };
  int mu_rank = mu < mu_sim;
  int sigma_rank = sigma < sigma_sim;
}
