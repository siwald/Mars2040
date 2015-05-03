function [ Spacecraft, Results ] = Lunar_Move( Cur_Arch, Spacecraft, Results )
%LUNAR_MOVE Summary of this function goes here

if or(Cur_Arch.TransitFuel(1) == TransitFuel.LUNAR_O2, ...
        Cur_Arch.TransitFuel(2) == TransitFuel.LUNAR_O2)
    if ~isempty(Spacecraft.Ox_Mass) %only if there _is_O2
    Results.Lunar_ISRU.Oxidizer_Output = Results.Lunar_ISRU.Oxidizer_Output + Spacecraft.Ox_Mass; %add O2 to Lunar generation
    remove_ox(Spacecraft); %remove all O2 from Spacecraft Modules
    end
end
if or(Cur_Arch.TransitFuel(1) == TransitFuel.LUNAR_LH2,  ...
        Cur_Arch.TransitFuel(2) == TransitFuel.LUNAR_LH2)
    if ~(Cur_Arch.PropulsionType == Propulsion.CH4); %skip if Methane, can't gen on Lunar ISRU
        if ~isempty(Spacecraft.Fuel_Mass) %only if there _is_Fuel
        Results.Lunar_ISRU.Fuel_Output = Results.Lunar_ISRU.Fuel_Output + Spacecraft.Fuel_Mass; %add LH2 to Lunar generation
        remove_fuel(Spacecraft); %remove all LH2 from Spacecraft Modules
        end
    end
end

end

