%% MARS 2040 Tradespace architecture object
% record all the architectural decisions for mission to mars
classdef MarsArchitecture < handle  
    properties (Access = private)
        origin = Location.EARTH; % not used
        stageLocation = Location.LEO;
        destinations = [Location.LMO, Location.EARTH]; % not used
        propulsionType = Propulsion.LH2;
        crewTrajectory = CrewTrajectory.HOHMANN;
        cargoTrajectory = CargoTrajectory.HOHMANN;
        transitFuel = [TransitFuel.EARTH_LH2, TransitFuel.LUNAR_O2];
        transitCrew = Crew.DEFAULT_TRANSIT;
        transitShielding = HabitatShielding.H2O_INSULATION;
        orbitCapture = ArrivalEntry.AEROCAPTURE; % TODO: make an array to capture any orbital manuevars from destinations list
        entryDescent = ArrivalDescent.PROPULSIVE;
        siteSelection = Site.HOLDEN;
        surfaceCrew = SurfaceCrew.TARGET_SURFACE;
        isruBase = {cellstr('Atmospheric')};
        isruUse = {cellstr('Fuel')}; % almost feel this should be generated from fuel, food, etc.
        foodSupply = FoodSource.EARTH_MARS_50_SPLIT; %{Location.EARTH, 0.5000; Location.MARS, 0.5000};
        surfaceShielding = SurfaceShielding.REGOLITH;
        surfaceStructure = {StructureType.FIXED_SHELL, 0.500; StructureType.INFLATABLE, 0.500};
        surfacePower = [PowerSource.NUCLEAR, PowerSource.SOLAR, PowerSource.RTG];
        isfrUse = {cellstr('Metal')};
        returnFuel = [ReturnFuel.EARTH_LH2, ReturnFuel.MARS_O2];
        returnCapture = ReturnEntry.DIRECT;
        returnDescent = ReturnDescent.CHUTE;
        
        %% validation indicator
        isValid = false;
    end
    properties (Dependent)
        Origin;
        Staging;
        Destinations;
        PropulsionType;
        TransitFuel;
        CrewTrajectory;
        CargoTrajectory;
        ReturnFuel;
        TransitCrew;
        TransitShielding;
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
        ReturnCapture;
        ReturnDescent;
        %% Indicates whether or not architecture is valid and doesn't contain any contrary decisions
        IsValid;
    end
    
    %% static class methods
    methods (Static)
        %% Method to get an enumeration of possible architectures
        % 
        function architectures = Enumerate(varargin)
            % check if we have any arguments
            if ~isempty(varargin)
                % only argument in should be array of options
                archDecisions = varargin;
                % get the number of options for architecture tradespace
                % given, this is the number of tradespace decisions being
                % enumerated for the architecture analysis
                numberOfDecisions = length(archDecisions);

                % iterate over each tradespace or architectural decision to
                % enumerate option all the options for that decision
                for decisionCount = 1:numberOfDecisions
                    % get the decision options array
                    optionArray = archDecisions{decisionCount};
                    % skip any empty options
                    if isempty(optionArray)
                        continue; % no options provided for decision so we skip/ignore
                    end
                    
                    % if only one decision option, we override/force this
                    % decision for all architecture enumerations
                    if length(optionArray) == 1
                       % if the architectures variable doesn't exist yet,
                       % initialize to an array with default architecture
                       if ~exist('architectures', 'var')
                            architectures = {MarsArchitecture()};
                       end
                       
                       % determine the type of option being set
                       if isa(optionArray{1}, 'Propulsion')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set propulsion option for architecture
                               architectures{archIndIndex}.PropulsionType = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'Location')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set staging location for architecture
                               architectures{archIndIndex}.Staging = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'Site')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set site option for architecture
                               architectures{archIndIndex}.SurfaceSites = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       % do surface crew before crew, since it is a
                       % subclass of crew
                       if isa(optionArray{1}, 'SurfaceCrew')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set surface crew option for architecture
                               architectures{archIndIndex}.SurfaceCrew = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'Crew')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set transit crew option for architecture
                               architectures{archIndIndex}.TransitCrew = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'CrewTrajectory')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set crew trajectory option for architecture
                               architectures{archIndIndex}.CrewTrajectory = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'CargoTrajectory')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set cargo trajectory option for architecture
                               architectures{archIndIndex}.CargoTrajectory = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'PowerSource')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set power option for architecture
                               architectures{archIndIndex}.SurfacePower = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'StructureType')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set structure option for architecture
                               architectures{archIndIndex}.SurfaceStructure = optionArray(1);
                           end
                       end
                       if isa(optionArray{1}, 'FoodSource')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set food supply option for architecture
                               architectures{archIndIndex}.FoodSupply = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       % do surface shielding before transit shielding
                       % since it is a subclass of habitat shielding
                       if isa(optionArray{1}, 'SurfaceShielding')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set habitat shielding option for architecture
                               architectures{archIndIndex}.SurfaceShielding = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'HabitatShielding')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set transit shielding option for architecture
                               architectures{archIndIndex}.TransitShielding = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'TransitFuel')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set transit fuel option for architecture
                               architectures{archIndIndex}.TransitFuel = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'ReturnFuel')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set return fuel option for architecture
                               architectures{archIndIndex}.ReturnFuel = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'ArrivalEntry')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set orbit capture option for architecture
                               architectures{archIndIndex}.OrbitCapture = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'ReturnEntry')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set return capture option for architecture
                               architectures{archIndIndex}.ReturnCapture = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'ArrivalDescent')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set EDL option for architecture
                               architectures{archIndIndex}.EDL = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                       if isa(optionArray{1}, 'ReturnDescent')
                            % iterate of each of the architectures
                           for archIndIndex = 1:length(architectures)
                               % set return descent option for architecture
                               architectures{archIndIndex}.ReturnDescent = optionArray{1};
                           end
                           continue; % onto next decision
                       end
                    else
                        % declare a temporary array for new enumerated
                        % architectures
                        tempArray = {};
                        % initialize architectures if it doesn't exist
                       if ~exist('architectures', 'var')
                            architectures = {MarsArchitecture()};
                       end
                        % iterate of each of the previous architectures
                       for archIndex = 1:length(architectures)
                           % get a reference to the 'current' previous
                           % architecture
                           previousArchitecture = architectures{archIndex};
                           % iterate over each new option
                           for optionIndex = 1:length(optionArray)
                               % calculate index for new architecture
                               newIndex = (archIndex - 1) * length(optionArray) + optionIndex;
                               % set new architecture into temp array
                               tempArray{newIndex} = previousArchitecture.Duplicate();
                               % set option
                       
                               if isa(optionArray{1}, 'Propulsion')
                                   tempArray{newIndex}.PropulsionType = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'Location')
                                   tempArray{newIndex}.Staging = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'Site')
                                   tempArray{newIndex}.SurfaceSites = optionArray{optionIndex};
                                   continue;
                               end
                               % must do surface crew before transit crew
                               if isa(optionArray{1}, 'SurfaceCrew')
                                   tempArray{newIndex}.SurfaceCrew = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'Crew')
                                   tempArray{newIndex}.TransitCrew = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'CrewTrajectory')
                                   tempArray{newIndex}.CrewTrajectory = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'CargoTrajectory')
                                   tempArray{newIndex}.CargoTrajectory = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'PowerSource')
                                   tempArray{newIndex}.SurfacePower = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'StructureType')
                                   tempArray{newIndex}.SurfaceStructure = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'FoodSource')
                                   tempArray{newIndex}.FoodSupply = optionArray{optionIndex};
                                   continue;
                               end
                               % must do surface shielding before transit shielding
                               if isa(optionArray{1}, 'SurfaceShielding')
                                   tempArray{newIndex}.SurfaceShielding = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'HabitatShielding')
                                   tempArray{newIndex}.TransitShielding = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'TransitFuel')
                                   tempArray{newIndex}.TransitFuel = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'ReturnFuel')
                                   tempArray{newIndex}.ReturnFuel = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'ArrivalEntry')
                                   tempArray{newIndex}.OrbitCapture = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'ReturnEntry')
                                   tempArray{newIndex}.ReturnCapture = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'ArrivalDescent')
                                   tempArray{newIndex}.EDL = optionArray{optionIndex};
                                   continue;
                               end
                               if isa(optionArray{1}, 'ReturnDescent')
                                   tempArray{newIndex}.ReturnDescent = optionArray{optionIndex};
                                   continue;
                               end
                           end % end for option loop
                       end % end for prev architecture loop
                       % set architectures value to temp array for next
                       % loop
                       architectures = tempArray;
                    end % end else for multiple option values
                end % end for input option array loop
            else
                % if no input to method, output warning and just return
                % default architecture
                warning('Mars architectures requested without any options.');
                architectures = {MarsArchitecture.DEFAULT};
            end
            
            if length(architectures) == 1
                architectures = architectures{1};
            end
        end
    end
    
    %% Architecture public members
    methods
        %% Architecture constructor
        function arch = MarsArchitecture() 
            if nargin > 0
                % do we need any inputs, set later using setters
            end
        end
        
        %% Duplication function to copy an architecture
        function duplicate = Duplicate(currentArchitecture)
            %% verify we have valid architecture object input to copy
            if nargin > 0 && isa(currentArchitecture, 'MarsArchitecture')
                duplicate = MarsArchitecture();
                
                duplicate.origin = currentArchitecture.origin;
                duplicate.stageLocation = currentArchitecture.stageLocation;
                duplicate.destinations = currentArchitecture.destinations;
                duplicate.propulsionType = currentArchitecture.propulsionType;
                duplicate.transitFuel = currentArchitecture.transitFuel;
                duplicate.crewTrajectory = currentArchitecture.crewTrajectory;
                duplicate.cargoTrajectory = currentArchitecture.cargoTrajectory;
                duplicate.returnFuel = currentArchitecture.returnFuel;
                duplicate.transitCrew = currentArchitecture.transitCrew;
                duplicate.transitShielding = currentArchitecture.transitShielding;
                duplicate.orbitCapture = currentArchitecture.orbitCapture;
                duplicate.entryDescent = currentArchitecture.entryDescent;
                duplicate.siteSelection = currentArchitecture.siteSelection;
                duplicate.surfaceCrew = currentArchitecture.surfaceCrew;
                duplicate.isruBase = currentArchitecture.isruBase;
                duplicate.isruUse = currentArchitecture.isruUse;
                duplicate.foodSupply = currentArchitecture.foodSupply;
                duplicate.surfaceShielding = currentArchitecture.surfaceShielding;
                duplicate.surfaceStructure = currentArchitecture.surfaceStructure;
                duplicate.surfacePower = currentArchitecture.surfacePower;
                duplicate.isfrUse = currentArchitecture.isfrUse;
            else
                error('Invalid architecture to duplicate.');
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
        %% Crew Trajectory getter
        function trajectory = get.CrewTrajectory(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get crew trajectory from architecture object
                trajectory = obj.crewTrajectory;
            end
        end
        %% Cargo Trajectory getter
        function trajectory = get.CargoTrajectory(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get cargo trajectory from architecture object
                trajectory = obj.cargoTrajectory;
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
        %% Return capture getter
        function returnEDL = get.ReturnCapture(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get return from destinations list
                % get return EDL from architecture object
                returnEDL = obj.returnCapture;
            end
        end
        %% Return EDL getter
        function returnEDL = get.ReturnDescent(obj)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture')
                % get return from destinations list
                % get return EDL from architecture object
                returnEDL = obj.returnDescent;
            end
        end
        %%% ReturnFuel Setter
        %function returnFuel = set.ReturnFuel(obj, now)
        %    obj.returnFuel = now;
        %end
        %% TransitFuel Setter
        %function transitFuel = set.TransitFuel(obj, now)
        %    obj.transitFuel = now;
        %end
        %%% StageLoc Setter
        %function stageLocation = set.Staging(obj, now)
        %    obj.stageLocation = now;
        %end
        %%% OrbitCapture Setter
        %function orbitCapture = set.OrbitCapture(obj, now)
        %    obj.orbitCapture = now;
        %end
        
        %% Origin setter
        function set.Origin(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'Location')
                % get origin from architecture object
                obj.origin = value;
            else
                warning('Setting architecture origin not possible because of invalid input.');
            end
        end
        %% Staging location setter
        function set.Staging(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'Location')
                % get staging location from architecture object
                obj.stageLocation = value;
            else
                warning('Setting architecture staging not possible because of invalid input.');
            end
        end
        %% Destinations setter
        function set.Destinations(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'Location')
                % get destination list from architecture object
                obj.destinations = value;
            else
                warning('Setting architecture destinations not possible because of invalid input.');
            end
        end
        %% Propulsion setter
        function set.PropulsionType(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'Propulsion')
                % set propulsion value for architecture object
                obj.propulsionType = value;
            else
                warning('Setting architecture propulsion not possible because of invalid input.');
            end
        end
        %% Transit fuel setter
        function set.TransitFuel(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'TransitFuel')
                % get transit fuel object from architecture object
                obj.transitFuel = value;
            else
                warning('Setting architecture transit fuel not possible because of invalid input.');
            end
        end
        %% Crew Trajectory setter
        function set.CrewTrajectory(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'CrewTrajectory')
                % get trajectory from architecture object
                obj.crewTrajectory = value;
            else
                warning('Setting architecture trajectory not possible because of invalid input.');
            end
        end
        %% Cargo Trajectory setter
        function set.CargoTrajectory(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'CargoTrajectory')
                % get trajectory from architecture object
                obj.cargoTrajectory = value;
            else
                warning('Setting architecture trajectory not possible because of invalid input.');
            end
        end
        %% Return fuel setter
        function set.ReturnFuel(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'ReturnFuel')
                % get return fuel object from architecture object
                obj.returnFuel = value;
            else
                warning('Setting architecture return fuel not possible because of invalid input.');
            end
        end
        %% Transit Crew setter
        function set.TransitCrew(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'Crew')
                % get transit crew object from architecture object
                obj.transitCrew = value;
            else
                warning('Setting architecture transit crew not possible because of invalid input.');
            end
        end
        %% Transit shielding setter
        function set.TransitShielding(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'HabitatShielding')
                % get transit shielding from architecture object
                obj.transitShielding = value;
            else
                warning('Setting architecture transit shield not possible because of invalid input.');
            end
        end 
        %% Orbit capture setter
        function set.OrbitCapture(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'ArrivalEntry')
                % get orbit capture from architecture object
                obj.orbitCapture = value;
            else
                warning('Setting architecture orbit capture not possible because of invalid input.');
            end
        end
        %% EDL setter
        function set.EDL(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'ArrivalDescent')
                % get EDL from architecture object
                obj.entryDescent = value;
            else
                warning('Setting architecture EDL not possible because of invalid input.');
            end
        end
        %% Sites setter
        function set.SurfaceSites(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'Site')
                % get sites list from architecture object
                obj.siteSelection = value;
            else
                warning('Setting architecture site not possible because of invalid input.');
            end
        end
        %% Surface crew setter
        function set.SurfaceCrew(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'SurfaceCrew')
                % get surface Crew object from architecture object
                obj.surfaceCrew = value;
            else
                warning('Setting architecture surface crew not possible because of invalid input.');
            end
        end
        %% ISRU base setter
        function set.ISRUBase(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, '')
                % get ISRU base from architecture object
                obj.isruBase = value;
            else
                warning('Setting architecture ISRU base not possible because of invalid input.');
            end
        end
        %% ISRU use setter
        function set.ISRUUse(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, '')
                % TODO: determine uses from fuel, food, etc. configuration
                % get ISRU use from architecture object
                obj.isruUse = value;
            else
                warning('Setting architecture ISRU use not possible because of invalid input.');
            end
        end
        %% ISFR setter
        function set.ISFRUse(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, '')
                % get ISFR use from architecture object
                obj.isfrUse = value;
            else
                warning('Setting architecture ISRF use not possible because of invalid input.');
            end
        end
        %% Food supply setter
        function set.FoodSupply(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'FoodSource')
                % get food supply list from architecture object
                obj.foodSupply = value;
            else
                warning('Setting architecture food supply not possible because of invalid input.');
            end
        end
        %% Surface shielding setter
        function set.SurfaceShielding(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'SurfaceShielding')
                % get surface shielding from architecture object
                obj.surfaceShielding = value;
            else
                warning('Setting architecture surface shield not possible because of invalid input.');
            end
        end
        %% Surface structure setter
        function set.SurfaceStructure(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && ...
                    (isa(value, 'StructureType') || (length(value) > 1 && isa(value{1}, 'StructureType')))
                % get surface structure from architecture object
                obj.surfaceStructure = value;
            else
                warning('Setting architecture surface structure not possible because of invalid input.');
            end
        end
        %% Surface power setter
        function set.SurfacePower(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'PowerSource')
                % get surface power list from architecture object
                obj.surfacePower = value;
            else
                warning('Setting architecture surface power not possible because of invalid input.');
            end
        end
        %% Return capture setter
        function set.ReturnCapture(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'ReturnEntry')
                % get return from destinations list
                % get return capture from architecture object
                obj.returnCapture = value;
            else
                warning('Setting architecture return capture not possible because of invalid input.');
            end
        end
        %% Return EDL setter
        function set.ReturnDescent(obj, value)
            % verify we have valid input object
            if nargin > 0 && isa(obj, 'MarsArchitecture') && isa(value, 'ReturnDescent')
                % get return from destinations list
                % get return EDL from architecture object
                obj.returnDescent = value;
            else
                warning('Setting architecture return descent not possible because of invalid input.');
            end
        end
    end
    
    properties (Constant)
        DEFAULT = MarsArchitecture();
        DRA5 = MarsArchitecture.Enumerate( ...
            {Propulsion.NTR}, ...
            {TransitFuel.EARTH_LH2}, ...
            {HabitatShielding.DEDICATED}, ...
            {ArrivalEntry.PROPULSIVE}, ...
            {ArrivalDescent.PROPULSIVE}, ...
            {Crew.DRA_CREW}, ...
            {SurfaceShielding.DEDICATED}, ...
            {FoodSource.EARTH_ONLY});
    end
end