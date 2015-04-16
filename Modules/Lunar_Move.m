function [ Spacecraft, Results ] = Lunar_Move( Cur_Arch, Spacecraft, Results )
%LUNAR_MOVE Summary of this function goes here
%   Detailed explanation goes here
    if isempty(Results.Lunar_ISRU.Oxidizer_Output)
        Results.Lunar_ISRU.Oxidizer_Output = 0; %initialize this if empty
    end
    if isempty(Results.Lunar_ISRU.Fuel_Output)
        Results.Lunar_ISRU.Oxidizer_Output = 0; %initialize this if empty
    end
for i=1:2
    if Cur_Arch.TransitFuel(i).Location == Location.LUNAR & ...
            strcmp(Cur_Arch.TransitFuel(i).Name, 'O2')

        Results.Lunar_ISRU.Oxidizer_Output = Results.Lunar_ISRU.Oxidizer_Output + Spacecraft.Ox_Mass; %add O2 to Lunar generation
        remove_ox(Spacecraft); %remove all O2 from Spacecraft Modules
    end
    if Cur_Arch.TransitFuel(i).Location == Location.LUNAR & ...
            strcmp(Cur_Arch.TransitFuel(i).Name, 'LH2')
        if ~(Cur_Arch.PropulsionType == Propulsion.CH4); %skip if Methane, can't gen on Lunar ISRU
            Results.Lunar_ISRU.Fuel_Output = Results.Lunar_ISRU.Fuel_Output + Spacecraft.Fuel_Mass; %add LH2 to Lunar generation
            remove_fuel(Spacecraft); %remove all LH2 from Spacecraft Modules
        end
    end
end
end

