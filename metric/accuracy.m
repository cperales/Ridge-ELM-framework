function [ acc ] = accuracy(clf, testData, testJTarg)
% Percentage of the well-predicted data.

predTarg = clf.predict(testData);

bool_vector = testJTarg == predTarg;
acc = mean(bool_vector);
acc = mean(acc);

end