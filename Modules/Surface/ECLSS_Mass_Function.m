function [ECLSS,Storage,Crew_System] = ECLSS_Mass_Function(MARS_2040, Spare_Rate)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%This code is calculating the mass requirements for the consumables, spares 
%and equipment for ECLSS.   

%------Inputs------
% MARS_2040.O2_Spec = 5.0418731705; %Units: kg/day; Oxygen supplied from ISRU
% MARS_2040.CO2_Spec = 18.69;
% MARS_2040.CCAA_Spec = 34.2;
% MARS_2040.UPA_Spec = 42;
% MARS_2040.WPA_Spec = 536.74;
% MARS_2040.CRA_Spec = 18.69;
% MARS_2040.CO2_Injector_Spec = 24.09;
% MARS_2040.Crop_Area = 450;
%  MARS_2040.Habitat_Mass = 4580.00;
%  MARS_2040.Habitat_Volume = 33.33;
% MARS_2040.Crew_Size = 20;
% MARS_2040.Surface_Duration = 780;
% MARS_2040.Food_Supply = 0.5;
% MARS_2040.Packed_Food_Mass = 2.3;
% MARS_2040.Packed_Food_Volume = 0.00657;
% Spare_Rate = 10;

%------Outputs------


%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.

ECLSS.OGA.Mass = 223.13; %Units: kg ; MarsOne specified Data
ECLSS.OGA.Volume = 0.25; %Units: m^3; MarsOne specified Data
ECLSS.OGA.Spec = 5.4; %Units: kg/day; Spec data for crew usage; MarsOne specified Data
ECLSS.OGA.Power = 1.942; %Units: kW; MarsOne Data
ECLSS.OGA.Primary = 1; %Units: # of units; # of units in the primary system with BPS in MarsOne
ECLSS.OGA.Secondary = 1; %Units; # of units; # of units in the secondary system with BPS in MarsOne

ECLSS.CDRA.Mass = 156.31; %Units: kg ; MarsOne specified Data
ECLSS.CDRA.Volume = 0.42; 
ECLSS.CDRA.Spec = 6.314;
ECLSS.CDRA.Power = 0.860;
ECLSS.CDRA.Primary = 2;
ECLSS.CDRA.Secondary = 2;

ECLSS.CCAA.Mass = 100.9;
ECLSS.CCAA.Volume = 0.61;
ECLSS.CCAA.Spec = 34.8;
ECLSS.CCAA.Power = 0.469;
ECLSS.CCAA.Primary = 4;
ECLSS.CCAA.Secondary = 4;

ECLSS.UPA.Mass = 244.67;
ECLSS.UPA.Volume = 0.48;
ECLSS.UPA.Spec = 8.4;
ECLSS.UPA.Power = 0.176;
ECLSS.UPA.Primary = 1;
ECLSS.UPA.Secondary = 1;

ECLSS.WPA.Mass = 620.84;
ECLSS.WPA.Volume = 0.75;
ECLSS.WPA.Spec = 93.4;
ECLSS.WPA.Power = 0.2563;
ECLSS.WPA.Primary = 1;
ECLSS.WPA.Secondary = 1;

ECLSS.CRA.Mass = 219.49;
ECLSS.CRA.Volume = 0.74;
ECLSS.CRA.Spec = 12.11;
ECLSS.CRA.Power = 0.4008;
ECLSS.CRA.Primary = 1;
ECLSS.CRA.Secondary = 1;

ECLSS.CO2_Injector.Mass = 161.06;
ECLSS.CO2_Injector.Volume = 0.45;
ECLSS.CO2_Injector.Spec = 6.314;
ECLSS.CO2_Injector.Power = 1.149;
ECLSS.CO2_Injector.Primary = 1;
ECLSS.CO2_Injector.Secondary = 1;

ECLSS.BPS.Mass = 1960;
ECLSS.BPS.Volume = 14.26;
ECLSS.BPS.Primary = 1;
ECLSS.BPS.Secondary = 0;

ECLSS.GLS.Mass = 8.0;
ECLSS.GLS.Volume = 0.02;
ECLSS.GLS.Spec = 1.44; %Units: m^2/unit
ECLSS.GLS.Power = 0.630;
ECLSS.GLS.Primary = ceil(MARS_2040.Crop_Area/ECLSS.GLS.Spec);
ECLSS.GLS.Secondary = 0;

load('Crew_System_Values.var')
load('Storage_Values.var')
%  Crew_System_Values = xlsread('Habitat Resource Analysis_v5.xlsx',6,'D121:M152');
%  Storage_Values =  xlsread('Habitat Resource Analysis_v5.xlsx',6,'D103:M111');
%------------------------------------------------------------------------
% MARS_2040.O2_Spec
% MARS_2040.CO2_Spec
% MARS_2040.CCAA_Spec
% MARS_2040.UPA_Spec
% MARS_2040.WPA_Spec
% MARS_2040.CRA_Spec
% MARS_2040.CO2_Injector_Spec
% MARS_2040.Crop_Area
% MARS_2040.Habitat_Mass
% MARS_2040.Habitat_Volume
% MARS_2040.Crew_Size
% MARS_2040.Surface_Duration
% MARS_2040.Food_Supply
% MARS_2040.Packed_Food_Mass
% MARS_2040.Packed_Food_Volume
% Spare_Rate


