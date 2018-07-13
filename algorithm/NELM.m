classdef NELM < NMethod
    % Neural Extreme Learning Machine with a hidden layer
    
    properties
        H
        trainPatterns
        
    end
    
    methods
      
        function obj = fit(obj, trainData, trainTarg, parameters)
            % :trainData: Data matrix n x m, with n instances and m features.
            % :trainTarg: Target J-encoded matrix n x j.
            % :parameters: Structure with the cross validated hyperparameters.
            
                    % Absorb the parameter structure
                    hiddenNeurons = parameters.hiddenNeurons;
                    if hiddenNeurons == 0
                        hiddenNeurons = size(trainTarg, 2);
                    end
                    C = parameters.C;
                    
                    n = size(trainData,1);
                    m = size(trainData,2);
                    h = hiddenNeurons;
                    
                    InputWeight = rand(h, m);
                    BiasVector = rand(h, 1);
                    ind = ones(n, 1);
                    BiasMatrix = BiasVector(:,ind);
                    tempH = InputWeight * trainData' + BiasMatrix;
                    H = obj.neuronFun(tempH');  % n x h
                    OutputWeight = (eye(size(H, 2)) ./ C + H' * H) \ (H' * trainTarg);
                    
                    % Store Information
                    obj.C = C;
                    obj.hiddenNeurons = hiddenNeurons;
                    obj.InputWeight = InputWeight;
                    obj.BiasVector = BiasVector;
                    obj.OutputWeight = OutputWeight;
                    obj.trainPatterns = trainData;

        end

        function [indicator] = get_indicator(obj, testPatterns)
            % Get matrixes
            n = size(testPatterns, 1);
            ind = ones(n, 1);
            BiasMatrix = obj.BiasVector(:, ind);
            tempH = obj.InputWeight * testPatterns' + BiasMatrix;
            H = obj.neuronFun(tempH');
            % Obtain target
            indicator = H * obj.OutputWeight;
        end
         
        function [parameters] = save_param(obj)
            parameters.hiddenNeurons = obj.hiddenNeurons;
            parameters.C = obj.C;
        end

    end
    
end