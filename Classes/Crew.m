%% MARS 2040 crew architecture object
% crew object keeps track of number of crew, and supplies required
% for the crew per day
classdef Crew < handle
    %% Constant properties for static crew properties
    properties(Constant, GetAccess = public)
        %% Average food consumption per crew member per day in kilograms
        FoodKgMassPerDay = 2.3; % Units: kg/person/day, per BVAD, packaged food
        %% Average water consumption/need per crew member per day in kilograms
        H2OKgMassPerDay = 1.5; % TODO: bogus number
        %% Average incidental material need/consumption per crew member per day in kilograms
        IncidentalKgMassPerDay = 1.0; % TODO: bogus number
    end
    
    %% Public properties of crew architecture
    properties(Access = public)
        Size = int16(0); % set default value of 0 crew, indicates non-initialized object
    end
    
    %% private properties of crew architecture
    properties(Access = private)
    end
    
    %% Calculated properties of crew architecture
    properties(Dependent)
        %% Get the daily kg supply mass requirements for current crew
        KgPerDay;
        %% Get the daily kg food mass requirements for current crew
        FoodKgPerDay;
        %% Get the daily kg water mass requirements for current crew
        H2OKgPerDay;
        %% Get the daily kg incidental supply mass requirements for current crew
        IncidentalKgPerDay;
    end
    
    %% Crew architecture methods
    methods
        %% Crew architecture contructor.
        % initialize the size of crew
        function crew = Crew(size)
            % validate we got a valid crew size
            if nargin > 0 && isnumeric(size) && size > 0
                % set crew size to integer value
                crew.Size = int16(size);
            end
        end
        %% Size setter
        % reset the crew size
        function set.Size(obj, value)
            if nargin == 2 && isa(obj, 'Crew') ...
                && isnumeric(value) && value > 0
                obj.Size = int16(value);
            else
                obj.Size = int16(0);
            end
        end
        
        
    end
    
    %% Enumeration of standard crew sizes
    enumeration
        MIN_CREW (2)
        DEFAULT_TRANSIT (4)
        DRA_CREW (6)
        TARGET_SURFACE (20)
    end
end