%Calculations begin
ECLSS.Equipment_Mass.OGA = ECLSS.OGA.Mass *(MARS_2040.O2_Spec/ECLSS.OGA.Spec)*(ECLSS.OGA.Primary + ECLSS.OGA.Secondary);
ECLSS.Equipment_Volume.OGA = ECLSS.OGA.Volume * (MARS_2040.O2_Spec/ECLSS.OGA.Spec)*(ECLSS.OGA.Primary + ECLSS.OGA.Secondary);
ECLSS.Equipment_Power.OGA = ECLSS.OGA.Power *(MARS_2040.O2_Spec/ECLSS.OGA.Spec);
ECLSS.Spare_Mass.OGA = ECLSS.Equipment_Mass.OGA * (Spare_Rate/100);
ECLSS.Spare_Volume.OGA = ECLSS.Equipment_Volume.OGA * (Spare_Rate/100);

ECLSS.Equipment_Mass.CDRA = ECLSS.CDRA.Mass *(MARS_2040.CO2_Spec/ECLSS.CDRA.Spec)*(ECLSS.CDRA.Primary + ECLSS.CDRA.Secondary);
ECLSS.Equipment_Volume.CDRA = ECLSS.CDRA.Volume * (MARS_2040.CO2_Spec/ECLSS.CDRA.Spec)*(ECLSS.CDRA.Primary + ECLSS.CDRA.Secondary);
ECLSS.Equipment_Power.CDRA = ECLSS.CDRA.Power *(MARS_2040.CO2_Spec/ECLSS.CDRA.Spec);
ECLSS.Spare_Mass.CDRA = ECLSS.Equipment_Mass.CDRA * (Spare_Rate/100);
ECLSS.Spare_Volume.CDRA = ECLSS.Equipment_Volume.CDRA * (Spare_Rate/100);

ECLSS.Equipment_Mass.CCAA = ECLSS.CCAA.Mass *(MARS_2040.CCAA_Spec/ECLSS.CCAA.Spec)*(ECLSS.CCAA.Primary + ECLSS.CCAA.Secondary);
ECLSS.Equipment_Volume.CCAA = ECLSS.CCAA.Volume * (MARS_2040.CCAA_Spec/ECLSS.CCAA.Spec)*(ECLSS.CCAA.Primary + ECLSS.CCAA.Secondary);
ECLSS.Equipment_Power.CCAA = ECLSS.CCAA.Power *(MARS_2040.CCAA_Spec/ECLSS.CCAA.Spec);
ECLSS.Spare_Mass.CCAA = ECLSS.Equipment_Mass.CCAA * (Spare_Rate/100);
ECLSS.Spare_Volume.CCAA = ECLSS.Equipment_Volume.CCAA * (Spare_Rate/100);

ECLSS.Equipment_Mass.UPA = ECLSS.UPA.Mass *(MARS_2040.UPA_Spec/ECLSS.UPA.Spec)*(ECLSS.UPA.Primary + ECLSS.UPA.Secondary);
ECLSS.Equipment_Volume.UPA = ECLSS.UPA.Volume * (MARS_2040.UPA_Spec/ECLSS.UPA.Spec)*(ECLSS.UPA.Primary + ECLSS.UPA.Secondary);
ECLSS.Equipment_Power.UPA = ECLSS.UPA.Power *(MARS_2040.UPA_Spec/ECLSS.UPA.Spec);
ECLSS.Spare_Mass.UPA = ECLSS.Equipment_Mass.UPA * (Spare_Rate/100);
ECLSS.Spare_Volume.UPA = ECLSS.Equipment_Volume.UPA * (Spare_Rate/100);

ECLSS.Equipment_Mass.WPA = ECLSS.WPA.Mass *(MARS_2040.WPA_Spec/ECLSS.WPA.Spec)*(ECLSS.WPA.Primary + ECLSS.WPA.Secondary);
ECLSS.Equipment_Volume.WPA = ECLSS.WPA.Volume * (MARS_2040.WPA_Spec/ECLSS.WPA.Spec)*(ECLSS.WPA.Primary + ECLSS.WPA.Secondary);
ECLSS.Equipment_Power.WPA = ECLSS.WPA.Power *(MARS_2040.WPA_Spec/ECLSS.WPA.Spec);
ECLSS.Spare_Mass.WPA = ECLSS.Equipment_Mass.WPA * (Spare_Rate/100);
ECLSS.Spare_Volume.WPA = ECLSS.Equipment_Volume.WPA * (Spare_Rate/100);

