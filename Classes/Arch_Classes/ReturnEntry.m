%% Return entry was simply a subclass of EntryType, but indicates entry upon return.
classdef ReturnEntry < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        AEROCAPTURE = ReturnEntry('Aerocapture');
        AEROBRAKE = ReturnEntry('Aerobrake');
        PROPULSIVE = ReturnEntry('Propulsive');
        DIRECT = ReturnEntry('Direct');
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
        function obj = ReturnEntry(edlName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(edlName) && ~isempty(edlName) % have a name
                obj.name = edlName;
            else
                error('Cannot create ReturnEntry object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ReturnEntry') % obj is a ReturnEntry object
                n = obj.name;
            else
                warning('Cannot call ReturnEntry name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ReturnEntry') % obj is a ReturnEntry object
                disp(obj.name);
            else
                warning('Display method of ReturnEntry called without ReturnEntry object');
                disp('unknown');
            end
        end
        
        function isEqual = eq(obj1, obj2)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj1, 'ReturnEntry') ... % obj is a ReturnEntry object
                    && isa(obj2, 'ReturnEntry') % obj is a ReturnEntry object
                isEqual = strcmp(obj1.name, obj2.name);
            else
                isEqual = obj2.eq(obj1);
            end
        end
    end
end

