function [ S_C_inst ] = Propellant_Mass( ~ , ~ )
%function [ S_C_Mass ] = Propellant_Mass( Prop_Nums, Payload_Mass )
%PROPELLANT_MASS Calculate the mass of the propellant needed for a maneuver
%   Calculating the necessary propellant mass from a Delta_V manuever and
%   the Isp of the fuel source.
%       UNITS
%       Delta_V in km/s
%       Fuel Isp in seconds
%       Final mass in kg

%  Rocket Equation (Isp version): dV = Isp*g0*ln(m0/m1)
%  Gravitational Constant, g0 = 9.80665 m/s^2 = 0.0098665 km/s^2

%-----Testing Inputs-----
    Prop_Nums = Prop_Class;
    Prop_Nums.Isp = 380; %in seconds
    Prop_Nums.FOx_Rat = 6.0; %Ratio, 6kg fuel to 1kg oxidizer
    Prop_Nums.InertM_Rat = 0.17; %percentage, 0-1
    Payload_Mass = 30000; %kg
    dV = 6; %km/s
%-----Testing-----

%-----Constants-----
g0=0.0098665; %km/s^2
e=2.71828182845904523536028747135266249;
%-----Constants-----

%Convergent loop
converge_to = 0.0000001; %set convergence limit in difference percent
%tic
converge = 1; %initialize convergence factor
last = 0; %initialize tracking variable
Eng_Mass = 0; %initialize engine mass for 1st iteration
it = 0; %counting variable
while converge > converge_to
    %evaluate the rocket equation for fuel mass
    Prop_Mass=e^(((dV)/(g0*Prop_Nums.Isp)))*(Eng_Mass+Payload_Mass)-Eng_Mass-Payload_Mass;
    %Rocket_Eqn == dV = Prop_Nums.Isp*g0*log((Eng_Mass+Payload_Mass+fuel_mass)/(Eng_Mass+Payload_Mass))
    %Prop_Mass = solve(Rocket_Eqn, fuel_mass)
    %evaluate engine mass and determine SpaceCraft Mass
    Eng_Mass = Prop_Mass * Prop_Nums.InertM_Rat;
    S_C_Mass = Prop_Mass + Eng_Mass + Payload_Mass;
    
    %compare results to last iteration
    converge = (S_C_Mass - last) / S_C_Mass;
    last = S_C_Mass; %set tracking variable to this iteration
    it = it + 1;

end

%put solutions into spacecraft object
S_C_inst = S_C_Class(S_C_Mass, Payload_Mass, Prop_Mass); %create S/C instance, takes: total mass at origin, payload mass at destination and fuel mass at origin, respectivley 

%{
Prop_Loop_time_in_seconds = toc
disp('Iterations: ')
disp(it)
disp('Fueled Spacecraft Mass in kg:')
disp(S_C_Mass)
%}

end