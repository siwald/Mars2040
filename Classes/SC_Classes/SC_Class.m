classdef SC_Class < handle
    %SC_CLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %All in kg, or m^3
        Prop_Mass %mass of propellant at departure
        Fuel_Mass %mass of fuel at departure
        Ox_Mass %mass of oxidizer and departure
        Origin_Mass %total mass at departure
        Bus_Mass %mass of unfueled spacecraft bus (propulsion, nav, etc.)
        Bus_Vol %volume of S/C outside Hab, Payload and Propulsion
        Payload_Mass %mass of payload to destination
        Payload_Vol %Volume for payload
        Hab_Mass %mass of the habitat kg
        Hab_Vol %volume of habitatable area m^3
        Hab_Power %Power needs of habitat kW
        Eng_Mass %Engine Mass, scales with fuel requirement
        Volume % volume estimate of element
        Dry_Mass % Mass of entire S/C less fuel
        Description@char %description of this instance, character string
    end
    
    methods
        %Constructor
        function this = SC_Class(description)
            if nargin > 0
                this.Description = description;
            end
        end
        %{
        --- should be unused
        function origin_def(this, origin, prop, fox_rat)
            %Send variable to this function in order, Origin Mass, Propellant Mass and Fuel/Oxidizer Ratio
            this.Prop_Mass = prop;
            this.Origin_Mass = origin;
            this.Bus_Mass = origin - this.Payload_Mass - prop - this.Hab_M;
            this.Ox_Mass = prop*(fox_rat/(fox_rat + 1));
            this.Fuel_Mass = prop*(1/(fox_rat + 1));
        end
        %}
        %% Populators for aggregate properties
        function origin_calc(this) %calc the origin mass by adding all the components
            this.Origin_Mass = nansum( ... nansum ignores empty or NaN values.
                [this.Fuel_Mass, ...
                 this.Ox_Mass, ...
                 this.Eng_Mass, ...
                 this.Bus_Mass, ...
                 this.Payload_Mass, ...
                 this.Hab_Mass]);
        end
        
        function drymass_calc(this) %calc drymass
%             %Run origin_calc first if not run yet.
            if this.Origin_Mass == 0
                this.origin_calc;
            elseif isempty(this.Origin_Mass)
                this.origin_calc;
            end
            %Calc the dry mass, origin_mass minus prop mass
            if ~isempty(this.Prop_Mass) %only if Prop_Mass is defined
            this.Dry_Mass = this.Origin_Mass - this.Prop_Mass;
            end
        end
        
        function volume_calc(obj)
            obj.Volume = nansum([ ... nan sum ignores values yet undefined.
                obj.Hab_Vol, ...
                obj.Payload_Vol, ...
                obj.Bus_Vol]);
        end
        %% Setters
        
        %% Getters 
        %Total Volume getter, will populate if as-yet undefined
        function out = get.Volume(obj)
            if isempty(obj.Volume)
                obj.volume_calc;
            end
            out = obj.Volume;
        end
        
        %Origin Mass getter, will popelate if as-yet undefined
        function out = get.Origin_Mass(obj)
            %if isempty(obj.Origin_Mass)
                obj.origin_calc; %just run it first.
            %end
            out = obj.Origin_Mass;
        end  
    end
    
end

