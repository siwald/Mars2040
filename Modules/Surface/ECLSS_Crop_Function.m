function [ECLSS_Crop] = ECLSS_Crop_Function(MARS_2040)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%This code is calculating the mass requirements for the consumables, spares 
%and equipment for ECLSS.   

%------Inputs------
%MARS_2040.Food_Supply = 0.5;
%MARS_2040.Crew_Size = 18;

%------Outputs------


%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.

Crop_Constant_Values = xlsread('Habitat Resource Analysis_v3.xlsx',5,'B4:L12');

%------------------------------------------------------------------------

%Calculations begin

Crop_Grow_Area.Peanut = Crop_Constant_Values(3,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Soybean = Crop_Constant_Values(5,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Sweet_Potato = Crop_Constant_Values(6,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Wheat = Crop_Constant_Values(8,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.White_Potato = Crop_Constant_Values(9,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Overall = sum(cell2mat(struct2cell(Crop_Grow_Area)));

Crop_O2_Generation.Peanut = Crop_Constant_Values(3,8)*Crop_Grow_Area.Peanut/1000;
Crop_O2_Generation.Soybean = Crop_Constant_Values(5,8)*Crop_Grow_Area.Soybean/1000;
Crop_O2_Generation.Sweet_Potato = Crop_Constant_Values(6,8)*Crop_Grow_Area.Sweet_Potato/1000;
Crop_O2_Generation.Wheat = Crop_Constant_Values(8,8)*Crop_Grow_Area.Wheat/1000;
Crop_O2_Generation.White_Potato = Crop_Constant_Values(9,8)*Crop_Grow_Area.White_Potato/1000;
Crop_O2_Generation.Overall = sum(cell2mat(struct2cell(Crop_O2_Generation)));

Crop_CO2_Generation.Peanut = Crop_Constant_Values(3,9)*Crop_Grow_Area.Peanut/1000;
Crop_CO2_Generation.Soybean = Crop_Constant_Values(5,9)*Crop_Grow_Area.Soybean/1000;
Crop_CO2_Generation.Sweet_Potato = Crop_Constant_Values(6,9)*Crop_Grow_Area.Sweet_Potato/1000;
Crop_CO2_Generation.Wheat = Crop_Constant_Values(8,9)*Crop_Grow_Area.Wheat/1000;
Crop_CO2_Generation.White_Potato = Crop_Constant_Values(9,9)*Crop_Grow_Area.White_Potato/1000;
Crop_CO2_Generation.Overall = sum(cell2mat(struct2cell(Crop_CO2_Generation)));

Crop_Water_Generation.Peanut = Crop_Constant_Values(3,10)*Crop_Grow_Area.Peanut;
Crop_Water_Generation.Soybean = Crop_Constant_Values(5,10)*Crop_Grow_Area.Soybean;
Crop_Water_Generation.Sweet_Potato = Crop_Constant_Values(6,10)*Crop_Grow_Area.Sweet_Potato;
Crop_Water_Generation.Wheat = Crop_Constant_Values(8,10)*Crop_Grow_Area.Wheat;
Crop_Water_Generation.White_Potato = Crop_Constant_Values(9,10)*Crop_Grow_Area.White_Potato;
Crop_Water_Generation.Overall = sum(cell2mat(struct2cell(Crop_Water_Generation)));

ECLSS_Crop.Crop_Grow_Area = Crop_Grow_Area.Overall;
ECLSS_Crop.Crop_O2_Generation = Crop_O2_Generation.Overall;
ECLSS_Crop.Crop_CO2_Generation = Crop_CO2_Generation.Overall;
ECLSS_Crop.Crop_Water_Generation = Crop_Water_Generation.Overall;

end

