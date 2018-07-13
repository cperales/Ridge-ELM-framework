classdef BaggingNELM < NELM
    % Bagging ensemble of Neural regularized Extreme Learning Machine
    
    properties
		
        trainTargDecoded
        alpha
        D
        k

    end
    
    methods
        
        function [Beta_s] = fit_step(obj, H_whole, trainTarg_whole, k_n, s)
            H = H_whole(k_n,:);
            trainTarg = trainTarg_whole(k_n,:);
            H_reg = (eye(size(H, 2)) ./ obj.C + H' * H);
            
            % Check if H_reg is invertible
            if check_singular_matrix(H_reg)
                if s == 1
                    error('H_reg is singular in the first iteration')
                end
                Beta_s = obj.OutputWeight{s - 1};
                alpha_s = obj.alpha{s - 1};
            else
                % Calculate beta
                Beta_s = H_reg \ (H' * trainTarg);

                % Calculate errors, alpha and weight
                Y_hat = H_whole * Beta_s;
                Y_hat_decoded = Jdecoding(Y_hat);
                error_vector = not(obj.trainTargDecoded == Y_hat_decoded);
                alpha_s = 1 - sum(error_vector) / size(error_vector, 1);
            end
            
            % Store
            obj.alpha{s} = alpha_s;
%             obj.InputWeight{s} = H;
            obj.k{s} = k_n;
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
                    % Whole data
                    H_whole = H;
                    trainTarg_whole = trainTarg;
                    for s=1:obj.ensembleSize
                        n=ceil(0.75*size(H_whole, 1)); 
                        %idx=randsample(1:size(H_whole,1), n) ;
                        %H = H_whole(idx,:) ; % pick rows randomly 
                        k = randperm(size(H_whole, 1));
                        k_n = k(1:n);
                        beta_s = obj.fit_step(H_whole, trainTarg_whole, k_n, s);
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