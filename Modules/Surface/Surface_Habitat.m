function Results = Surface_Habitat(Cur_Arch, Results)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%Surface Habitat is solving for the Mass, Volume, and power required to
%sustain the lifes of 20 people on Mars. The values in this module are
%based off previous studies. The initial volume is a combination of the
%Marsone study and the BVAD document from NASA. 

%------Inputs------

% Percentage of food supply grown on Mars
% Cur_Arch{1} = 'FIXED_SHELL';
% Cur_Arch{2} = 'INFLATABLE';
% Cur_Arch{3} = 0.5;
% Cur_Arch{4} = 0.5;

%------Outputs------

%This module will output the SWAP values for the surface architecture. This
%modules includes the radiation protection and habitat structure. The food,
%parts, etc requirements are included in the other modules. 

%Surf_Mass;
%Surf_Volume;
%Surf_Power;

%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.

Crew_Size = Cur_Arch.SurfaceCrew.Size; %Units: Crew Members; Mission Decision
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

for n = 1:2
    StructureType = char(Cur_Arch.SurfaceStructure{n});
    %StructureType = Cur_Arch{n};
    switch StructureType
        case 'FIXED_SHELL'
            Solid_Mass = (Surf_Volume * Cur_Arch.SurfaceStructure{n+2}) * Solid_Ratio;
            %Solid_Mass = (Surf_Volume * Cur_Arch{n+2}) * Solid_Ratio;
        case 'INFLATABLE'
            Inflatable_Mass = (Surf_Volume * Cur_Arch.SurfaceStructure{n+2}) * Inflatable_Ratio;
            %Inflatable_Mass = (Surf_Volume * Cur_Arch{n+2}) * Inflatable_Ratio;
        otherwise
            error('Structure not defined properly in Matrix, should be: Fixed_Shell or Inflatable');
    end
end

Surf_Mass = Solid_Mass + Inflatable_Mass;

% switch Cur_Arch.SurfaceStructure
%     
%     case 'Hybrid'
%         Inflatable_Mass = (BVAD.Tunnel + (BVAD.Facilities*(Crew_Size/4))) * Inflatable_Ratio;
%         Solid_Mass = (Surf_Volume - (BVAD.Tunnel + (BVAD.Facilities*(Crew_Size/4)))) * Solid_Ratio;
%         Surf_Mass = Inflatable_Mass + Solid_Mass;
% 
%         
%     case 'Inflatable'
%         Surf_Mass = Surf_Volume * Inflatable_Ratio;
%         
%     case 'Solid'
%         Surf_Mass = Surf_Volume * Solid_Ratio;
%         
%     otherwise
%         error('Power poorly defined in Morph Matrix, should be: Hybrid, Solar, Fuel Cells (H2O), RTGs, or Nuclear');
%         
% end

Surf_Power = (Internal_Thermal * Surf_Mass) + (External_Thermal * Surf_Mass) + (0.019*Surf_Mass); %Units: kW; 0.019 is worst case value from BVAD table 3.2.2 for surface power.
Regolith_Mass = Regolith_Constant * Surf_Volume;



%% put into results
Results.Surface_Habitat.Volume = Surf_Volume;
Results.Surface_Habitat.Mass = Surf_Mass;
Results.Surface_Habitat.Power = Surf_Power;
Results.Regolith = Regolith_Mass;
end

