%% Setup
%--Tradespace Enumeration--

%             %Morpholigical Definition
%             Num_Astro = { 4 }; % 6 10 20 100
%             Human_Trajectory = { cellstr('Hohmann') cellstr('1L1Cycler') cellstr('2L3Cycler') cellstr('Elliptical') };
%             Cargo_Trajectory = { cellstr('Hohmann') cellstr('Spiral') cellstr('Elliptical') };
%             Staging = { cellstr('LEO') cellstr('EML1') cellstr('LLO') cellstr('None') cellstr('EML2') cellstr('LDRO') };
%             Transit_Fuel_Source = { cellstr('Earth') cellstr('Moon') };
%             Return_Fuel_Source = { cellstr('Earth') cellstr('Moon') cellstr('Mars') };
%             Propulsion = { cellstr('H2') cellstr('Methane') cellstr('NTR') cellstr('SEP') };
%             Entry = { cellstr('Propulsive') cellstr('Aerocapture') };
%             EDL = { cellstr('Propulsive') cellstr('Aerobraking') };
%             Trans_Rad_Sheild = { cellstr('Water') cellstr('Cargo') cellstr('Aluminum') };
%             Trans_Rad_Sheild_Qty = { cellstr('Permanent') cellstr('Temporary') };
%             Trans_Hab_Size = { cellstr('Min') cellstr('10') cellstr('Spacious') };
%             Site_Selection = { cellstr('Gusev Crater') cellstr('Holden Crater') cellstr('Mawrth Vallis') cellstr('Gale Crater') };
%             Base_of_ISRU = { cellstr('None') cellstr('Soil') cellstr('Atm') cellstr('Both') };
%             Gas_Processing = { cellstr('O2') cellstr('O2/CH4') cellstr('O2/LH2') };
%             ISRU_Use = { cellstr('None') cellstr('Fuel') cellstr('Water') };
%             Food_Supply = { 0 50 100 }; %percentage of food that is grown on Mars
%             Rad_Prot = { cellstr('Regolith') cellstr('Lava tube') cellstr('Aluminum') };
%             Structure = { cellstr('Fixed') cellstr('Inflatable') cellstr('Hybrid') };
%             Number_of_sites = { 1 2 4 5 };
%             ISFR_Consumables = { cellstr('None') cellstr('Polymer') cellstr('Metal') };
%             Surface_Power = { cellstr('Solar') cellstr('Fuel Cell') cellstr('RTG') cellstr('Nuclear') cellstr('Hybrid') };
%             Earth_Entry = {cellstr('Direct') cellstr('PreCirc') };
% 
%             %Enumeration Code
%             Enumerated = allcomb(Num_Astro, Human_Trajectory ,Cargo_Trajectory ,Staging ,Transit_Fuel_Source ,Return_Fuel_Source ,Propulsion ,Entry ,EDL ,Trans_Rad_Sheild ,Trans_Rad_Sheild_Qty ,Trans_Hab_Size ,Site_Selection ,Base_of_ISRU ,Gas_Processing ,ISRU_Use ,Food_Supply ,Rad_Prot ,Structure ,Number_of_sites ,ISFR_Consumables ,Surface_Power, Earth_Entry)
%             %generates a matrix, where each row is a different architecture, and each
%             %cell is a decision, the contents of which is the specific choice
%             %for that architecture.
%              disp(size(Enumerated,1))
%             %Preallocate the results array
%             Results = zeros(size(Enumerated,1),4); %1 row for every architectureal combo, 4 cols: Arch #, IMLEO, Sci_Val, Risk


%% Calulations

