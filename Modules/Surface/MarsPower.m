function [Results] = MarsPower(Cur_Arch, Results, MarsLat, varargin)

% MarsPowerMP.m
% Brayton Reactor vs Solar Sizing (MANUAL PLOTTING)
% Wilfredo 'Alex' Sanchez
% Created: 30 APR 2015
%  
% INPUT:
% Power Required (kWe)
% OUTPUT:
% Reactor System Mass (kg)
% Reactor System Volume (m^3)
% Thin-Film Solar System w/ Fuel Cell Storage Mass (kg)
% Thin-Film Solar System w/ Fuel Cell Storage Volume (m^3)
% Thin-Film Solar System w/ Battery Storage Mass (kg)
% Thin-Film Solar System w/ Battery Storage Volume (m^3)
%
% This sizing code method was developed in cooperation with the 
% MIT Mars2040 Study (2015) and uses information shared by Eric 
% Ward, Nathan Bower & Chris McCormick.
%
% Sources:
% Kerwin PT, Whitmarsh CL. A 1-Megawatt Reactor Design for 
% Brayton-Cycle Space Power Application.  Part 1 - Thermal 
% Analysis and Core Design.; 1969.
%
% Chang YI, LoPinto P, Konomura M, Cahalan J, Dunn F, Farmer M, 
% Krajtl L, Moisseytsev A, Momozaki Y, Sienicki J, et al. Small 
% Modular Fast Reactor design description. Argonne National Lab., 
% Argonne, IL (US); 2005.
%
% Silver M, Hofstetter W, Cooper C, Hoffman J. Comparative Analysis 
% of Power System Architectures: The Case of Human Mars Surface Missions. 
% In: Mars: Prospective Energy and Material Resources. 2009. p. 351–368.
%
% Cooper C, Hofstetter W, Hoffman JA, Crawley EF. Assessment of 
% Architectural Options for Surface Power Generation and Energy 
% Storage on Human Mars Missions. Acta Astronautica. 2010;66 p. 1106–1112.
Results.Cum_Surface_Power = nansum([Results.Surface_Habitat.Power, ...
    Results.ECLSS.Power, ...
    Results.Mars_ISRU.Power]); %Units: kW 
if ~isempty(varargin)%DRA5 comparison
    Results.Cum_Surface_Power = 26; %kW, use DRA5 number.
end
Power_Req = Results.Cum_Surface_Power;

% Power_Req = 100; % [0:100:1000]
% MarsLat = 20; % [-50:1:50]
% 
% Power_Req = [0:100:1000];
% MarsLat = 20;
% 
% Power_Req = 100; % [0:100:1000]
% MarsLat = [-50:1:50];



if Cur_Arch.SurfacePower == PowerSource.NUCLEAR
%% Reactor Section
% Rx CORE
Brayton_Eff = 0.24;
FuelDen = 0.96; %percent
UN_Energy = 65*(1000); %kW-days/kg
Rod_Number = 8;
Rod_Radius = 0.59*(1/100); %m
Neutron_Reflector_Thickness = 0.1; %m
BeO_Thickness = Neutron_Reflector_Thickness/2; %m
B4C_Thickness = Neutron_Reflector_Thickness/2; %m

% MATERIAL DENSITIES
B4C_Den = 2.52*(1/1000)*(100)^3; %kg/m3
BeO_Den = 3.0*(1/1000)*(100)^3; %kg/m3
UN_Den = 11300*FuelDen; %kg/m3
LiH_Den = 780; %kg/m3
Tung_Den = 19.25*(1/1000)*(100^3); %kg/m3
Rod_Den = BeO_Den; %kg/m3

% EFFECTIVE NEUTRON MULTIPLICATION FACTOR COEFFICIENTS
Sigma_a = 2.277*10^-2;
RSigma_f = 4.391*10^-2;
Sigma_tr = 3.84*10^-1;
D_sigs = 1/(3*Sigma_tr);

% NUCLEAR Rx
Duration_Yrs = 10; %yrs
Duration =Duration_Yrs*365; %days
Wire_Eff = 0.98;
Power_Tot = Power_Req./Wire_Eff; %kWe
Power_Thermal = Power_Tot./Brayton_Eff; %kWt
FuelMass = Power_Thermal.*Duration./UN_Energy; %kg
FuelVolume = FuelMass./UN_Den; %m3
FuelRadius = (FuelVolume./(2*pi)).^(1/3); %m
FuelHeight = 2*FuelRadius; %m
FuelRadiuscm = FuelRadius*100; %cm
FuelHeightcm = FuelHeight*100; %cm
Buckling = (2.405./FuelRadiuscm).^2 + (pi./FuelHeightcm).^2;
kEff = RSigma_f./(Sigma_a + D_sigs.*Buckling);
Rod_Vol = Rod_Number*(pi*Rod_Radius^2*FuelHeight); %m3
Rod_Mass = Rod_Vol*Rod_Den; %kg
Frame_Vol = FuelVolume + Rod_Vol; %m3
Frame_Radius = sqrt(Frame_Vol./(pi*FuelHeight)); %m
Core_Radius = Frame_Radius + Neutron_Reflector_Thickness; %m
Core_Height = FuelHeight + 2*Neutron_Reflector_Thickness; %m
Core_Volume = pi.*Core_Radius.^2.*Core_Height; %m3
B4C_Radius = Frame_Radius + B4C_Thickness; %m
B4C_Volume = pi.*(B4C_Radius.^2 - Frame_Radius.^2).*FuelHeight...
+ 2.*(pi.*B4C_Radius.^2.*B4C_Thickness); %m3
B4C_Mass = B4C_Volume*B4C_Den; %kg
BeO_Volume = pi.*(Core_Radius.^2 - B4C_Radius.^2).*FuelHeight...
+ 2.*(pi.*Core_Radius.^2.*BeO_Thickness); %m3
BeO_Mass = BeO_Volume*BeO_Den; %kg
Neutron_Reflector_Mass = B4C_Mass + BeO_Mass; %kg
Core_Mass = FuelMass + Rod_Mass + Neutron_Reflector_Mass; %kg

