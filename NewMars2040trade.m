tic
%setup morphological matrix
Morph = ...
MarsArchitecture.Enumerate( ...
        {Propulsion.NTR}, ...  Propulsion.SEP, Propulsion.LH2, Propulsion.CH4, 
        {CargoTrajectory.HOHMANN}, ... ,CargoTrajectory.ELLIPTICAL
        {Location.LEO, Location.EML1, Location.EML2}, ...  
        {[TransitFuel.EARTH_LH2,TransitFuel.EARTH_O2],[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2],[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]}, ...
        {[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2],[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]}, ...
        {Crew.DEFAULT_TRANSIT, Crew.DRA_CREW}, ... Crew.MIN_CREW,
        {ArrivalEntry.AEROCAPTURE, ArrivalEntry.PROPULSIVE}, ... ArrivalEntry.AEROBRAKE, ,ArrivalEntry.DIRECT
        {Site.HOLDEN,Site.GALE}, ...
        {FoodSource.EARTH_ONLY,FoodSource.EARTH_MARS_50_SPLIT,FoodSource.MARS_ONLY,FoodSource.EARTH_MARS_25_75, FoodSource.EARTH_MARS_75_25}, ...
        {SurfaceShielding.REGOLITH}, ...SurfaceShielding.BURIED, SurfaceShielding.DEDICATED,SurfaceShielding.H2O_INSULATION
        {PowerSource.SOLAR,PowerSource.NUCLEAR,[PowerSource.NUCLEAR, PowerSource.SOLAR], [PowerSource.NUCLEAR, PowerSource.FUEL_CELL]});%, ...
        %{ArrivalDescent.PROPULSIVE,ArrivalDescent.CHUTE,ArrivalDescent.SHOCK_ABSORBTION}, ...
        %{HabitatShielding.DEDICATED,HabitatShielding.H2O_INSULATION}, ...
        %{StructureType.FIXED_SHELL,StructureType.INFLATABLE,{StructureType.FIXED_SHELL, 0.500; StructureType.INFLATABLE, 0.500}}, ...
        %{ReturnFuel.EARTH_LH2,[ReturnFuel.EARTH_LH2, ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]}, ...
        %{ReturnEntry.AEROCAPTURE,ReturnEntry.AEROBRAKE,ReturnEntry.PROPULSIVE,ReturnEntry.DIRECT}, ...
        %{ReturnDescent.PROPULSIVE,ReturnDescent.CHUTE,ReturnDescent.SHOCK_ABSORBTION});

%  Morph = {MarsArchitecture.DEFAULT, MarsArchitecture.DRA5};
 
[~, Num_Arches] = size(Morph)
enumeration_time = toc;
%Preallocate the results array
All_Results = cell(Num_Arches,1); %1 row for every architectureal combo, 1 cols: Results object
tic
parfor i=1:Num_Arches %begin looping for each architecture
    %extract current archeticture from Morph
    Cur_Arch = Morph{i};
    %initialize the Results Object for this run
    Results = Results_Class(i); %with the Arch_Num of i
    %% Logistics Setup %%
    
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
    Results.HumanSpacecraft = Transit_Habitat(Cur_Arch, Results.HumanSpacecraft, Results);
    
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
    Results.HumanSpacecraft.Add_Craft = Earth_Entry; %Add entry module to the S/C
    
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
    
    [Results.HumanSpacecraft, Results] = Return_Trans (Cur_Arch, Results.HumanSpacecraft, Results);
    
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
    
    [Results.AscentSpacecraft, Results.HumanSpacecraft, Results] = Ascent (Cur_Arch, Results.HumanSpacecraft, Results);
       
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
    [Food_Time, ECLSS_ISRU, Results] = ECLSS (Cur_Arch, Results);

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
    [Site_Sci_Value, Site_Elevation] = Site_Selection(Cur_Arch);
    
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
    [Results] = Astronaut_Time(Cur_Arch, Results, Food_Time);
    
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
    [Results.AscentSpacecraft, Results.HumanSpacecraft, Results.CargoSpacecraft] = Descent(Cur_Arch, Results.AscentSpacecraft, Results.HumanSpacecraft, Results, Site_Elevation);

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
    [Results.HumanSpacecraft] = NewTransit(Cur_Arch, Results.HumanSpacecraft, 'Human', Results);
    [Results.CargoSpacecraft] = NewTransit(Cur_Arch, Results.CargoSpacecraft, 'Cargo', Results);
    %% --- Lunar ISRU --- %%
    %{
    Inputs:
        Cur_Arch
            TransitFuel
        HumanSpacecraft
            Fuel_Mass
            Ox_Mass
        Results.CargoSpacecraft
            Fuel_Mass
            Ox_Mass
        Results
    Outputs:
        Results
        FerrySpacecraft
    %}
    
    [Results.FerrySpacecraft, Results.HumanSpacecraft, Results.CargoSpacecraft, Results] = Lunar_ISRU (Cur_Arch, Results.HumanSpacecraft, Results.CargoSpacecraft, Results);
        
    %% --- Staging Module --- %%
    HumanStageing = SC_Class('Staging Engines'); %should Initialize
    HumanStageing = Propellant_Mass(Cur_Arch.PropulsionType,HumanStageing,Hohm_Chart('LEO',Cur_Arch.Staging.Code),Results.HumanSpacecraft.Mass);
    Results.HumanSpacecraft.Add_Craft = HumanStageing;
    
    CargoStageing = SC_Class('Staging Engines');
    CargoStageing = Propellant_Mass(Cur_Arch.PropulsionType,CargoStageing,Hohm_Chart('LEO',Cur_Arch.Staging.Code),(Results.CargoSpacecraft.Mass ...
        + Results.FerrySpacecraft.Prop_Mass)); %Needs to bring the non-Lunar ISRU prop mass to staging point for the Ferry
    Results.CargoSpacecraft.Add_Craft = CargoStageing;
    
    Results.IMLEO = Results.HumanSpacecraft.Mass + Results.CargoSpacecraft.Mass;
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
    %1 row for every architectureal combo, 5 cols: Results object, Human S/C, 1 array of Cargo S/C, Ferry S/C, Ascent S/C
    %Index into All_Results
    All_Results(i,1) = Results; 
    %% End Main Loop
end %end main loop
time_per_run = toc / Num_Arches;
runtime_Mins = toc / 60;
%% --- Results Managment --- %%

%IMLEO vs Sci_Value Scatter Plot
run('View_Results')
