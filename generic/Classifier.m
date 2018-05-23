classdef Classifier < handle
    % Algorithm Abstract interface class
    % Abstract class which defines classifiers.
    % It describes some common methods and variables for all the
    % algorithms.
    
    properties
        
        % Name of the method
        name
        methodConf
        
    end
        
    methods(Abstract)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: fit(Public)
        % Description: Estimate the parameters of the model.
        % Type: Void
        % Arguments:
        %           No arguments
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fit(obj);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: predict(Public)
        % Description: Predict the class label
        % Type: Void
        % Arguments:
        %           No arguments
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        predict(obj);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: config(Public)
        % Description: Conguire the classifier (and crossvalide)
        % Type: Void
        % Arguments:
        %           No arguments
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        config(obj);
    end
    
    
end


