%% Class representing types of power surface for generating electricity
classdef PowerSource < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        Sizes
        Output        
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = PowerSource()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        NUCLEAR
        RTG
        FUEL_CELL
        SOLAR
    end
end

