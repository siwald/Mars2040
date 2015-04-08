function [AscentSpacecraft, HumanSpacecraft, CargoSpacecraft] = Descent(Cur_Arch, AscentSpacecraft, HumanSpacecraft, Results)
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
Landing_Cargo = nansum([Results.Consumables, Results.Spares, Results.Replacements]);

%% Constants
Max_AeroB_Mass = 40000; %kg
Cap_Syst_Mass = 4000; %est basd on DRA 5.0 Add 1 pg 99. < this is AeroCapture, not Descent

%% Descent Taxi
    %Get out the Multiple Entry And Ascent vehicle
    AscentModulesList = AscentSpacecraft.SC; %extract the SC list
    [num, ~] = size(AscentModulesList);
    for i=1:num
        if AscentModulesList(i).Description = 'Ascent and Earth Entry Module'
            MEAA = AscentModulesList(i); %copy out the entry module
            AscentModulesList(i,:) = []; %remove the module from the AscentModulesList
            AscentSpacecraft.SC = AscentModulesList; %replace the SC list without the Ascent Vehicle
        end
    end
    MEAA.Description = 'Multiple Entry and Ascent Module';
    
    %Add it to the Human Spacecraft
    HumanSpacecraft.Add_Craft = MEAA;
    
%% Cargo Descenders
    CargoSpacecraft = OverallSC; %Initialize the Cargo Spacecraft
    Num_Landers = ceil(Landing_Cargo / Max_AeroB_Mass); %determine needed number of landers based on Mars Descent size practicality

    Cargo_Lander = SC_Class('Cargo Lander');
    Cargo_Lander.Bus_Mass = Cap_Syst_Mass;
    Cargo_Lander.Payload = Landing_Cargo / Num_Landers;
        for i=1:Num_Landers %add a Cargo_Lander Module until number of landers is reached
            CargoSpacecraft.Add_Craft = Cargo_Lander;
        end
end