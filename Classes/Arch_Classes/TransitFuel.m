%% Transit fuel is simply a subclass of TransitFuel, but indicates fuel is for the transit leg.
classdef TransitFuel < handle
    
    %% Class enumerations (as constant properties)
    properties (Constant)
        EARTH_LH2 = TransitFuel('H2', Location.EARTH);
        EARTH_O2 = TransitFuel('O2', Location.EARTH);
        EARTH_CH4 = TransitFuel('CH4', Location.EARTH);
        LUNAR_O2 = TransitFuel('O2', Location.LUNAR);
        LUNAR_LH2 = TransitFuel('O2', Location.LUNAR);
        MARS_LH2 = TransitFuel('H2', Location.MARS);
        MARS_O2 = TransitFuel('O2', Location.MARS);
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
        function obj = TransitFuel(fuelName, sourceLocation)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(fuelName) && ~isempty(fuelName) ... % have a name
                    && isa(sourceLocation, 'Location') % source location is a Location object
                obj.name = fuelName;
                obj.location = sourceLocation;
            else
                error('Cannot create TransitFuel object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'TransitFuel') % obj is a TransitFuel object
                n = obj.name;
            else
                warning('Cannot call TransitFuel name getter without valid object');
            end
        end
        %% Location getter
        function loc = get.Location(obj)
            % validate we have a initalized fuel object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'TransitFuel') % obj is a TransitFuel object
                loc = obj.location;
            else
                warning('Cannot call TransitFuel location getter without valid object');
            end
        end
        
        %%% class display method
        %function disp(obj)
        %    % validate we have a initalized fuel object
        %    if nargin > 0 ... % received input arguments
        %            && isa(obj, 'TransitFuel') % obj is a TransitFuel object
        %        disp(char([obj.name '@' obj.location.Code]));
        %    else
        %        warning('Display method of TransitFuel called without TransitFuel object');
        %        disp('unknown');
        %    end
        %end
    end
 
end

