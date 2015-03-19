function [ SC_Inst ] = Propellant_Mass( prop_inst , SC_Inst , dV)
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
    SC_Inst.Payload_Mass = 30000; %kg
    SC_Inst.Hab_Mass = 2500; %kg
    
    %--would be delivered by trajectory module
    dV = 6; %km/s
%}
%-----Testing-----

%-----Constants-----
g0=0.0098665; %km/s^2
e=2.71828182845904523536028747135266249;
%-----Constants-----
%tic
%Convergent loop
converge_to = 0.0000001; %set convergence limit in difference percent
converge = 1; %initialize convergence factor
last = 0; %initialize tracking variable
if isempty(SC_Inst.Eng_Mass) %initialize engine mass for 1st iteration, if not re-used
    SC_Inst.Eng_Mass = 0;
end
it = 0; %counting variable
while converge > converge_to
    %sum rocket parts to see final mass
    Final_Mass = SC_Inst.Eng_Mass + SC_Inst.Payload_Mass + SC_Inst.Hab_Mass + prop_inst.StaticMass;
    
    %evaluate the rocket equation for fuel mass
    SC_Inst.Prop_Mass=e^(((dV)/(g0*prop_inst.Isp)))*(Final_Mass)-Final_Mass;
    
    %evaluate engine mass %determine SpaceCraft Origin Mass
    if (SC_Inst.Eng_Mass < (SC_Inst.Prop_Mass * prop_inst.InertMassRatio)) %don't overwrite if engine is already big enough
        SC_Inst.Eng_Mass = SC_Inst.Prop_Mass * prop_inst.InertMassRatio;
    end
    
    %determine SpaceCraft Origin Mass
    SC_Inst.Origin_Mass = SC_Inst.Prop_Mass + SC_Inst.Eng_Mass + prop_inst.StaticMass + SC_Inst.Payload_Mass + SC_Inst.Hab_Mass;
    
    %compare results to last iteration
    converge = (SC_Inst.Origin_Mass - last) / SC_Inst.Origin_Mass;
    last = SC_Inst.Origin_Mass; %set tracking variable to this iteration
    it = it + 1;

end

%fill out the rest of the SC class
SC_Inst.Bus_Mass = SC_Inst.Eng_Mass + prop_inst.StaticMass;
SC_Inst.Ox_Mass = SC_Inst.Prop_Mass * ((1 + prop_inst.FuelOxRatio) / prop_inst.FuelOxRatio);
SC_Inst.Fuel_Mass = SC_Inst.Prop_Mass * (prop_inst.FuelOxRatio / (1 + prop_inst.FuelOxRatio));

%{
%----debugging outputs
Prop_Loop_time_in_seconds = toc
disp('Iterations: ')
disp(it)
disp('Fueled Spacecraft Mass in kg:')
disp(SC_Inst.Origin_M)
%}
end

%% Antiquated Code
%{
  These solved the rocket equation with solve(), but it's faster to have
  reduced it algebraically so that Matlab just solves for SC_Inst.Prop_Mass.
    %Rocket_Eqn == dV = propulsion.Isp*g0*log((Eng_Mass+SC_Inst.Payload_Mass+fuel_mass)/(Eng_Mass+SC_Inst.Payload_Mass))
    %SC_Inst.Prop_Mass = solve(Rocket_Eqn, fuel_mass)
%}