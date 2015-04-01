classdef Site < handle
    %SITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=private)
        name = '';
    end
    
    properties (Dependent)
        Name;
    end
    
    methods
        %% Constructor
        function obj = Site(siteName)
            obj.name = siteName;
        end
        
        %% Name getter
        function n = get.Name(obj)
            %% do validation here
            n = obj.name;
        end
    end
    
    enumeration
        HOLDEN_CRATER ('Holden Crater')
        GALE_CRATER ('Gale Crater')
    end
end

