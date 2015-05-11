function [ Results ] = ISRU(Cur_Arch, ECLSS_Requirements, Water_Percent, Results)

%% Propellant Section
%Soil Based ISRU for Fuel Needs.

%1Mol O2 = 31.9988g = .0319988 kg
%1Mol H2 = 2.02g = .00202 kg
%1Mol H2O = 18.01528g = .01801528 kg
% 2H2O -> 2H2 + O2

%H2O Need from Ox Needs
if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_O2, ... skip if no Mars_ISRU ox.
        Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_O2) 
	Moles_O2 = Results.Mars_ISRU.Oxidizer_Output / .0319988;
	Needed_Moles_H2O_Ox = Moles_O2 * 2;
	Needed_H2O_From_Oxidizer = Needed_Moles_H2O_Ox * 0.01801528;
    Needed_H2O_From_Oxidizer = Needed_H2O_From_Oxidizer/780;
else
	Needed_H2O_From_Oxidizer = 0;
end
%H2O Need from Fuel needs
if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_LH2, ... skip if no Mars_ISRU fuel.
        Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_LH2) 
	Moles_H2 = Results.Mars_ISRU.Fuel_Output / .00202;
	Needed_H2O_From_Fuel = Moles_H2 * 0.01801528;
    Needed_H2O_From_Fuel = Needed_H2O_From_Fuel/780;
else
	Needed_H2O_From_Fuel = 0;
end

%% ECLSS Section

%Find the oxygen needed, as above
Moles_O2 = ECLSS_Requirements.Oxygen / .0319988;
Needed_Moles_H2O_for_ECLSS_O2 = Moles_O2 * 2;
Needed_H2O_for_ECLSS_O2 = Needed_Moles_H2O_for_ECLSS_O2 * 0.01801528;


%Use the H2O needs that's the biggest, since if you need more H2O for O2,
%then you'll automatically have the amount you need for LH2 as well.
Needed_H2O = max((Needed_H2O_From_Oxidizer + Needed_H2O_for_ECLSS_O2), Needed_H2O_From_Fuel);

Full_H2O = Needed_H2O + ECLSS_Requirements.Water; %add the molecular water needed.



%% H2O Plant Selection

S_Plant_Mass = Water_Percent*(-6.6) + (168.8);
S_Plant_Vol = 0;
S_Plant_Power = Water_Percent*(-0.004)+(1.422);
S_Plant_Output = 7.15;
S_Plant_Qty = 0; %initialize

M_Plant_Mass = Water_Percent*(-9.8) + 210.4;
M_Plant_Vol = 0;
M_Plant_Power = Water_Percent*(-0.006)+(1.488);
M_Plant_Output = 11.95;%kg / day
M_Plant_Qty = 0; %initialize

L_Plant_Mass = Water_Percent*(-33) + 512; 
L_Plant_Vol = 0;
L_Plant_Power = Water_Percent*(-0.028)+(2.104);
L_Plant_Output = 55.96;
L_Plant_Qty = 0; %initialize

Remaining_Daily_H2O = Full_H2O;
if Remaining_Daily_H2O > L_Plant_Output
    L_Plant_Qty = floor(Remaining_Daily_H2O/L_Plant_Output);
    Remaining_Daily_H2O = Remaining_Daily_H2O - (L_Plant_Qty * L_Plant_Output);
end
if Remaining_Daily_H2O > M_Plant_Output
    if (Remaining_Daily_H2O/M_Plant_Output > 1)
        L_Plant_Qty = L_Plant_Qty + 1;
        Remaining_Daily_H2O = Remaining_Daily_H2O - (L_Plant_Qty * L_Plant_Output);
    else
        M_Plant_Qty = floor(Remaining_Daily_H2O/M_Plant_Output);
        Remaining_Daily_H2O = Remaining_Daily_H2O - (M_Plant_Qty * M_Plant_Output);
    end