% RADIATION SHIELDING
Li_Shield_Thck = .10; %m
Li_Shield_Vol = Li_Shield_Thck.*(1/2.*((2.*Core_Radius).*1.1)).^2.*pi; %m^3
Li_Shield_Mass = Li_Shield_Vol*LiH_Den; %kg
ThermEff = Power_Tot./((0.24/100).*((Power_Tot-0)./Power_Tot)); % efficiency
Gamma_Radiation_Flux = ((ThermEff/1000)*(2.3*10^3)/2.3)/...
(4*pi*(1/2*Li_Shield_Thck)^2)*3600*24*7; %rad / wk
Gamma_Reduction = 0.1./Gamma_Radiation_Flux; %rad / wk
Tung_Shield_Thck = -8.12982207e-1.*log(Gamma_Reduction); %cm
Tung_Shield_Thck = Tung_Shield_Thck/100; %m
Tung_Shield_Vol = Tung_Shield_Thck.*(1/2.*(2.*Core_Radius).*1.25).^2*pi; %m^3
Tung_Shield_Mass = Tung_Shield_Vol.*Tung_Den; %kg
Shield_Mass = Tung_Shield_Mass + Li_Shield_Mass; %kg
Shield_Volume = Tung_Shield_Vol + Li_Shield_Vol; %m^3

% BRAYTON ENGINE
Mass_Brayton_1 = 41.973.*(Power_Tot.^0.5832); %kg
Mass_Brayton_2 = 10.155.*(Power_Tot.^-0.3719).*Power_Tot; %kg
Mass_Brayton = (Mass_Brayton_1+Mass_Brayton_2)/2; %kg
Width_Brayton = 2/1000.*Power_Tot.^0.88; %m
Height_Brayton = 2/1000.*Power_Tot.^0.88; %m
Length_Brayton = 3/1000.*Power_Tot.^0.88; %m
Volume_Brayton = Width_Brayton.*Height_Brayton.*Length_Brayton; %m3

% RECOUPERATOR
Mass_Recoup_1 = 41.973*Power_Tot.^0.5832; %kg/kWe
Mass_Recoup_2 = 17.236.*(Power_Tot./0.24).^-0.5566.*(Power_Tot./0.24); %kg/kWth
Mass_Recoup = (2*Mass_Recoup_1 + Mass_Recoup_2)/3; %kg
Width_Recoup = Mass_Recoup/486.15; %m,
Height_Recoup = Mass_Recoup/344.23; %m
Length_Recoup = Mass_Recoup/192.68; %m
Volume_Recoup = Width_Recoup.*Height_Recoup.*Length_Recoup; %m^3

% RADIATOR
% (100 kWe Design)
Rad_Mass100 = 720; %kg
Rad_Vol100 = 1.728; %m^3
Rad_Area100 = 22.43; %m^2
Radiator_Mass = (Power_Req./100)*Rad_Mass100; %kg
Radiator_Volume = (Power_Req./100)*Rad_Vol100; %m^3
Radiator_Area = (Power_Req./100)*Rad_Area100; %m^2

% REACTOR MASS & VOLUME
RxMass = (Radiator_Mass+Mass_Recoup+Mass_Brayton...
+Shield_Mass+Core_Mass)*3; %kg
RxVolume = (Radiator_Volume+Volume_Recoup+Volume_Brayton...
+Shield_Volume+Core_Volume)*3; %m^3

% % SPECIFIC POWER INTERPOLATION
% RxMassSP = (Power_Req.*1000)/RxMass; %W/kg
% RxVolSP = (Power_Req.*1000)/RxVolume; %W/m^3

PowerPlant_Distance = 3000; %Units: m; distance from power plant to habitat, DRA5, no sheild
PowerCable_Mass = (0.11446*PowerPlant_Distance);

Results.PowerPlant.Mass = RxMass + PowerCable_Mass;
Results.PowerPlant.Volume = RxVolume;


