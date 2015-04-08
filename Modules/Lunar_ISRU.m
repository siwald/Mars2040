function [FerrySpacecraft, HumanSpacecraft, CargoSpacecraft, Results] = Lunar_ISRU (Cur_Arch, HumanSpacecraft, CargoSpacecraft, Results)
%LUNAR_ISRU Summary of this function goes here
%   Detailed explanation goes here

%% Move Fuel to the appropriate spots
[HumanSpacecraft, Results] = Lunar_Move(Cur_Arch, HumanSpacecraft, Results);
[CargoSpacecraft, Results] = Lunar_Mave(Cur_Arch, CargoSpacecraft, Results);

%% Ferry craft
%sum the Lunar ISRU mass
Prop_Mass = nansum([Results.Lunar_ISRU.Fuel_Output, Results.Lunar_ISRU.Oxidizer_Output]);
FerrySpacecraft = OverallSC; %initialize the Ferry Craft
Tank = SC_Class ('Lunar ISRU Tank');
Tank.Bus_Mass = .005 * Prop_Mass; %Example Number
FerrySpacecraft.Add_Craft = Tank;

%Get tank back from staging point
FerryBack_Eng = SC_Class('Ferry Return Stage');
FerryBack_Eng = Propellant_Mass(Cur_Arch.Propulsion,FerryBack_Eng,Hohm_Chart('EML1','Moon'),0);
FerrySpacecraft.Add_Craft = FerryBack_Eng;

%Get Full tank and fuel to staging point
Ferry_Eng = SC_Class('Ferry Main Engines');
Ferry_Eng = Propellant_Mass(Cur_Arch.Propulsion,Ferry_Eng,Hohm_Chart('EML1','Moon'),Prop_Mass);
FerrySpacecraft.Add_Craft = Ferry_Eng;

%Add Ferry Fuel Needs to Lunar ISRU
[FerrySpacecraft, Results] = Lunar_Move(Cur_Arch, FerrySpacecraft, Results);
end

%% Lunar ISRU results
Results.Lunar_ISRU.Mass = 50 * Results.Lunar_ISRU.Fuel_Output + 25 * Results.Lunar_ISRU.Oxidizer_Output;
Results.Lunar_ISRU.Power = 600 *(Results.Lunar_ISRU.Fuel_Output + Results.Lunar_ISRU.Oxidizer_Output);

end

