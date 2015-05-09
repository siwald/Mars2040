function [Results,Food_Time,ISRU_Requirements] = Surface_Habitat(Cur_Arch, Results)

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
BVAD.Facilities = 185.13; %Units: m^3; There are 5 facilities in BVAD design with 4 astronauts. For our study we still would use 5 facilities but multiply this value by 5 to account for 20 astronauts instead of 4. 
BVAD.Tunnel = 263.43; %Units: m^3; The tunnel will not be affected by the increase in astronauts. 
BVAD.Airlock = 48; %Units: m^3; The airlock will not be affected by the increase in astronauts.
Inflatable_Ratio = 21.13; %Units: kg/m^3; This is based off the Transhab used for ISS. 
Inflatable_Weight_Advantage = 50;  %Units: %; Source:http://www.marshome.org/files2/Fisher.pdf. Inflatable habitats are 30-50% lighter than Hard Aluminum structures 
Thermal_Cost = 0.006849315; %kW/kg; This value is from BVAD 2015 table 3.17. 

MARS2040.Crew_Size = Crew_Size;
[a,FoodSupply] = Cur_Arch.FoodSupply.Amount;
MARS2040.Food_Supply = FoodSupply;
MARS2040.Surface_Duration = 500;

GreenHouse_Crop = ECLSS_Crop_Function(MARS2040);
GreenHouse_Area = GreenHouse_Crop.Crop_Grow_Area;

LAVAPOLIS.SectionOne = 71.0613; %Units: m^3/CM; Prairie View A&M Mars Habitat study was used. They designed an inflatable structure for 20 crew. 
LAVAPOLIS.SectionTwo = 56.034; %Units: m^3/CM; Prairie View A&M Mars Habitat study was used. They designed an inflatable structure for 20 crew. 
LAVAPOLIS.SectionThree = 37.82295; %Units: m^3/CM; Prairie View A&M Mars Habitat study was used. They designed an inflatable structure for 20 crew. 
LAVAPOLIS.SectionFour = 71.0613; %Units: m^3/CM; Prairie View A&M Mars Habitat study was used. They designed an inflatable structure for 20 crew. 
LAVAPOLIS.GreenHouse = GreenHouse_Area * 9 * 0.0283; %Units: m^3; %Units: m^3/CM; This is from ECLSS and accounts for 20 CM.
LAVAPOLIS.Tunnel = 28.3; %Units: m^3/CM/Hall; Prairie View A&M Mars Habitat study was used. They designed an inflatable structure for 20 crew.
LAVAPOLIS.Airlock = 28.3; %Units: m^3/CM/Airlock; Prairie View A&M Mars Habitat study was used. They designed an inflatable structure for 20 crew.

Marineris.Gym = 137.538; %Units: m^3; This is based off a typical large recreational room. Equipment: 2 Treadmills, 1 Elliptical, 1 Bike, 1 Adjustable Cable Crossover with Chin up Bar, 1 Lat Pulldown/Low Row Combo, 1 Leg Extension/Prone Leg Curl Combo, 1 Flat/Incline Bench, 1 Dumbbell set, 1 dumbbell rack
% Marineris.ECLSS = 37.82295; %Units: m^3; This is based off the ECLSS study and accounts for 20 CM
Marineris.GreenHouse = GreenHouse_Area * 9 * 0.0283; %Units: m^3; This is from ECLSS and accounts for 20 CM.
Marineris.Airlock = 48; %Units: m^3; This is based of the BVAD value
Marineris.EVA_Prep = 20.376*2; %Units: m^3/5 CM; This is based off a large utility/mud room, Initial estimate is for 5 crew members and the initial tradespace assumption is to have 10 CM/EVA therefore it will be doubled.
Marineris.Office = 64.1844; %Units: m^3; This is based off a typcial large Home office/work room
Marineris.Medical = 213.948; %Units: m^3/3CM; This is based off the typcial size of a large bedroom x 3(3 seperate medical rooms) and a large storage room for the equipment
Marineris.Lab = 144.6696; %Units: m^3; This is based off the size of a typical 2 car garage + storage closet. The science equipment will need more space than a room in a house. 
Marineris.Kitchen = 132.444; %Units: m^3/5 CM; This is based off the size of a large kitchen + pantry + eat area. This is for a typical household therefore these values will be based off approximately 5 people (typical large family)
Marineris.Bathroom = 24.4512; %Units: m^3; This is based off the size of a large full bathroom
Marineris.Bedroom = 64.1844; %Units: m^3; This is based off the size of a large guest bedroom
Marineris.Entertainment = 156.8952; %Units: m^3; This is based off the size of a large living room
Marineris.Storage = 42.7896; %Units: m^3; This is based off the size of a large storage room
Marineris.Laundry = 20.376; %Units: m^3; This is based off the size or a large laundry room

