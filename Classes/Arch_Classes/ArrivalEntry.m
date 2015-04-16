%% Arrival entry was a subclass of EntryType, but indicates entry at arrival.
classdef ArrivalEntry < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        AEROCAPTURE = ArrivalEntry('Aerocapture');
        AEROBRAKE = ArrivalEntry('Aerobrake');
        PROPULSIVE = ArrivalEntry('Propulsive');
        DIRECT = ArrivalEntry('Direct');
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
        function obj = ArrivalEntry(edlName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(edlName) && ~isempty(edlName) % have a name
                obj.name = edlName;
            else
                error('Cannot create ArrivalEntry object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ArrivalEntry') % obj is a ArrivalEntry object
                n = obj.name;
            else
                warning('Cannot call ArrivalEntry name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ArrivalEntry') % obj is a ArrivalEntry object
                disp(obj.name);
            else
                warning('Display method of ArrivalEntry called without ArrivalEntry object');
                disp('unknown');
            end
        end
        
        function isEqual = eq(obj1, obj2)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj1, 'ArrivalEntry') ... % obj is a ArrivalEntry object
                    && isa(obj2, 'ArrivalEntry') % obj is a ArrivalEntry object
                isEqual = strcmp(obj1.name, obj2.name);
            else
                isEqual = obj2.eq(obj1);
            end
        end
    end
end

