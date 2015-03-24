%% MARS 2040 Tradespace architecture object
% record all the architectural decisions for mission to mars
classdef MarsArchitecture < handle
    properties (Access = private)
        origin = Location.EARTH;
        stageLocation = Location.LEO;
        destinations = [Location.LMO, Location.EARTH];        
        propulsionType = Propulsion.LH2;
        transitFuel = 'Lunar_O2';
        transitTrajectory = 'Hohmann';
        returnFuel = 'Mars_O2';
        returnTrajectory = 'Hohmann';
        %transitCrew = Crew.DEFAULT_TRANSIT;
        transitCrew = 4; %until Crew.m works
        transitShielding = 'Temp';
        transitShieldMaterial = 'Water';
        transitHabitatVolume = '10';
        orbitCapture = 'Aerocapture'; % TODO: make an array to capture any orbital manuevars from destinations list
        entryDescent = 'Propulsive';
        siteSelection = {cellstr('Holden Crater')};
        surfaceCrew = Crew.TARGET_SURFACE;
        isruBase = {cellstr('Atmospheric')};
        isruUse = {cellstr('Fuel')}; % almost feel this should be generated from fuel, food, etc.
        foodSupply = {Location.EARTH, 0.5000; Location.MARS, 0.5000};
        surfaceShielding = 'Regolith';
        surfaceStructure = 'Hybrid';
        %surfacePower = {cellstr('Nuclear'); cellstr('RTG'); cellstr('Solar')};
        surfacePower = {cellstr('Hybrid')};
        isfrUse = {cellstr('Metal')};
        returnEntry = 'Direct'; % TODO: can we assume this from no orbital destination before earth
        
        %% validation indicator
        isValid = false;
    end
    properties %(Dependent)
        Origin;
        Staging;
        Destinations;
        PropulsionType;
        TransitFuel;
        TransitTrajectory;
        ReturnFuel;
        ReturnTrajectory;
        TransitCrew;
        TransitShielding;
        TransitShieldMaterial;      
        TransitHabitatVolume;
        OrbitCapture;
        EDL;
        SurfaceSites;
        NumberOfSites;
        SurfaceCrew;
        ISRUBase;
        ISRUUse;
        ISFRUse;
        FoodSupply;
        SurfaceShielding;
        SurfaceStructure;
        SurfacePower;
        ReturnEntry;
        %% Indicates whether or not architecture is valid and doesn't contain any contrary decisions
        IsValid;
    end
    
    %% Architecture public members
    methods
        %% Architecture constructor
        function arch = MarsArchitecture() 
            if nargin > 0
                % do we need any inputs, set later using setters
            end
        end
        
        %% Origin getter
        function origin = get.Origin(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get origin from architecture object
                origin = obj.origin;
            end
        end
        %% Staging location getter
        function stageLoc = get.Staging(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get staging location from architecture object
                stageLoc = obj.stageLocation;
            end
        end
        %% Destinations getter
        function dest = get.Destinations(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get destination list from architecture object
                dest = obj.destinations;
            end
        end
        %% Propulsion getter
        function propulsion = get.PropulsionType(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get propulsion object from architecture object
                propulsion = obj.propulsionType;
            end
        end
        %% Transit fuel getter
        function transFuel = get.TransitFuel(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get transit fuel object from architecture object
                transFuel = obj.transitFuel;
            end
        end
        %% Transit trajectory getter
        function transTraj = get.TransitTrajectory(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get transit trajectory from architecture object
                transTraj = obj.transitTrajectory;
            end
        end
        %% Return fuel getter
        function returnFuel = get.ReturnFuel(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get return fuel object from architecture object
                returnFuel = obj.returnFuel;
            end
        end
        %% Return trajectory getter
        function returnTraj = get.ReturnTrajectory(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get return trajectory from architecture object
                returnTraj = obj.returnTrajectory;
            end
        end
        %% Transit Crew getter
        function transCrew = get.TransitCrew(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get transit crew object from architecture object
                transCrew = obj.transitCrew;
            end
        end
        %% Transit shielding getter
        function transShield = get.TransitShielding(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get transit shielding from architecture object
                transShield = obj.transitShielding;
            end
        end
        %% Transit shield material getter
        function transShieldMat = get.TransitShieldMaterial(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get transit shield material from architecture object
                transShieldMat = obj.transitShieldMaterial;
            end
        end   
        %% Transit size getter
        function transSize = get.TransitHabitatVolume(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get transit hab size from architecture object
                transSize = obj.transitHabitatVolume;
            end
        end
        %% Orbit capture getter
        function orbCap = get.OrbitCapture(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get orbit capture from architecture object
                orbCap = obj.orbitCapture;
            end
        end
        %% EDL getter
        function edl = get.EDL(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get EDL from architecture object
                edl = obj.entryDescent;
            end
        end
        %% Sites getter
        function sites = get.SurfaceSites(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get sites list from architecture object
                sites = obj.siteSelection;
            end
        end        
        %% Site Number getter
        function siteNum = get.NumberOfSites(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get number of sites in selection array
                siteNum = numel(obj.siteSelection);
            end
        end
        %% Surface crew getter
        function surfCrew = get.SurfaceCrew(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get surface Crew object from architecture object
                surfCrew = obj.surfaceCrew;
            end
        end
        %% ISRU base getter
        function isru = get.ISRUBase(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get ISRU base from architecture object
                isru = obj.isruBase;
            end
        end
        ;
        %% ISRU use getter
        function isru = get.ISRUUse(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % TODO: determine uses from fuel, food, etc. configuration
                % get ISRU use from architecture object
                isru = obj.isruUse;
            end
        end
        %% ISFR getter
        function isfr = get.ISFRUse(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get ISFR use from architecture object
                isfr = obj.isfrUse;
            end
        end
        %% Food supply getter
        function food = get.FoodSupply(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get food supply list from architecture object
                food = obj.foodSupply;
            end
        end
        %% Surface shielding getter
        function surfShield = get.SurfaceShielding(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get surface shielding from architecture object
                surfShield = obj.surfaceShielding;
            end
        end
        %% Surface structure getter
        function surfStruc = get.SurfaceStructure(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get surface structure from architecture object
                surfStruc = obj.surfaceStructure;
            end
        end
        %% Surface power getter
        function surfPower = get.SurfacePower(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get surface power list from architecture object
                surfPower = obj.surfacePower;
            end
        end
        %% Return entry getter
        function returnEDL = get.ReturnEntry(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get return from destinations list
                % get return EDL from architecture object
                returnEDL = obj.returnEntry;
            end
        end
        %% ReturnFuel Setter
        function returnFuel = set.ReturnFuel(obj, now)
            obj.returnFuel = now;
        end
        %% TransitFuel Setter
        function transitFuel = set.TransitFuel(obj, now)
            obj.transitFuel = now;
        end
    end
    
    enumeration
        DEFAULT
    end
end