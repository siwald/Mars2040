%% Class representing EDL manuevers
classdef EntryType < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        DeltaVPerTime
        Location
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = EntryType()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        AEROCAPTURE
        AEROBRAKE
        PROPULSIVE
        DIRECT
    end
end

