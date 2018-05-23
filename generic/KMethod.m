classdef KMethod < CVMethod
   
    % Abstract class to define a kernel model 

   properties
		
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Variable: parameters (Private)
        % Description: No parameters for this algorithm
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        kernelFun
        k
        OutputWeight

   end

          methods

              function obj = setConf(obj, methodConf)
                    % Set kernel type. methodConf is a structure
                    obj.kernelFun = methodConf.kernelFun;

                    if isfield(methodConf, 'k')
                        obj.gridParam.k = methodConf.k;
                    else  % Linear
                        obj.k = 0;
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
                    else
                        obj.ensembleSize = 1;
                    end

                    % Negative correlation
                    if isfield(methodConf, 'lambda')
                        obj.gridParam.lambda = methodConf.lambda;
                    %             else
                    %                 obj.gridParam.lambda = 0;
                    end
                    
              end
              
          end
          
end