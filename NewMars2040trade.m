
%setup morphological matrix
%Morph = MarsArchitecture(all);
Morph{1} = MarsArchitecture.DEFAULT;
Morph{2} = MarsArchitecture.DEFAULT;
[Num_Arches, ~] = size(Morph);

%Preallocate the results array
All_Results = cell(Num_Arches,4); %1 row for every architectureal combo, 4 cols: Results object, Human S/C, 1 array of Cargo S/C, Ferry S/C

parfor i=1:Num_Arches %begin looping for each architecture
    %extract current archeticture from Morph
    Cur_Arch = Morph{i};
    %initialize the Results Object for this run
    Results = Results_Class(i); %with the Arch_Num of i
    
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
    [ISRURequirements, Results] = ECLSS (Cur_Arch, Results);
    
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
    Results = ISRU(Cur_Arch, ISRURequirements, Results);
    
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
    SparesRatio = 0.05; %percentage of Mass
    
    Results.Surface_Habitat.Spares = Results.Surface_Habitat.Mass * SparesRatio;
    Results.ECLSS.Spares = Results.ECLSS.Mass * SparesRatio;
    Results.Mars_ISRU.Spares = Results.Mars_ISRU.Mass * SparesRatio;
    Results.PowerPlant.Spares = Results.PowerPlant.Mass * SparesRatio;
    
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
    HumanStageing = SC_Class('Staging Engines');
    HumanStageing = Propellant_Mass(Cur_Arch.PropulsionType,HumanStageing,Hohm_Chart('LEO','EML1'),HumanSpacecraft.Mass);
    HumanSpacecraft.Add_Craft = HumanStageing;
    
    CargoStageing = SC_Class('Staging Engines');
    CargoStageing = Propellant_Mass(Cur_Arch.PropulsionType,CargoStageing,Hohm_Chart('LEO','EML1'),(CargoSpacecraft.Mass ...
        + FerrySpacecraft.Prop_Mass)); %Needs to bring the non-Lunar ISRU prop mass to staging point for the Ferry
    CargoSpacecraft.Add_Craft = CargoStageing;
    
    Results.IMLEO = HumanSpacecraft.Mass + CargoSpacecraft.Mass;
    
    %% --- Science Module --- %%
    %{
    Inputs:
        Astronaut_Sci_Time
        Site_Sci_Value
        Results
    Output:
        Results
            Science
    %}
    Results.Science = Results.Science_Time * Site_Sci_Value;
    
    %% Fill out Results Row
    %Create comeplete row first, so there's only 1 index into the global
    %All_Results outside the parfor
    Results_Row = cell(1,4); %init Results Row
    Results_Row{1,1} = Results;
    Results_Row{1,2} = HumanSpacecraft;
    Results_Row{1,3} = CargoSpacecraft;
    Results_Row{1,4} = FerrySpacecraft;
    %Index into All_Results
    All_Results{i,:} = Results_Row; 
    %% End Main Loop
end %end main loop
%% --- Results Managment --- %%
All_Results;
