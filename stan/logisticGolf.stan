data {
  int N_distances;
  vector[N_distances] x_distances;
  int y_successes[N_distances];
  int n_attempts[N_distances];
  int hold_out[N_distances];
}

parameters {
  real a_intercept;
  real b_slope;
}

model {
  for (i in 1:N_distances) {
    if (hold_out[i] == 0) {
      // print("running ", i);
      y_successes[i] ~ binomial_logit(n_attempts[i],
                                      a_intercept + x_distances[i] * b_slope);
    }
  }
}

generated quantities {
  vector[N_distances] posterior_pred_training = rep_vector(0,N_distances);
  vector[N_distances] held_out_pred = rep_vector(0,N_distances);
  for (i in 1:N_distances) {
    real prob = inv_logit(a_intercept + x_distances[i] * b_slope);
    if (hold_out[i] == 1) {
      held_out_pred[i] = prob;
      // print("held out=", prob);
    }
    else {
      posterior_pred_training[i] = prob;
      // print("test=", prob);
    }
  }
}