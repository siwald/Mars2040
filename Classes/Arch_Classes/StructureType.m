%% Class representing EDL manuevers
classdef StructureType < handle
    %% private class members
    properties (Access = private)
    end
    
    %% public dependent members
    properties (Dependent)
        StorageVolume
        IsCollapsible
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = StructureType()
        end
    end
    
    %% public class methods
    methods
    end
    
    %% Class enumerations
    enumeration
        FIXED_SHELL
        INFLATABLE
    end
end

