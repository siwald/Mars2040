%% Arrival entry was a subclass of EntryType, but indicates entry at arrival.
classdef ArrivalCargoEntry < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        AEROCAPTURE = ArrivalCargoEntry('Aerocapture');
        AEROBRAKE = ArrivalCargoEntry('Aerobrake');
        PROPULSIVE = ArrivalCargoEntry('Propulsive');
        DIRECT = ArrivalCargoEntry('Direct');
    end
    
    %% private class members
    properties (Access = private)
        name;
    end
    
    %% public dependent members
    properties (Dependent) 
        Name
        DeltaVPerTime
        Location
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = ArrivalCargoEntry(edlName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(edlName) && ~isempty(edlName) % have a name
                obj.name = edlName;
            else
                error('Cannot create ArrivalCargoEntry object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ArrivalCargoEntry') % obj is a ArrivalCargoEntry object
                n = obj.name;
            else
                warning('Cannot call ArrivalCargoEntry name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ArrivalCargoEntry') % obj is a ArrivalCargoEntry object
                disp(obj.name);
            else
                warning('Display method of ArrivalCargoEntry called without ArrivalCargoEntry object');
                disp('unknown');
            end
        end
        
        function isEqual = eq(obj1, obj2)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj1, 'ArrivalCargoEntry') ... % obj is a ArrivalCargoEntry object
                    && isa(obj2, 'ArrivalCargoEntry') % obj is a ArrivalCargoEntry object
                isEqual = strcmp(obj1.name, obj2.name);
            else
                isEqual = obj2.eq(obj1);
            end
        end
    end
end

