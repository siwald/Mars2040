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


if Cur_Arch.EDL == ArrivalDescent.AEROENTRY %subtract 30 days for each crew member in aerocapture maneuver
    Results.Science_Time = Results.Science_Time - (Cur_Arch.TransitCrew.Size * 30);
end
end