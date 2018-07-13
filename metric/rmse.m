function [r] = rmse(clf, testData, testJTarg)
%Root Mean Squared Error Summary of this function goes here
predTarg = clf.get_indicator(testData);
r = mean(sqrt(mean((predTarg - testJTarg).^2)));
end