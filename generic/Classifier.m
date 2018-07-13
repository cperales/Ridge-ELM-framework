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
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fit(obj);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: config(Public)
        % Description: Configure the classifier (and crossvalide)
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        config(obj);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Function: indicator(Public)
        % Description: Pure result of the classifier (without renorm)
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        get_indicator(obj);
        
        
    end
    
    methods
    
        function [probPatterns] = prob_predict(obj, testPatterns)
            % :testPattern: Data matrix n x m, with n instances
            % to predict and m features.
            indicator = obj.get_indicator(testPatterns);
            probPatterns = indicator ./ sum(indicator, 2);
        end
        
        function [testTargets] = predict(obj, testPatterns)
            % :testPattern: Data matrix n x m, with n instances
            % to predict and m features.
            indicator = obj.get_indicator(testPatterns);
            testTargets = Jrenorm(indicator);
        end
        
    end    
    
end