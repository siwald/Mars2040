%% Results Section
val = zeros(1, Num_Arches); %initialize value vector
time = zeros(1, Num_Arches);
Im = zeros(1,Num_Arches); %ititialize IMLEO vector
marsox = zeros(1,Num_Arches);
marsh2 = zeros(1,Num_Arches);
LCC_Prox = zeros(1,Num_Arches);
Infra = zeros(1,Num_Arches);
LandedCargo = zeros(1,Num_Arches);
LandedHumans = zeros(1,Num_Arches);
AscentMass = zeros(1,Num_Arches);
HumanMass = zeros(1,Num_Arches);
CargoMass = zeros(1,Num_Arches);
MAMA = zeros(1,Num_Arches);
HumanMALMO = zeros(1,Num_Arches);
CargoMALMO = zeros(1,Num_Arches);
PowerMass = zeros(1,Num_Arches);


for i=1:Num_Arches
    val(i) = All_Results{i,1}.Science;
    time(i) = All_Results{i}.Science_Time;
    Im(i) = All_Results{i,1}.IMLEO;
    marsox(i) = nansum([All_Results{i,1}.Mars_ISRU.Oxidizer_Output]);
    marsh2(i) = nansum([All_Results{i,1}.Mars_ISRU.Fuel_Output]);
    Infra(i) = nansum([All_Results{i,1}.Surface_Habitat.Mass,All_Results{i,1}.ECLSS.Mass, ...
        All_Results{i,1}.Mars_ISRU.Mass, All_Results{i,1}.Lunar_ISRU.Mass, All_Results{i,1}.ISFR.Mass, ...
        All_Results{i,1}.PowerPlant.Mass, ...
        All_Results{i}.FerrySpacecraft.Static_Mass, All_Results{i}.FerrySpacecraft.Eng_Mass, All_Results{i}.FerrySpacecraft.Bus_Mass]);
    LCC_Prox(i) = Infra(i) + (6 * All_Results{i}.IMLEO);
    MarsInfra(i) = Infra(i) - nansum([All_Results{i,1}.Lunar_ISRU.Mass]);
    LandedCargo(i) = All_Results{i}.CargoSpacecraft.SC{1}.Payload_Mass + All_Results{i}.HumanSpacecraft.SC{3}.Origin_Mass;
    LandedHumans(i) = All_Results{i}.HumanSpacecraft.SC{4}.Origin_Mass - (All_Results{i}.HumanSpacecraft.SC{4}.Dry_Mass + All_Results{i}.HumanSpacecraft.SC{4}.Static_Mass);
    AscentMass(i) = All_Results{i}.AscentSpacecraft.Mass;
    HumanMass(i) = All_Results{i}.HumanSpacecraft.Mass;
    CargoMass(i) = All_Results{i}.CargoSpacecraft.Mass;
    PowerMass(i) = All_Results{i}.PowerPlant.Mass;

end
% disp
% hold off;
% xaxis = Infra;
% xlab = 'Infrastructure';
% scatter(xaxis,Im);
% hold on;
% %scatter(250000,30000,'d');
% ylabel('IMLEO');
% xlabel(xlab);

%% Morph Section
val = zeros(1, Num_Arches); %initialize value vector
Im = zeros(1,Num_Arches); %ititialize IMLEO vector

crew = zeros(1,Num_Arches);
surfcrew = zeros(1,Num_Arches);
crater = zeros(1,Num_Arches);
food = zeros(1,Num_Arches);
stage = zeros(1,Num_Arches);
power = zeros(1,Num_Arches);
prop = zeros(1,Num_Arches);
cap = zeros(1,Num_Arches);
transfuel = zeros(1,Num_Arches);
returnfuel = zeros(1,Num_Arches);
cumpower = zeros(1,Num_Arches);
ch4 = zeros(1,Num_Arches);
stay = zeros(1,Num_Arches);
isrupower = zeros(1,Num_Arches);
forceCH4 = zeros(1,Num_Arches);
forceISRU = zeros(1,Num_Arches);

