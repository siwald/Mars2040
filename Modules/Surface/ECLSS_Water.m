function [Crew_Water] = ECLSS_Water(Crew_Size)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%ECLSS is solving for the life supporting systems. 

%------Inputs------

% Percentage of food supply grown on Mars 

%Crew Activities on Mars. EVA_Freq is the amount of EVA trips expected per 
%week. CM_EVA is the number of crew members per EVA. EVA_Dur is the 
%duration of each EVA per crew member.

%Total Cabin Volume for the habitat on Mars. Used for calculating the air
%requied inside the habitat.  

%------Outputs------

%Required resources from ISRU. All requirements sent in kg/day

%SWAP requirements. Power is average power in kW. Mass is kg/mission.
%Volume is the consumables in m3/mission

%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.

%Habitat_Water.Drink_Water = 2;
Habitat_Water.Drink_Water = 2.5; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Vapor = 2.277;
Habitat_Water.Vapor = 1.9; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Fecal_Water = 0.091;
Habitat_Water.Fecal_Water = 0.1; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Urine_Water = 1.5;
Habitat_Water.Urine_Water = 1.6; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Urinal_Flush = 0.5;
Habitat_Water.Urinal_Flush = 0.5; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Oral_Hygiene = 0.37;
Habitat_Water.Oral_Hygiene = 0.37; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Hand_Wash = 4.08;
Habitat_Water.Hand_Wash = 4.08; %Units: kg/CM/day; BVAD 2015 pg. 50
% Habitat_Water.Shower = 2.72;
Habitat_Water.Shower = 2.72; %Units: kg/CM/day; BVAD 2015 pg. 50
Habitat_Water.Laundry_In = 12.47;
Habitat_Water.Laundry_Out = 11.87;

%------------------------------------------------------------------------

%Calculations begin

%Calculations to determine the amount of Water that is required from ISRU. 
Crew_Water.Drink_Water = Habitat_Water.Drink_Water*Crew_Size;
Crew_Water.Vapor_Water = Habitat_Water.Vapor*Crew_Size;
Crew_Water.Urine_Flush = Habitat_Water.Urinal_Flush*Crew_Size;
Crew_Water.Urine_Water_Flush = (Habitat_Water.Urinal_Flush+Habitat_Water.Urine_Water)*Crew_Size;
Crew_Water.Hygiene = (Habitat_Water.Oral_Hygiene+Habitat_Water.Hand_Wash)*Crew_Size;
%Crew_Water.Hygiend_Dirty = (Habitat_Water.Oral_Hygiene+Habitat_Water.Hand_Wash)*Crew_Size;
Crew_Water.Shower = Habitat_Water.Shower*Crew_Size;
Crew_Water.Laundry_In = Habitat_Water.Laundry_In * Crew_Size;
Crew_Water.Laundry_Out = Habitat_Water.Laundry_Out * Crew_Size;

end

