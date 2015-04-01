%% Class representing rocket fuel types
classdef HabitatShielding < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        Protection
        ThermalLoss        
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = HabitatShielding()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        DEDICATED
        H2O_INSULATION
        REGOLITH
        BURIED
    end
end