elseif Cur_Arch.SurfacePower == PowerSource.SOLAR
%% Solar Section
% SOLAR POWER VS MARS LATITUDE
MarsLatT = [-60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -10 -5 0 5 10 15 20 25 30 35 40 45 50 55 60];
RFCMassT = [4.845010567 7.833596698 9.841331374 11.31986659 12.46520732 13.40169797 14.18348732 14.86331412 15.46299724 16.00481623 16.49705038 16.94919278 17.36792385 17.75014533 18.09149292 18.37767261 18.56919109 18.61464779 18.3097226 16.33125137 15.05009617 13.75409675 12.11506707 9.832893282 6.283439143];
%Solar w/ Regenerative Fuel Cell Storage - Mass Specific Power (W/kg)
RFCVolT = [291.7468514 527.2660964 716.7809428 875.6959312 1011.727129 1132.201472 1239.729571 1338.690399 1430.458445 1517.144652 1599.182895 1677.41138 1752.437133 1823.276943 1888.668668 1945.467704 1985.668067 1998.58092 1945.284234 1599.118296 1390.217495 1196.965702 979.633325 721.094657 400.0783237];
%Solar w/ Regenerative Fuel Cell Storage - Volume Specific Power (W/m^3)
BattMassT = [4.364712409 6.67559655 8.104392063 9.103719142 9.850820857 10.44611402 10.93315193 11.35002896 11.71295531 12.03727493 12.3290483 12.59478129 12.83897158 13.06013452 13.25602269 13.41847127 13.52437953 13.5440157 13.35682488 12.17109275 11.40516687 10.61699711 9.586809323 8.07482646 5.498705418];
%Solar w/ Lithium-Ion Battery Storage - Mass Specific Power (W/kg)
BattVolT = [292.6896298 530.2758055 722.2615266 883.7864188 1022.433241 1145.511762 1255.589822 1357.08213 1451.354303 1540.542658 1625.070869 1705.783305 1783.291738 1856.567668 1924.290231 1983.18504 2024.931397 2038.410783 1983.265893 1625.565605 1410.458251 1212.11723 989.8947949 726.7352519 401.8533821];
%Solar w/ Lithium-Ion Battery Storage - Volume Specific Power (W/m^3)

% SPECIFIC POWER INTERPOLATION
RFCMassSP = interp1(MarsLatT,RFCMassT,MarsLat); %W/kg
RFCVolSP = interp1(MarsLatT,RFCVolT,MarsLat); %W/m^3
BattMassSP = interp1(MarsLatT,BattMassT,MarsLat); %W/kg
BattVolSP = interp1(MarsLatT,BattVolT,MarsLat); %W/m^3

% SOLAR MASS & VOLUME
RFCMass = (Power_Req.*1000)./RFCMassSP; %kg
RFCVol = (Power_Req.*1000)./RFCVolSP; %m^3
BattMass = (Power_Req.*1000)./BattMassSP; %kg
BattVol = (Power_Req.*1000)./BattVolSP; %m^3

Results.PowerPlant.Mass = RFCMass;
Results.PowerPlant.Volume = RFCVol;

end

% POWER DENSITY
% RxPD = RxMass./RxVolume; %kg/m^3
% RFCPD = RFCMass./RFCVol; %kg/m^3
% Batt = BattMass./BattVol; %kg/m^3

% OUTPUT DISPLAY
% fprintf('\nTOTAL MASS & VOLUME')
% fprintf('\n-----------------------------')
% fprintf('\nReactor Mass is %4.2f kg.\n',RxMass)
% fprintf('Reactor Volume is %4.2f m^3.\n',RxVolume)
% fprintf('Solar-RFC Mass is %4.2f kg.\n',RFCMass)
% fprintf('Solar-RFC Volume is %4.2f m^3.\n',RFCVol)
% fprintf('Solar-Batt Mass is %4.2f kg.\n',BattMass)
% fprintf('Solar-Batt Volume is %4.2f m^3.\n',BattVol)
% 
% fprintf('\nSPECIFIC POWER')
% fprintf('\n-----------------------------')
% fprintf('\nReactor Mass SP is %4.2f W/kg.\n',RxMassSP)
% fprintf('Reactor Volume SP is %4.2f W/m^3.\n',RxVolSP)
% fprintf('Solar-RFC Mass SP is %4.2f W/kg.\n',RFCMassSP)
% fprintf('Solar-RFC Volume SP is %4.2f W/m^3.\n',RFCVolSP)
% fprintf('Solar-Batt Mass SP is %4.2f W/kg.\n',BattMassSP)
% fprintf('Solar-Batt Volume SP is %4.2f W/m^3.\n',BattVolSP)

% PLOTTING
% plot(Power_Req,RxMass,'--',Power_Req,RFCMass,'-',Power_Req,BattMass,':')
% title('Req Pwr vs Mass @ 20N'), xlabel('Power'),ylabel('Mass')
% legend('RxMass','RFCMass','BattMass')
%
% plot(RxMassSP,RxVolSP,'--',RFCMassSP,RFCVolSP,'-',BattMassSP,BattVolSP,':')
% title('Energy Density @ 100kW'), xlabel('Mass SP (W/kg)'),ylabel('Volume SP (W/m^3)')
% legend('Reactor','RFC','Batt')



end
