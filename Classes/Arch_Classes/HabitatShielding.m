%% Class representing rocket fuel types
classdef HabitatShielding < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        DEDICATED = HabitatShielding('Dedicated');
        H2O_INSULATION = HabitatShielding('Water');
        REGOLITH = HabitatShielding('Regolith');
        BURIED = HabitatShielding('Buried');
    end
    
    %% private class members
    properties (Access = private)
        name;
    end
    
    %% public dependent members
    properties (Dependent)
        Name;
        Protection;
        ThermalLoss;        
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = HabitatShielding(shieldName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(shieldName) && ~isempty(shieldName) % have a name
                obj.name = shieldName;
            else
                error('Cannot create HabitatShielding object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'HabitatShielding') % obj is a HabitatShielding object
                n = obj.name;
            else
                warning('Cannot call HabitatShielding name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'HabitatShielding') % obj is a HabitatShielding object
                disp(obj.name);
            else
                warning('Display method of HabitatShielding called without HabitatShielding object');
                disp('unknown');
            end
        end
    end
end

