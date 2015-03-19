function [ Ascent_Vehicle ] = Ascent( Cur_Arch, Taxi_V )
%ASCENT Design the Ascent_Vehicle
%   Take the Taxi Vehicle and get it from the surface to LMO, to allow the
%   Taxi Vehicle to dock with the Transit Hab, or depart to dock with the
%   Cycler.
%
%   The Taxi vehicle should contain the Habitat Mass for the Astronauts
%   until they get to the tranist hab.  As a payload it should contain the
%   science sample return (if any) and the return propellant being supplied
%   from Mars ISRU

dV = 4.41; % total km/s, Mars Surface to LMO (500 km). est. from HSMAD Fig. 10-27.  Section 10.4.2 for detailed calculations.

Ascent_Vehicle = SC_Class(Taxi_V.Payload_Mass,0,'Ascent Vehicle to get Taxi to LMO');
Ascent_Vehicle = Propellant_Mass(Cur_Arch.PropulsionType,Ascent_Vehicle,dV);

end

