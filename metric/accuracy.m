function [ acc ] = accuracy(clf, testData, testJTarg)
% This function measures the percentage of the well-predicted test data.

predTarg = clf.predict(testData);

bool_vector = testJTarg == predTarg;
acc = mean(bool_vector);
acc = mean(acc);

end