%% Class representing EDL manuevers
classdef EntryType < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        AEROCAPTURE = EntryType('Aerocapture');
        AEROBRAKE = EntryType('Aerobrake');
        PROPULSIVE = EntryType('Propulsive');
        DIRECT = EntryType('Direct');
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
        function obj = EntryType(edlName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(edlName) && ~isempty(edlName) % have a name
                obj.name = edlName;
            else
                error('Cannot create EntryType object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'EntryType') % obj is a EntryType object
                n = obj.name;
            else
                warning('Cannot call EntryType name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'EntryType') % obj is a EntryType object
                disp(obj.name);
            else
                warning('Display method of EntryType called without EntryType object');
                disp('unknown');
            end
        end
    end
end

