classdef SC_Class < handle
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
        function origin_def(this, origin, prop, fox_rat)
            %Send variable to this function in order, Origin Mass, Propellant Mass and Fuel/Oxidizer Ratio
            this.Prop_M = prop;
            this.Origin_M = origin;
            this.Bus_M = origin - this.Payload_M - prop - this.Hab_M;
            this.Fuel_M = prop*(fox_rat/(fox_rat + 1));
            this.Ox_M = prop*(1/(fox_rat + 1));
        end
            
    end
    
end

