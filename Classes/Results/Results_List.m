classdef Results_List < handle
    %RESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Consumables_Mass 
        Consumables_Volume 
        Spares_Mass 
        Spares_Volume 
        Replacements_Mass
        Replacements_Volume
        Mass 
        Power 
        Volume
        Fuel_Output 
        Oxidizer_Output 
        CH4_Prop_Output
        Lights
    end
    properties
        Consumables
        Spares
        Replacements
        Num
    end
    
    methods
        %setters for Consumables_Mass and Spares_Mass by usintg
        %just Consumables and Spares
        function obj = set.Consumables(obj,in)
            obj.Consumables_Mass = in;
        end
        function obj = set.Spares(obj,in)
            obj.Spares_Mass = in;
        end
        %getters just like that too.
        function out = get.Consumables(obj)
            out = obj.Consumables_Mass;
        end
        function out = get.Spares(obj)
            out = obj.Spares_Mass;
        end
        function out = get.Replacements(obj)
            out = obj.Replacements_Mass;
        end
    end
    
end

