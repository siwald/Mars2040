function [FerrySpacecraft, HumanSpacecraft, CargoSpacecraft, Results] = ...
    Lunar_ISRU (Cur_Arch, HumanSpacecraft, CargoSpacecraft, Results)
%LUNAR_ISRU Summary of this function goes here
%   Detailed explanation goes here
%% powerplant constants
Solar_Size = 1.3; %Units: m^2; Size of solar panels that were used for Spirit and Opportunity
Solar_Output = 450; %Units: W/hr; Lowest power output for solar panels from Spirit and Opportunity Missions. Worst case was asuumed for this study.
Panel_Mass = 2.5; %Units: kg/m^2; Mass of solar panels used for Spirit and Opportunity
PowerPlant_Distance = 3000; %Units: m; distance from power plant to habitat, DRA5, no sheild

XL_Reactor_Size = 10; %Units: MW; Rocketdyne reactor, liquid cooled
L_Reactor_Size = 5; %Units: MW; ORNL reactor, UN pellet fuel pin w/T-111 alloy
M_Reactor_Size = 4; %Units: MW; 1993 DRM derived from NTP and SP-100
S_Reactor_Size = 0.1; %Units: MW; SP-100 US Research group for nuclear reactors in space
XL_Reactor_Mass = 40095; %Units: kg; Rocketdyne reactor, liquid cooled
XL_Reactor_Volume = 8247.98; %Units: m^3
L_Reactor_Mass = 24500; %Units: kg; ORNL reactor, UN pellet fuel pin w/T-111 alloy
L_Reactor_Volume = 2324.74; %Units: m^3;
M_Reactor_Mass = 41510; %Units: kg; 1993 DRM derived from NTP and SP-100
S_Reactor_Mass = 4610; %Units: kg; SP-100 US Research group for nuclear reactors in space
S_Reactor_Volume = 36.77; %Units: m^3;
M_Reactor_Volume = (S_Reactor_Mass + L_Reactor_Mass)/2; %Units: m^3
XL_Reactor_Size = XL_Reactor_Size * 1000; %Units: kW; convert MW to kW
L_Reactor_Size = L_Reactor_Size * 1000; %Units: kW; convert MW to kW
M_Reactor_Size = M_Reactor_Size * 1000; %Units: kW; convert MW to kW
S_Reactor_Size = S_Reactor_Size * 1000; %Units: kW; convert MW to kW

Synod = 2.137;
%% Move Fuel to the appropriate spots
Results.Lunar_ISRU.Oxidizer_Output = 0; %initialize this
Results.Lunar_ISRU.Fuel_Output = 0; %initialize this
[HumanSpacecraft, Results] = Lunar_Move(Cur_Arch, HumanSpacecraft, Results);
[CargoSpacecraft, Results] = Lunar_Move(Cur_Arch, CargoSpacecraft, Results);

%% Lunar Plant Size (1st pass, no Ferry Fuel, get spares for ferry)
if or(isequal(Cur_Arch.TransitFuel, [TransitFuel.EARTH_LH2, TransitFuel.EARTH_O2]),...
        isequal(Cur_Arch.TransitFuel, [TransitFuel.EARTH_O2, TransitFuel.EARTH_LH2]))
    %nothing, no Lunar ISRU.
elseif or(isequal(Cur_Arch.TransitFuel, [TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2]),...
        isequal(Cur_Arch.TransitFuel, [TransitFuel.LUNAR_O2,TransitFuel.EARTH_LH2]))
    %O2 Only
    if ~isequal(Cur_Arch.PropulsionType, Propulsion.NTR) %just skip if NTR
    O2_Per_Month = Results.Lunar_ISRU.Oxidizer_Output / (Synod*12) ; %kg/month
    Results.Lunar_ISRU.Mass = (6.50 * O2_Per_Month) + 11800; %kg
    Results.Lunar_ISRU.Power = (58.2 * (O2_Per_Month/1000)) + 30.8; %kW

                XL_Reactor_Quantity = floor(Results.Cum_Surface_Power/XL_Reactor_Size);
            Remaining_Power = Results.Cum_Surface_Power - (XL_Reactor_Quantity * XL_Reactor_Size);
            if (Remaining_Power/L_Reactor_Size) > 1 %add another XL_Reactor instead of 2 Larges, Mass Savings!
                XL_Reactor_Quantity = XL_Reactor_Quantity + 1;
                Remaining_Power = Remaining_Power - (1 * XL_Reactor_Size);
                L_Reactor_Quantity = 0; %set as 0 for later calcs
            else
            L_Reactor_Quantity = floor(Remaining_Power/L_Reactor_Size);
            Remaining_Power = Remaining_Power - (L_Reactor_Quantity * L_Reactor_Size);
            end
            %Don't use M reactor, 2X as heavy as Large.
            % M_Reactor_Quantity = floor(Remaining_Power/M_Reactor_Size);
            % Remaining_Power = Remaining_Power - (M_Reactor_Quantity * M_Reactor_Size);
            M_Reactor_Quantity =0; %set as 0 for later calcs.

            if (Remaining_Power / S_Reactor_Size) > 5 %Use another L rather than 6+ S, mass savings!
                L_Reactor_Quantity = L_Reactor_Quantity + 1;
                S_Reactor_Quantity = 0; %set as for later calcs
                Remaining_Power = Remaining_Power - (1 * L_Reactor_Size);
            else
                S_Reactor_Quantity = floor(Remaining_Power/S_Reactor_Size);
                Remaining_Power = Remaining_Power - (S_Reactor_Quantity * S_Reactor_Size);
            end

            if Remaining_Power > 0
                S_Reactor_Quantity = S_Reactor_Quantity + 1; 
            else
                %do not add anything to Small Reactor Quantity, we have a power margin!
            end

            PowerPlant_Mass = (XL_Reactor_Quantity * XL_Reactor_Mass) + (L_Reactor_Quantity * L_Reactor_Mass)+(M_Reactor_Quantity * M_Reactor_Mass)+(S_Reactor_Quantity * S_Reactor_Mass);
            PowerPlant_Volume = (XL_Reactor_Quantity * XL_Reactor_Volume) + (L_Reactor_Quantity * L_Reactor_Volume)+(M_Reactor_Quantity * M_Reactor_Volume)+(S_Reactor_Quantity * S_Reactor_Volume);
    Results.Lunar_ISRU.Mass = Results.Lunar_ISRU.Mass + PowerPlant_Mass;
    Results.Lunar_ISRU.Spares = Results.Lunar_ISRU.Mass * 0.05;
    end
