% temp = MarsArchitecture.DRA5;
% tempDRA = temp;
% tempDRA.TransitFuel = [TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2];
% tempDRA.SurfaceCrew.Size = 18;
% 
% for i=1:length(Morph)
%     if Morph{i} == tempDRA
%         disp('DRA5 is Morph number:')
%         disp(i)
%     end
% end

list = [];
list2 = [];

for i=1:length(Morph)
    ind = i;
    if Morph{ind}.PropulsionType == Propulsion.NTR
        list2(end+1) = ind;
    end
end
length(list2)
list = [];
for i=1:length(list2)
    ind = list2(i);
    if Morph{ind}.SurfacePower == PowerSource.NUCLEAR
        list(end+1) = ind;
    end
end
length(list)
list2 = [];
for i=1:length(list)
    ind = list(i);
    if Morph{ind}.TransitFuel == [TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2]
        list2(end+1) = ind;
    end
end
length(list2)
list = [];
for i=1:length(list2)
    ind = list2(i);
    if Morph{ind}.ReturnFuel == [ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2]
        list(end+1) = ind;
    end
end
length(list)
list2 = [];
for i=1:length(list)
    ind = list(i);
    if Morph{ind}.ForceCH4Ascent == 1
        list2(end+1) = ind;
    end
end
length(list2)

list = [];
for i=1:length(list2)
    ind = list2(i);
    if Morph{ind}.SurfaceSites == Site.GALE
        list(end+1) = ind;
    end
end
length(list)

list2 = [];
for i=1:length(list)
    ind = list(i);
    if Morph{ind}.EDL == ArrivalDescent.AEROENTRY
        list2(end+1) = ind;
    end
end
length(list2)

list = [];
for i=1:length(list2)
    ind = list2(i);
    if Morph{ind}.OrbitCapture == ArrivalEntry.AEROCAPTURE
        list(end+1) = ind;
    end
end
length(list)

list2 = [];
for i=1:length(list)
    ind = list(i);
    if Morph{ind}.FoodSupply == FoodSource.EARTH_ONLY
        list2(end+1) = ind;
    end
end
length(list2)

list = [];
for i=1:length(list2)
    ind = list2(i);
    if Morph{ind}.TransitCrew == Crew.DRA_CREW
        list(end+1) = ind;
    end
end
length(list)



disp('DRA5 is Morph number:')
        disp(list(1))
        All_Results{list(1)}.IMLEO
        All_Results{list(1)}.Science
