classdef Trajectory
    %TRAJECTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=private)
        %% Type of trajectory
        % Quick single character abbreviation for quick reference. Values
        % can include
        % H = hohmann
        % E = elliptical
        % S = SLS Launch Vehicle
        % 
        type = 'H';
        origin = Location.LEO;
        destination = Location.LMO;
        propulsionType = PropulsionType.LH2;
        payload = 40000;
    end
    
    
    properties (Dependent)
        Type
        Propulsion
        Duration
        Origin
        Destination
        Payload
    end
    
    %% classes private methods
    methods (Access=private)
        %% class constructor, private so
    end
    
    methods
        function obj = New(origin, destination, propulsion)
    end
    
    enumeration
        SLS
        HOHMANN
    end
end

