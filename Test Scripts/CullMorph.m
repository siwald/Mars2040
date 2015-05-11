temp = Morph;
for i = 1:length(temp)
    if ~isequal(temp{i}.TransitFuel,[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2])
        temp{i} = {};
    end
end