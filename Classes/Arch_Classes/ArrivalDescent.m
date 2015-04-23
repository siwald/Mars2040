%% Arrival descent is simply a subclass of ArrivalDescent, but indicates descent at arrival.
classdef ArrivalDescent < handle
    %% Class enumerations (as constant properties)
    properties (Constant)
        PROPULSIVE = ArrivalDescent('Propulsive');
        CHUTE = ArrivalDescent('Chute');
        SHOCK_ABSORBTION = ArrivalDescent('Shock');
        AEROENTRY = ArrivalDescent('Aero Entry');
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
        function obj = ArrivalDescent(typeName)
            % validate we have a correct parameters
            if nargin > 0 ... % received input arguments
                    && ischar(typeName) && ~isempty(typeName) % have a name
                obj.name = typeName;
            else
                error('Cannot create ArrivalDescent object because parameters were invalid.');
            end
        end
    end
    
    %% public class methods
    methods
        %% Name getter
        function n = get.Name(obj)
            % validate we have a initalized descent type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ArrivalDescent') % obj is a ArrivalDescent object
                n = obj.name;
            else
                warning('Cannot call ArrivalDescent name getter without valid object');
            end
        end
        
        %% class display method
        function disp(obj)
            % validate we have a initalized entry type object
            if nargin > 0 ... % received input arguments
                    && isa(obj, 'ArrivalDescent') % obj is a ArrivalDescent object
                disp(obj.name);
            else
                warning('Display method of ArrivalDescent called without ArrivalDescent object');
                disp('unknown');
            end
        end
    end
end