end
if Remaining_Daily_H2O > S_Plant_Output
    S_Plant_Qty = floor(Remaining_Daily_H2O/S_Plant_Output);
    Remaining_Daily_H2O = Remaining_Daily_H2O - (S_Plant_Qty * S_Plant_Output);
end
if Remaining_Daily_H2O > 0 
    S_Plant_Qty = S_Plant_Qty + 1;
    %Remaining_Daily_H2O = Remaining_Daily_H2O - (1 * S_Plant_Output);
end


%% Electrolysis Section
Remaining_Electrolysis_H20 = Needed_H2O; %H2Okg per day

Electrolysis_Plant_Mass = 38.5; %kg
Electrolysis_Plant_Vol = 0; %as yet unknown
Electrolysis_Plant_Power = (72 * 36) / 24; %72 kWh per kilogram, times kg per day, divided by  24 hours running per day
Electrolysis_Plant_Capacity = 36; %kg of Water processed per day

Num_Electrolysis_Plants = ceil(Remaining_Electrolysis_H20 / Electrolysis_Plant_Capacity);

%% Sabatier Section
Sabatier_Mass = 479.12; %kg
Sabatier_Vol = 0.8; %m^3
Sabatier_Power = 24.98;
Sabatier_Production = 6567 / 496; %kg per day, CH4, DRA5 Addendum 1, Table 3-18, necessary CH4 for trip, divided by stay duration
Sabatier_Production = Sabatier_Production * (1+2.93); %kg per day, Propellant(CH4+O2), since plant produces both, stoichiometrically


if ~isempty(Results.Mars_ISRU.CH4_Prop_Output) % skip if no CH4
    CH4_Daily_Prop_Needs = Results.Mars_ISRU.CH4_Prop_Output / 780;
    Num_Sabatier_Plants = ceil((CH4_Daily_Prop_Needs / 24) / Sabatier_Production);
elseif isempty(Results.Mars_ISRU.CH4_Prop_Output)
    Num_Sabatier_Plants = 0;
end

%% add to results object
%Since this is a simple extension of DRA5.0 plan, ISRU system is H2O only,
%thus:

Results.Mars_ISRU.Mass = (S_Plant_Qty * S_Plant_Mass) + (M_Plant_Qty * M_Plant_Mass) + (L_Plant_Qty * L_Plant_Mass)...
    + (Electrolysis_Plant_Mass * Num_Electrolysis_Plants)...
    + (Sabatier_Mass * Num_Sabatier_Plants); %ISRU_Mass;
Results.Mars_ISRU.Volume = (S_Plant_Qty * S_Plant_Vol) + (M_Plant_Qty * M_Plant_Vol) + (L_Plant_Qty * L_Plant_Vol)...
    + (Electrolysis_Plant_Vol * Num_Electrolysis_Plants)...
    + (Sabatier_Vol * Num_Sabatier_Plants); %ISRU_Vol;
Results.Mars_ISRU.Power = (S_Plant_Qty * S_Plant_Power) + (M_Plant_Qty * M_Plant_Power) + (L_Plant_Qty * L_Plant_Power)...
    + (Electrolysis_Plant_Power * Num_Electrolysis_Plants)...
    + (Sabatier_Power * Num_Sabatier_Plants); %ISRU_Power;
Results.Mars_ISRU.Consumables_Mass = ECLSS_Requirements.Nitrogen + ECLSS_Requirements.CO2; %mass of gasses shipped in.


end


%{
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

%Calculations for Moxie Oxygen for Fuel
Oxygen_Daily_Generation = (Moxie_Oxygen_Rate/1000)*24; %Units: kg/day
if nansum([Results.Mars_ISRU.Oxidizer_Output]) > 1
    Required_Daily_Ox_Mars = Results.Mars_ISRU.Oxidizer_Output / (Time_Between_Missions * 30);
elseif nansum([Results.Mars_ISRU.Oxidizer_Output]) == 0
    Required_Daily_Ox_Mars = 0;        
else
    disp ('Error, ISRU lines 44-51')
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
%}