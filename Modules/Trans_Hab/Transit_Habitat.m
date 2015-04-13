%% NEED DESCRIPTION
% inputs
%   Cur_Arch - MarsArchitecture object
% outputs
%   p_transhab - units?
%   v_crew - units?
%   m_transhab - units?
function [SpaceCraft] = Transit_Habitat(Cur_Arch, SpaceCraft)

%----------------------Code Definition-----------------------------------
% Mass, Volume, and power required to
% sustain the lifes of 4 people en-route to Mars. 
% Joseph Yang, March 17, 2015
% Code based on surface habitat module (Mar 17, 2015)

%------Inputs------
 Num_Crew = Cur_Arch.TransitCrew.Size;           % Reference architecture
%%%%NATHAN-remove:Num_Crew = Cur_Arch.TransitCrew.Size;
% Days_to_Mars = 180;     % Approx
switch Cur_Arch.CrewTrajectory.Type
    case TrajectoryType.HOHMANN.Type
            Days_to_Mars = 259; % HSMAD pg.255, minimum energy orbits
            Days_to_Earth = 258; % HSMAD pg.255, minimum energy orbits
            Days_Contingency = 455;
    case TrajectoryType.ELLIPTICAL.Type
end
% Days_to_Earth = 180;    % Approx
% Days_Contingency = 700; % Approx for contingency flyby & return to Earth; also include stage
crew_day = Num_Crew * (Days_to_Mars + Days_to_Earth + Days_Contingency);

%------Constants------
%%%%NATHAN-remove:Crew_Size = Num_Crew;           %Units: Crew Members
m_Airlock = 1250;               %Units: kg, HSMAD Table 31-6 
%%%%NATHAN-remove:m_food_CM_Day = 2.3;            %Units: kg/CM/day, per BVAD, packaged food
v_food_CM_Day = 0.00678;        %Units: m^3/CM/day, per BVAD, Table 4.3.3 (including rack)
v_Pressurized = 330;            %Units: m^3, based on Transhab (also BA330)
m_MOI_max = 126000;             %DRA 5.0 Aerocapture, Table 3-17, post-burn

%------------------------------------------------------------------------

% ADD COMMENTS
% set mass of crew system by dividing something by something else times
% crew days to get kg????
m_crew_sys = 17051/(6*680)*crew_day;       % HSMAD, Table 31-5 (scaled)
p_crew_sys = 2.47/(6*680)*crew_day;        % HSMAD, Table 31-5 (scaled)
v_crew_sys = 85.51/(6*680)*crew_day;

m_crew = 70 * Num_Crew;

m_food = Cur_Arch.TransitCrew.FoodKgMassPerDay * crew_day;
p_ECLSS = (4.2 + 0.18 + 0.575)/6*4;     % HSMAD, Table 31-7 (scaled), ECLSS air, water, thermal 
p_food = m_food * 0.91;

%{
Should be in transit module
m_aero_shield = 66100;                  % Based on DRA 5.0, including payload fairing & adapter
%}

m_transhab_dry = 20000;                 % Based on BA330, incl. 1 airlock

v_food = v_food_CM_Day & crew_day;
v_waste = 20;        % WAG
m_spare = 500;       % WAG on spare
v_spare = 1;         % WAG on spare

%{
Don't Need Lander stuff, that's in Descent and Ascent Modules
% m_lander = 10000;    % Based on Dragon
% m_prop_lander = 500; % Guess
%}

p_transhab = p_crew_sys + 20;
m_transhab = m_transhab_dry + m_crew + m_crew_sys; %+ m_lander+ m_aero_shield
v_crew = v_Pressurized - (v_crew_sys + v_waste + v_spare); %Assumes BA330

margin = m_MOI_max - m_transhab;

Trans_SC = SC_Class('Transit Habitat');
Trans_SC.Hab_Vol = v_crew;
Trans_SC.Volume = v_crew_sys;
Trans_SC.Hab_Power = p_transhab;
Trans_SC.Hab_Mass = m_transhab;

SpaceCraft.Add_Craft = Trans_SC;
end