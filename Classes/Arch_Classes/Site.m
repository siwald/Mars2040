classdef Site < handle
    %SITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=private)
        name = '';
    end
    
    properties (Dependent)
        Name;
        Altitude;
        ScienceWeighting;
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
        HOLDEN ('Holden Crater')
        GALE ('Gale Crater')
        MERIDIANI ('Meridiani Planum')
        GUSEV ('Gusev Crater')
        ISIDIS ('Isidis Planitia')
        ELYSIUM ('Elysium')
        MAWRTH ('Mawrth Vallis')
        EBERSWALDE ('Eberswalde Ellipse')
        UTOPIA ('Utopia Planitia')
        PLANUS_BOREUM ('Planus Boreum')
        HELLAS ('Hellas Planitia')
        AMAZONIS ('Amazonis Planitia')
    end
end

