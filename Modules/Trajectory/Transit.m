function [ IMLEO ] = Transit( Orbit , Stage_Point, Destination, Fuel_Source, Final_Mass )
%TRANSIT Solving for the Mass to Orbit based on the staging points and fuel
%sources
%   Detailed explanation goes here

%------Inputs------
%{
Orbit = 'Hohmann';
Stage_Point = 'EML2';
Destination = 'LMO';
Fuel_Source = 'Moon';
Final_Mass = 5000; %kg
%}
Isp = 453.5; %seconds, SSME Vacuum Isp 
FOx_Ratio = 6; %SSME and stoichiometric optimal for LOX/LH2
              %both from https://engineering.purdue.edu/~propulsi/propulsion/rockets/liquids/ssme.html
%------Inputs------


%Get the propellant and departure masses based on the selected transit orbit
switch Orbit
    case 'Hohmann'
        Prop_Mass = Propellant_Mass(Hohm_Chart(Stage_Point,Destination),Isp,Final_Mass);
        Dep_Mass = Prop_Mass + Final_Mass;
    case 'Cycler_1L1'
        Approach_Vinf = 9.75; % McConaghy, Longuski & Byrnes
        %Here, 
        Departure_Vinf = 6.54;% McConaghy, Longuski & Byrnes
      
        disp('Not Yet')
    case 'Cycler_2L3'
        Approach_Vinf = 3.05; % McConaghy, Longuski & Byrnes
        Departure_Vinf = 5.65; % McConaghy, Longuski & Byrnes
        disp('Not Yet')
    case 'Elliptical'
        disp('Not Yet')
end

%Use the departure fuel needs and S/C mass to calc getting fuel to the S/C from the appropriate source
switch Fuel_Source
    case 'Earth'
        IMLEO = eval(Propellant_Mass(Hohm_Chart('LEO',Stage_Point),Isp,Dep_Mass) + Dep_Mass); %Get Departure Mass (already fueled up) to Staging Point
    case 'Moon'
        %Get the Fuel to the staging point
        Fuel_Mass = Prop_Mass / (1 + FOx_Ratio) ; %this much fuel
        From_Moon = Propellant_Mass(Hohm_Chart('Moon',Stage_Point),Isp,Fuel_Mass); %Plus this propellant from moon to stage
        Ox_to_Moon = From_Moon / (1 + FOx_Ratio) ; %Need this Ox shipped from IMLEO as Propellant for fuel transport
        Ox_Moon_IMLEO = Propellant_Mass(Hohm_Chart('LEO','Moon'),Isp,Ox_to_Moon) + Ox_to_Moon; %IMLEO of Ox to moon plus dV to get there
        
        
        %Get the Oxidizer and S/C to the staging point
        Ox_Mass = Prop_Mass - Fuel_Mass; %this much oxidizer to combine with the fuel from the moon
        S_C = Ox_Mass+Final_Mass;
        Stage_from_Earth = Propellant_Mass(Hohm_Chart('LEO',Stage_Point),Isp,S_C) + S_C; %IMLEO of S/C with Ox but no Fuel, plus dV to get to staging
        
        %Sum IMLEO to get everything to staging point
        IMLEO = eval(Ox_Moon_IMLEO + Stage_from_Earth); %Ox_Moon_IMLEO pushes fuel from moon to staging, Stage_From_Earth is the S/C without fuel at the staging point

disp('O2 from Moon ')
disp(eval(From_Moon))
end
end

