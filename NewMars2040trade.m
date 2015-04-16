tic
%setup morphological matrix
Morph = ...
MarsArchitecture.Enumerate( ...
        {Propulsion.LH2,Propulsion.NTR,Propulsion.CH4}, ... Propulsion.SEP,
        {CargoTrajectory.HOHMANN}, ... ,CargoTrajectory.ELLIPTICAL
        {Location.LEO, Location.EML1, Location.EML2}, ... 
        {TransitFuel.EARTH_LH2,[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2],[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]}, ...
        {ReturnFuel.EARTH_LH2,[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]}, ...
        {Crew.DEFAULT_TRANSIT,Crew.DRA_CREW}, ... Crew.MIN_CREW,
        {ArrivalEntry.AEROCAPTURE,ArrivalEntry.PROPULSIVE}, ... ArrivalEntry.AEROBRAKE, ,ArrivalEntry.DIRECT
        {Site.HOLDEN_CRATER,Site.GALE_CRATER}, ...
        {FoodSource.EARTH_ONLY,FoodSource.EARTH_MARS_50_SPLIT,FoodSource.MARS_ONLY,FoodSource.EARTH_MARS_25_75, FoodSource.EARTH_MARS_75_25}, ...
        {SurfaceShielding.REGOLITH}, ...SurfaceShielding.BURIED, SurfaceShielding.DEDICATED,SurfaceShielding.H2O_INSULATION
        {PowerSource.SOLAR,PowerSource.NUCLEAR,[PowerSource.NUCLEAR, PowerSource.SOLAR, PowerSource.RTG]});%, ...
        %{ArrivalDescent.PROPULSIVE,ArrivalDescent.CHUTE,ArrivalDescent.SHOCK_ABSORBTION}, ...
        %{HabitatShielding.DEDICATED,HabitatShielding.H2O_INSULATION}, ...
        %{StructureType.FIXED_SHELL,StructureType.INFLATABLE,{StructureType.FIXED_SHELL, 0.500; StructureType.INFLATABLE, 0.500}}, ...
        %{ReturnFuel.EARTH_LH2,[ReturnFuel.EARTH_LH2, ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]}, ...
        %{ReturnEntry.AEROCAPTURE,ReturnEntry.AEROBRAKE,ReturnEntry.PROPULSIVE,ReturnEntry.DIRECT}, ...
        %{ReturnDescent.PROPULSIVE,ReturnDescent.CHUTE,ReturnDescent.SHOCK_ABSORBTION});

%  Morph = {MarsArchitecture.DEFAULT, MarsArchitecture.DRA5};
 
