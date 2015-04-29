function [Results] = Astronaut_Time(Cur_Arch, Results, CrewFood)
%Astronaut_Sci_Time output in units of: CM-days/day

%Subtractions. These are in units of hours per days spent doing tasks
personal = 13; %sleeping 8, exercise 2, hygiene 1, personal 2
general_repairs = (24.66-13)*0.13; %Maintenance % of work time, NASA IG-13-019 pg. 7
food_time = CrewFood / Cur_Arch.SurfaceCrew.Size;
spent_time = nansum([food_time, general_repairs, personal]);

Astronaut_Daily_Time = 24.66 - spent_time; % in Hours per Astronaut

Astronaut_Days_on_Surf = ...%in Total Astronaut-Days per Synod
    (Cur_Arch.SurfaceCrew.Size * 780)... Base crew size for full Synod
    - (Cur_Arch.TransitCrew.Size * 280); %minus rotation crew size until next arrival
Results.Science_Time = (Astronaut_Daily_Time * Astronaut_Days_on_Surf) / 24; %in Science-Days per Synod
% science_fraction = spent_time/24;
% days_of_scientific_output = science_fraction*time_on_Mars;
% days_of_scientific_output = days_of_scientific_output - .1*time_on_Mars; %Budget 10% of time as reserve for emergencies 
% total_mission_time = time_on_Mars + time2Mars + time2Earth;
% Astronaut_Sci_Time = days_of_scientific_output/total_mission_time;

end
    
    
