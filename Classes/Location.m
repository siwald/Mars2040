%% Represents potential locations for MARS 2040 missions
classdef Location < handle
    %% Location constants to be used for lookups and calculations
    properties (Constant)
        %% Constant array holding all the location abbreviations by location index
        LOCATION_ABBRS = [cellstr('EARTH'),'LEO','GEO','EML1','EML2','EML3','EML4','EML5','LLO','LUNAR','EL1','EL2','EL3','EL4','EL5','MTO','MCO','LMO','MARS','PTO','LPO','PHOBOS','DTO','LDO','DEIMOS'];
        
        %% Constant array holding all the location names by location index
        LOCATION_NAMES = [cellstr('Earth Surface'),'Low Earth Orbit','Geosynchronous Earth Orbit',...
            'Earth-Moon L1','Earth-Moon L2','Earth-Moon L3','Earth-Moon L4','Earth-Moon L5',...
            'Low Lunar Orbit','Lunar Surface',...
            'Earth-Sun L1','Earth-Sun L2','Earth-Sun L3','Earth-Sun L4','Earth-Sun L5',...
            'Mars Transfer Orbit','Mars Capture Orbit','Low Mars Orbit','Mars Surface',...
            'Phobos Transfer Orbit','Low Phobos Orbit','Phobos Surface',...
            'Deimos Transfer Orbit','Low Deimos Orbit','Deimos Surface'];
        
        %% Constants array holding location's orbital indicator by location index
        ORBITAL_LOCATIONS = logical([0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0]);
        
        %% Constants array holding the location's lagrangian indicator by location index
        LAGRANGIAN_LOCATIONS = int8([0,0,0,1,2,3,4,5,0,0,1,2,3,4,5,0,0,0,0,0,0,0,0,0,0]);
        
        %% Constant table holding all delta-V values between locations
        % TODO : need to add the delta V table
        DELTAV_TABLE = [ ...
           %Earth|LEO  |GEO  |EML1 |EML2 |EML3 |EML4 |EML5 |LLO  |Moon |EL1  |EL2  |EL3  |EL4  |EL5  |MTO  |MCO  |LMO  |Mars |PTO  |LPO  |Phobo|DTO  |LDO  |Deimo|
           %1,    2,    3,    4,    5,    6,    7,    8,    9,    10,   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,   25; ...
            % Earth row
            0,    9.5,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN; ...
            % LEO row
            NaN,  0,    NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN,  NaN; ...
            ];
        
        %% index constants for delta-v lookups
        EARTH_INDEX	= int8(1);
        LEO_INDEX	= int8(2);
        GEO_INDEX	= int8(3);
        EML1_INDEX	= int8(4);
        EML2_INDEX	= int8(5);
        EML3_INDEX	= int8(6);
        EML4_INDEX	= int8(7);
        EML5_INDEX	= int8(8);
        LLO_INDEX	= int8(9);
        LUNAR_INDEX	= int8(10);
        EL1_INDEX	= int8(11);
        EL2_INDEX	= int8(12);
        EL3_INDEX	= int8(13);
        EL4_INDEX	= int8(14);
        EL5_INDEX	= int8(15);
        MTO_INDEX	= int8(16);
        MCO_INDEX	= int8(17);
        LMO_INDEX	= int8(18);
        MARS_INDEX	= int8(19);
        PTO_INDEX	= int8(20);
        LPO_INDEX	= int8(21);
        PHOBOS_INDEX= int8(22);
        DTO_INDEX	= int8(23);
        LDO_INDEX	= int8(24);
        DEIMOS_INDEX= int8(25);
    end
    
    %% private properties
    properties (GetAccess = private, SetAccess = immutable)
        %% original value used to instantiate object
        originalVal;
        %% location index for the current location object
        index = int8(0);
    end
    
    %% Public properties for location object
    properties (Dependent)
        %% Short-hand form of location
        Initials;
        %% Descriptive name of location
        Name;
        %% Indicator of whether or not the location represents a direct orbit around a celestial body
        IsOrbital;
        %% Indicator of whether or not the location represents a Lagrangian point about two celestial bodies
        IsLagrangian;
    end
    
    methods
        %% Location class construction
        % initialize location name
        function obj = Location(location)
            % verify we have a location input
            if nargin > 0 && ischar(location)
                % store original value of location
                obj.originalVal = char(location);
                % lookup index for provided location
                switch upper(location)
                    case 'EARTH'
                        obj.index = Location.EARTH_INDEX;
                    case 'LEO'
                        obj.index = Location.LEO_INDEX;
                    case 'GEO'
                        obj.index = Location.GEO_INDEX;
                    case 'EML1'
                        obj.index = Location.EML1_INDEX;
                    case 'EML2'
                        obj.index = Location.EML2_INDEX;
                    case 'EML3'
                        obj.index = Location.EML3_INDEX;
                    case 'EML4'
                        obj.index = Location.EML4_INDEX;
                    case 'EML5'
                        obj.index = Location.EML5_INDEX;
                    case 'LLO'
                        obj.index = Location.LLO_INDEX;
                    case 'LUNAR'
                        obj.index = Location.LUNAR_INDEX;
                    case 'EL1'
                        obj.index = Location.EL1_INDEX;
                    case 'EL2'
                        obj.index = Location.EL2_INDEX;
                    case 'EL3'
                        obj.index = Location.EL3_INDEX;
                    case 'EL4'
                        obj.index = Location.EL4_INDEX;
                    case 'EL5'
                        obj.index = Location.EL5_INDEX;
                    case 'MTO'
                        obj.index = Location.MTO_INDEX;
                    case 'MCO'
                        obj.index = Location.MCO_INDEX;
                    case 'LMO'
                        obj.index = Location.LMO_INDEX;
                    case 'MARS'
                        obj.index = Location.MARS_INDEX;
                    case 'PTO'
                        obj.index = Location.PTO_INDEX;
                    case 'LPO'
                        obj.index = Location.LPO_INDEX;
                    case 'PHOBOS'
                        obj.index = Location.PHOBOS_INDEX;
                    case 'DTO'
                        obj.index = Location.DTO_INDEX;
                    case 'LDO'
                        obj.index = Location.LDO_INDEX;
                    case 'DEIMOS'
                        obj.index = Location.DEIMOS_INDEX;
                    otherwise
                        % TODO: some sort of exception;
                end
            end
        end
        
        %% Initials getter
        function initials = get.Initials(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                    && obj.index > 0 % obj has a valid index
                % set value of initials by looking up location abbreviation
                % with current index
                initials = obj.LOCATION_ABBRS(obj.index);
            end
        end        
        %% Name getter
        function name = get.Name(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                    && obj.index > 0 % obj has a valid index
                % set value of name by looking up location names
                % with current index
                name = obj.LOCATION_NAMES(obj.index);
            end
        end
        %% Oribital getter
        function isOrbit = get.IsOrbital(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                    && obj.index > 0 % obj has a valid index
                % set value of isOrbit by looking up location orbits
                % with current index
                isOrbit = obj.ORBITAL_LOCATIONS(obj.index);
            end
        end
        %% Lagrangian getter
        function isLagrangian = get.IsLagrangian(obj)
            % validate we have a initalized location object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'Location') ... % obj is a Location object
                    && obj.index > 0 % obj has a valid index
                % set value of isOrbit by looking up location orbits
                % with current index
                isLagrangian = obj.LAGRANGIAN_LOCATIONS(obj.index);
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
            if strcmp(currentLocation.Initials, destinationLocation.Initials)
                % set delta-v to zero (0)
                deltaV = 0;
                % quit function
                return;
            end
            
            % lookup deltaV by using current index for row and destination
            % index for cell/column
            deltaV = Location.DELTAV_TABLE(currentLocation.index, destinationLocation.index);
        end
    end
    
    enumeration
        EARTH ('EARTH'), % Earth surface
        LEO ('LEO'), % low Earth orbig
        GEO ('GEO'), % geosynchronous earth orbit
        EML1 ('EML1'), % Earth-moon L1
        EML2 ('EML2'), % Earth-moon L2
        EML3 ('EML3'), % Earth-moon L3
        EML4 ('EML4'), % Earth-moon L4
        EML5 ('EML5'), % Earth-moon L5
        LLO ('LLO'), % low lunar orbit
        LUNAR ('LUNAR'), % Moon surface
        EL1 ('EL1'), % Earth-sun L1
        EL2 ('EL2'), % Earth-sun L2
        EL3 ('EL3'), % Earth-sun L3
        EL4 ('EL4'), % Earth-sun L4
        EL5 ('EL5'), % Earth-sun L5
        MTO ('MTO'), % Mars transfer orbit
        MCO ('MCO'), % Mars capture orbit
        LMO ('LMO'), % low Mars orbit
        MARS ('Mars'), % Mars surface
        PTO ('PTO'), % Phobos transfer orbit
        LPO ('LPO'), % low Phobos orbit
        PHOBOS ('PHOBOS'), % Phobos surface
        DTO ('DTO'), % Deimos transfer orbit
        LDO ('LDO'), % low Deimos orbit
        DEIMOS ('DEIMOS') % Deimos surface
    end
end

