
    % set to run DRA5.0 model architecture
    Cur_Arch = MarsArchitecture.DRA5;
    %initialize the Results Object for this run
    Results = Results_Class(1); %with the Arch_Num of i
    
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
    Results.HumanSpacecraft = Transit_Habitat(Cur_Arch, Results.HumanSpacecraft);
    
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

Results.Arch_Name = strcat('Model ', Results.Arch_Num);

% build DRA 5.0 results
DRA5_Results = Results_Class(0);
DRA5_Results.Arch_Name = 'DRA 5.0';
% primarily result values
DRA5_Results.IMLEO = 800000;
DRA5_Results.Science = -1;
DRA5_Results.Risk = -1;
DRA5_Results.Regolith = -1;
DRA5_Results.Science_Time = -1;
% surface habitat
DRA5_Results.Surface_Habitat.Consumables = -1;
DRA5_Results.Surface_Habitat.Spares = -1;
DRA5_Results.Surface_Habitat.Replacements = -1;
DRA5_Results.Surface_Habitat.Mass = -1;
DRA5_Results.Surface_Habitat.Power = -1;
DRA5_Results.Surface_Habitat.Volume = -1;
DRA5_Results.Surface_Habitat.Fuel_Output = -1;
DRA5_Results.Surface_Habitat.Oxidizer_Output = -1;
% ECLSS
DRA5_Results.ECLSS.Consumables = -1;
DRA5_Results.ECLSS.Spares = -1;
DRA5_Results.ECLSS.Replacements = -1;
DRA5_Results.ECLSS.Mass = -1;
DRA5_Results.ECLSS.Power = -1;
DRA5_Results.ECLSS.Volume = -1;
DRA5_Results.ECLSS.Fuel_Output = -1;
DRA5_Results.ECLSS.Oxidizer_Output = -1;
% ISRU
DRA5_Results.Mars_ISRU.Consumables = -1;
DRA5_Results.Mars_ISRU.Spares = -1;
DRA5_Results.Mars_ISRU.Replacements = -1;
DRA5_Results.Mars_ISRU.Mass = -1;
DRA5_Results.Mars_ISRU.Power = -1;
DRA5_Results.Mars_ISRU.Volume = -1;
DRA5_Results.Mars_ISRU.Fuel_Output = -1;
DRA5_Results.Mars_ISRU.Oxidizer_Output = -1;
% Lunar ISRU
DRA5_Results.Lunar_ISRU.Consumables = -1;
DRA5_Results.Lunar_ISRU.Spares = -1;
DRA5_Results.Lunar_ISRU.Replacements = -1;
DRA5_Results.Lunar_ISRU.Mass = -1;
DRA5_Results.Lunar_ISRU.Power = -1;
DRA5_Results.Lunar_ISRU.Volume = -1;
DRA5_Results.Lunar_ISRU.Fuel_Output = -1;
DRA5_Results.Lunar_ISRU.Oxidizer_Output = -1;
% ISFR
DRA5_Results.ISFR.Consumables = -1;
DRA5_Results.ISFR.Spares = -1;
DRA5_Results.ISFR.Replacements = -1;
DRA5_Results.ISFR.Mass = -1;
DRA5_Results.ISFR.Power = -1;
DRA5_Results.ISFR.Volume = -1;
DRA5_Results.ISFR.Fuel_Output = -1;
DRA5_Results.ISFR.Oxidizer_Output = -1;
% Power plant
DRA5_Results.PowerPlant.Consumables = -1;
DRA5_Results.PowerPlant.Spares = -1;
DRA5_Results.PowerPlant.Replacements = -1;
DRA5_Results.PowerPlant.Mass = -1;
DRA5_Results.PowerPlant.Power = -1;
DRA5_Results.PowerPlant.Volume = -1;
DRA5_Results.PowerPlant.Fuel_Output = -1;
DRA5_Results.PowerPlant.Oxidizer_Output = -1;

results = ResultsCompare(Results,DRA5_Results);
