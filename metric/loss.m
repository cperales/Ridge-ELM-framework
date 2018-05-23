function [ L ] = loss(expTarg, predTarg)
% Function for cross validation. It is the inverse of the accuracy.

bool_vector = expTarg == predTarg;
acc = mean(bool_vector);
acc = mean(acc);

L = 1 - acc;

end