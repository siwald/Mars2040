%% Class representing landing manuevers
classdef DescentType < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        PROPULSIVE = DescentType('Propulsive');
        CHUTE = DescentType('Chute');
        SHOCK_ABSORBTION = DescentType('Shock');
        AEROENTRY = DescentType('Aero Entry');
    end
    
    %% private class members
    properties (Access = private)
        name;
    end
    
    %% public dependent members
    properties (Dependent)
        Name;
        CrewAllowable
    end
    
    %% private methods (incl. constrcutor)
    methods(Access = private)
        %% class constructor
        function obj = DescentType(typeName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(typeName) && ~isempty(typeName) % have a name
                obj.name = typeName;
            else
                error('Cannot create DescentType object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized descent type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'DescentType') % obj is a DescentType object
                n = obj.name;
            else
                warning('Cannot call DescentType name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'DescentType') % obj is a DescentType object
                disp(obj.name);
            else
                warning('Display method of DescentType called without DescentType object');
                disp('unknown');
            end
        end
    end
end

