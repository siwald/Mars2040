%% IMLEO vs Sci_Value Scatter Plot
val = zeros(1, Num_Arches); %initialize value vector
Im = zeros(1,Num_Arches); %ititialize IMLEO vector
marsox = zeros(1,Num_Arches);
marsh2 = zeros(1,Num_Arches);
LCC_Prox = zeros(1,Num_Arches);
Infra = zeros(1,Num_Arches);
for i=1:Num_Arches
    val(i) = All_Results{i,1}.Science;
    Im(i) = All_Results{i,1}.IMLEO;
    marsox(i) = nansum([All_Results{i,1}.Mars_ISRU.Oxidizer_Output]);
    marsh2(i) = nansum([All_Results{i,1}.Mars_ISRU.Fuel_Output]);
    LCC_Prox(i) = nansum([All_Results{i,1}.Surface_Habitat.Mass,All_Results{i,1}.ECLSS.Mass, ...
        All_Results{i,1}.Mars_ISRU.Mass, All_Results{i,1}.Lunar_ISRU.Mass, All_Results{i,1}.ISFR.Mass, ...
        All_Results{i,1}.PowerPlant.Mass]) + (10*All_Results{i,1}.IMLEO);
    Infra(i) = nansum([All_Results{i,1}.Surface_Habitat.Mass,All_Results{i,1}.ECLSS.Mass, ...
        All_Results{i,1}.Mars_ISRU.Mass, All_Results{i,1}.Lunar_ISRU.Mass, All_Results{i,1}.ISFR.Mass, ...
        All_Results{i,1}.PowerPlant.Mass]);
end
%disp
hold off;
xaxis = val;
xlab = 'Science Value';
scatter(xaxis,Im);
hold on;
%scatter(250000,30000,'d');
ylabel('IMLEO');
xlabel(xlab);



%% Morph Section
val = zeros(1, Num_Arches); %initialize value vector
Im = zeros(1,Num_Arches); %ititialize IMLEO vector

crew = zeros(1,Num_Arches);
sufcrew = zeros(1,Num_Arches);
crater = zeros(1,Num_Arches);
food = zeros(1,Num_Arches);
stage = zeros(1,Num_Arches);
power = zeros(1,Num_Arches);
prop = zeros(1,Num_Arches);
cap = zeros(1,Num_Arches);
transfuel = zeros(1,Num_Arches);
returnfuel = zeros(1,Num_Arches);

for i=1:Num_Arches
    val(i) = All_Results{i,1}.Science;
    Im(i) = All_Results{i,1}.IMLEO;

    crew(i) = Morph{i}.TransitCrew.Size;
    surfcrew(i) = Morph{i}.SurfaceCrew.Size;
	switch Morph{i}.SurfaceSites
        case Site.HOLDEN
            crater(i) = 1;
        case Site.GALE
            crater(i) = 0;
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
    elseif Morph{i}.SurfacePower ==  [PowerSource.NUCLEAR, PowerSource.SOLAR]
            power(i) = 3;
    elseif Morph{i}.SurfacePower == [PowerSource.NUCLEAR, PowerSource.FUEL_CELL]
            power(i) = 4;
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
	if isequal(Morph{i}.TransitFuel, [TransitFuel.EARTH_LH2, TransitFuel.EARTH_O2])
            transfuel(i) = 1;
		elseif isequal(Morph{i}.TransitFuel, [TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2])
            transfuel(i) = 2;
		elseif isequal(Morph{i}.TransitFuel, [TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2])
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

end
%% disp
hold off;
gscatter(val,Im,power,'mcrgb','o+xsd');
hold on;
%scatter(250000,30000,'d');
xlabel('Science Value');
ylabel('IMLEO');

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