for i=1:Num_Arches
    val(i) = All_Results{i,1}.Science;
    Im(i) = All_Results{i,1}.IMLEO;
    isrupower(i) = nansum([All_Results{i}.Mars_ISRU.Power]);
    forceCH4(i) = Morph{i}.ForceCH4Ascent;
    forceISRU(i) = Morph{i}.ForceAscentISRUCH4;
    crew(i) = Morph{i}.TransitCrew.Size;
    surfcrew(i) = Morph{i}.SurfaceCrew.Size;
	switch Morph{i}.SurfaceSites
        case Site.HOLDEN	
            crater(i) = 1;
        case Site.GALE	
            crater(i) = 2;
        case Site.MERIDIANI	
            crater(i) = 3;
        case Site.GUSEV	
            crater(i) = 4;
        case Site.ISIDIS	
            crater(i) = 5;
        case Site.ELYSIUM	
            crater(i) = 6;
        case Site.MAWRTH	
            crater(i) = 7;
        case Site.EBERSWALDE	
            crater(i) = 8;
        case Site.UTOPIA	
            crater(i) = 9;
        case Site.PLANUS_BOREUM	
            crater(i) = 10;
        case Site.HELLAS	
            crater(i) = 11;
        case Site.AMAZONIS	
            crater(i) = 12;
	end
    food(i) = Morph{i}.FoodSupply(2).Amount; %percent grown on mars
	switch Morph{i}.Staging
        case Location.LEO
            stage(i) = 1;
        case Location.EML1
            stage(i) = 2;
        case Location.EML2
            stage(i) = 3;
    end
	if Morph{i}.SurfacePower == PowerSource.SOLAR
            power(i) = 1;
    elseif Morph{i}.SurfacePower == PowerSource.NUCLEAR
            power(i) = 2;
    else
            power(i) = 3;
   end
    switch char(Morph{i}.PropulsionType)
        case char(Propulsion.LH2)
            prop(i) = 1;
        case char(Propulsion.CH4)
            prop(i) = 2;
        case char(Propulsion.NTR)
            prop(i) = 3;
    end
    switch Morph{i}.OrbitCapture
        case ArrivalEntry.AEROCAPTURE
            cap(i) = 1;
        case ArrivalEntry.PROPULSIVE
            cap(i) = 2;
    end
	if or(isequal(Morph{i}.TransitFuel, [TransitFuel.EARTH_LH2, TransitFuel.EARTH_O2]),...
            isequal(Morph{i}.TransitFuel, [TransitFuel.EARTH_O2, TransitFuel.EARTH_LH2]))
            transfuel(i) = 1;
		elseif or(isequal(Morph{i}.TransitFuel, [TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2]),...
                isequal(Morph{i}.TransitFuel, [TransitFuel.LUNAR_O2,TransitFuel.EARTH_LH2]))
            transfuel(i) = 2;
		elseif or(isequal(Morph{i}.TransitFuel, [TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]),...
                isequal(Morph{i}.TransitFuel, [TransitFuel.LUNAR_O2,TransitFuel.LUNAR_LH2]))
            transfuel(i) = 3;
		else
			transfuel(i) = 4;
    end
    if isequal(Morph{i}.ReturnFuel, [ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2])
            returnfuel(i) = 1;
		elseif isequal(Morph{i}.ReturnFuel,  [ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2])
            returnfuel(i) = 3;
		elseif isequal(Morph{i}.ReturnFuel, [ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2])
            returnfuel(i) = 4;
        elseif isequal(Morph{i}.ReturnFuel, [ReturnFuel.MARS_LH2, ReturnFuel.EARTH_O2])
			returnfuel(i) = 2;
    else
        returnfuel{i} = 5;
    end
    MAMA(i) = All_Results{i}.HumanSpacecraft.MAMA;
    HumanMALMO(i) = All_Results{i}.HumanSpacecraft.MALMO;
    CargoMALMO(i) = All_Results{i}.CargoSpacecraft.MALMO;
    cumpower(i) = All_Results{i}.Cum_Surface_Power;
    ch4(i) = Morph{i}.ForceCH4Ascent;
    stay(i) = 780 * ((Morph{i}.SurfaceCrew.Size/Morph{i}.TransitCrew.Size))/365; %Stay duration in Earth Years
    
end

%% disp
hold off;

plot = gscatter(val,Im,food,'mcrgb','o+xsd*^<>ph');
 % ylim(xlim);
hold on;
%  xlabel('HumanMass');
%  ylabel('Resupply IMLEO');
%  title('Single-site Science hrs, Colored by Food Grown on Mars');

%% Gen Presentation Graphs
figure;
 gscatter(Infra,Im,transfuel,'mcrgb','o+xsd*^<>ph');
% lim = ylim;
% lim(1) = 0;
% ylim(lim);
hold on;
 xlabel('Infrastructure Mass, kg');
 ylabel('Resupply IMLEO, kg');
 title('Effects of Lunar ISRU');
  
 figure;
 scatter3(val,Im,Infra);
 xlabel('Scientific Value, CM-hr-Intrest/synod');
 ylabel('Resupply IMLEO, kg');
 zlabel('Infrastructure Mass, kg');
 title('3D Results');
 
 
figure;
full = gscatter(val,Im,food,'mcrgb','o+xsd*^<>ph');
% lim = ylim;
% lim(1) = 0;
% ylim(lim);
hold on;
 xlabel('Scientific Value, CM-hr-Intrest/synod');
 ylabel('Resupply IMLEO, kg');
 title('Full Results, Colored by Food Grown on Mars');
 set(full,'MarkerSize',10);
 
 ID_DRA5;

 
%% isolate utopian corner
ind = [];
Im = transpose(Im);
val = transpose(val);
for i=1:length(Im)
    if or(Im(i) > 0.5e6, val(i) < 3.2e4)
        ind(end+1) = i;
    end
end
Im = removerows(Im,ind);
val = removerows(val,ind);
Im = transpose(Im);
val = transpose(val);

%% Find most utopian (if un-dominated)
bestim = min(Im);
bestsci = max(val);
bestind = 0;
for i=1:Num_Arches
    if and(All_Results{i}.IMLEO == bestim, All_Results{i}.Science == bestsci)
        bestind = i;
    end
end
if ~(bestind == 0)
disp('Best Architecture')
disp(bestind)
elseif bestind == 0
    disp('No Utopian Architecture')
end
%% Find Best IMLEO of the Best Sci
bestim = min(Im);
bestsci = max(val);
bestind = 0;
sciim = [];
for i=1:length(Im)
    if val(i) == bestsci;
        sciim(end+1) = Im(i);
    end
end
bestimleft = min(sciim);
for i=1:Num_Arches
    if and(All_Results{i}.IMLEO == bestimleft, All_Results{i}.Science == bestsci)
        bestind = i;
    end
end
if ~(bestind == 0)
disp('Best Architecture')
disp(bestind)
elseif bestind == 0
    disp('No best IMLEO for best Science')
end