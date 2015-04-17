function [ Results ] = ISRU(Cur_Arch, ECLSS_Requirements, Results)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%ISRU is solving for the in-situ resource utilization equipment. This will
%output the mass, volume, and power requirements for the equipment required
%to provide the expected resources required by other modules. 

%------Inputs------

% ISRU requirements from ECLSS module
    %ECLSS_Requirements.Oxygen = 10.81;
    %ECLSS_Requirements.Water = 57.94;
    %ECLSS_Requirements.Nitrogen = 1.70;
    %ECLSS_Requirements.CO2 = 19.94; 
    
    %Ox_From_Mars = 500; %Units: kg/mission

%------Outputs------

%SWAP requirements. Power is average power in kW. Mass is kg/mission.
%Volume is the consumables in m3/mission
%ISRU_Power;
%ISRU_Mass;
%ISRU_Volume;

%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen. Assumption at this point is to
%use Moxie units for all resource generation. Moxie production rate for 
%Oxygen is 22g/hr

Moxie_Volume = 0.0165675; %Units: m^3; Mars Moxie Units
Moxie_Power = 30; %Units: kW; Mars Moxie Units
Moxie_Mass = 50; %Units: kg; TEMPORARY NUMBER
Moxie_Oxygen_Rate = 22; %Units: g/hr; Mars Moxie Units
Time_Between_Missions = 26; %Units: months

%------------------------------------------------------------------------

%Calculations for Moxie Oxygen
Oxygen_Daily_Generation = (Moxie_Oxygen_Rate/1000)*24; %Units: kg/day
if nansum([Results.Mars_ISRU.Oxidizer_Output]) > 1
    Required_Daily_Ox_Mars = Results.Mars_ISRU.Oxidizer_Output / (Time_Between_Missions * 30);
elseif nansum([Results.Mars_ISRU.Oxidizer_Output]) == 0
    Required_Daily_Ox_Mars = 0;
end
Required_Oxygen = ECLSS_Requirements.Oxygen + Required_Daily_Ox_Mars; %Units: kg/day
Oxygen_Moxie_Required = Required_Oxygen/Oxygen_Daily_Generation; %Units: whole number of Moxie units required

if Oxygen_Moxie_Required - round(Oxygen_Moxie_Required) < 0
    Oxygen_Moxie_Required = round(Oxygen_Moxie_Required);
else
    Oxygen_Moxie_Required = round(Oxygen_Moxie_Required) + 1;
end

ISRU_Power = (Oxygen_Moxie_Required * Moxie_Power);
ISRU_Volume = (Oxygen_Moxie_Required * Moxie_Volume);
ISRU_Mass = (Oxygen_Moxie_Required * Moxie_Mass);

%% BS scaling for other ISRU needs
%use this if only until ISRU can be based from ECLSS needs too.
if Results.Mars_ISRU.Oxidizer_Output == 0
    ISRU_Power = 0;
    ISRU_Volume = 0;
    ISRU_Mass = 0;
else
ISRU_Power = ISRU_Power / Results.Mars_ISRU.Oxidizer_Output * ...
    nansum([Results.Mars_ISRU.Oxidizer_Output, Results.Mars_ISRU.Fuel_Output, ....
    ECLSS_Requirements.Water, ECLSS_Requirements.Oxygen, ...
    ECLSS_Requirements.Nitrogen, ECLSS_Requirements.CO2]);

ISRU_Volume = ISRU_Volume / Results.Mars_ISRU.Oxidizer_Output * ...
    nansum([Results.Mars_ISRU.Oxidizer_Output, Results.Mars_ISRU.Fuel_Output, ....
    ECLSS_Requirements.Water, ECLSS_Requirements.Oxygen, ...
    ECLSS_Requirements.Nitrogen, ECLSS_Requirements.CO2]);

ISRU_Mass = ISRU_Mass / Results.Mars_ISRU.Oxidizer_Output * ...
    nansum([Results.Mars_ISRU.Oxidizer_Output, Results.Mars_ISRU.Fuel_Output, ....
    ECLSS_Requirements.Water, ECLSS_Requirements.Oxygen, ...
    ECLSS_Requirements.Nitrogen, ECLSS_Requirements.CO2]);
end
%% add to results object
Results.Mars_ISRU.Mass = ISRU_Mass;
Results.Mars_ISRU.Volume = ISRU_Volume;
Results.Mars_ISRU.Power = ISRU_Power;
end

