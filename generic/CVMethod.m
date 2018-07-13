classdef CVMethod < Classifier

   properties
		
        C  % Regularization
        ensembleSize  % Ensemble
        gridParam
   end
    
       methods(Abstract)
        
        fit(obj);
        
       end
    
          methods
              
              function obj = config(obj, trainData, trainTarg)
                  CVparamNames = fieldnames(obj.gridParam);
                  combinations = combvec(obj.gridParam.(CVparamNames{1}));
                  
                  for i=2:length(CVparamNames)
                      combinations = combvec(combinations, obj.gridParam.(CVparamNames{i}));
                  end                  
                  
                  % Init the CV criteria
                  bestCvCriteria = inf;
                  bestIdx = [1, 1];        
                  nFolds = 5;
                   
                  matrix_cell = cell(nFolds, size(combinations,2));
                                       
                  % Start nested cross-validation
                  for i=1:size(combinations,2)
                      currentCombination = combinations(:,i);
                      kIdxC = crossvalind('Kfold', length(trainTarg), nFolds);
                      L = zeros(1, nFolds);
                           
                      for kC = 1:nFolds
                          trainDataFold = trainData(kIdxC~=kC, :);
                          trainTargFold = trainTarg(kIdxC~=kC, :);
                          testDataFold = trainData(kIdxC==kC, :);
                          testTargFold = trainTarg(kIdxC==kC, :);

                          param = struct();
                          for j=1:length(CVparamNames)
                              param.(CVparamNames{j}) = currentCombination(j);
                          end
                               
                          try
                              obj.fit(trainDataFold,trainTargFold, param);
                              pred = obj.predict(testDataFold);
                                
                              % Save parameters
                              matrix_param = obj.save_param();
                              matrix_cell{i, kC} = matrix_param;                               
                              L(kC) = loss(testTargFold, pred);
                          catch ME
                              if contains(ME.message, 'singular')
                                  L(kC) = 1;
                              else
                                  rethrow(ME)
                              end
                          end
                       
                      end
                      % We average over the folds
                      currentCvCriteria = mean(L);
                
                      if currentCvCriteria < bestCvCriteria
                          % Save the index for accesing the fold results
                          [~, position] = min(L);
                          currentCvCriteria = mean(L);
                          bestIdx = [i, position];
                          % Copy all the settings
                          bestCvCriteria = currentCvCriteria;
                      end
                  end
                    
                  optimals_param = matrix_cell{bestIdx(1), bestIdx(2)};
                    
                  %% Load parameters
%                   obj.load_param(optimals);
                  obj.fit(trainData, trainTarg, optimals_param);
              end
              
          end
          
end