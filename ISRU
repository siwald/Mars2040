function [ISRU_Power, ISRU_Volume] = ISRU(ECLSS_Requirements)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%ISRU is solving for the in-situ resource utilization equipment. This will
%output the mass, volume, and power requirements for the equipment required
%to provide the expected resources required by other modules. 

%------Inputs------

% ISRU requirements from ECLSS module
    ECLSS_Requirements.Oxygen = 10.81;
    ECLSS_Requirements.Water = 57.94;
    ECLSS_Requirements.Nitrogen = 1.70;
    ECLSS_Requirements.CO2 = 19.94;  

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

Moxie_Volume = 0.0165675; %Units: m^3
Moxie_Power = 30; %Units: kW
%Moxie_Mass = ??; %Units: kg
Moxie_Oxygen_Rate = 22; %Units: g/hr

%------------------------------------------------------------------------

%Calculations begin
Oxygen_Daily_Generation = (Moxie_Oxygen_Rate/1000)*24; %Units: kg/day
Required_Oxygen = ECLSS_Requirements.Oxygen + ECLSS_Requirements.Water; %Units: kg/day
Oxygen_Moxie_Required = Required_Oxygen/Oxygen_Daily_Generation; %Units: whole number of Moxie units required

if Oxygen_Moxie_Required - round(Oxygen_Moxie_Required) < 0
    Oxygen_Moxie_Required = round(Oxygen_Moxie_Required);
else
    Oxygen_Moxie_Required = round(Oxygen_Moxie_Required) + 1;
end

ISRU_Power = (Oxygen_Moxie_Required * Moxie_Power);
ISRU_Volume = (Oxygen_Moxie_Required * Moxie_Volume);

end

