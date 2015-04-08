%% Class representing rocket fuel types
classdef FuelSource < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        Mass
        Refuelable
        Location
    end
    
    %% private methods (incl. constructor)
    methods(Access = private)
        %% class constructor
        function obj = FuelSource()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        EARTH_LH2,
        EARTH_O2,
        EARTH_CH4,
        LUNAR_O2,
        LUNAR_LH2,
        MARS_LH2,
        MARS_O2
    end
end

