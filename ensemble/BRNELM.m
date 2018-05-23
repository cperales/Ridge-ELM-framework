classdef BRNELM < NELM
    % Boosting Ridge ensemble of Neural regularized Extreme Learning Machine
    
    properties
%         lambda
        y_mu
        alpha
    end
    
    methods
                
        function [y_mu] = fit_step(obj, y_mu, s)
            
            % Same part
            H_reg = (eye(size(obj.H, 2)) ./ obj.C + obj.H' * obj.H);
            
            % Check if H_reg is invertible
            if check_singular_matrix(H_reg)
                if s == 1
                    error('H_reg is singular in the first iteration')
                end
                Beta_s = obj.OutputWeight{s - 1};
            else
                % Calculate beta
                Beta_s = H_reg \ (obj.H' * y_mu);
            end
            
            % Calculate mu
            Y_hat = obj.H * Beta_s;
            y_mu = y_mu - Y_hat;
            
            % Store
            obj.OutputWeight{s} = Beta_s;
        end
              
        function obj = fit(obj, trainData, trainTarg, parameters)
            % :trainData: Data matrix n x m, with n instances and m features.
            % :trainTarg: Target J-encoded matrix n x j.
            % :parameters: Structure with the cross validated hyperparameters.
            
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
            obj.InputWeight = rand(h, s);
            obj.BiasVector = rand(h, 1);
            ind = ones(n, 1);
            BiasMatrix = obj.BiasVector(:,ind);
            tempH = obj.InputWeight * trainData' + BiasMatrix;
            H = obj.neuronFun(tempH');  % n x h
            obj.H = H;
            
            ensemble = cell(obj.ensembleSize, 1);
            obj.OutputWeight = ensemble;
            y_mu = trainTarg;
            
            for s=1:obj.ensembleSize
                [y_mu] = obj.fit_step(y_mu, s);
            end
            
        end
    
        function [testTargets] = predict(obj, testPatterns)
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
                testTargets = testTargets + indicator;
            end
            
            testTargets = Jrenorm(testTargets);
            
        end
         
        function [parameters] = save_param(obj)
            parameters.C = obj.C;
            parameters.hiddenNeurons = obj.hiddenNeurons;
        end

    end
    
end