%% Class representing landing manuevers
classdef DescentType < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        CrewAllowable
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = DescentType()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        PROPULSIVE
        CHUTE
        SHOCK_ABSORBTION
    end
end

