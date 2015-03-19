function [p_transhab, v_crew, m_transhab] = Transit_Habitat(Num_Crew,Days_to_Mars,Days_to_Earth,Days_Contingency)

%----------------------Code Definition-----------------------------------
% Mass, Volume, and power required to
% sustain the lifes of 4 people en-route to Mars. 
% Joseph Yang, March 17, 2015
% Code based on surface habitat module (Mar 17, 2015)

%------Inputs------
% Num_Crew = 4;           % Reference architecture
% Days_to_Mars = 180;     % Approx
% Days_to_Earth = 180;    % Approx
% Days_Contingency = 700; % Approx for contingency flyby & return to Earth; also include stage
crew_day = Num_Crew * (Days_to_Mars + Days_to_Earth + Days_Contingency);

%------Constants------
Crew_Size = Num_Crew;           %Units: Crew Members
m_Airlock = 1250;               %Units: kg, HSMAD Table 31-6 
m_food_CM_Day = 2.3;            %Units: kg/CM/day, per BVAD, packaged food
v_food_CM_Day = 0.00678;        %Units: m^3/CM/day, per BVAD, Table 4.3.3 (including rack)
v_Pressurized = 330;            %Units: m^3, based on Transhab (also BA330)
m_MOI_max = 126000;             %DRA 5.0 Aerocapture, Table 3-17, post-burn

%------------------------------------------------------------------------
m_crew_sys = 17051/(6*680)*crew_day;       % HSMAD, Table 31-5 (scaled)
p_crew_sys = 2.47/(6*680)*crew_day;        % HSMAD, Table 31-5 (scaled)
v_crew_sys = 85.51/(6*680)*crew_day;

m_crew = 70 * Num_Crew;

m_food = m_food_CM_Day * crew_day;
p_ECLSS = (4.2 + 0.18 + 0.575)/6*4;     % HSMAD, Table 31-7 (scaled), ECLSS air, water, thermal 
p_food = m_food * 0.91;

m_aero_shield = 66100;                  % Based on DRA 5.0, including payload fairing & adapter
m_transhab_dry = 20000;                 % Based on BA330, incl. 1 airlock

v_food = v_food_CM_Day & crew_day;
v_waste = 20;        % WAG
m_spare = 500;       % WAG on spare
v_spare = 1;         % WAG on spare

m_lander = 10000;    % Based on Dragon
m_prop_lander = 500; % Guess

p_transhab = p_crew_sys + 20;
m_transhab = m_transhab_dry + m_lander + m_crew + m_aero_shield + m_crew_sys;
v_crew = 330 - (v_crew_sys + v_waste + v_spare);
margin = m_MOI_max - m_transhab;

end