%for loop, go through each row indicating a seperate architceture, i
 %parfor i=1:size(Enumerated,1)
 parfor i=1:1
 tic
    
    %extract the ith architcecture from the enumerated matrix
    Cur_Arch = MarsArchitecture.DEFAULT; %test Case for now.
   
    %% Logistics Setup and Return Logistics
    
    %% ----- Transit Habitation Module-----(Joe)
    %{
    The inputs are: 
        Cur_Arch
	
    The outputs are:
        Trans_Hab_Volume - in kW?
        Trans_Hab_Mass - in m3?
        Trans_Hab_Mass - in kg?
    
        ???
        Return_SC
            .Hab_M defined
    %}
    [Trans_Hab_Power,... % TODO: units?
        Trans_Hab_Volume,... % TODO: units?
        Trans_Hab_Mass... % TODO: units?
        ] = Transit_Habitat(Cur_Arch); % Calculate the Transit Habitat needs from current architecture
    
    %Create Trans_Hab spacecraft with mass numbers from Transit_Habitat module
    Trans_Hab = SC_Class(0,Trans_Hab_Mass,'Trans Hab for crew support'); 

    %% ------Transit Module (return)-----(Eric)
    %{
    The inputs are: 
        Cur_Arch, this main loop's instance of the Arch_Class 
        Return_S_C, instance of S_C_Class with these defined: 
            .Payload_M
            .Hab_M
        Prop_Nums, instance of Prop_Class with these defined:
            .Isp
            .FOx_Rat
            .InertM_Rat
    Calls: Destination = Earth, Origin = Mars Orbit
    The outputs are: 
        Return_S_C, an instance of the S_C_Class, now with these defined:
            .Payload_M
            .Hab_M
            .Prop_M *added
            .Fuel_M *added
            .Ox_M *added
            .Bus_M *added
            .Origin_M *added
    %}
    
    %Calculate the Earth Descent Craft
    Earth_EDL_Mass = 0; %this should calculate the actual Earth EDL needs in Mass
    Descent_SC = SC_Class(Earth_EDL_Mass,0,'Earth Descent Craft');%initalize the Descent craft
    origin_calc(Descent_SC); %populate the origin mass of the descent craft
    Return_SC = SC_Class(Descent_SC.Origin_Mass,Trans_Hab.Origin_Mass,'Return craft with Transit Habitat and propulsion');
    [Return_SC, Fuel_From_Mars, Ox_From_Mars ] = Return_Trans (Cur_Arch, Descent_SC, Return_SC);
    Earth_Transit_Fuel = Return_SC.Fuel_Mass - Fuel_From_Mars;
    Earth_Transit_Ox = Return_SC.Ox_Mass - Ox_From_Mars;
        
    
    %% -----Ascent----- (Eric)
    %{
    The inputs are: Cur_Arch, Mars_Area_Fuel, Prop_Nums
    The outputs are: Ascent_Vehicle_Mass, Ascent_Fuel
    %}
    
    %initialize the Ascent_SC
    Ascent_SC = SC_Class((Fuel_From_Mars + Ox_From_Mars),0,'Launch Vehicle From Mars');
    origin_calc(Ascent_SC);
    Ascent_SC = Ascent(Cur_Arch, Ascent_SC);
    
    %include ascent vehicle fuel ISRU
    switch Cur_Arch.ReturnFuel
        case 'Mars_O2'
            Ox_From_Mars = Ox_From_Mars + Ascent_SC.Ox_Mass;
            Fuel_From_Mars = 0;
            Earth_Ascent_Fuel = Ascent_SC.Fuel_Mass;
            Earth_Ascent_Ox = 0;
        case 'Mars_Fuel'
            Fuel_From_Mars = Fuel_From_Mars + Ascent_SC.Fuel_Mass;
            Ox_From_Mars = 0;
            Earth_Ascent_Ox = Ascent_SC.Ox_Mass;
            Earth_Ascent_Fuel = 0;
        case 'Mars_All'
            Fuel_From_Mars = Fuel_From_Mars + Ascent_SC.Fuel_Mass;
            Ox_From_Mars = Ox_From_Mars + Ascent_SC.Ox_Mass;
            Earth_Ascent_Fuel = 0;
            Earth_Ascent_Ox = 0;
    end
  
    %% Surface Begin   
    
    [MTMS, Science_Val_per_Day]= Surface_Architecture(Cur_Arch, Fuel_From_Mars, Ox_From_Mars);
    MTMS = MTMS + Earth_Ascent_Fuel + Earth_Ascent_Ox;
    
    %% Outgoing Logistics Begin
    
    %% -----EDL Module----- (Eric)
    %{
    The inputs are: Cur_Arch, FMMS, IMMS(eventually)
    The outputs are: MTMD, Time_of_Flight_Descent
    %}
    
    %MTMO = MTMD + Earth_Area_Fuel; %Mass to Mars Orbit is the Mass to Mars Descent plus the Return Fuel from earth area
    Descent_Craft = SC_Class(MTMS,0,'Descent Craft');
    Descent_Craft.Bus_Mass = Descent_Craft.Origin_Mass;
    origin_calc(Descent_Craft);
    
    %% ------Transit Module----- (Eric)
    %{
    The inputs are: Cur_Arch, MTMO, Trans_Hab_Mass, Prop_Nums,
    Time_of_Flight_Descent, Time_of_Flight_Return
    CALLS: Destination = Mars Orbit, Origin = Staging Point
    The outputs are: Departure_Mass, Departure_Fuel, Days_on_Mars,
    Total_Time_of_Flight
    %}
    
   [IMLEO,Days_on_Mars] = Transit(Cur_Arch,Descent_Craft,Trans_Hab,'Human');
   
    %% Results
    Scientific_Value = Science_Val_per_Day * Days_on_Mars;
    if ~exist('Surface_Risk')
        Surface_Risk = 0;
    end
    if ~exist('Logistics_Risk')
        Logistics_Risk = 0;
    end
    Total_Risk = Surface_Risk + Logistics_Risk;
    
    %display the results
    disp('Architecture number:')
    disp(i)
    disp('IMLEO:')
    disp(IMLEO)
    disp('Scientific Value:')
    disp(Scientific_Value)
    disp('Total Risk:')
    disp(Total_Risk)
    
    %{
    %add the results into the Results matrix
    Cur_Results = zeros(1,4); %initialize a temporary results vector, necessary for parfor
    
    Cur_Results(1) = i; %architecture number
    Cur_Results(2)=IMLEO;
    Cur_Results(3)=Scientific_Value;
    Cur_Results(4)=Total_Risk;
        
    Results(i,:) = Cur_Results; %input the entire Results vector into the appropriate row of the global results vector
    %}
    runtime = toc
    %% Close Loop

 end %end main for loop, go back and try the next architecture
%disp (Results) %display the final results matrix