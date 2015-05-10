
data = zeros(Num_Arches,18);
desc = struct('RunNo',{},'PropType',{},'TransitCrew',{},'SurfaceCrew',{},'FoodGrown',{},...
    'Staging',{},'TransitFuel',{},'TransitLOX',{},'ReturnFuel',{},'ReturnLOX',{},'Site',{},...
    'OrbitCapture',{},'IMLEO',{},'Consumables',{},'Spares',{},'SurfPower',{},'NumCargo',{},...
    'mCrewVehicle',{},'mPropCrewVehicle',{},...
    'mCargoVehicle',{},'mPropCargoVehicle',{},...
    'mAscentVehicle',{},'mPropAscentVehicle',{},...
    'LandedMass',{});

    for i=1:Num_Arches
    % Case Description
    desc(i).Site = Morph{i}.SurfaceSites.Name;
    desc(i).PropType = Morph{i}.PropulsionType;
    desc(i).FoodGrown = Morph{i}.FoodSupply(2).Amount;
    desc(i).Staging = Morph{i}.Staging.Name;
    desc(i).TransitCrew = Morph{i}.TransitCrew.Size;
    desc(i).SurfaceCrew = Morph{i}.SurfaceCrew.Size;
    desc(i).TransitFuel = Morph{i}.TransitFuel(1).Location.Name;
    desc(i).TransitLOX = Morph{i}.TransitFuel(2).Location.Name;
    desc(i).ReturnFuel = Morph{i}.ReturnFuel(1).Location.Name;
    desc(i).ReturnLOX = Morph{i}.ReturnFuel(2).Location.Name;
    desc(i).OrbitCapture = Morph{i}.OrbitCapture.Name;
    desc(i).Consumables = All_Results{i}.Consumables/1000;
    desc(i).Spares = All_Results{i}.Spares/1000;
    desc(i).SurfPower = All_Results{i}.Cum_Surface_Power;
    desc(i).IMLEO = All_Results{i}.IMLEO/1000;
    desc(i).NumCargo = All_Results{i}.Num_CargoSpacecraft;
    desc(i).mAscentVehicle = All_Results{i}.AscentSpacecraft.Mass/1000;
    desc(i).mPropAscentVehicle = All_Results{i}.AscentSpacecraft.Prop_Mass/1000;
    desc(i).mCargoVehicle = All_Results{i}.CargoSpacecraft.Mass/1000;
    desc(i).mPropCargoVehicle = All_Results{i}.CargoSpacecraft.Prop_Mass/1000;
    desc(i).mCrewVehicle = All_Results{i}.HumanSpacecraft.Mass/1000;
    desc(i).mPropCrewVehicle = All_Results{i}.HumanSpacecraft.Prop_Mass/1000;
    desc(i).RunNo = i;
    desc(i).LandedMass = (All_Results{i}.Consumables + All_Results{i}.AscentSpacecraft.Mass + All_Results{i}.Spares)/1000;
   
    % Joseph's Data Extraction for plots
    data(i,1) = All_Results{i}.HumanSpacecraft.Mass;
    data(i,2) = All_Results{i}.HumanSpacecraft.SC{1,1}.Origin_Mass;    % Transit Hab 
    data(i,3) = All_Results{i}.HumanSpacecraft.SC{2,1}.Origin_Mass;    % Return Engine
    data(i,4) = All_Results{i}.HumanSpacecraft.SC{3,1}.Origin_Mass;    % Earth Entry
    data(i,5) = All_Results{i}.HumanSpacecraft.SC{4,1}.Origin_Mass;    % Mars Capture
    data(i,6) = All_Results{i}.HumanSpacecraft.SC{5,1}.Origin_Mass;    % Dry Mass
    data(i,7) = All_Results{i}.CargoSpacecraft.Mass;
    data(i,8) = All_Results{i}.CargoSpacecraft.SC{1,1}.Origin_Mass;
    data(i,9) = All_Results{i}.CargoSpacecraft.SC{2,1}.Origin_Mass;
    data(i,10) = All_Results{i}.CargoSpacecraft.SC{3,1}.Origin_Mass;
    data(i,11) = All_Results{i}.Consumables;
    data(i,12) = All_Results{i}.Spares;
    data(i,13) = All_Results{i}.Cum_Surface_Power;
    data(i,14) = All_Results{i}.Science_Time;
    data(i,15) = All_Results{i}.IMLEO;
    data(i,16) = All_Results{i}.Num_CargoSpacecraft;
    data(i,17) = i;    
    data(i,18) = All_Results{i}.AscentSpacecraft.Mass;
end

% Write to Excel file for data review
xlswrite('All_Results{i}.xls',struct2cell(desc(:)).',1,'A2');

close all;

data = sortrows(data,15);

vehicles = zeros (size(data,1),4);
vehicles(:,1) = data(:,1);      % Crew Vehicle
vehicles(:,2) = data(:,7);      % Cargo Vehicle1
vehicles(:,3) = data(:,7).*fix(data(:,16)/2); % Cargo Vehicle2
vehicles(:,4) = data(:,7).*fix(data(:,16)/3); % Cargo Vehicle3

lmass = zeros (size(data,1),3);
lmass(:,1) = data(:,11);    % Consumables
lmass(:,2) = data(:,12);    % Spares
lmass(:,3) = data(:,18);    % Ascent SC

% Figure 1 -> Resupply Mass
figure;
bar (lmass/1000,'stacked');
grid;
title ('Resupply Mass (Spares, Consumables, Ascent SC)');
ylabel ('Mass (mt)');
legend ('Consumables Mass','Spare Mass','Ascent S/C','location','northeast')

% Figure 2 -> IMLEO
figure;
bar(vehicles/1000, 'stacked');
grid;
title ('IMLEO Sorted by Mass');
ylabel ('IMLEO');
legend ('Human Vehicle','Cargo Vehicle1','Cargo Vehicle2','Cargo Vehicle3','Location','northwest');

% Figure 3 -> 
figure;
scatter (data(:,14),data(:,15)/1000);
grid;
title ('IMLEO vs. Science Time');
xlabel ('Science Time per Synodic Period');
ylabel ('IMLEO (mt)');
