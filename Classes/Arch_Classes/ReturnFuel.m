%% Return fuel is simply a subclass of ReturnFuel, but indicates fuel is for the return leg.
classdef ReturnFuel < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        EARTH_LH2 = ReturnFuel('H2', Location.EARTH);
        EARTH_O2 = ReturnFuel('O2', Location.EARTH);
        EARTH_CH4 = ReturnFuel('CH4', Location.EARTH);
        LUNAR_O2 = ReturnFuel('O2', Location.LUNAR);
        LUNAR_LH2 = ReturnFuel('O2', Location.LUNAR);
        MARS_LH2 = ReturnFuel('H2', Location.MARS);
        MARS_O2 = ReturnFuel('O2', Location.MARS);
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
        function obj = ReturnFuel(fuelName, sourceLocation)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(fuelName) && ~isempty(fuelName) ... % have a name
                    && isa(sourceLocation, 'Location') % source location is a Location object
                obj.name = fuelName;
                obj.location = sourceLocation;
            else
                error('Cannot create ReturnFuel object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ReturnFuel') % obj is a ReturnFuel object
                n = obj.name;
            else
                warning('Cannot call ReturnFuel name getter without valid object');
            end
        end
        %% Location getter
        function loc = get.Location(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ReturnFuel') % obj is a ReturnFuel object
                loc = obj.location;
            else
                warning('Cannot call ReturnFuel location getter without valid object');
            end
        end
        
        %%% class display method
        %function disp(obj)
        %    % validate we have a initalized fuel object
        %    if nargin > 0 ... % received input arguments
        %            && isa(obj, 'ReturnFuel') % obj is a ReturnFuel object
        %        disp(char([obj.name '@' obj.location.Code]));
        %    else
        %        warning('Display method of ReturnFuel called without ReturnFuel object');
        %        disp('unknown');
        %    end
        %end
    end
end