[~, Num_Arches] = size(Morph);
enumeration_time = toc;
%Preallocate the results array
All_Results = cell(Num_Arches,4); %1 row for every architectureal combo, 4 cols: Results object, Human S/C, 1 array of Cargo S/C, Ferry S/C
tic
parfor i=1:Num_Arches %begin looping for each architecture
    %extract current archeticture from Morph
    Cur_Arch = Morph{i};
    %initialize the Results Object for this run
    Results = Results_Class(i); %with the Arch_Num of i
    %initialize the Results Lists, must clear these each run
    Results.Surface_Habitat = Results_List;
    Results.ECLSS = Results_List;
    Results.Mars_ISRU = Results_List;
    Results.Lunar_ISRU = Results_List;
    Results.ISFR = Results_List;
    Results.PowerPlant = Results_List;
    
    %% Logistics Setup %%
    
    %Initialize the Overall Spacecraft for the Human legs
    HumanSpacecraft = OverallSC;
    
    %% --- Duration Module --- %%
    %{
    Inputs:
        Cur_Arch
            Trajectory in TrajectoryType
    Outputs:
        Trajectory Object
            Stay Duration in Days
            Outgoing Duration in Days
            Return Duration in Days
            Contingency Duration in Days
    %}
    %Trajectory_obj = Duration(Cur_Arch);
    
    %% --- Transit Hab Module --- %%
    %{
    Inputs:
        Cur_Arch
            Crew_Number in #
        Trajectory Object
            Stay Duration in Days
            Outgoing Duration in Days
            Return Duration in Days
            Contingency Duration in Days
        Overall Spacecraft Object
            empty
    Outputs:
        Overall Spacecraft Object
            Transit Hab
                Dry Mass
                Power
                Volume
    %}
    HumanSpacecraft = Transit_Habitat(Cur_Arch, HumanSpacecraft);
    
    %% --- Earth Entry Module --- %%
    %{
    Inputs: 
        Cur_Arch
            Transit Crew Size in #
            Payload Mass and Volume (0 for now)
        Overall Spacecraft Object
    Outputs:
        Overall Spacecraft Object
            Earth Entry
                Habitable Mass
                Habitable Vol
                Bus Volume
                Bus Mass
    %}
    
    Earth_Entry = SC_Class('Earth Entry Module'); %initialize the Earth Entry Module
    Earth_Entry.Hab_Mass = Cur_Arch.TransitCrew.Size * 1570; %kg, based on (Apollo CM Mass - heat sheild mass) / astronaut
    Earth_Entry.Hab_Vol = Cur_Arch.TransitCrew.Size * 2.067; %based on Apollo hab vol / astronaut
    Earth_Entry.Payload_Vol = 0; %As yet undefined, and not a trade
    Earth_Entry.Payload_Mass = 0; %As yet undefined, and not a trade
    Earth_Entry.volume_calc; %populate the total volume
    Earth_Entry.Bus_Mass = Earth_Entry.Volume * 81.73; %size of HeatSheild, kg, based on Apollo, per total module volume
    Earth_Entry.drymass_calc; %populate the overall mass numbers
    HumanSpacecraft.Add_Craft = Earth_Entry; %Add entry module to the S/C
    
    %% --- Return Transit Module --- %%
    %{
    Inputs:
        Cur_Arch
            Trajectory Class
        Spacecraft
            -Transit Habitat
            -Earth Entry
            Mass      
    Outputs:
        Spacecraft
            Return Engine Stage
        Results Object
            Mars ISRU requirements
    %}
    
    [HumanSpacecraft, Results] = Return_Trans (Cur_Arch, HumanSpacecraft, Results);
    
    %% --- Ascent Module --- %%
    %{
    Inputs:
        Cur_Arch
            Propulsion Type
        HumanSpacecraft
            EarthEntry Module
        Results
            Mars Fuel ISRU
            Mars Oxidizer ISRU
    
    Outputs:
        AscentSpacecraft
        HumanSpacecraft without reuseable Ascent/Descent Craft
        Results with updated ISRU fuel
    %}
    
    [AscentSpacecraft, HumanSpacecraft, Results] = Ascent (Cur_Arch, HumanSpacecraft, Results);
       
    %% --- Surf Structure --- %%
    %{
    Inputs:
        Cur_Arch
    Outputs:
        Results
            Surface Mass
            Surface Volume
            Surface Power
    %}
    Results = Surface_Habitat(Cur_Arch, Results);
    
    %% --- ECLSS Module --- %%
    %{
    Inputs:
        Cur_Arch
            Crew Number
        Results
            Surface_Habitat.Volume
    Outputs:
        Results
            ECLSS.Mass, Volume & Power
            ISRURequirements object
    %}
    [ECLSS_ISRU, Results] = ECLSS (Cur_Arch, Results);
    
    %% --- Mars ISRU --- %%
    %{
    Inputs:
        Cur_Arch
        ISRURequirements object
        Results
            Fuel & Oxidizer_Output
    Outputs:
        Results
            ISRU.Mass, Volume & Power
    %}
    Results = ISRU(Cur_Arch, ECLSS_ISRU, Results);
    
    %% --- Surface Power Module --- %%
    %{
    Inputs:
        Cur_Arch
            Surface_Power
        Results
            ECLSS, Surface_Habitat & ISRU.Power
    Outputs:
        Results
            Surface_PowerPlant.Mass & Volume
    %}
    Results = Surface_Power (Cur_Arch, Results);
    
    %% --- ISFR and Sparing Module --- %%
    %{
    Inputs:
        Results
            Surface_Habitat, ECLSS, Mars_ISRU, PowerPlant.Mass
    Outputs:
        Results
            Surface_Habitat, ECLSS, Mars_ISRU, PowerPlant.Spares
    %}
    SparesRatio = 0.05; %percentage of Mass per Year, Leath and Green, 1993
    %Years per Synodic Cycle = 1.881, be able to convert to % mass per
    %resupply
    
    Results.Surface_Habitat.Spares = Results.Surface_Habitat.Mass * SparesRatio * 1.881;
    Results.ECLSS.Spares = Results.ECLSS.Mass * SparesRatio * 1.881;
    Results.Mars_ISRU.Spares = Results.Mars_ISRU.Mass * SparesRatio * 1.881;
    Results.PowerPlant.Spares = Results.PowerPlant.Mass * SparesRatio * 1.881;
    
    %% --- Site Selection Module --- %%
    %{
    Inputs:
        Cur_Arch
            SiteSelection
    Outputs:
        Site_Sci_Value
    %}
    Site_Sci_Value = Site_Selection(Cur_Arch);
    
    %% --- Astronaut Time Module --- %%
    %{
    Inputs:
        Cur_Arch
            SurfaceCrew.Size
        Results
            Spares
    Outputs:
        Astronaut_Sci_Time
    %}
    [Results] = Astronaut_Time(Cur_Arch, Results);
    
    %% --- Descent --- %%
    %{
    Inputs:
        Cur_Arch
            TransitCrew.Size
        Results
            Spares
            Consumables
            Replacements
        Ascent_Vehicle
            Entry and Ascent Module
    Outputs:
        Descent_Craft
            MEAA Module
            Cargo Descenders
    %}
    [AscentSpacecraft, HumanSpacecraft, CargoSpacecraft] = Descent(Cur_Arch, AscentSpacecraft, HumanSpacecraft, Results);

    %% --- Outgoing Transit --- %%
    %{
    Inputs:
        HumanSpacecraft
        CargoSpacecraft
        Cur_Arch
            HumanTrajectory
            CargoTrajectory
    Outputs:
        HumanSpacecraft
        CargoSpacecraft
    %}
    [HumanSpacecraft] = NewTransit(Cur_Arch, HumanSpacecraft, 'Human', Results);
    [CargoSpacecraft] = NewTransit(Cur_Arch, CargoSpacecraft, 'Cargo', Results);
    %% --- Lunar ISRU --- %%
    %{
    Inputs:
        Cur_Arch
            TransitFuel
        HumanSpacecraft
            Fuel_Mass
            Ox_Mass
        CargoSpacecraft
            Fuel_Mass
            Ox_Mass
        Results
    Outputs:
        Results
        FerrySpacecraft
    %}
    
    [FerrySpacecraft, HumanSpacecraft, CargoSpacecraft, Results] = Lunar_ISRU (Cur_Arch, HumanSpacecraft, CargoSpacecraft, Results);
        
    %% --- Staging Module --- %%
    HumanStageing = SC_Class('Staging Engines'); %should Initialize
    HumanStageing = Propellant_Mass(Cur_Arch.PropulsionType,HumanStageing,Hohm_Chart('LEO','EML1'),HumanSpacecraft.Mass);
    HumanSpacecraft.Add_Craft = HumanStageing;
    
    CargoStageing = SC_Class('Staging Engines');
    CargoStageing = Propellant_Mass(Cur_Arch.PropulsionType,CargoStageing,Hohm_Chart('LEO','EML1'),(CargoSpacecraft.Mass ...
        + FerrySpacecraft.Prop_Mass)); %Needs to bring the non-Lunar ISRU prop mass to staging point for the Ferry
    CargoSpacecraft.Add_Craft = CargoStageing;
    
    Results.IMLEO = HumanSpacecraft.Mass + CargoSpacecraft.Mass;
