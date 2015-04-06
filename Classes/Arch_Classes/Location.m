%% Represents potential locations for MARS 2040 missions
classdef Location < handle
    %% Location constants to be used for lookups and calculations
    properties (Constant)
        %% table containing miscellaneous properties of each location
        % most data is interpreted from common knowledge
        % use of ISRU resources should be sourced
        DETAILS_TABLE = readtable('locations-details.dat','ReadRowNames',true);
                
        %% table containing all delta-v paths for Earth-Mars system
        % delta-v network populated from http://i.imgur.com/WGOy3qT.png
        % assumes hohmann transfer orbits
        % aerocapture noted in following table but not included in delta-v
        % low thrust propulsion (i.e. SEP), should use 1.5 * delta-v values
        DELTAV_TABLE = readtable('locations-deltaVs.dat','ReadRowNames',true);
        
        %% table containing all aerocapture paths for Earth-Mars system
        % aerocapture network populated from http://i.imgur.com/WGOy3qT.png
        % table is assymetric, representing one-way nature of aerocapture
        % table contains logical values, 1 for aerocapture, nothing otherwise
        AEROCAPTURE_TABLE = readtable('locations-aerocaptureTrajs.dat','ReadRowNames',true);
    end
    
    %% private properties
    properties (GetAccess = private, SetAccess = immutable)
        %% original value used to instantiate location representing the row name of location
        locationName;
    end
    
    %% Public properties for location object
    %
    % TODO: verify certain properties, such that surfaces are typically the
    % only location for ISRU resources and location indicators are mutually
    % exclusive
    %
    properties (Dependent)
        %% Short-hand form of location
        Code;
        %% Descriptive name of location
        Name;
        %% Description of location
        Description;
        %% Indicator of whether the location represents a surface of an object
        IsSurface;
        %% Indicator of whether or not the location represents a direct orbit around a celestial body
        IsOrbital;
        %% Indicator of whether or not the location represents a Lagrangian point about two celestial bodies
        IsLagrangian;
        %% List of names of resources available from location
        ISRU;
    end
    
    %% private class functions
    methods (Access = private)
        %% Location class construction
        % initialize location name
        function obj = Location(location)
            % verify we have a location input
            if nargin > 0 && ischar(location)
                % store original value of location
                obj.locationName = upper(char(location));                
                % make sure that the Delta-V table contains a row that
                % matches the requested location, if not throw error
                if ~any(strcmp(Location.DELTAV_TABLE.Properties.RowNames, obj.locationName))
                    error('Location name was not valid.');
                end
            else
                error('Location was not initialized with any input.');
            end
        end
    end
    
    %% Public class methods
    methods        
        %% Code getter
        function Code = get.Code(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value of Code by using object location name
                Code = obj.locationName;
            end
        end
        %% Name getter
        function name = get.Name(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value of name from details table for current
                % location code
                name = strjoin(obj.DETAILS_TABLE{obj.locationName, 'Name'});
            end
        end
        %% Description getter
        function desc = get.Description(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value of description from details table for current
                % location code
                desc = strjoin(obj.DETAILS_TABLE{obj.locationName, 'Description'});
            end
        end
        %% Is Surface getter
        function isSurface = get.IsSurface(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value for surface indicator from details table for
                % current location code, converted to logical value
                isSurface = logical(obj.DETAILS_TABLE{obj.locationName, 'IsSurface'});
            end
        end
        %% Oribital getter
        function isOrbit = get.IsOrbital(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value for orbital indicator from details table for
                % current location code, converted to logical value
                isOrbit = logical(obj.DETAILS_TABLE{obj.locationName, 'IsOrbital'});
            end
        end
        %% Lagrangian getter
        function isLagrangian = get.IsLagrangian(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value for lagrangian indicator from details table for
                % current location code, converted to logical value
                isLagrangian = logical(obj.DETAILS_TABLE{obj.locationName, 'IsLagrangian'});
            end
        end
        %% ISRU getter
        function isru = get.ISRU(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                % get value for ISRU list from details table for
                % current location code, converted cell array
                isru = eval(cell2mat(obj.DETAILS_TABLE{obj.locationName, 'ISRU'}));
            end
        end
            
        %% Lookup Delta-V value between locations
        % function lookups the Delta-V required to reach
        % the provided destination location from the current
        % location
        function deltaV = DeltaVTo(currentLocation, destinationLocation)
            % verify we have method inputs
            if nargin == 0 ... % no arguments
                    || ~isa(currentLocation, 'Location') ... % current input not a location object
                    || ~isa(destinationLocation, 'Location') % destination input not a location object 
            % start if 'DeltaVArgs'
                % if there is no valid input, return NaN for delta-v
                deltaV = NaN; 
                % quit function
                return; 
            end % end if 'DeltaVArgs'
            
            % check if locations are the same
            if strcmp(currentLocation.Code, destinationLocation.Code)
                % set delta-v to zero (0)
                deltaV = 0;
                % quit function
                return;
            end
            
            % lookup deltaV by using current and destination row names from
            % table
            deltaV = Location.DELTAV_TABLE{currentLocation.Code, destinationLocation.Code};
            
            % verify we found a deltaV, if not, locations were not adjacent
            % so we now must check for a path between them
            if ~isfinite(deltaV)
                % must get index of locations from table in order to
                % calculate shortest path
                % get current location index from rows
                currIndex = find(strcmp(Location.DELTAV_TABLE.Properties.RowNames, currentLocation.locationName));
                % get destination location index from rows
                destIndex = find(strcmp(Location.DELTAV_TABLE.Properties.RowNames, destinationLocation.locationName));
                % call the shortest path function with the Delta-V table,
                % the current and destination indices, and the height of
                % the delta-v table for the step parameter to ensure all
                % iterations are completed.
                deltaV = shortestPath(table2array(Location.DELTAV_TABLE),currIndex,destIndex,height(Location.DELTAV_TABLE));
            end
        end
        
        %% Lookup function to determine if aerocapture is possible
        % checks for aerocapture between current location and destination
        function canAerocap = CanAerocaptureTo(currentLocation, destinationLocation)
            % verify we have method inputs
            if nargin == 0 ... % no arguments
                    || ~isa(currentLocation, 'Location') ... % current input not a location object
                    || ~isa(destinationLocation, 'Location') % destination input not a location object 
            % start if 'AerocapArgs'
                % if there is no valid input, return NaN for delta-v
                canAerocap = NaN; 
                % quit function
                return; 
            end % end if 'AerocapArgs'
            
            % check if locations are the same
            if strcmp(currentLocation.Code, destinationLocation.Code)
                % set aerocapture to false
                canAerocap = false;
                % quit function
                return;
            end
            
            % lookup aerocapture capability by using current and
            % destination row names from table
            canAerocap = Location.AEROCAPTURE_TABLE{currentLocation.Code, destinationLocation.Code};
            
            % verify we found an aerocapture indicator, if not, locations
            % were not adjacent, so we now must check for a path between them
            if ~isfinite(canAerocap) && ~logical(canAerocap)
                % must get index of locations from table in order to
                % calculate shortest path
                % get current location index from rows
                currIndex = find(strcmp(Location.DELTAV_TABLE.Properties.RowNames, currentLocation.locationName));
                % get destination location index from rows
                destIndex = find(strcmp(Location.DELTAV_TABLE.Properties.RowNames, destinationLocation.locationName));
            end
        end
    end
    
    enumeration
        EARTH ('EARTH'), % Earth surface
        LEO ('LEO'), % low Earth orbit
        GTO ('GTO'), % geostationary orbit transfer
        GEO ('GEO'), % geostationary earth orbit
        LT ('LT'), % lunar orbit transfer
        LCE ('LCE'), % lunar capture/escape
        LLO ('LLO'), % low lunar orbit
        LUNAR ('LUNAR'), % Moon surface
        EML1 ('EML1'), % Earth-moon L1
        EML2 ('EML2'), % Earth-moon L2
        EML3 ('EML3'), % Earth-moon L3
        EML4 ('EML4'), % Earth-moon L4
        EML5 ('EML5'), % Earth-moon L5
        ECE ('ECE'), % Earth escape/capture
        ASTEROID ('ASTRD'), % near-earth asteroids
        EL1 ('EL1'), % Earth-sun L1
        EL2 ('EL2'), % Earth-sun L2
        EL3 ('EL3'), % Earth-sun L3
        EL4 ('EL4'), % Earth-sun L4
        EL5 ('EL5'), % Earth-sun L5
        MTO ('MTO'), % Mars transfer orbit
        MCE ('MCE'), % Mars capture orbit
        DTO ('DTO'), % Deimos transfer orbit
        PTO ('PTO'), % Phobos transfer orbit
        LMO ('LMO'), % low Mars orbit
        MARS ('MARS'), % Mars surface
        DCE ('DCE'), % Deimos capture/escape
        LDO ('LDO'), % low Deimos orbit
        DEIMOS ('DEIMOS'), % Deimos surface
        PCE ('PCE'), % Phobos capture/escape
        LPO ('LPO'), % low Phobos orbit
        PHOBOS ('PHOBOS'), % Phobos surface
        DPT ('DPT') % Deimos-Phobos transfer orbit
    end
end

