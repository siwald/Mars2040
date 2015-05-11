%% Transit fuel is simply a subclass of AscentFuel, but indicates fuel is for the transit leg.
classdef AscentFuel < handle
    
    %% Class enumerations (as constant properties)
    properties (Constant)
        EARTH_LH2 = AscentFuel('H2', Location.EARTH);
        EARTH_O2 = AscentFuel('O2', Location.EARTH);
        EARTH_CH4 = AscentFuel('CH4', Location.EARTH);
        ISRU_O2 = AscentFuel('O2', Location.MARS);
        ISRU_LH2 = AscentFuel('H2', Location.MARS);
        ISRU_CH4 = AscentFuel('CH4', Location.MARS);
        MARS_LH2 = AscentFuel('H2', Location.MARS);
        MARS_O2 = AscentFuel('O2', Location.MARS);
        MARS_CH4 = AscentFuel('CH4', Location.MARS);
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
        function obj = AscentFuel(fuelName, sourceLocation)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(fuelName) && ~isempty(fuelName) ... % have a name
                    && isa(sourceLocation, 'Location') % source location is a Location object
                obj.name = fuelName;
                obj.location = sourceLocation;
            else
                error('Cannot create AscentFuel object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'AscentFuel') % obj is a AscentFuel object
                n = obj.name;
            else
                warning('Cannot call AscentFuel name getter without valid object');
            end
        end
        %% Location getter
        function loc = get.Location(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'AscentFuel') % obj is a AscentFuel object
                loc = obj.location;
            else
                warning('Cannot call AscentFuel location getter without valid object');
            end
        end
        
        %%% class display method
        %function disp(obj)
        %    % validate we have a initalized fuel object
        %    if nargin > 0 ... % received input arguments
        %            && isa(obj, 'AscentFuel') % obj is a AscentFuel object
        %        disp(char([obj.name '@' obj.location.Code]));
        %    else
        %        warning('Display method of AscentFuel called without AscentFuel object');
        %        disp('unknown');
        %    end
        %end
    end
 
end

