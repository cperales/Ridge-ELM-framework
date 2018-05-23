function [ finalTarg ] = targetEncoding( Targ, nameAlgorithm, trainJTarg)
% (TESTING) This function choose the encoding, depending on algorithm.

if contains(nameAlgorithm, 'SVM')

    finalTarg = Yencoding(Targ);

else  % contains(nameAlgorithm, 'ELM')

        if nargin == 2
            finalTarg = Jencoding(Targ);
        else
            nLabels = size(trainJTarg, 2);
            finalTarg = Jencoding(Targ, nLabels);
        end

end