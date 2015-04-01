%% Propulsion class defining characteristics of a specific propulsion type
classdef Propulsion
    %% constants for handling propulsion types
    properties (Constant, Access = private)
        %% the propulsion type table
        % Lists all the properties of each type of propulsion. Each
        % propulsion type is a row, with the first column being the type,
        % and each column represents different properties.
        % Current columns (3/17/15): PropulsionType,Isp,FuelOxidizerRatio,InertMassRatio,StaticMass
        propulsionProps = readtable('propulsionTypes.dat','ReadRowNames',true); % read table from data file
        %% Column name for the specific impulse propulsion data
        ispColName = 'Isp';
        %% Column name for the fuel-oxidizer ratio propulsion data
        fuelOxidizerColName = 'FuelOxidizerRatio';
        %% Column name for the inert mass ratio propulsion data
        inertMassColName = 'InertMassRatio';
        %% Column name for the static mass propulsion data
        staticMassColName = 'StaticMass';
    end
    
    %% private properties
    properties (GetAccess = private, SetAccess = immutable)
        %% the shorthand name of the propulsion type
        % this should be a 3 character representation of the type, such as
        % 'LH2' for liquid hydrogen chemical rockets or 'NUC' for NTR
        type;
    end
    
    %% characteristic properties of propulsion type
    properties (Dependent)
        %% specific impulse of the propulsion type (or typical average)
        Isp
        %% fuel to oxidizer ration, that characterizes the amount of oxider required per part of fuel
        % dimensionless since this is a part ratio
        FuelOxRatio
        %% ratio describing the amount of mass required for engine and fuel storage as compared to propellant mass
        InertMassRatio
        %% any fixed amount of mass required for engines, fuel, fuel storage, or anything else specific to propulsion
        StaticMass
    end
    
    methods
        %% Propulsion constructor
        function obj = Propulsion(typeName)
            % verify we have correct type input
            if nargin > 0 && ischar(typeName)
                % lookup type for provided propulsion, set type to 3
                % character value
                switch upper(typeName)
                    case 'LH2'
                        obj.type = 'LH2';
                    case 'NTR'
                        obj.type = 'NTR';
                    case 'SEP'
                        obj.type = 'SEP';
                end
            end
        end
        
        %%% Propulsion class display method overload
        %function disp(obj)
        %    % verify we have correct inputs to get Isp
        %    if nargin > 0 && isa(obj,'Propulsion')
        %        disp(['Propulsion.' obj.type]);
        %    else 
        %        warning('Unable to display object because it was not a Propulsion object.');
        %        disp('unknown');
        %    end
        %end
        
        %% Isp getter
        function isp = get.Isp(obj)
            % verify we have correct inputs to get Isp
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
                % lookup isp using the type and column names from
                % propulsion properties table
                isp = Propulsion.propulsionProps{obj.type,Propulsion.ispColName};
            end
        end
        %% Fuel-Oxidizer ratio getter
        function fuelOxRatio = get.FuelOxRatio(obj)
            % verify we have correct inputs to get fuel-oxidizer ratio
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
                % lookup fuel-oxidizer ratio using the type and column
                % names from propulsion properties table
                fuelOxRatio = Propulsion.propulsionProps{obj.type,Propulsion.fuelOxidizerColName};
            end
        end
        %% Inert Mass ratio getter
        function inertMass = get.InertMassRatio(obj)
            % verify we have correct inputs to get inert mass ratio
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
                % lookup inert mass ratio using the type and column names
                % from propulsion properties table
                inertMass = Propulsion.propulsionProps{obj.type,Propulsion.inertMassColName};
            end
        end
        %% Static Mass getter
        function mass = get.StaticMass(obj)
            % verify we have correct inputs to get static mass
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
                % lookup static mass using the type and column names from
                % propulsion properties table
                mass = Propulsion.propulsionProps{obj.type,Propulsion.staticMassColName};
            end
        end
    end
    
    %% enumerated values for common propulsion types
    enumeration
        % liquid hyrdogen/oxygen
        LH2 ('LH2'),
        % nuclear thermal rocket
        NTR ('NTR'),
        % solar-electric propulsion
        SEP ('SEP'),
    end
end

