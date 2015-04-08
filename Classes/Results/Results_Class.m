classdef Results_Class < dynamicprops
    %RESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Results
        Arch_Num
        Science
        Risk
        SpaceCraft
        Food
        SC_Drymass
        Propellant
        Fuel
        Oxidizer
        Regolith
        Science_Time
        IMLEO
        
        %Module Breakdowns
        Surface_Habitat = Results_List;
        ECLSS = Results_List;
        Mars_ISRU = Results_List;
        Lunar_ISRU = Results_List;
        ISFR = Results_List;
        PowerPlant = Results_List;
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
        end
        
        %Getter for total Consumables
        function out = get.Consumables(obj)
            out = obj.ECLSS.Consumables + ...
                obj.Mars_ISRU.Consumables + ...
                obj.Lunar_ISRU.Consumables + ...
                obj.ISFR.Consumables + ...
                obj.PowerPlant.Consumables; %sum Consumables from each Module
        end

        %Getter for total Spares
        function out = get.Spares(obj)
            out = obj.ECLSS.Spares + ...
                obj.Mars_ISRU.Spares + ...
                obj.Lunar_ISRU.Spares + ...
                obj.ISFR.Spares + ...
                obj.PowerPlant.Spares; %sum Spares from each Module
        end
                %Getter for total Replacements
        function out = get.Replacements(obj)
            out = obj.ECLSS.Replacements + ...
                obj.Mars_ISRU.Replacements + ...
                obj.Lunar_ISRU.Replacements + ...
                obj.ISFR.Replacements + ...
                obj.PowerPlant.Replacements; %sum Replacements from each Module
        end
        
    end
    
end

