function [FerrySpacecraft, HumanSpacecraft, CargoSpacecraft, Results] = ...
    Lunar_ISRU (Cur_Arch, HumanSpacecraft, CargoSpacecraft, Results)
%LUNAR_ISRU Summary of this function goes here
%   Detailed explanation goes here

%% Move Fuel to the appropriate spots
[HumanSpacecraft, Results] = Lunar_Move(Cur_Arch, HumanSpacecraft, Results);
[CargoSpacecraft, Results] = Lunar_Move(Cur_Arch, CargoSpacecraft, Results);

%% Ferry craft
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
FerrySpacecraft = OverallSC; %initialize the Ferry Craft
Tank = SC_Class ('Lunar ISRU Tank');
Tank.Bus_Mass = .05 * Prop_Mass; %MAE 4262, Florida Institude of Tech, Accessed 4-21-15, http://my.fit.edu/~dkirk/4262/Lectures/Propellant%20Tank%20Design.doc
FerrySpacecraft.Add_Craft = Tank;

%Get tank back from staging point
FerryBack_Eng = SC_Class('Ferry Return Stage');
FerryBack_Eng = Propellant_Mass(Cur_Arch.PropulsionType,FerryBack_Eng,Hohm_Chart(stage,'Moon'),0);
FerrySpacecraft.Add_Craft = FerryBack_Eng;

%Get Full tank and fuel to staging point
Ferry_Eng = SC_Class('Ferry Main Engines');
Ferry_Eng = Propellant_Mass(Cur_Arch.PropulsionType,Ferry_Eng,Hohm_Chart(stage,'Moon'),Prop_Mass);
FerrySpacecraft.Add_Craft = Ferry_Eng;

%Add Ferry Fuel Needs to Lunar ISRU
[FerrySpacecraft, Results] = Lunar_Move(Cur_Arch, FerrySpacecraft, Results);

%% Lunar ISRU results
Results.Lunar_ISRU.Mass = 50 * Results.Lunar_ISRU.Fuel_Output + 25 * Results.Lunar_ISRU.Oxidizer_Output;
Results.Lunar_ISRU.Power = 600 *(Results.Lunar_ISRU.Fuel_Output + Results.Lunar_ISRU.Oxidizer_Output);

end