elseif or(...
        or(isequal(Cur_Arch.TransitFuel, [TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]),...
            isequal(Cur_Arch.TransitFuel, [TransitFuel.LUNAR_O2,TransitFuel.LUNAR_LH2])), ...
        or(isequal(Cur_Arch.TransitFuel, [TransitFuel.LUNAR_LH2,TransitFuel.EARTH_O2]),...
            isequal(Cur_Arch.TransitFuel, [TransitFuel.EARTH_O2,TransitFuel.LUNAR_LH2])) ...
        )
    %H2 Only, or H2 and O2
    Lunar_Plant_O2_Prod = 24000 * Synod; %kg/synod
    Lunar_Plant_H2_Prod = 14000 * Synod; %kg/synod
    Lunar_Plant_Mass = 60000 ; %Plant and Power

    Results.Lunar_ISRU.Num = max(ceil(Results.Lunar_ISRU.Oxidizer_Output/Lunar_Plant_O2_Prod), ...
        ceil(Results.Lunar_ISRU.Fuel_Output/Lunar_Plant_H2_Prod));

    Results.Lunar_ISRU.Mass = Results.Lunar_ISRU.Num * Lunar_Plant_Mass;
    Results.Lunar_ISRU.Power = 0;
    Results.Lunar_ISRU.Spares = Results.Lunar_ISRU.Mass * 0.05;
else 
    warning('error in parsing Lunar ISRU needs');
end


%% Ferry craft
FerrySpacecraft = OverallSC; %initialize the Ferry Craft
if or(Results.Lunar_ISRU.Fuel_Output < 0, ... do only if there is Lunar ISRU
        Results.Lunar_ISRU.Oxidizer_Output < 0) 
%set stage location
switch Cur_Arch.Staging
    case Location.LEO
        stage = 'LEO';
    case Location.EML1
        stage = 'EML1';
    case Location.EML2
        stage = 'EML2';
end
%sum the Lunar ISRU mass
Prop_Mass = nansum([Results.Lunar_ISRU.Fuel_Output, Results.Lunar_ISRU.Oxidizer_Output]);

Tank = SC_Class ('Lunar ISRU Tank');
Tank.Bus_Mass = .05 * Prop_Mass; %MAE 4262, Florida Institude of Tech, Accessed 4-21-15, http://my.fit.edu/~dkirk/4262/Lectures/Propellant%20Tank%20Design.doc
FerrySpacecraft.Add_Craft = Tank;

Spares = SC_Class ('Spares for Lunar ISRU');
Spares.Payload_Mass = Results.Lunar_ISRU.Spares;
FerrySpacecraft.Add_Craft = Spares;

%Get tank back from staging point
FerryBack_Eng = SC_Class('Ferry Return Stage');
FerryBack_Eng = Propellant_Mass(Cur_Arch.PropulsionType,FerryBack_Eng,Hohm_Chart(stage,'Moon'),FerrySpacecraft.Mass);
%FerryBack_Eng = Propellant_Mass(Propulsion.LH2,FerryBack_Eng,Hohm_Chart(stage,'Moon'),FerrySpacecraft.Mass);
FerrySpacecraft.Add_Craft = FerryBack_Eng;

%Get Full tank and fuel to staging point
Ferry_Eng = SC_Class('Ferry Main Engines');
Ferry_Eng = Propellant_Mass(Cur_Arch.PropulsionType,Ferry_Eng,Hohm_Chart(stage,'Moon'),Prop_Mass);
FerrySpacecraft.Add_Craft = Ferry_Eng;

%Add Ferry Fuel Needs to Lunar ISRU
[FerrySpacecraft, Results] = Lunar_Move(Cur_Arch, FerrySpacecraft, Results);
end
%% Lunar Plant ReSize (with additional Ferry Fuel)

end

