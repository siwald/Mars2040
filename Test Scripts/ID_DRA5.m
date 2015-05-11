list = [];
list2 = [];

tempDRA = MarsArchitecture.Duplicate(MarsArchitecture.DRA5);

for i=1:Num_Arches
    if Morph{i} == temp
        list2(1) = i;
    end
end
% length(list)
% for i=1:length(list)
%     ind = list(i);
%     if Morph{ind}.PropulsionType == Propulsion.LH2
%         list2(end+1) = ind;
%     end
% end
% length(list2)
% list = [];
% for i=1:length(list2)
%     ind = list2(i);
%     if Morph{ind}.SurfacePower == PowerSource.NUCLEAR
%         list(end+1) = ind;
%     end
% end
% length(list)
% list2 = [];
% for i=1:length(list)
%     ind = list(i);
%     if Morph{ind}.TransitFuel == [TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2]
%         list2(end+1) = ind;
%     end
% end
% length(list2)
% list = [];
% for i=1:length(list2)
%     ind = list2(i);
%     if Morph{ind}.ReturnFuel == [ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2]
%         list(end+1) = ind;
%     end
% end
% length(list)
% list2 = [];
% for i=1:length(list)
%     ind = list(i);
%     if Morph{ind}.ForceCH4Ascent == 1
%         list2(end+1) = ind;
%     end
% end
% length(list2)
% 
% list = [];
% for i=1:length(list2)
%     ind = list2(i);
%     if Morph{ind}.SurfaceSites == Site.HOLDEN
%         list(end+1) = ind;
%     end
% end
% length(list)
% 
% list2 = [];
% for i=1:length(list)
%     ind = list(i);
%     if Morph{ind}.EDL == ArrivalDescent.AEROENTRY
%         list2(end+1) = ind;
%     end
% end
% length(list2)
% 
% list = [];
% for i=1:length(list2)
%     ind = list2(i);
%     if Morph{ind}.OrbitCapture == ArrivalEntry.AEROCAPTURE
%         list(end+1) = ind;
%     end
% end
% length(list)
% 
% list2 = [];
% for i=1:length(list)
%     ind = list(i);
%     if Morph{ind}.FoodSupply == FoodSource.EARTH_ONLY
%         list2(end+1) = ind;
%     end
% end
% length(list2)
disp('DRA5 is Morph number:')
list2(1)
