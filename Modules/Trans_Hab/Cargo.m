function [p_cargo, v_cargo] = Cargo(m_food)

%----------------------Code Definition-----------------------------------
% Assume unpressurized cargo, aerobraking
% Joseph Yang, March 18, 2015
% Code based on DRA 5.0

% Constants
% m_food = 18000 (18 tons per Tatsuya)
m_aeroshell = 66000;    % Per DRA 5.0

% m_drymass = 20000 (20tons per DRA 5.0)
p_cargo = m_food * 0.91 / 1000
m_cargo = 120000

end