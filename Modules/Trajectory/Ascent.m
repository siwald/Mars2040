function [ Ascent_Vehicle, HumanSpacecraft, Results ] = Ascent( Cur_Arch, HumanSpacecraft, Results, varargin)
%ASCENT Design the Ascent_Vehicle
% 
%     [AscentSpacecraft, HumanSpacecraft, Results] = Ascent (Cur_Arch, HumanSpacecraft, Results);
%
%   Take the Taxi Vehicle and get it from the surface to LMO, to allow the
%   Taxi Vehicle to dock with the Transit Hab, or depart to dock with the
%   Cycler.
%
%   The Taxi vehicle should contain the Habitat Mass for the Astronauts
%   until they get to the tranist hab.  As a payload it should contain the
%   science sample return (if any) and the return propellant being supplied
%   from Mars ISRU
%   
%     Inputs:
%         Cur_Arch
%             Propulsion Type
%         HumanSpacecraft
%             EarthEntry Module
%         Results
%             Mars Fuel ISRU
%             Mars Oxidizer ISRU
%     
%     Outputs:
%         AscentSpacecraft
%         HumanSpacecraft without reuseable Ascent/Descent Craft
%         Results with updated ISRU fuel
%    

dV = 4.41; % total km/s, Mars Surface to LMO (500 km). est. from HSMAD Fig. 10-27.  Section 10.4.2 for detailed calculations.

%% Ascent Taxi Definition
Ascent_Vehicle = OverallSC; %initialize the Ascent Vehicle

Ascent_Hab = HumanSpacecraft.Get_Craft('Earth Entry Module');

%% Add Ascent Hab to the Ascent Vehicle
Ascent_Hab.Description = 'Ascent and Earth Entry Module';
Ascent_Vehicle.Add_Craft = Ascent_Hab;

%% Add the ISRU fuel payload to the Ascent Vehicle
Fuel_Payload = SC_Class('ISRU generated Fuel for Earth Return');
Fuel_Payload.Fuel_Mass = Results.Mars_ISRU.Fuel_Output;
Fuel_Payload.Ox_Mass = Results.Mars_ISRU.Oxidizer_Output;
Fuel_Payload.Bus_Mass = 0; %tank weight, add later?
origin_calc(Fuel_Payload);
Ascent_Vehicle.Add_Craft = Fuel_Payload;

%% Ascent Vehicle  propulsion
Ascent_Rocket = SC_Class('Ascent Propulsion Module');
Ascent_Rocket = Propellant_Mass(Cur_Arch.PropulsionType, Ascent_Rocket, dV, Ascent_Vehicle.Mass);
Ascent_Vehicle.Add_Craft = Ascent_Rocket;

%% Fuel Depot Section
if isempty(Results.Mars_ISRU.Oxidizer_Output)
    Results.Mars_ISRU.Oxidizer_Output = 0; %initialize this if empty
end
if isempty(Results.Mars_ISRU.Fuel_Output)
    Results.Mars_ISRU.Fuel_Output = 0; %initialize this if empty
end
    
%Move Ox to Mars ISRU if appropriate
if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_O2, ...
        Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_O2)
    Results.Mars_ISRU.Oxidizer_Output = Results.Mars_ISRU.Oxidizer_Output + Ascent_Vehicle.Ox_Mass; %add O2 to Mars generation
    remove_ox(Ascent_Vehicle); %remove all O2 from Spacecraft Modules
end
%Move Fuel to Mars ISRU if appropriate
if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_LH2, ...
        Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_LH2)
    if ~(Cur_Arch.PropulsionType == Propulsion.CH4); %skip if Methane, can't gen on Mars ISRU
        Results.Mars_ISRU.Fuel_Output = Results.Mars_ISRU.Fuel_Output + Ascent_Vehicle.Fuel_Mass; %add LH2 to Mars generation
        remove_fuel(Ascent_Vehicle); %remove all LH2 from Spacecraft Modules
    end
end

if ~isempty(varargin) %Move ascent O2 prod to Mars, for DRA comparison Only
    Results.Mars_ISRU.Oxidizer_Output = nansum([Results.Mars_ISRU.Oxidizer_Output, Ascent_Vehicle.Ox_Mass]); %add O2 to Mars generation
    remove_ox(Ascent_Vehicle); %remove all O2 from Spacecraft Modules
    disp('good')
end
end

