function [ SC_Inst ] = Propellant_Mass( prop_inst , SC_Inst , dV)
%function [ SC_Inst ] = Propellant_Mass( Prop_Nums, s_C_Inst )
%PROPELLANT_MASS Calculate the mass of the propellant needed for a maneuver
%   Calculating the necessary propellant mass from a Delta_V manuever and
%   the Isp of the fuel source.
%       UNITS
%       Delta_V in km/s
%       Fuel Isp in seconds
%       Final mass in kg

%  Rocket Equation (Isp version): dV = Isp*g0*ln(m0/m1)
%  Gravitational Constant, g0 = 9.80665 m/s^2 = 0.0098665 km/s^2

%{
%-----Testing Inputs-----
    %--would be delivered by Propulsion Module
    %--Prop_Nums = Prop_Class;
    %--Prop_Nums.Isp = 380; %in seconds
    %--Prop_Nums.ROx_RAT = 6.0; %Ratio, 6kg fuel to 1kg oxidizer
    %--Prop_Nums.InertM_Rat = 0.17; %percentage, 0-1
    % new propulsion logic
    prop_inst = Propulsion.NTR;
   
    %--would be defined in trans hab module
    SC_Inst = SC_Class;
    SC_Inst.Payload_M = 30000; %kg
    SC_Inst.Hab_M = 2500; %kg
    
    %--would be delivered by trajectory module
    dV = 6; %km/s
%}
%-----Testing-----

%-----Constants-----
g0=0.0098665; %km/s^2
e=2.71828182845904523536028747135266249;
%-----Constants-----

%Convergent loop
converge_to = 0.0000001; %set convergence limit in difference percent
tic
converge = 1; %initialize convergence factor
last = 0; %initialize tracking variable
Eng_Mass = 0; %initialize engine mass for 1st iteration
it = 0; %counting variable
while converge > converge_to
    %sum rocket parts to see final mass
    Final_M = Eng_Mass + SC_Inst.Payload_M + SC_Inst.Hab_M + prop_inst.StaticMass;
    %evaluate the rocket equation for fuel mass
    Prop_Mass=e^(((dV)/(g0*prop_inst.Isp)))*(Final_M)-Final_M;
    %Rocket_Eqn == dV = propulsion.Isp*g0*log((Eng_Mass+SC_Inst.Payload_Mass+fuel_mass)/(Eng_Mass+SC_Inst.Payload_Mass))
    %Prop_Mass = solve(Rocket_Eqn, fuel_mass)
    %evaluate engine mass and determine SpaceCraft Mass
    Eng_Mass = Prop_Mass * prop_inst.InertMassRatio;
    SC_Mass = Prop_Mass + Eng_Mass + prop_inst.StaticMass + SC_Inst.Payload_M + SC_Inst.Hab_M;
    
    %compare results to last iteration
    converge = (SC_Mass - last) / SC_Mass;
    last = SC_Mass; %set tracking variable to this iteration
    it = it + 1;

end

%put solutions into spacecraft object by using the origin_def method for
%the SC_Class
SC_Inst.origin_def (SC_Mass, Prop_Mass, prop_inst.FuelOxRatio);

%{
%----debugging outputs
Prop_Loop_time_in_seconds = toc
disp('Iterations: ')
disp(it)
disp('Fueled Spacecraft Mass in kg:')
disp(SC_Inst.Origin_M)
%}
end