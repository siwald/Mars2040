%% Class representing rocket fuel types
classdef Fuel < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        Mass
        Refuelable
        Location
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = Fuel()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        EARTH_H2,
        EARTH_O2,
        EARTH_CH4,
        LUNAR_O2,
        LUNAR_H2,
        MARS_H2,
        MARS_O2
    end
end

