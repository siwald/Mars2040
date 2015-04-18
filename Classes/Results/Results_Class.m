classdef Results_Class < dynamicprops
    %RESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Results
        Arch_Num
        Arch_Name
        Science
        Risk
        % replace with space craft objects
        %SpaceCraft
        %Food
        %SC_Drymass
        %Propellant
        %Fuel
        %Oxidizer
        Regolith
        Science_Time
        IMLEO
        
        % Spacecraft breakdowns
        HumanSpacecraft;
        CargoSpacecraft;
        FerrySpacecraft;
        AscentSpacecraft;
        
        %Module Breakdowns
        Transit_Habitat;
        Surface_Habitat;
        ECLSS;
        Mars_ISRU;
        Lunar_ISRU;
        ISFR;
        PowerPlant;
    end
    properties (SetAccess = private) %thus GetAccess is public, for access to aggregate lists
        Consumables
        Spares
        Replacements
    end
    
    methods
        %Constructor with Arch Number
        function obj = Results_Class(num)
            obj.Arch_Num = num;
            % initialize objects
            obj.HumanSpacecraft = OverallSC();
            obj.CargoSpacecraft = OverallSC();
            obj.FerrySpacecraft = OverallSC();
            obj.AscentSpacecraft = OverallSC();
            obj.Transit_Habitat = Results_List();
            obj.Surface_Habitat = Results_List();
            obj.ECLSS = Results_List();
            obj.Mars_ISRU = Results_List();
            obj.Lunar_ISRU = Results_List();
            obj.ISFR = Results_List();
            obj.PowerPlant = Results_List();
            obj.IMLEO = IMLEO_Split();
        end
        
        %Getter for total Consumables
        function out = get.Consumables(obj)
            out = nansum([obj.ECLSS.Consumables,
                obj.Mars_ISRU.Consumables,
                obj.Lunar_ISRU.Consumables,
                obj.ISFR.Consumables,
                obj.PowerPlant.Consumables]); %sum Consumables from each Module
        end

        %Getter for total Spares
        function out = get.Spares(obj)
            out = nansum([obj.ECLSS.Spares,
                obj.Mars_ISRU.Spares,
                obj.Lunar_ISRU.Spares,
                obj.ISFR.Spares,
                obj.PowerPlant.Spares]); %sum Spares from each Module
        end
                %Getter for total Replacements
        function out = get.Replacements(obj)
            out = nansum([obj.ECLSS.Replacements,
                obj.Mars_ISRU.Replacements,
                obj.Lunar_ISRU.Replacements,
                obj.ISFR.Replacements,
                obj.PowerPlant.Replacements]); %sum Replacements from each Module
        end
        
    end
    
end

