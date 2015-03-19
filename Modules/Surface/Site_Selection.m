function [Site_Sci_Value] = Site_Selection(Cur_Arch)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%Site selection will use a case statement to output the calculated
%scientific value for the site that has been selected. Future development
%will output radiation exposure and other variables depending on altitude
%and cooridnates of each site. 

%------Inputs------

% Site selected in Morphological Matrix
Cur_Arch = 'Holden Crater'; 

%------Outputs------

%This module will output the scientific value for the site that is being
%evaluated. 

%Site_Sci_Value; % Site scientific value based on values in the site
%selection excel document. 

%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.

Crew_Size = 20; %Units: Crew Members; Mission Decision
Mars_One = 1000; %Units: m^3; The Marsone design accounts for 4 Crew Members; 
BVAD.Facilities = 185.13; %Units: m^3; There are 5 facilities in BVAD design with 4 astronauts. For our study we still would use 5 facilities but multiply this value by 5 to account for 20 astronauts instead of 4. 
BVAD.Tunnel = 263.43; %Units: m^3; The tunnel will not be affected by the increase in astronauts. 
BVAD.Airlock = 48; %Units: m^3; The airlock will not be affected by the increase in astronauts.
Inflatable_Ratio = 21.13; %Units: kg/m^3; This is based off the Transhab used for ISS. 
Inflatable_Weight_Advantage = 50;  %Units: %; Source:http://www.marshome.org/files2/Fisher.pdf. Inflatable habitats are 30-50% lighter than Hard Aluminum structures 
Internal_Thermal = 0.040; %Units: kW/kg; This is from BVAD table 3.2.9
External_Thermal = 0.0083; %Units: kW/kg; This is from BVAD table 3.2.9. Worst case for first spiral

%Surface_Radiation = 0.7; %Units: msv/day; This is based off the curiosity rover
Regolith_Constant = 9.157; %Units: kg/m^3; BVAD study
%------------------------------------------------------------------------

%Calculations begin

Surf_Volume = ((Mars_One*(Crew_Size/4))+(((BVAD.Facilities*5)*(Crew_Size/4))+BVAD.Tunnel + BVAD.Airlock))/2; %For the baseline tradespace analysis the average volume of the Marsone study and BVAD study was used.
Solid_Ratio = (Inflatable_Ratio * (Inflatable_Weight_Advantage/100))+Inflatable_Ratio; %convert inflatable ratio to solid structure ratio.  

switch Cur_Arch.SurfaceStructure
    
    case 'Hybrid'
        Inflatable_Mass = (BVAD.Tunnel + (BVAD.Facilities*(Crew_Size/4))) * Inflatable_Ratio;
        Solid_Mass = (Surf_Volume - (BVAD.Tunnel + (BVAD.Facilities*(Crew_Size/4)))) * Solid_Ratio;
        Surf_Mass = Inflatable_Mass + Solid_Mass;

        
    case 'Inflatable'
        Surf_Mass = Surf_Volume * Inflatable_Ratio;
        
    case 'Solid'
        Surf_Mass = Surf_Volume * Solid_Ratio;
        
    otherwise
        error('Power poorly defined in Morph Matrix, should be: Hybrid, Solar, Fuel Cells (H2O), RTGs, or Nuclear');
        
end

Surf_Power = (Internal_Thermal * Surf_Mass) + (External_Thermal * Surf_Mass) + (0.019*Surf_Mass); %Units: kW; 0.019 is worst case value from BVAD table 3.2.2 for surface power.
Regolith_Mass = Regolith_Constant * Surf_Volume;
Surf_Mass = Surf_Mass + Regolith_Mass;

end

