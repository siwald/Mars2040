function [ SC_Module ] = Propellant_Mass( prop_inst , SC_Module , dV, AdditionalSC_Mass)
%PROPELLANT_MASS Calculate the mass of the propellant needed for a maneuver
%   Calculating the necessary propellant mass from a Delta_V manuever and
%   the Isp of the fuel source.
%       UNITS
%       Delta_V in km/s
%       Fuel Isp in seconds
%       Final mass in kg

%  Rocket Equation (Isp version): dV = Isp*g0*ln(m0/m1)
%  Gravitational Constant, g0 = 9.80665 m/s^2 = 0.0098665 km/s^2


%-----Constants-----
g0=0.0098665; %km/s^2
e=2.71828182845904523536028747135266249;
%-----Constants-----

%----Initialize other SC Module stuff
if isempty(SC_Module.Bus_Mass)
    SC_Module.Bus_Mass = 0; %initialize Bus Mass if empty
end
SC_Module.Bus_Mass = SC_Module.Bus_Mass + prop_inst.StaticMass; %add engine Static Mass to bus mass.

%tic
%Convergent loop
converge_to = 0.0000001; %set convergence limit in difference percent
converge = 1; %initialize convergence factor
last = 0; %initialize tracking variable
if isempty(SC_Module.Eng_Mass) %initialize engine mass for 1st iteration, if not re-used
    SC_Module.Eng_Mass = 0;
end
it = 0;
while converge > converge_to
    %sum rocket parts to see final mass
    Final_Mass = nansum([SC_Module.Eng_Mass, SC_Module.Payload_Mass, SC_Module.Hab_Mass, SC_Module.Bus_Mass, AdditionalSC_Mass]);
    
    %evaluate the rocket equation for fuel mass
    SC_Module.Prop_Mass=e^(((dV)/(g0*prop_inst.Isp)))*(Final_Mass)-Final_Mass;
    
    %evaluate engine mass %determine SpaceCraft Origin Mass
    if (SC_Module.Eng_Mass < (SC_Module.Prop_Mass * prop_inst.InertMassRatio)) %don't overwrite if engine is already big enough
        SC_Module.Eng_Mass = SC_Module.Prop_Mass * prop_inst.InertMassRatio;
    end
    
    %determine SpaceCraft Origin Mass
    origin_calc(SC_Module)    
    %compare results to last iteration
    converge = (SC_Module.Origin_Mass - last) / SC_Module.Origin_Mass;
    last = SC_Module.Origin_Mass; %set tracking variable to this iteration
    it = it + 1;

end

%fill out the fuel vs ox split
SC_Module.Ox_Mass = SC_Module.Prop_Mass * (prop_inst.FuelOxRatio / (1 + prop_inst.FuelOxRatio));
SC_Module.Fuel_Mass = SC_Module.Prop_Mass * (1 / (1 + prop_inst.FuelOxRatio));

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