%     disp(Results.IMLEO)
    
    %% --- Science Module --- %%
    %{
    Inputs:
        Results
            Astronaut_Sci_Time
            Site_Sci_Value
    Output:
        Results
            Science
    %}
    Results.Science = Results.Science_Time * Site_Sci_Value;
    
    %% Fill out Results Row
    %Create comeplete row first, so there's only 1 index into the global
    %All_Rdesults outside the parfor
    Results_Row = cell(1,4); %init Results Row
    Results_Row{1,1} = Results;
    Results_Row{1,2} = HumanSpacecraft;
    Results_Row{1,3} = CargoSpacecraft;
    Results_Row{1,4} = FerrySpacecraft;
    %Index into All_Results
    All_Results(i,:) = Results_Row; 
    %% End Main Loop
end %end main loop
time_per_run = toc / Num_Arches;
runtime_Mins = toc / 60;
%% --- Results Managment --- %%
All_Results;

%IMLEO vs Sci_Value Scatter Plot
val = zeros(1, Num_Arches); %initialize value vector
Im = zeros(1,Num_Arches); %ititialize IMLEO vector
LCC_Prox = zeros(1,Num_Arches);
labels = cell(1,Num_Arches);
for i=1:Num_Arches
    val(i) = All_Results{i,1}.Science;
    Im(i) = All_Results{i,1}.IMLEO;
    LCC_Prox(i) = nansum([All_Results{i,1}.Surface_Habitat.Mass,All_Results{i,1}.ECLSS.Mass, ...
        All_Results{i,1}.Mars_ISRU.Mass, All_Results{i,1}.Lunar_ISRU.Mass, All_Results{i,1}.ISFR.Mass, ...
        All_Results{i,1}.PowerPlant.Mass]) + (10*All_Results{i,1}.IMLEO);
    labels{i} = num2str(i);
end
scatter(Im,val);
%labelpoints(Im,val,labels);