ECLSS.Equipment_Mass.CRA = ECLSS.CRA.Mass *(MARS_2040.CRA_Spec/ECLSS.CRA.Spec)*(ECLSS.CRA.Primary + ECLSS.CRA.Secondary);
ECLSS.Equipment_Volume.CRA = ECLSS.CRA.Volume * (MARS_2040.CRA_Spec/ECLSS.CRA.Spec)*(ECLSS.CRA.Primary + ECLSS.CRA.Secondary);
ECLSS.Equipment_Power.CRA = ECLSS.CRA.Power *(MARS_2040.CRA_Spec/ECLSS.CRA.Spec);
ECLSS.Spare_Mass.CRA = ECLSS.Equipment_Mass.CRA * (Spare_Rate/100);
ECLSS.Spare_Volume.CRA = ECLSS.Equipment_Volume.CRA * (Spare_Rate/100);

ECLSS.Equipment_Mass.CO2_Injector = ECLSS.CO2_Injector.Mass *(MARS_2040.CO2_Injector_Spec/ECLSS.CO2_Injector.Spec)*(ECLSS.CO2_Injector.Primary + ECLSS.CO2_Injector.Secondary);
ECLSS.Equipment_Volume.CO2_Injector = ECLSS.CO2_Injector.Volume * (MARS_2040.CO2_Injector_Spec/ECLSS.CO2_Injector.Spec)*(ECLSS.CO2_Injector.Primary + ECLSS.CO2_Injector.Secondary);
ECLSS.Equipment_Power.CO2_Injector = ECLSS.CO2_Injector.Power *(MARS_2040.CO2_Injector_Spec/ECLSS.CO2_Injector.Spec);
ECLSS.Spare_Mass.CO2_Injector = ECLSS.Equipment_Mass.CO2_Injector * (Spare_Rate/100);
ECLSS.Spare_Volume.CO2_Injector = ECLSS.Equipment_Volume.CO2_Injector * (Spare_Rate/100);

ECLSS.Equipment_Mass.BPS = 9.8 * MARS_2040.Crop_Area;
ECLSS.Equipment_Volume.BPS= ECLSS.Equipment_Mass.BPS/MARS_2040.Habitat_Mass*MARS_2040.Habitat_Volume;
ECLSS.Spare_Mass.BPS = ECLSS.Equipment_Mass.BPS * (Spare_Rate/100);
ECLSS.Spare_Volume.BPS = ECLSS.Equipment_Volume.BPS * (Spare_Rate/100);

ECLSS.Equipment_Mass.GLS = ECLSS.GLS.Mass * (ECLSS.GLS.Primary + ECLSS.GLS.Secondary);
ECLSS.Equipment_Volume.GLS = ECLSS.GLS.Volume * (ECLSS.GLS.Primary + ECLSS.GLS.Secondary);
ECLSS.Equipment_Power.GLS = ECLSS.GLS.Power * (ECLSS.GLS.Primary + ECLSS.GLS.Secondary);
ECLSS.Spare_Mass.GLS = ECLSS.Equipment_Mass.GLS * (Spare_Rate/100);
ECLSS.Spare_Volume.GLS = ECLSS.Equipment_Volume.GLS * (Spare_Rate/100);

ECLSS.Equipment_Mass.Overall = ECLSS.Equipment_Mass.OGA + ECLSS.Equipment_Mass.CDRA + ECLSS.Equipment_Mass.CCAA + ECLSS.Equipment_Mass.UPA + ECLSS.Equipment_Mass.WPA + ECLSS.Equipment_Mass.CRA + ECLSS.Equipment_Mass.CO2_Injector + ECLSS.Equipment_Mass.BPS + ECLSS.Equipment_Mass.GLS;
ECLSS.Equipment_Volume.Overall = ECLSS.Equipment_Volume.OGA + ECLSS.Equipment_Volume.CDRA + ECLSS.Equipment_Volume.CCAA + ECLSS.Equipment_Volume.UPA + ECLSS.Equipment_Volume.WPA + ECLSS.Equipment_Volume.CRA + ECLSS.Equipment_Volume.CO2_Injector + ECLSS.Equipment_Volume.BPS + ECLSS.Equipment_Volume.GLS;
ECLSS.Equipment_Power.Overall = ECLSS.Equipment_Power.OGA + ECLSS.Equipment_Power.CDRA + ECLSS.Equipment_Power.CCAA + ECLSS.Equipment_Power.UPA + ECLSS.Equipment_Power.WPA + ECLSS.Equipment_Power.CRA + ECLSS.Equipment_Power.CO2_Injector + ECLSS.Equipment_Power.GLS;
ECLSS.Spare_Mass.Overall = ECLSS.Spare_Mass.OGA + ECLSS.Spare_Mass.CDRA + ECLSS.Spare_Mass.CCAA + ECLSS.Spare_Mass.UPA + ECLSS.Spare_Mass.WPA + ECLSS.Spare_Mass.CRA + ECLSS.Spare_Mass.CO2_Injector + ECLSS.Spare_Mass.BPS + ECLSS.Spare_Mass.GLS;
ECLSS.Spare_Volume.Overall = ECLSS.Spare_Volume.OGA + ECLSS.Spare_Volume.CDRA + ECLSS.Spare_Volume.CCAA + ECLSS.Spare_Volume.UPA + ECLSS.Spare_Volume.WPA + ECLSS.Spare_Volume.CRA + ECLSS.Spare_Volume.CO2_Injector + ECLSS.Spare_Volume.BPS + ECLSS.Spare_Volume.GLS;

