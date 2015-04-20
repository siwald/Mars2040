function [AscentSpacecraft, HumanSpacecraft, CargoSpacecraft, Num_Landers] = Descent(Cur_Arch, AscentSpacecraft, HumanSpacecraft, Results, Site_Elevation)
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
Landing_Cargo = nansum([Results.Consumables, Results.Spares, Results.Replacements, AscentSpacecraft.Mass]);

%% Constants
Max_AeroB_Mass = 40000; %kg
%Descent_Syst_Mass = 4000; %est basd on DRA 5.0 Add 1 pg 99. < this is AeroCapture, not Descent

%% Descent Taxi
    %Get out the Multiple Entry And Ascent vehicle
    MEAA = AscentSpacecraft.Get_Craft('Ascent and Earth Entry Module');
    MEAA.Description = 'Multiple Entry and Ascent Module';
    MEAA_Aeroshell = MEAA.Origin_Mass * (0.10 +(0.01*Site_Elevation)); % 10% mass in Descent System, + 1% for each km altitude
    MEAA.Bus_Mass = MEAA.Bus_Mass + MEAA_Aeroshell;
    %Add it to the Human Spacecraft
    HumanSpacecraft.Add_Craft = MEAA;
    
%% Cargo Descenders
    Cargo_Manifest = [Results.Consumables, Results.Spares, Results.Replacements, AscentSpacecraft.Mass];
    Landing_Cargo = nansum([Results.Consumables, Results.Spares, Results.Replacements, AscentSpacecraft.Mass]);
    CargoSpacecraft = OverallSC; %Initialize the Cargo Spacecraft
    Num_Landers = ceil(Landing_Cargo / Max_AeroB_Mass); %determine needed number of landers based on Mars Descent size practicality

    Cargo_Lander = SC_Class('Cargo Lander');
    Cargo_Lander.Payload_Mass = Landing_Cargo / Num_Landers;
    Descent_Syst_Mass = Cargo_Lander.Payload_Mass * (0.10 + (0.01*Site_Elevation)); % 10% mass in Descent System, + 1% for each km altitude
    Cargo_Lander.Bus_Mass = Descent_Syst_Mass;
        for i=1:Num_Landers %add a Cargo_Lander Module until number of landers is reached
            CargoSpacecraft.Add_Craft = Cargo_Lander;
        end
        
end