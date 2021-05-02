data {
  int N_distances;
  vector[N_distances] x_distances;
  int y_successes[N_distances];
  int n_attempts[N_distances];
  int hold_out[N_distances];
}

transformed data {
  real r = (1.68/2)/12;
  real R = (4.25/2)/12;
  real threshold_angle[N_distances];
  for (i in 1:N_distances) {
    threshold_angle[i] = asin((R-r)/x_distances[i]);
  }
}

parameters {
  real<lower=0> sigma_error_in_radians;
}

model {
  for (i in 1:N_distances) {
    if (hold_out[i] == 0) {
      real prob = 2*Phi(threshold_angle[i]/sigma_error_in_radians) - 1;
      // print("running ", i);
      y_successes[i] ~ binomial(n_attempts[i], prob);
    }
  }
}

generated quantities {
  vector[N_distances] posterior_pred_training = rep_vector(0,N_distances);
  vector[N_distances] held_out_pred = rep_vector(0,N_distances);
  for (i in 1:N_distances) {
   real prob = 2*Phi(threshold_angle[i]/sigma_error_in_radians) - 1;
    if (hold_out[i] == 1) {
      held_out_pred[i] = prob;
//      print("held out=", prob);
    }
    else {
      posterior_pred_training[i] = prob;
//      print("test=", prob);
    }
  }
}
