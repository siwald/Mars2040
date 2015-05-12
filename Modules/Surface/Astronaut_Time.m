function [Results] = Astronaut_Time(Cur_Arch, Results, CrewFood)
%Astronaut_Sci_Time output in units of: CM-days/day

%Subtractions. These are in units of hours per days spent doing tasks
personal = 13; %sleeping 8, exercise 2, hygiene 1, personal 2
%general_repairs = (24.66-13)*0.13; %Maintenance % of work time, NASA IG-13-019 pg. 7
food_time = CrewFood / Cur_Arch.SurfaceCrew.Size;
%spent_time = nansum([food_time, general_repairs, personal]);
spent_time = nansum([food_time, personal]);

Astronaut_Daily_Time = 24.66 - spent_time; % in Hours per Astronaut
Astronaut_Daily_Time = Astronaut_Daily_Time *(1-0.13-0.06-0.04-0.03);%Maintenance, prep, medical, etc. % of work time, NASA IG-13-019 pg. 7

switch Cur_Arch.CrewTrajectory.Type
    case TrajectoryType.HOHMANN.Type
        until_next = 280; % Days between crew leaving, and next batch arriving
    case TrajectoryType.ELLIPTICAL.Type
        until_next = 0; % Days between crew leaving, and next batch arriving
        disp('too bad')
    case TrajectoryType.ALDRIN.Type
        until_next = 0; % Days between crew leaving, and next batch arriving
        disp('too bad')
    case TrajectoryType.LONGCYCLER.Type
        until_next = 0; % Days between crew leaving, and next batch arriving
        disp('too bad')
    case TrajectoryType.SHORTCYCLER.Type
        until_next = 0; % Days between crew leaving, and next batch arriving
        disp('too bad')
    otherwise
        disp('Astronaut_Time, line 12 switch case')
end
Astronaut_Days_on_Surf = ...%in Total Astronaut-Days per Synod
    (Cur_Arch.SurfaceCrew.Size * 780)... Base crew size for full Synod
    - (Cur_Arch.TransitCrew.Size * until_next); %minus rotation crew size until next arrival
Results.Science_Time = (Astronaut_Daily_Time * Astronaut_Days_on_Surf) / 24; %in CM-hours per Synod

% if Cur_Arch.EDL == OrbitCapture.AEROENTRY %subtract 30 days for each crew member in aerocapture maneuver
%     Results.Science_Time = Results.Science_Time - (Cur_Arch.TransitCrew.Size * 30);
% end
end