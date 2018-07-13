classdef KELM < KMethod
    % Kernel Extreme Learning Machine
    
    properties
		
        trainPatterns % Train data is stored for kernel trick.

    end
    
    methods
      
        function [model]= fit(obj, trainData, trainTarg, parameters)
            % :trainData: Data matrix n x m, with n instances and m features.
            % :trainTarg: Target J-encoded matrix n x j.
            % :parameters: Structure with the cross validated hyperparameters.
            
                    % Absorb the parameter structure
                    obj.C = parameters.C;
                    obj.k = parameters.k;
                    
                    n = size(trainData,1);

                    % Configure the hidden layer
                    switch obj.kernelFun
                        case 'rbf'
                            Omega_train = kernel_matrix(trainData,'RBF_kernel', obj.k);
                        case 'polynomial'
                            Omega_train = kernel_matrix(trainData,'polynomial_kernel', obj.k);
                    end
                    
                    Beta = ((Omega_train+(speye(n)/obj.C))\(trainTarg));

                    % Store Information
                    obj.OutputWeight = Beta;
                    obj.trainPatterns = trainData;

        end

        function [indicator] = get_indicator(obj, testPatterns)
            % :testPattern: Data matrix n x m, with n instances to predict and m features.
            
                    switch obj.kernelFun
                                case 'rbf'
                                    Omega_test = kernel_matrix(obj.trainPatterns,'RBF_kernel', obj.k, testPatterns);
                                case 'polynomial'
                                    Omega_test = kernel_matrix(obj.trainPatterns,'polynomial_kernel', obj.k, testPatterns);
                        case 'linear'
                            Omega_test = kernel_matrix(obj.trainPatterns,'lin_kernel', obj.k, testPatterns);
                    end
                try
                    indicator = Omega_test'*obj.OutputWeight;
                catch ME
                    rethrow(ME);
                end
                
                % Extreme values of kernel give NaN
                indicator(isnan(indicator)) = 0;
        end
    
        function [parameters] = save_param(obj)
            parameters.k = obj.k;
            parameters.C = obj.C;
        end
        
    end
    
end