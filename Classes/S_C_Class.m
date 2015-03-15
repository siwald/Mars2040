classdef S_C_Class
    %S_C_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Fuel_M %mass of fuel at origin
        Origin_M %total mass at origin
        Bus_M %mass of unfueled spacecraft bus (propulsion, nav, etc.)
        Payload_M %mass of payload to destination
    end
    
    methods
        function obj = S_C_Class(origin, payload, fuel)
            obj.Fuel_M = fuel;
            obj.Origin_M = origin;
            obj.Bus_M = origin - payload - fuel;
            obj.Payload_M = payload;
        end
    end
    
end