%Crew_System_Subgroups = {'Food_System' 'Waste' 'Hygiene' 'Clothing' 'Closet' 'Housekeeping' 'Restraints' 'Photography' 'Sleep' 'Healthcare' 'Exercise_Equipment' 'EVA'};

Crew_System.Equipment_Mass.Food_System = (Crew_System_Values(1,1) + Crew_System_Values(2,1) + Crew_System_Values(3,1) + Crew_System_Values(5,1) + Crew_System_Values(6,1))*(MARS_2040.Crew_Size / 4);
Crew_System.Equipment_Volume.Food_System = (Crew_System_Values(1,2) + Crew_System_Values(2,2) + Crew_System_Values(3,2) + Crew_System_Values(5,2) + Crew_System_Values(6,2))*(MARS_2040.Crew_Size / 4);
Crew_System.Equipment_Power.Food_System = (Crew_System_Values(1,6) + Crew_System_Values(2,6) + Crew_System_Values(3,6) + Crew_System_Values(6,6))/1000*(MARS_2040.Crew_Size / 4);
Crew_System.Spare_Mass.Food_System = Crew_System.Equipment_Mass.Food_System * (Spare_Rate/100);
Crew_System.Spare_Volume.Food_System = Crew_System.Equipment_Volume.Food_System * (Spare_Rate/100);
Consumables_Mass.Food_System.Kitchen_Cleaning = 0.25*MARS_2040.Crew_Size/6*MARS_2040.Surface_Duration;
Consumables_Volume.Food_System.Kitchen_Cleaning = 0.0018*MARS_2040.Crew_Size/6*MARS_2040.Surface_Duration;
Consumables_Mass.Food_System.Cooking = (5*MARS_2040.Crew_Size);
Consumables_Volume.Food_System.Cooking = (0.0014*MARS_2040.Crew_Size);
Crew_System.Consumables_Mass.Food_System = Consumables_Mass.Food_System.Kitchen_Cleaning + Consumables_Mass.Food_System.Cooking;
Crew_System.Consumables_Volume.Food_System = Consumables_Volume.Food_System.Kitchen_Cleaning + Consumables_Volume.Food_System.Cooking;

