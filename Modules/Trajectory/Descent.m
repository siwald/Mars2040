function [AscentSpacecraft, HumanSpacecraft, CargoSpacecraft, Num_Landers] = Descent(Cur_Arch, AscentSpacecraft, HumanSpacecraft, Results, Site_Elevation, varargin)
%ASCENT Design the Ascent_Vehicle
% 
%     
%   Take the Taxi Vehicle and get it from the LMO to the Surface, to allow the
%   Taxi Vehicle to dock with the Transit Hab, or depart to dock with the
%   Cycler.
%
%   The Taxi vehicle should contain the Habitat Mass for the Astronauts
%   until they get to the tranist hab.  As a payload it should contain the
%   science sample return (if any) and the return propellant being supplied
%   from Mars ISRU
%    
%% Inputs
%% Constants
Max_AeroB_Mass = 40400; %kg

%% Descent Taxi
    %Get out the Multiple Entry And Ascent vehicle
    MEAA = AscentSpacecraft.Get_Craft('Ascent and Earth Entry Module');
    MEAA.Description = 'Multiple Entry and Ascent Module';
%     
%     %test only
%     MEAA = SC_Class('test MEAA');
%     MEAA.Payload_Mass = 40400;
%     %end test
    
%    if Cur_Arch.EDL == ArrivalDescent.AEROENTRY
%        MEAA_Aeroshell = MEAA.Origin_Mass * (0.10 +(0.01*Site_Elevation)); % 10% mass in Descent System, + 1% for each km altitude
        %These are scaled, the Engines scale to payload
         MEAA.Dry_Mass = 28700 / (40.4 / MEAA.Origin_Mass); %see cargo lander below, NASA DRA5 T4-3, Dry Descent Stage for max 40.4mt payload
        %These are scaled, the Aeroshell scales to volume, mass scales to
        %volume within some degree of variablity.
         MEAA.Static_Mass = 40700 / (40.4 / MEAA.Origin_Mass); %see cargo lander below, NASA DRA5 T4-3, Entry Mass for max 40.4mt payload
%     else
%         warning('alternative descents not yet programmed')
%     end
    %Add it to the Human Spacecraft
    HumanSpacecraft.Add_Craft = MEAA;
    HumanSpacecraft.MALMO = HumanSpacecraft.Mass;
    
%% Cargo Descenders
    Cargo_Manifest = [Results.Consumables, Results.Spares, Results.Replacements, AscentSpacecraft.Mass];
    if ~isempty(varargin)
        %Cargo_Manifest = [Cargo_Manifest [AscentSpacecraft.Mass, Results.ECLSS.Mass, Results.PowerPlant.Mass, Results.Mars_ISRU.Mass]];
        Cargo_Manifest = [36000, 36000];
        %Cargo_Manifest = [11007];
    end
    Landing_Cargo = nansum(Cargo_Manifest);
    CargoSpacecraft = OverallSC; %Initialize the Cargo Spacecraft
    Num_Landers = ceil(Landing_Cargo / Max_AeroB_Mass); %determine needed number of landers based on Mars Descent size practicality

    Cargo_Lander = SC_Class('Cargo Lander');
    Cargo_Lander.Payload_Mass = Landing_Cargo / Num_Landers;
%     if Cur_Arch.EDL == ArrivalDescent.AEROENTRY 
        %Descent_Dry_Mass = Cargo_Lander.Payload_Mass * (0.10 + (0.01*Site_Elevation)) % 10% mass in Descent System, + 1% for each km altitude
        Cargo_Lander.Dry_Mass = 28700 / (40.4 / Cargo_Lander.Payload_Mass); %kg, DRA 5.0 T4-3 EDL summary
        Cargo_Lander.Static_Mass = 40700  / (40.4 / Cargo_Lander.Payload_Mass); %kg, DRA 5.0 T4-3 EDL summary
%     else
%         warning('alternative entry types not yet programmed')
%     end
%{
Comment for loop out.  We'll have one Cargo Spacecraft pulled back, then
multiply by Results.Num_CargoSpacecraft, since they're all alike.
%}
        %for i=1:Num_Landers %add a Cargo_Lander Module until number of landers is reached
            CargoSpacecraft.Add_Craft = Cargo_Lander;
            CargoSpacecraft.MALMO = CargoSpacecraft.Mass;
        %end
        %}
end