classdef AdaBoostNCNELM < AdaBoostNELM
    % AdaBoost Negative Correlation ensemble of Neural regularized Extreme Learning Machine
   
    properties

    end
    
    methods
        
        function [weight, pen] = fit_step(obj, weight, pen, trainTarg, eye_matrix, s)
            %% Weight matrix
            weight_matrix = diag(weight);
            
            %% Beta
            Beta_s = obj.H' * ((eye_matrix ./ obj.C + weight_matrix * obj.H * obj.H') \ (weight_matrix * trainTarg));

            %% Calculate errors, alpha and weight
            Y_hat = obj.H * Beta_s;
            Y_hat_decoded = Jdecoding(Y_hat);            
            error_vector = not(obj.trainTargDecoded == Y_hat_decoded);

            % Update penalty
            if s > 1
                % predict with the ensemble
                H_T = zeros(size(Y_hat));
                for k=1:s-1
                    % Obtain target
                    H_T_hat = obj.H * obj.OutputWeight{k};
                    % Ponderate
                    H_T = H_T + H_T_hat .* obj.alpha{k};
                end                    
                H_T_decoded = Jdecoding(H_T);
                amb = 0.5 * 1 / obj.ensembleSize .* not(H_T_decoded == Y_hat_decoded);  % [0, 0.5]
                pen = 1 - abs(amb);  % [1, 0.5], respectively
            end                

            % Update weight
            pen_lambda = pen.^obj.lambda;
            e_s = sum(pen_lambda .* weight .* error_vector) / sum(pen_lambda .* weight);
            alpha_s = log((1 - (e_s + eps)) / (e_s + eps)) + log(size(trainTarg, 2) - 1);
            weight = pen_lambda .* weight .* exp(alpha_s * error_vector);
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
                    hiddenNeurons = parameters.hiddenNeurons;
                    if hiddenNeurons == 0
                        hiddenNeurons = size(trainTarg, 2);
                    end
                    obj.C = parameters.C;
                    obj.lambda = parameters.lambda;
                    obj.hiddenNeurons = hiddenNeurons;
                    
                    % Initialize values
                    n = size(trainData,1);
                    m = size(trainData,2);
                    h = hiddenNeurons;
                    weight = ones(n,1)./n;  % Pattern weight
                    pen = ones(n,1);  % Penalties
                    obj.t = size(trainTarg, 2);
                    
                    % Matrix
                    eye_matrix = eye(n);
                    obj.InputWeight = rand(h, m);
                    obj.BiasVector = rand(h, 1);
                    ind = ones(n, 1);
                    BiasMatrix = obj.BiasVector(:,ind);
                    tempH = obj.InputWeight * trainData' + BiasMatrix;
                    H = obj.neuronFun(tempH');  % n x h
                    obj.H = H;
                    
                    %% For fit_step
                    obj.trainTargDecoded = Jdecoding(trainTarg);
                    ensemble = cell(obj.ensembleSize, 1);
                    obj.OutputWeight = ensemble;
                    obj.alpha = ensemble;
                    
                    for s=1:obj.ensembleSize
                        [weight, pen] = obj.fit_step(weight, pen, trainTarg, eye_matrix, s);
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
            
            indicator = zeros(n, obj.t);
            for s=1:obj.ensembleSize
                Y_hat = H * obj.OutputWeight{s};
                % Ponderate
                indicator = indicator + Y_hat .* obj.alpha{s};
            end

        end
         
        function [parameters] = save_param(obj)
            parameters.C = obj.C;
            parameters.lambda = obj.lambda;
            parameters.hiddenNeurons = obj.hiddenNeurons;
        end

    end
    
end