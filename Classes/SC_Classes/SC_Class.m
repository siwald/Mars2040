classdef SC_Class < handle
    %SC_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %All in kg, or m^3
        Prop_Mass %mass of propellant at departure
        Fuel_Mass %mass of fuel at departure
        Ox_Mass %mass of oxidizer and departure
        Origin_Mass %total mass at departure
        Bus_Mass %mass of unfueled spacecraft bus (propulsion, nav, etc.) Should be sum of engine mass plus static mass
        Payload_Mass %mass of payload to destination
        Hab_Mass %mass of the habitat
        Hab_Vol %volume of habitat
        Eng_Mass %Engine Mass, scales with fuel requirement
        Description@char %description of this instance, character string
    end
    
    methods
        function origin_def(this, origin, prop, fox_rat)
            %Send variable to this function in order, Origin Mass, Propellant Mass and Fuel/Oxidizer Ratio
            this.Prop_Mass = prop;
            this.Origin_Mass = origin;
            this.Bus_Mass = origin - this.Payload_Mass - prop - this.Hab_M;
            this.Ox_Mass = prop*(fox_rat/(fox_rat + 1));
            this.Fuel_Mass = prop*(1/(fox_rat + 1));
        end
        function origin_calc(this) %calc the origin mass by adding all the components
            this.Origin_Mass = this.Prop_Mass + this.Eng_Mass + this.Bus_Mass + this.Payload_Mass + this.Hab_Mass;
        end
        function this = SC_Class(payload, hab, desc);
            if nargin > 0
                this.Hab_Mass = hab;
                this.Payload_Mass = payload;
                this.Description = desc;
                this.Prop_Mass = 0;
                this.Fuel_Mass = 0;
                this.Ox_Mass = 0;
                this.Origin_Mass = payload + hab;
                this.Bus_Mass = 0;
                this.Hab_Vol = 0;
                this.Eng_Mass = 0;

            end
        end
    end
    
end

