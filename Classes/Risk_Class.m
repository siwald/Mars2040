classdef Risk_Class
    %RISK_CLASS Structure that contains the risk values
    %   Unitless risk metric, only for architucterally distinquishing
    %   features, if all architectures 
    
    properties
        Tech_R %One-time risk to develop the technology
        Ops_R %Periodic risk repeated for each mission
    end
    
    methods
        function obj = Risk_Class (tech,ops)
            obj.Tech_R = tech;
            obj.Ops_R = ops;
        end
    end
    
end