%Surface_Radiation = 0.7; %Units: msv/day; This is based off the curiosity rover
Regolith_Constant = 9.157; %Units: kg/m^3; BVAD study
%------------------------------------------------------------------------

%Calculations begin

DesignChoice = 3; %Choose which Habitat design you want to use: 1 - BVAD, 2 - Prairie View A&M modified, 3 - Marineris

Solid_Ratio = (Inflatable_Ratio * (Inflatable_Weight_Advantage/100))+Inflatable_Ratio; %convert inflatable ratio to solid structure ratio.  

switch DesignChoice
    case 1
        Surf_Volume = ((BVAD.Facilities*5)*(Crew_Size/4))+BVAD.Tunnel + BVAD.Airlock; %For the baseline tradespace analysis the average volume of the Marsone study and BVAD study was used.
        
    case 2
        Surf_Volume = ((LAVAPOLIS.SectionOne + LAVAPOLIS.SectionTwo + LAVAPOLIS.SectionThree + LAVAPOLIS.SectionFour + LAVAPOLIS.GreenHouse) * Crew_Size)  + (LAVAPOLIS.Tunnel* 4) + (LAVAPOLIS.Airlock * 1);
        
    case 3
        if Crew_Size > 5
            Marineris.Kitchen = Marineris.Kitchen * (Crew_Size/5);
        else
            Marineris.Kitchen = Marineris.Kitchen;
        end
        Marineris.Medical = ceil(Marineris.Medical/3);
        Marineris.Storage = Marineris.Storage * (Crew_Size/5);
        Surf_Volume = (Marineris.Gym + Marineris.GreenHouse + Marineris.Airlock + Marineris.EVA_Prep + Marineris.Office + Marineris.Medical + Marineris.Lab + Marineris.Kitchen + ((Marineris.Bathroom*(Crew_Size/2+0.5))) + (Marineris.Bedroom*Crew_Size) + Marineris.Entertainment + Marineris.Storage + Marineris.Laundry);
end
        
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

Results.Surface_Habitat.Volume = Surf_Volume;
Results.Surface_Habitat.Mass = Surf_Mass;

[Food_Time,ISRU_Requirements] = ECLSS (Cur_Arch,Results);

switch DesignChoice
    case 1
        Surf_Volume = Surf_Volume;
        Surf_Mass = Surf_Mass;
    case 2
        Surf_Volume = Surf_Volume;
        Surf_Mass = Surf_Mass;
    case 3
        Surf_Volume = Surf_Volume + Results.ECLSS.Volume;
        Surf_Mass = Surf_Mass + Results.ECLSS.Mass;
end
        

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

%Surf_Power = (0.019*Surf_Mass); %Units: kW; 0.019 is worst case value from BVAD table 3.2.2 for surface power.
Surf_Power = Surf_Mass * Thermal_Cost;
Regolith_Mass = Regolith_Constant * Surf_Volume;

%MMSEV_Mass = 4000; %kg SEV total mass
%UtiliRover_Mass = 4000; %kg SEV Chassis + full payload of utility equipment
%Num_Sci_Rovers = ceil(Cur_Arch.SurfaceCrew.Size * 0.34); %based on DRA5, 2 rovers per 6 crew
%Num_Util_Rovers = floor(Cur_Arch.SurfaceCrew.Size * 0.34); %based on DRA5, 2 rovers per 6 crew
%BOM_Mass = 56.4; %kg, Bennet, 2006 pg. 13, RTG
%BOM_Power = 596/1000; %kW, Bennet, 2006, RTG

%Rovers_Mass = (MMSEV_Mass * Num_Sci_Rovers) + (UtiliRover_Mass * Num_Util_Rovers) + (BOM_Mass * (Num_Sci_Rovers + Num_Util_Rovers));

%% put into results


Results.Surface_Habitat.Volume = Surf_Volume;
Results.Surface_Habitat.Mass = Surf_Mass;
Results.Surface_Habitat.Power = Surf_Power;
Results.Regolith = Regolith_Mass;
end

