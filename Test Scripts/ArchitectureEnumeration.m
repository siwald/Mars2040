

%test default architecture creation
testDefault = MarsArchitecture.DEFAULT;
testDRA5 = MarsArchitecture.DRA5;

testEnumeration = MarsArchitecture.Enumerate( ... 
    {Propulsion.NTR,Propulsion.LH2}, ...
    {Site.HOLDEN_CRATER,Site.GALE_CRATER}, ...
    {FoodSupply.EARTH_ONLY,FoodSupply.EARTH_MARS_50_SPLIT,FoodSupply.MARS_ONLY})