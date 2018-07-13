classdef AdaBoostNELM < NELM
    % AdaBoost ensemble of Neural regularized Extreme Learning Machine
    
    properties
		
        trainTargDecoded
        alpha
        D

    end
    
    methods
        
        function [weight] = fit_step(obj, weight, trainTarg, s)
            weight_matrix = diag(weight);
            H_reg = (eye(size(obj.H, 2)) ./ obj.C + obj.H' * weight_matrix * obj.H);
            
            % Calculate beta
            Beta_s = H_reg \ (obj.H' * weight_matrix * trainTarg);

            % Calculate errors, alpha and weight
            error_vector = not(obj.trainTargDecoded == Jdecoding(obj.H * Beta_s));
            e_s = sum(weight .* error_vector) / sum(weight);
            alpha_s = log((1 - (e_s + eps)) ./ (e_s + eps)) + log(size(Beta_s, 2) - 1);
            weight = weight .* exp(alpha_s * error_vector);
            weight = weight ./ sum(weight);  % Normalize
            
            % Store
            obj.alpha{s} = alpha_s;
            obj.OutputWeight{s} = Beta_s;
        end
      
        function obj = fit(obj, trainData, trainTarg, parameters)
            % :trainData: Data matrix n x m, with n instances and m features.
            % :trainTarg: Target J-encoded matrix n x j.
            % :parameters: Structure with the cross validated hyperparameters.
            
                    % Absorb the parameter structure
%                     M = parameters.size_ensemble;  % Number of classifiers to ensemble
                    
                    hiddenNeurons = parameters.hiddenNeurons;
                    if hiddenNeurons == 0
                        hiddenNeurons = size(trainTarg, 2);
                    end
                    obj.C = parameters.C;
                    obj.hiddenNeurons = hiddenNeurons;
                    
                    % Initialize values
                    n = size(trainData,1);
                    s = size(trainData,2);
                    h = hiddenNeurons;
                    obj.t = size(trainTarg, 2);
                    weight = ones(n,1)./n;  % Pattern weight
                    
                    % Matrix
                    try
                        obj.InputWeight = rand(h, s);
                    catch ME
                        display(ME);
                    end
                    obj.BiasVector = rand(h, 1);
                    ind = ones(n, 1);
                    BiasMatrix = obj.BiasVector(:,ind);
                    tempH = obj.InputWeight * trainData' + BiasMatrix;
                    H = obj.neuronFun(tempH');  % n x h
                    obj.H = H;
                    
                    obj.trainTargDecoded = Jdecoding(trainTarg);
                    ensemble = cell(obj.ensembleSize, 1);
                    obj.OutputWeight = ensemble;
                    obj.alpha = ensemble;
                    
                    for s=1:obj.ensembleSize
                        weight = obj.fit_step(weight, trainTarg, s);
                    end                    

        end
    
        function [indicator] = get_indicator(obj, testPatterns)
            % :testPattern: Data matrix n x m, with n instances to predict and m features.
            
            % Get indicators
            n = size(testPatterns, 1);
            ind = ones(n, 1);
            BiasMatrix = obj.BiasVector(:, ind);
            tempH = obj.InputWeight * testPatterns' + BiasMatrix;
            H = obj.neuronFun(tempH');
            
            testTargets = zeros(n, obj.t);
            for s=1:obj.ensembleSize
                indicator = H * obj.OutputWeight{s};
                % Obtain target
                Y_hat = Jrenorm(indicator);
                % Ponderate
                testTargets = testTargets + Y_hat .* obj.alpha{s};
            end
            
            indicator = testTargets;
            
        end
         
        function [parameters] = save_param(obj)
            parameters.C = obj.C;
            parameters.hiddenNeurons = obj.hiddenNeurons;
        end

    end
    
end