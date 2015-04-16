%% Class representing rocket fuel types and its source (i.e. source location)
classdef blergFuelSource < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        EARTH_LH2 = FuelSource('H2', Location.EARTH);
        EARTH_O2 = FuelSource('O2', Location.EARTH);
        EARTH_CH4 = FuelSource('CH4', Location.EARTH);
        LUNAR_O2 = FuelSource('O2', Location.LUNAR);
        LUNAR_LH2 = FuelSource('O2', Location.LUNAR);
        MARS_LH2 = FuelSource('H2', Location.MARS);
        MARS_O2 = FuelSource('O2', Location.MARS);
    end
    
    %% private class members
    properties (Access = private)
        name;
        location;
    end
    
    %% public dependent members
    properties (Dependent)
        Name
        Mass
        Refuelable
        Location
    end
    
    %% private methods (incl. constructor)
    methods(Access = private)
        %% class constructor
        function obj = FuelSource(fuelName, sourceLocation)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(fuelName) && ~isempty(fuelName) ... % have a name
                    && isa(sourceLocation, 'Location') % source location is a Location object
                obj.name = fuelName;
                obj.location = sourceLocation;
            else
                error('Cannot create FuelSource object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'FuelSource') % obj is a FuelSource object
                n = obj.name;
            else
                warning('Cannot call FuelSource name getter without valid object');
            end
        end
        %% Location getter
        function loc = get.Location(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'FuelSource') % obj is a FuelSource object
                loc = obj.location;
            else
                warning('Cannot call FuelSource location getter without valid object');
            end
        end
        
        %%% class display method
        %function disp(obj)
        %    % validate we have a initalized fuel object
        %    if nargin > 0 ... % received input arguments
        %            && isa(obj, 'FuelSource') % obj is a FuelSource object
        %        disp(char([obj.name '@' obj.location.Code]));
        %    else
        %        warning('Display method of FuelSource called without FuelSource object');
        %        disp('unknown');
        %    end
        %end
    end
end

