function [Results] = Astronaut_Time(Cur_Arch, Results)
%Astronaut_Sci_Time output in units of: CM-days/day

%Cur_Arch = MarsArchitecture.DEFAULT;
spares = Results.Spares;
power_upkeep = 0;
% time2Mars = 35;
% time2Earth = 35;




% switch Cur_Arch.TransitTrajectory
%     
%     case 'Opposition'
%         time_on_Mars = 26*30; %days
%     case 'Hohmann'
%         time_on_Mars = 3*30; %days 
%         
% end

% if strngcmp(Cur_Arch.TransitTrajectory, 'Opposition')
%     time_on_Mars = 26*30; %days
% elseif strngcmp(Cur_Arch.TransitTrajectory, 'Hohmann')
%     time_on_Mars = 3*30; %days
% end

%Subtractions. These are in units of hours per days spent doing tasks
personal = 12; %sleeping 8, eating/cooking 2, hygiene 1, personal 1
general_repairs = (spares*0.001)*.15; %for every ton of spares, assume 1 minutes is spent per day making repairs. ie. 10 tons of spares is 2 hours of upkeep a day
FoodSupply = Cur_Arch.FoodSupply.Amount;

if FoodSupply == 1
    food_time = 2; %hours per day growing
elseif FoodSupply > 0
    food_time = 1;
else
    food_time = 0;
end

n = length(Cur_Arch.SurfacePower);
Power_Method = Cur_Arch.SurfacePower;

for m = 1:n
    switch char(Power_Method(m))
        
        case 'SOLAR'
            power_upkeep = power_upkeep + 2;
        case 'FUEL_CELLS'
            power_upkeep = power_upkeep + 1.5;    
        case 'RTG'
            %No Equations at this time. Insert equations here
            power_upkeep = power_upkeep + 0;
        case 'NUCLEAR'
            power_upkeep = power_upkeep + 1.5;
        otherwise
            power_upkeep = power_upkeep + 0;
    end

% if strngcmp(Cur_Arch.SurfacePower{1}, 'Solar')
%     power_upkeep = 2; %dust of solar cells during storms
% elseif strngcmp(Cur_Arch.SurfacePower{1}, 'Nuclear')
%     power_upkeep = 1.5;
% elseif strngcmp(Cur_Arch.SurfacePower{1}, 'Hybrid')
%     power_upkeep = 1.75;
% else
%     power_upkeep = 0;
% end

% switch char(Cur_Arch.ISRUBase{1})
%     
%     case 'None'
%         ISRU_upkeep = 1;
%     otherwise
%         ISRU_upkeep = 0;
% end

switch char(Cur_Arch.ISRUBase{1})
    
    case 'NONE'
        ISRU_upkeep = 1;
    otherwise
        ISRU_upkeep = 0;
end

% if ISRU_Base == 'NONE'
%     ISRU_upkeep = 1;
% else 
%     ISRU_upkeep = 0;
% end

spent_time = ISRU_upkeep + power_upkeep + food_time + general_repairs + personal;

Astronaut_Daily_Time = 24.5 - spent_time; % in Hours per Astronaut

Results.Science_Time = Astronaut_Daily_Time * Cur_Arch.SurfaceCrew.Size / 24; %in days per Team
% science_fraction = spent_time/24;
% 
% days_of_scientific_output = science_fraction*time_on_Mars;
% 
% days_of_scientific_output = days_of_scientific_output - .1*time_on_Mars; %Budget 10% of time as reserve for emergencies
% 
% total_mission_time = time_on_Mars + time2Mars + time2Earth;
% 
% Astronaut_Sci_Time = days_of_scientific_output/total_mission_time;

end
    
    
