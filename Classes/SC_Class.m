classdef SC_Class
    %SC_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Prop_M %mass of propellant at departure
        Fuel_M %mass of fuel at departure
        Ox_M %mass of oxidizer and departure
        Origin_M %total mass at departure
        Bus_M %mass of unfueled spacecraft bus (propulsion, nav, etc.)
        Payload_M %mass of payload to destination
        Hab_M %mass of the habitat
    end
    
    methods
        function obj = origin_def(origin, payload, prop, fox_rat)
            obj.Prop_M = prop;
            obj.Origin_M = origin;
            obj.Bus_M = origin - payload - fuel;
            obj.Payload_M = payload;
            obj.Fuel_M = prop*(fox_rat/(fox_rat + 1));
            obj.Ox_M = prop*(1/(fox_rat + 1));
        end
            
    end
    
end

