function [r] = rmse(clf, testData, testJTarg)
% Root Mean Squared Error
predTarg = clf.predict(testData);
r = mean(sqrt(mean((predTarg - testJTarg).^2)));
end
