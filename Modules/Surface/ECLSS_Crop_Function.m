function [ECLSS_Crop] = ECLSS_Crop_Function(MARS_2040)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%This code is calculating the mass requirements for the consumables, spares 
%and equipment for ECLSS.   

%------Inputs------
%MARS_2040.Food_Supply = 0.5;
%MARS_2040.Crew_Size = 18;
%MARS_2040.Surface_Duration;

%------Outputs------


%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.

Crop_Constant_Values = xlsread('Habitat Resource Analysis_v5.xlsx',5,'E4:L16');

%------------------------------------------------------------------------

%Calculations begin

Crop_Grow_Area.Carrot = Crop_Constant_Values(1,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Dry_Bean = Crop_Constant_Values(2,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Green_Onion = Crop_Constant_Values(3,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Lettuce = Crop_Constant_Values(4,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Peanut = Crop_Constant_Values(5,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Radish = Crop_Constant_Values(6,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Rice = Crop_Constant_Values(7,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Soybean = Crop_Constant_Values(8,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Spinach = Crop_Constant_Values(9,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Sweet_Potato = Crop_Constant_Values(10,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Tomato = Crop_Constant_Values(11,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Wheat = Crop_Constant_Values(12,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.White_Potato = Crop_Constant_Values(13,1)*(MARS_2040.Crew_Size/4)*MARS_2040.Food_Supply;
Crop_Grow_Area.Overall = sum(cell2mat(struct2cell(Crop_Grow_Area)));

Crop_O2_Generation.Carrot = Crop_Constant_Values(1,6)*Crop_Grow_Area.Carrot/1000;
Crop_O2_Generation.Dry_Bean = Crop_Constant_Values(2,6)*Crop_Grow_Area.Dry_Bean/1000;
Crop_O2_Generation.Green_Onion = Crop_Constant_Values(3,6)*Crop_Grow_Area.Green_Onion/1000;
Crop_O2_Generation.Lettuce = Crop_Constant_Values(4,6)*Crop_Grow_Area.Lettuce/1000;
Crop_O2_Generation.Peanut = Crop_Constant_Values(5,6)*Crop_Grow_Area.Peanut/1000;
Crop_O2_Generation.Radish = Crop_Constant_Values(6,6)*Crop_Grow_Area.Radish/1000;
Crop_O2_Generation.Rice = Crop_Constant_Values(7,6)*Crop_Grow_Area.Rice/1000;
Crop_O2_Generation.Soybean = Crop_Constant_Values(8,6)*Crop_Grow_Area.Soybean/1000;
Crop_O2_Generation.Spinach = Crop_Constant_Values(9,6)*Crop_Grow_Area.Spinach/1000;
Crop_O2_Generation.Sweet_Potato = Crop_Constant_Values(10,6)*Crop_Grow_Area.Sweet_Potato/1000;
Crop_O2_Generation.Tomato = Crop_Constant_Values(11,6)*Crop_Grow_Area.Tomato/1000;
Crop_O2_Generation.Wheat = Crop_Constant_Values(12,6)*Crop_Grow_Area.Wheat/1000;
Crop_O2_Generation.White_Potato = Crop_Constant_Values(13,6)*Crop_Grow_Area.White_Potato/1000;
Crop_O2_Generation.Overall = sum(cell2mat(struct2cell(Crop_O2_Generation)));

Crop_CO2_Generation.Carrot = Crop_Constant_Values(1,7)*Crop_Grow_Area.Carrot/1000;
Crop_CO2_Generation.Dry_Bean = Crop_Constant_Values(2,7)*Crop_Grow_Area.Dry_Bean/1000;
Crop_CO2_Generation.Green_Onion = Crop_Constant_Values(3,7)*Crop_Grow_Area.Green_Onion/1000;
Crop_CO2_Generation.Lettuce = Crop_Constant_Values(4,7)*Crop_Grow_Area.Lettuce/1000;
Crop_CO2_Generation.Peanut = Crop_Constant_Values(5,7)*Crop_Grow_Area.Peanut/1000;
Crop_CO2_Generation.Radish = Crop_Constant_Values(6,7)*Crop_Grow_Area.Radish/1000;
Crop_CO2_Generation.Rice = Crop_Constant_Values(7,7)*Crop_Grow_Area.Rice/1000;
Crop_CO2_Generation.Soybean = Crop_Constant_Values(8,7)*Crop_Grow_Area.Soybean/1000;
Crop_CO2_Generation.Spinach = Crop_Constant_Values(9,7)*Crop_Grow_Area.Spinach/1000;
Crop_CO2_Generation.Sweet_Potato = Crop_Constant_Values(10,7)*Crop_Grow_Area.Sweet_Potato/1000;
Crop_CO2_Generation.Tomato = Crop_Constant_Values(11,7)*Crop_Grow_Area.Tomato/1000;
Crop_CO2_Generation.Wheat = Crop_Constant_Values(12,7)*Crop_Grow_Area.Wheat/1000;
Crop_CO2_Generation.White_Potato = Crop_Constant_Values(13,7)*Crop_Grow_Area.White_Potato/1000;
Crop_CO2_Generation.Overall = sum(cell2mat(struct2cell(Crop_CO2_Generation)));

Crop_Water_Generation.Carrot = Crop_Constant_Values(1,8)*Crop_Grow_Area.Carrot;
Crop_Water_Generation.Dry_Bean = Crop_Constant_Values(2,8)*Crop_Grow_Area.Dry_Bean;
Crop_Water_Generation.Green_Onion = Crop_Constant_Values(3,8)*Crop_Grow_Area.Green_Onion;
Crop_Water_Generation.Lettuce = Crop_Constant_Values(4,8)*Crop_Grow_Area.Lettuce;
Crop_Water_Generation.Peanut = Crop_Constant_Values(5,8)*Crop_Grow_Area.Peanut;
Crop_Water_Generation.Radish = Crop_Constant_Values(6,8)*Crop_Grow_Area.Radish;
Crop_Water_Generation.Rice = Crop_Constant_Values(7,8)*Crop_Grow_Area.Rice;
Crop_Water_Generation.Soybean = Crop_Constant_Values(8,8)*Crop_Grow_Area.Soybean;
Crop_Water_Generation.Spinach = Crop_Constant_Values(9,8)*Crop_Grow_Area.Spinach;
Crop_Water_Generation.Sweet_Potato = Crop_Constant_Values(10,8)*Crop_Grow_Area.Sweet_Potato;
Crop_Water_Generation.Tomato = Crop_Constant_Values(11,8)*Crop_Grow_Area.Tomato;
Crop_Water_Generation.Wheat = Crop_Constant_Values(12,8)*Crop_Grow_Area.Wheat;
Crop_Water_Generation.White_Potato = Crop_Constant_Values(13,8)*Crop_Grow_Area.White_Potato;
Crop_Water_Generation.Overall = sum(cell2mat(struct2cell(Crop_Water_Generation)));

Crop_Stock_Solution.Carrot = Crop_Constant_Values(1,8)*0.034/0.34;
Crop_Stock_Solution.Dry_Bean = Crop_Constant_Values(2,8)*0.026/0.32;
Crop_Stock_Solution.Green_Onion = Crop_Constant_Values(3,8)*0.034/0.34;
Crop_Stock_Solution.Lettuce = Crop_Constant_Values(4,8)*0.034/0.34;
Crop_Stock_Solution.Peanut = Crop_Constant_Values(5,8)*0.022/0.15;
Crop_Stock_Solution.Radish = Crop_Constant_Values(6,8)*0.034/0.34;
Crop_Stock_Solution.Rice = Crop_Constant_Values(7,8)*0.021/0.13;
Crop_Stock_Solution.Soybean = Crop_Constant_Values(8,8)*0.026/0.32;
Crop_Stock_Solution.Spinach = Crop_Constant_Values(9,8)*0.034/0.34;
Crop_Stock_Solution.Sweet_Potato = Crop_Constant_Values(10,8)*0.022/0.15;
Crop_Stock_Solution.Tomato = Crop_Constant_Values(11,8)*0.034/0.34;
Crop_Stock_Solution.Wheat = Crop_Constant_Values(12,8)*0.021/0.13;
Crop_Stock_Solution.White_Potato = Crop_Constant_Values(13,8)*0.022/0.15;
Crop_Stock_Solution.Overall = sum(cell2mat(struct2cell(Crop_Water_Generation))); % Units: L/day
Crop_Stock_Solution.Overall = Crop_Stock_Solution.Overall * MARS_2040.Surface_Duration; %Units: kg/mission

Crop_Acid_Usage.Carrot = Crop_Constant_Values(1,8)*0.0618/0.34*Crop_Grow_Area.Carrot;
Crop_Acid_Usage.Dry_Bean = Crop_Constant_Values(2,8)*0.0548/0.32*Crop_Grow_Area.Dry_Bean;
Crop_Acid_Usage.Green_Onion = Crop_Constant_Values(3,8)*0.0618/0.34*Crop_Grow_Area.Green_Onion;
Crop_Acid_Usage.Lettuce = Crop_Constant_Values(4,8)*0.0618/0.34*Crop_Grow_Area.Lettuce;
Crop_Acid_Usage.Peanut = Crop_Constant_Values(5,8)*0.0428/0.15*Crop_Grow_Area.Peanut;
Crop_Acid_Usage.Radish = Crop_Constant_Values(6,8)*0.0618/0.34*Crop_Grow_Area.Radish;
Crop_Acid_Usage.Rice = Crop_Constant_Values(7,8)*0.0744/0.13*Crop_Grow_Area.Rice;
Crop_Acid_Usage.Soybean = Crop_Constant_Values(8,8)*0.0548/0.32*Crop_Grow_Area.Soybean;
Crop_Acid_Usage.Spinach = Crop_Constant_Values(9,8)*0.0618/0.34*Crop_Grow_Area.Spinach;
Crop_Acid_Usage.Sweet_Potato = Crop_Constant_Values(10,8)*0.0428/0.15*Crop_Grow_Area.Sweet_Potato;
Crop_Acid_Usage.Tomato = Crop_Constant_Values(11,8)*0.0618/0.34*Crop_Grow_Area.Tomato;
Crop_Acid_Usage.Wheat = Crop_Constant_Values(12,8)*0.0744/0.13*Crop_Grow_Area.Wheat;
Crop_Acid_Usage.White_Potato = Crop_Constant_Values(13,8)*0.0428/0.15*Crop_Grow_Area.White_Potato;
Crop_Acid_Usage.Overall = sum(cell2mat(struct2cell(Crop_Water_Generation))); %Units: g/day
Crop_Acid_Usage.Overall = Crop_Acid.Usage.Overall * MARS_2040.Surface_Duration/1000; %Units: kg/mission

ECLSS_Crop.Crop_Grow_Area = Crop_Grow_Area.Overall;
ECLSS_Crop.Crop_O2_Generation = Crop_O2_Generation.Overall;
ECLSS_Crop.Crop_CO2_Generation = Crop_CO2_Generation.Overall;
ECLSS_Crop.Crop_Water_Generation = Crop_Water_Generation.Overall;
ECLSS_Crop.Stock_Solution = Crop_Stock_Solution.Overall;
ECLSS_Crop.Acid_Usage = Crop_Acid_Usage.Overall;

end

