classdef NMethod < CVMethod
   
    % Abstract class to define a neural model 

   properties
		
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Variable: parameters (Private)
        % Description: No parameters for this algorithm
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Cross validated parameters
        neuronFun
        hiddenNeurons = 0;
        lambda  % Negative correlation or Boosting ridge
        
        % Neural Network features
        InputWeight
        BiasVector
        OutputWeight  % Also known as beta
        t  % number of labels
   end
    
   methods
             
        function obj = setConf(obj, methodConf)
            neuronFunName = methodConf.neuronFun;
            obj.gridParam.hiddenNeurons = methodConf.hiddenNeurons;
            
            if contains(neuronFunName, 'sin')
                obj.neuronFun = @(x) sin(x);
                
            elseif contains(neuronFunName, 'hard')
                obj.neuronFun = @(x) hardlim(x);
                
            elseif contains(neuronFunName, 'sig')
                obj.neuronFun = @(x) logsig(x);
                
            else
                error('Neuron function not recognised, %s', neuronFunName)
                
            end
                        
            % Regularization
            if isfield(methodConf, 'C')
                obj.gridParam.C = methodConf.C;
            else
                obj.gridParam.C = 0;  % No regularization
            end
            
            % Ensemble
            if isfield(methodConf, 'ensembleSize')
                obj.ensembleSize = methodConf.ensembleSize;
%             else
%                 obj.ensembleSize = 1;
            end
            
            % Negative correlation
            if isfield(methodConf, 'lambda')
                obj.gridParam.lambda = methodConf.lambda;
%             else
%                 obj.gridParam.lambda = 0;
            end
            
            % Diversity
            if isfield(methodConf, 'D')
                obj.gridParam.D = methodConf.D;
%             else
%                 obj.gridParam.D = 0;
            end
            
            % SM Diversity
            if isfield(methodConf, 'r')
                obj.gridParam.r = methodConf.r;
%             else
%                 obj.gridParam.D = 0;
            end
            
        end
        
   end
   
end