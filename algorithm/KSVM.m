classdef KSVM < KMethod
    % Kernel Support Vector Machine
    
    properties
		
        alphas
        w
        b
        SVMModel

    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: KSVM (Public Constructor)
        % Description: It constructs an object of the class POM and sets its
        %               characteristics.
        % Type: Void
        % Arguments:
        %           No Parameters
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
        function obj = KSVM(obj)
            obj.name = 'Kernel SVM';
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: runAlgorithm (Public)
        % Description: This function runs the corresponding algorithm, fitting the
        %               model, and testing it in a dataset. It also calculates some
        %               statistics as CCR, Confusion Matrix, and others. 
        % Type: It returns a set of statistics (Struct) 
        % Arguments: 
        %           train --> trainning data for fitting the model
        %           test --> test data for validation
        %           parameter --> No Parameters
        % 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
        
        function [model]= fit(obj, trainData, trainTarg, param)
            
            C = param.C;
            k = param.k;
            avaTarg = unique(trainTarg);
            if length(avaTarg) > 2
                SVMModel = fitcecoc(trainData, trainTarg, 'BoxConstraint', C,...
                    'Standardize', false, 'KernelFunction','RBF',...
                    'KernelScale', sqrt(k));
            else
                SVMModel = fitcsvm(trainData, trainTarg, 'BoxConstraint', C,...
                    'Standardize', false, 'KernelFunction','RBF',...
                    'KernelScale', sqrt(k));
            end
                alphas = SVMModel.Alpha;
                b = SVMModel.Bias;
                w = alphas * (trainTarg' * trainData);

                % Store Information
                obj.SVMModel = SVMModel;
                obj.b = b;
                obj.alphas = alphas;
                obj.w = w;
            
%             end

            
        end
    
        function [ testTarg ]= predict(obj, testPatterns)

            testTarg = predict(obj.SVMModel, testPatterns);
            
%                     switch obj.linearType
%                                 case 'rbf'
%                                     Omega_test = linear_matrix(obj.trainPatterns,'RBF_linear', obj.parameters.k, testPatterns);
%                                 case 'polynomial'
%                                     Omega_test = linear_matrix(obj.trainPatterns,'polynomial_linear', obj.parameters.k, testPatterns);
%                     end
%                 
%                 indicator = (Omega_test'*obj.OutputWeight);
%                 
%                 [maxVal, finalOutput] = max(indicator');
%                 
%                 output_size = size(obj.OutputWeight);
%                 n_targets = output_size(2);                
%                 testTargets = Jencoding(finalOutput', n_targets);

        end
         
    end
    
end