Crew_System.Equipment_Mass.Waste = (Crew_System_Values(8,1))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Waste = (Crew_System_Values(8,2))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Waste = (Crew_System_Values(8,6))/1000 * (MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Waste = Crew_System.Equipment_Mass.Waste * (Spare_Rate/100);
Crew_System.Spare_Volume.Waste = Crew_System.Equipment_Volume.Waste * (Spare_Rate/100);
Consumables_Mass.Waste.WCS = 0.05*MARS_2040.Crew_Size*MARS_2040.Surface_Duration;
Consumables_Volume.Waste.WCS = 0.0013*MARS_2040.Crew_Size*MARS_2040.Surface_Duration;
Consumables_Mass.Waste.Collection_Mittens = 0.23*MARS_2040.Crew_Size*MARS_2040.Surface_Duration;
Consumables_Volume.Waste.Collection_Mittens = 0.0008*MARS_2040.Crew_Size*MARS_2040.Surface_Duration;
Crew_System.Consumables_Mass.Waste = Consumables_Mass.Waste.WCS + Consumables_Mass.Waste.Collection_Mittens;
Crew_System.Consumables_Volume.Waste = Consumables_Volume.Waste.WCS + Consumables_Volume.Waste.Collection_Mittens;

Crew_System.Equipment_Mass.Hygiene = (Crew_System_Values(11,1) + Crew_System_Values(12,1))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Hygiene = (Crew_System_Values(11,2) + Crew_System_Values(12,2)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Hygiene = (Crew_System_Values(11,6))/1000 * (MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Hygiene = Crew_System.Equipment_Mass.Hygiene * (Spare_Rate/100);
Crew_System.Spare_Volume.Hygiene = Crew_System.Equipment_Volume.Hygiene * (Spare_Rate/100);
Consumables_Mass.Hygiene.Personal_Kit = 1.8*(MARS_2040.Crew_Size);
Consumables_Volume.Hygiene.Personal_Kit = 0.005*MARS_2040.Crew_Size;
Consumables_Mass.Hygiene.Hygiene_Supplies = 0.075*MARS_2040.Crew_Size * MARS_2040.Surface_Duration;
Consumables_Volume.Hygiene.Hygiene_Supplies = 0.0015*MARS_2040.Crew_Size * MARS_2040.Surface_Duration;
Crew_System.Consumables_Mass.Hygiene = Consumables_Mass.Hygiene.Personal_Kit + Consumables_Mass.Hygiene.Hygiene_Supplies;
Crew_System.Consumables_Volume.Hygiene = Consumables_Volume.Hygiene.Personal_Kit + Consumables_Volume.Hygiene.Hygiene_Supplies;

Crew_System.Equipment_Mass.Clothing = (Crew_System_Values(16,1) + Crew_System_Values(17,1)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Clothing = (Crew_System_Values(16,2) + Crew_System_Values(17,2)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Clothing = (Crew_System_Values(16,6) + Crew_System_Values(17,6))/1000 * (MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Clothing = Crew_System.Equipment_Mass.Clothing * (Spare_Rate/100);
Crew_System.Spare_Volume.Clothing = Crew_System.Equipment_Volume.Clothing * (Spare_Rate/100);
Crew_System.Consumables_Mass.Clothing = 99*MARS_2040.Crew_Size;
Crew_System.Consumables_Volume.Clothing = 0.336*MARS_2040.Crew_Size;

Crew_System.Equipment_Mass.Closet = (Crew_System_Values(18,1)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Closet = (Crew_System_Values(18,2)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Closet = 0;
Crew_System.Spare_Mass.Closet = Crew_System.Equipment_Mass.Closet * (Spare_Rate/100);
Crew_System.Spare_Volume.Closet = Crew_System.Equipment_Volume.Closet * (Spare_Rate/100);
Crew_System.Consumables_Mass.Closet = 0;
Crew_System.Consumables_Volume.Closet = 0;

Crew_System.Equipment_Mass.Housekeeping = (Crew_System_Values(19,1) + Crew_System_Values(20,1)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Housekeeping = (Crew_System_Values(19,2) + Crew_System_Values(20,2)) * (MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Housekeeping = (Crew_System_Values(19,6) + Crew_System_Values(20,6))/1000 * (MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Housekeeping = Crew_System.Equipment_Mass.Housekeeping * (Spare_Rate/100);
Crew_System.Spare_Volume.Housekeeping = Crew_System.Equipment_Volume.Housekeeping * (Spare_Rate/100);
Crew_System.Consumables_Mass.Housekeeping = 0.05*MARS_2040.Crew_Size*MARS_2040.Surface_Duration;
Crew_System.Consumables_Volume.Housekeeping = 0.001*MARS_2040.Crew_Size*MARS_2040.Surface_Duration;

Crew_System.Equipment_Mass.Restraints = 0;
Crew_System.Equipment_Volume.Restraints = 0;
Crew_System.Equipment_Power.Restraints = 0;
Crew_System.Spare_Mass.Restraints = 0;
Crew_System.Spare_Volume.Restraints = 0;
Crew_System.Consumables_Mass.Restraints = (Crew_System_Values(23,1)*(MARS_2040.Crew_Size/4))+ (20*(MARS_2040.Crew_Size));
Crew_System.Consumables_Volume.Restraints = 0.54*(MARS_2040.Crew_Size/4) + (0.002*MARS_2040.Crew_Size);

Crew_System.Equipment_Mass.Photography = (Crew_System_Values(24,1))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Photography = (Crew_System_Values(24,2))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Photography = (Crew_System_Values(24,6))/1000*(MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Photography = Crew_System.Equipment_Mass.Photography * (Spare_Rate/100);
Crew_System.Spare_Volume.Photography = Crew_System.Equipment_Volume.Photography * (Spare_Rate/100);
Crew_System.Consumables_Mass.Photography = 0;
Crew_System.Consumables_Volume.Photography = 0;

Crew_System.Equipment_Mass.Sleep = (Crew_System_Values(25,1))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Sleep = (Crew_System_Values(25,2))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Sleep = 0;
Crew_System.Spare_Mass.Sleep = Crew_System.Equipment_Mass.Sleep * (Spare_Rate/100);
Crew_System.Spare_Volume.Sleep = Crew_System.Equipment_Volume.Sleep* (Spare_Rate/100);
Crew_System.Consumables_Mass.Sleep = 0;
Crew_System.Consumables_Volume.Sleep = 0;

Crew_System.Equipment_Mass.Healthcare = (Crew_System_Values(26,1))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Healthcare = (Crew_System_Values(26,2))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Healthcare = (Crew_System_Values(26,6))/1000*(MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Healthcare = Crew_System.Equipment_Mass.Healthcare * (Spare_Rate/100);
Crew_System.Spare_Volume.Healthcare = Crew_System.Equipment_Volume.Healthcare * (Spare_Rate/100);
Crew_System.Consumables_Mass.Healthcare = Crew_System_Values(27,1) * (MARS_2040.Crew_Size/4);
Crew_System.Consumables_Volume.Healthcare = Crew_System_Values(27,2) * (MARS_2040.Crew_Size/4);

Crew_System.Equipment_Mass.Exercise_Equipment = (Crew_System_Values(28,1) + Crew_System_Values(29,1) + Crew_System_Values(30,1))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Volume.Exercise_Equipment = (Crew_System_Values(28,2) + Crew_System_Values(29,2) + Crew_System_Values(30,2))*(MARS_2040.Crew_Size/4);
Crew_System.Equipment_Power.Exercise_Equipment = (Crew_System_Values(28,6) + Crew_System_Values(29,6) + Crew_System_Values(30,6))/1000*(MARS_2040.Crew_Size/4);
Crew_System.Spare_Mass.Exercise_Equipment = Crew_System.Equipment_Mass.Exercise_Equipment * (Spare_Rate/100);
Crew_System.Spare_Volume.Exercise_Equipment = Crew_System.Equipment_Volume.Exercise_Equipment * (Spare_Rate/100);
Crew_System.Consumables_Mass.Exercise_Equipment = 0;
Crew_System.Consumables_Volume.Exercise_Equipment = 0;

Crew_System.Equipment_Mass.EVA = (Crew_System_Values(31,1) + Crew_System_Values(32,1))*(MARS_2040.Crew_Size/4) * (Crew_System_Values(31,9) + Crew_System_Values(31,10));
Crew_System.Equipment_Volume.EVA = (Crew_System_Values(31,2) + Crew_System_Values(32,2))*(MARS_2040.Crew_Size/4) * (Crew_System_Values(31,9) + Crew_System_Values(31,10));
Crew_System.Equipment_Power.EVA = 0;
Crew_System.Spare_Mass.EVA = Crew_System.Equipment_Mass.EVA * (Spare_Rate/100);
Crew_System.Spare_Volume.EVA = Crew_System.Equipment_Volume.EVA * (Spare_Rate/100);
Crew_System.Consumables_Mass.EVA = 0;
Crew_System.Consumables_Volume.EVA = 0;

Crew_System.Equipment_Mass.Overall = Crew_System.Equipment_Mass.Food_System + Crew_System.Equipment_Mass.Waste + Crew_System.Equipment_Mass.Hygiene + Crew_System.Equipment_Mass.Hygiene + Crew_System.Equipment_Mass.Clothing + Crew_System.Equipment_Mass.Closet + Crew_System.Equipment_Mass.Housekeeping + Crew_System.Equipment_Mass.Restraints + Crew_System.Equipment_Mass.Photography + Crew_System.Equipment_Mass.Sleep + Crew_System.Equipment_Mass.Healthcare + Crew_System.Equipment_Mass.Exercise_Equipment + Crew_System.Equipment_Mass.EVA;
Crew_System.Equipment_Volume.Overall = Crew_System.Equipment_Volume.Food_System + Crew_System.Equipment_Volume.Waste + Crew_System.Equipment_Volume.Hygiene + Crew_System.Equipment_Volume.Hygiene + Crew_System.Equipment_Volume.Clothing + Crew_System.Equipment_Volume.Closet + Crew_System.Equipment_Volume.Housekeeping + Crew_System.Equipment_Volume.Restraints + Crew_System.Equipment_Volume.Photography + Crew_System.Equipment_Volume.Sleep + Crew_System.Equipment_Volume.Healthcare + Crew_System.Equipment_Volume.Exercise_Equipment + Crew_System.Equipment_Volume.EVA;
Crew_System.Equipment_Power.Overall = Crew_System.Equipment_Power.Food_System + Crew_System.Equipment_Power.Waste + Crew_System.Equipment_Power.Hygiene + Crew_System.Equipment_Power.Hygiene + Crew_System.Equipment_Power.Clothing + Crew_System.Equipment_Power.Closet + Crew_System.Equipment_Power.Housekeeping + Crew_System.Equipment_Power.Restraints + Crew_System.Equipment_Power.Photography + Crew_System.Equipment_Power.Sleep + Crew_System.Equipment_Power.Healthcare + Crew_System.Equipment_Power.Exercise_Equipment + Crew_System.Equipment_Power.EVA;
Crew_System.Spare_Mass.Overall = Crew_System.Spare_Mass.Food_System + Crew_System.Spare_Mass.Waste + Crew_System.Spare_Mass.Hygiene + Crew_System.Spare_Mass.Hygiene + Crew_System.Spare_Mass.Clothing + Crew_System.Spare_Mass.Closet + Crew_System.Spare_Mass.Housekeeping + Crew_System.Spare_Mass.Restraints + Crew_System.Spare_Mass.Photography + Crew_System.Spare_Mass.Sleep + Crew_System.Spare_Mass.Healthcare + Crew_System.Spare_Mass.Exercise_Equipment + Crew_System.Spare_Mass.EVA;
Crew_System.Spare_Volume.Overall = Crew_System.Spare_Volume.Food_System + Crew_System.Spare_Volume.Waste + Crew_System.Spare_Volume.Hygiene + Crew_System.Spare_Volume.Hygiene + Crew_System.Spare_Volume.Clothing + Crew_System.Spare_Volume.Closet + Crew_System.Spare_Volume.Housekeeping + Crew_System.Spare_Volume.Restraints + Crew_System.Spare_Volume.Photography + Crew_System.Spare_Volume.Sleep + Crew_System.Spare_Volume.Healthcare + Crew_System.Spare_Volume.Exercise_Equipment + Crew_System.Spare_Volume.EVA;
Crew_System.Consumables_Mass.Overall = Crew_System.Consumables_Mass.Food_System + Crew_System.Consumables_Mass.Waste + Crew_System.Consumables_Mass.Hygiene + Crew_System.Consumables_Mass.Hygiene + Crew_System.Consumables_Mass.Clothing + Crew_System.Consumables_Mass.Closet + Crew_System.Consumables_Mass.Housekeeping + Crew_System.Consumables_Mass.Restraints + Crew_System.Consumables_Mass.Photography + Crew_System.Consumables_Mass.Sleep + Crew_System.Consumables_Mass.Healthcare + Crew_System.Consumables_Mass.Exercise_Equipment + Crew_System.Consumables_Mass.EVA;
Crew_System.Consumables_Volume.Overall = Crew_System.Consumables_Volume.Food_System + Crew_System.Consumables_Volume.Waste + Crew_System.Consumables_Volume.Hygiene + Crew_System.Consumables_Volume.Hygiene + Crew_System.Consumables_Volume.Clothing + Crew_System.Consumables_Volume.Closet + Crew_System.Consumables_Volume.Housekeeping + Crew_System.Consumables_Volume.Restraints + Crew_System.Consumables_Volume.Photography + Crew_System.Consumables_Volume.Sleep + Crew_System.Consumables_Volume.Healthcare + Crew_System.Consumables_Volume.Exercise_Equipment + Crew_System.Consumables_Volume.EVA;

Storage.Equipment_Mass.O2_Tank = 0.364*600;
Storage.Equipment_Volume.O2_Tank = 0.425*(600/91);
Storage.Spare_Mass.O2_Tank = Storage.Equipment_Mass.O2_Tank * (Spare_Rate/100);
Storage.Spare_Volume.O2_Tank = Storage.Equipment_Volume.O2_Tank * (Spare_Rate/100);
Storage.Consumables_Mass.O2_Tank = 0;
Storage.Consumables_Volume.O2_Tank = 0;

Storage.Equipment_Mass.N2_Tank = 0.556*1456;
Storage.Equipment_Volume.N2_Tank = 0.425*(1456/90.1);
Storage.Spare_Mass.N2_Tank = Storage.Equipment_Mass.N2_Tank * (Spare_Rate/100);
Storage.Spare_Volume.N2_Tank = Storage.Equipment_Volume.N2_Tank * (Spare_Rate/100);
Storage.Consumables_Mass.N2_Tank = 0;
Storage.Consumables_Volume.N2_Tank = 0;

Storage.Equipment_Mass.CO2_Accumulator = Storage_Values(3,1)*10;
Storage.Equipment_Volume.CO2_Accumulator = Storage_Values(3,2)*10;
Storage.Spare_Mass.CO2_Accumulator = Storage.Equipment_Mass.CO2_Accumulator * (Spare_Rate/100);
Storage.Spare_Volume.CO2_Accumulator = Storage.Equipment_Volume.CO2_Accumulator * (Spare_Rate/100);
Storage.Consumables_Mass.CO2_Accumulator = 0;
Storage.Consumables_Volume.CO2_Accumulator = 0;

Storage.Equipment_Mass.Potable_Tank = Storage_Values(4,1)*15000/1500;
Storage.Equipment_Volume.Potable_Tank = 15/30;
Storage.Spare_Mass.Potable_Tank = Storage.Equipment_Mass.Potable_Tank * (Spare_Rate/100);
Storage.Spare_Volume.Potable_Tank = Storage.Equipment_Volume.Potable_Tank * (Spare_Rate/100);
Storage.Consumables_Mass.Potable_Tank = 0;
Storage.Consumables_Volume.Potable_Tank = 0;

Storage.Equipment_Mass.Dirty_Tank = (Storage_Values(5,1))*(MARS_2040.UPA_Spec/ECLSS.UPA.Spec);
Storage.Equipment_Volume.Dirty_Tank = Storage_Values(5,2)*MARS_2040.UPA_Spec/ECLSS.UPA.Spec;
Storage.Spare_Mass.Dirty_Tank = Storage.Equipment_Mass.Dirty_Tank * (Spare_Rate/100);
Storage.Spare_Volume.Dirty_Tank = Storage.Equipment_Volume.Dirty_Tank * (Spare_Rate/100);
Storage.Consumables_Mass.Dirty_Tank = 0;
Storage.Consumables_Volume.Dirty_Tank = 0;

Storage.Equipment_Mass.Gray_Tank = Storage_Values(6,1)*MARS_2040.WPA_Spec/ECLSS.WPA.Spec;
Storage.Equipment_Volume.Gray_Tank = Storage_Values(6,2)*MARS_2040.WPA_Spec/ECLSS.WPA.Spec;
Storage.Spare_Mass.Gray_Tank = Storage.Equipment_Mass.Gray_Tank * (Spare_Rate/100);
Storage.Spare_Volume.Gray_Tank = Storage.Equipment_Volume.Gray_Tank * (Spare_Rate/100);
Storage.Consumables_Mass.Gray_Tank = 0;
Storage.Consumables_Volume.Gray_Tank = 0;

Storage.Equipment_Mass.Crop_Tank = 0.0668*11000*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Storage.Equipment_Volume.Crop_Tank = 11*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply/30;
Storage.Spare_Mass.Crop_Tank = Storage.Equipment_Mass.Crop_Tank * (Spare_Rate/100);
Storage.Spare_Volume.Crop_Tank = Storage.Equipment_Volume.Crop_Tank * (Spare_Rate/100);
Storage.Consumables_Mass.Crop_Tank = 0;
Storage.Consumables_Volume.Crop_Tank = 0;

Storage.Equipment_Mass.Food_Storage = 0;
Storage.Equipment_Volume.Food_Storage = 0;
Storage.Spare_Mass.Food_Storage = 0;
Storage.Spare_Volume.Food_Storage = 0;
Storage.Consumables_Mass.Food_Storage = MARS_2040.Packed_Food_Mass * MARS_2040.Crew_Size * MARS_2040.Surface_Duration * (1-MARS_2040.Food_Supply);
Storage.Consumables_Volume.Food_Storage = MARS_2040.Packed_Food_Volume * MARS_2040.Crew_Size * MARS_2040.Surface_Duration * (1-MARS_2040.Food_Supply);
Storage.Equipment_Mass.Overall = Storage.Equipment_Mass.O2_Tank + Storage.Equipment_Mass.N2_Tank + Storage.Equipment_Mass.CO2_Accumulator + Storage.Equipment_Mass.Potable_Tank + Storage.Equipment_Mass.Dirty_Tank + Storage.Equipment_Mass.Gray_Tank + Storage.Equipment_Mass.Crop_Tank + Storage.Equipment_Mass.Food_Storage;
Storage.Equipment_Volume.Overall = Storage.Equipment_Volume.O2_Tank + Storage.Equipment_Volume.N2_Tank + Storage.Equipment_Volume.CO2_Accumulator + Storage.Equipment_Volume.Potable_Tank + Storage.Equipment_Volume.Dirty_Tank + Storage.Equipment_Volume.Gray_Tank + Storage.Equipment_Volume.Crop_Tank + Storage.Equipment_Volume.Food_Storage;
Storage.Spare_Mass.Overall = Storage.Spare_Mass.O2_Tank + Storage.Spare_Mass.N2_Tank + Storage.Spare_Mass.CO2_Accumulator + Storage.Spare_Mass.Potable_Tank + Storage.Spare_Mass.Dirty_Tank + Storage.Spare_Mass.Gray_Tank + Storage.Spare_Mass.Crop_Tank + Storage.Spare_Mass.Food_Storage;
Storage.Spare_Volume.Overall = Storage.Spare_Volume.O2_Tank + Storage.Spare_Volume.N2_Tank + Storage.Spare_Volume.CO2_Accumulator + Storage.Spare_Volume.Potable_Tank + Storage.Spare_Volume.Dirty_Tank + Storage.Spare_Volume.Gray_Tank + Storage.Spare_Volume.Crop_Tank + Storage.Spare_Volume.Food_Storage;
Storage.Consumables_Mass.Overall = Storage.Consumables_Mass.O2_Tank + Storage.Consumables_Mass.N2_Tank + Storage.Consumables_Mass.CO2_Accumulator + Storage.Consumables_Mass.Potable_Tank + Storage.Consumables_Mass.Dirty_Tank + Storage.Consumables_Mass.Gray_Tank + Storage.Consumables_Mass.Crop_Tank + Storage.Consumables_Mass.Food_Storage;
Storage.Consumables_Volume.Overall = Storage.Consumables_Volume.O2_Tank + Storage.Consumables_Volume.N2_Tank + Storage.Consumables_Volume.CO2_Accumulator + Storage.Consumables_Volume.Potable_Tank + Storage.Consumables_Volume.Dirty_Tank + Storage.Consumables_Volume.Gray_Tank + Storage.Consumables_Volume.Crop_Tank + Storage.Consumables_Volume.Food_Storage;

end

