t
%% Setup
%--Tradespace Enumeration--

%Morpholigical Definition
Num_Astro = [ 4 ]; % 6 10 20 100
Human_Trajectory = [ cellstr('Hohmann') cellstr('1L1Cycler') cellstr('2L3Cycler') cellstr('Elliptical') ];
Cargo_Trajectory = [ cellstr('Hohmann') cellstr('Spiral') cellstr('Elliptical') ];
Staging = [ cellstr('LEO') cellstr('EML1') cellstr('LLO') cellstr('None') cellstr('EML2') cellstr('LDRO') ];
Transit_Fuel_Source = [ cellstr('Earth') cellstr('Moon') ];
Return_Fuel_Source = [ cellstr('Earth') cellstr('Moon') cellstr('Mars') ];
Propulsion = [ cellstr('H2') cellstr('Methane') cellstr('NTR') cellstr('SEP') ];
Entry = [ cellstr('Propulsive') cellstr('Aerocapture') ];
EDL = [ cellstr('Propulsive') cellstr('Aerobraking') ];
Trans_Rad_Sheild = [ cellstr('Water') cellstr('Cargo') cellstr('Aluminum') ];
Trans_Rad_Sheild_Qty = [ cellstr('Permanent') cellstr('Temporary') ];
Trans_Hab_Size = [ cellstr('Min') cellstr('10') cellstr('Spacious') ];
Site_Selection = [ cellstr('Gusev Crater') cellstr('Holden Crater') cellstr('Mawrth Vallis') cellstr('Gale Crater') ];
Base_of_ISRU = [ cellstr('None') cellstr('Soil') cellstr('Atm') cellstr('Both') ];
Gas_Processing = [ cellstr('O2') cellstr('O2/CH4') cellstr('O2/LH2') ];
ISRU_Use = [ cellstr('None') cellstr('Fuel') cellstr('Water') ];
Food_Supply = [ 0 50 100 ]; %percentage of food that is grown on Mars
Rad_Prot = [ cellstr('Regolith') cellstr('Lava tube') cellstr('Aluminum') ];
Structure = [ cellstr('Fixed') cellstr('Inflatable') cellstr('Hybrid') ];
Number_of_sites = [ 1 2 4 5 ];
ISFR_Consumables = [ cellstr('None') cellstr('Polymer') cellstr('Metal') ];
Surface_Power = [ cellstr('Solar') cellstr('Fuel Cell') cellstr('RTG') cellstr('Nuclear') cellstr('Hybrid') ];
Earth_Entry = [cellstr('Direct') cellstr('PreCirc') ];

%Enumeration Code
Enumerated = ALLCOMB(Num_Astro, Human_Trajectory ,Cargo_Trajectory ,Staging ,Transit_Fuel_Source ,Return_Fuel_Source ,Propulsion ,Entry ,EDL ,Trans_Rad_Sheild ,Trans_Rad_Sheild_Qty ,Trans_Hab_Size ,Site_Selection ,Base_of_ISRU ,Gas_Processing ,ISRU_Use ,Food_Supply ,Rad_Prot ,Structure ,Number_of_sites ,ISFR_Consumables ,Surface_Power, Earth_Entry)
%generates a matrix, where each row is a different architecture, and each
%cell is a decision, the contents of which is the specific choice
%for that architecture.

%Preallocate the results array
Results = zeros(size(Enumerated,1),4); %1 row for every architectureal combo, 4 cols: Arch #, IMLEO, Sci_Val, Risk

%% Calulations

%for loop, go through each row indicating a seperate architceture, i
parfor i=1:size(Enumerated,1)
    
    %extract the ith architcecture from the enumerated matrix
    Cur_Arch = Enumerated(i,:);
        
    %test this architecture 
    %XXXXX Nathans Class Code XXXXX
    if NathansTest == fail
        fail = zeros (1,4); %temporary results vector, necessary for parfor
        fail(1) = i; %add the architecture number
        Results (i,:)=fail; %input into the correct place in the global Results matrix
        continue
    end
   
    %% Logistics Setup and Return Logistics
    
    %% -----Trans Hab Module-----(Nathan)
    %{
    INPUTS: Cur_Arch
    OUTPUTS: Trans_Hab_Mass
    %}
    
    Trans_Hab_Mass = Trans_Hab_Module (Cur_Arch);
    
    
    %% -----Propulsion Module-----(Eric)
    %{
    INPUTS: Cur_Arch
    OUTPUTS: Prop_Nums; Isp, FOx Ratio and Inert Mass Ratio
    %}
    
    Prop_Nums = Prop_Lookup (Cur_Arch); %Prop_Nums is a 1x3 array with Isp, Fuel-to-Oxidizer Ratio and Inert Mass Ratio in that order
    
  
    %% ------Transit Module (return)-----(Eric)
    %{
    INPUTS: Cur_Arch, Trans_Hab_Mass, Prop_Nums
    Calls: Destination = Earth, Origin = Mars Orbit
    OUTPUTS: Mars_Area_Fuel, Earth_Area_Fuel, Time_of_Flight_Return
    %}
    
    [ Mars_Area_Fuel, Earth_Area_Fuel, Return_Engine_Mass] = Transit (Cur_Arch, Trans_Hab_Mass, Prop_Nums);
    
    Return_SC_Mass = Trans_Hab_Mass + Return_Engine_Mass
    
    
    %% -----Ascent----- (Eric)
    %{
    INPUTS: Cur_Arch, Mars_Area_Fuel, Prop_Nums
    OUTPUTS: Ascent_Vehicle_Mass, Ascent_Fuel
    %}
    
    %% ----Transfer to Surface---- (Eric)
    
    %Transfer to Surface: Mars_ISRU_Fuel
    %Transfer to Logistics Outgoing: Trans_Hab_Mass, Earth_Area_Fuel, Isp,
    %FOx_Ratio, InertM_Ratio
    
    %% Surface Begin   
    
       
    %% -----Site Selection Analysis----- (Ryan)
    %{
    INPUTS:Cur_Arch
    OUTPUTS:Rad_Exposure, Site_Sci_Value
    %}
    
    
    %% -----Surf Structure----- (Chris)
    %{
    INPUTS:Cur_Arch, Rad_Exposure
    OUTPUTS:Hab_ISRU_Consume, Hab_Spares, Science_Cpk, Hab_Mass_Resupply, Hab_Mass_Infra(eventually)
    %}
    
    
    %% -----Surf ECLSS Module----- (Chris)
    %{
    INPUTS: Cur_Arch
    OUTPUTS: ECLSS_ISRU_Consume, ECLSS_Spares, ECLSS_Mass_Resupply, ECLSS_Mass_Infra(eventually)
    Hab_Power_Req, Hab_ISRU_Consume,
    Hab_Mass_Infra(eventuall)
    %}
    
    %% -----Surf ISRU Module----- (Chris)
    %{
    INPUTS: Cur_Arch, Mars_ISRU_Fuel, Hab_ISRU_Consume, ECLSS_ISRU_Consume
    OUTPUTS: ISRU_Mass_Resupply, ISRU_Power_Req, ISRU_spares
    %}
    
    %extract relevant architectural decisions
    ISRU_Use = Cur_Arch(ISRU_Use_Index);
    
    Total_Surf_ISRU_Req = Mars_ISRU_Fuel + ECLSS_ISRU_Consume + Hab_ISRU_Consume;
        
    [ISRU_Mass_Resupply, ISRU_Mass_Infra, ISRU_Risk] = ISRU(Total_Surf_ISRU_Req, ISRU_Use);
         
    Total_Risk = Total_Risk + ISRU_Risk;
    ISRU_Spares = ISRU_Mass_Infra * Spares_Ratio;
    
    
    
    %% -----Science Module----- (Ryan)
    %{
    INPUTS: Cur_Arch, Site_Sci_Value, Science_Cpk
    OUTPUTS: Science_Value_per_Time, Science_Power_Req, Science_Spares, Science_Mass_Resupply,
    Science_Mass_Setup (eventually)
    %}
    
    
    
    %% -----ISFR Module----- (Chris)
    %{
    INPUTS: Cur_Arch, Hab_Spares, ECLSS_Spares, ISRU_Spares
    OUTPUTS: ISFR_Power_Req, ISFR_Mass_Resupply,
    ISFR_Mass_Infra(eventually)
    %}
    
    %sum up the total spares needed from previous modules
    Total_Spares_Mass = Hab_Spares, ECLSS_Spares, ISRU_Spares + Science_Spares;
    
    %determine the current architectural decisions
    ISFR = Cur_Arch(ISFR_Index);
    
    switch ISFR 
        case 'None'
        Spares_Mass = Total_Spares_Mass;
        ISFR_Power_Req = 0;
        ISFR_Mass_Resupply = 0;
        ISFR_Mass_Infra = 0;
        
        case 'Plastic'
        Spares_Mass = Total_Spares_Mass * metal_ratio;
        ISFR_Prod = Total_Spares_Mass * plastic_ratio;
        [ISFR_Power_Req, ISFR_Mass_Resupply, ISFR_Mass_Infra, ISFR_Risk] = ISFR_Plastics(ISFR_Prod);
        
        case 'Metals'
        Spares_Mass = Total_Spares_Mass * plastic_ratio;
        ISFR_Prod = Total_Spares_Mass * metals_ratio;
        [ISFR_Power_Req, ISFR_Mass_Resupply, ISFR_Mass_Infra, ISFR_Risk] = ISFR_Metals(ISFR_Prod);
       
        case 'Both'
        metal_Spares = Total_Spares_Mass * metal_ratio;
        [metal_Power_Req, metal_Mass_Resupply, metal_Mass_Infra, metal_Risk] = ISFR_Metals(metal_Spares);
        plastic_Spares = Total_Spares_Mass * plastic_ratio;
        [plastic_Power_Req, plastic_Mass_Resupply, plastic_Mass_Infra, plastic_Risk] = ISFR_Plastics(plastic_Spares);
        
        ISFR_Power_Req = metal_Power_Req + plastic_Power_Req;
        ISFR_Mass_Resupply = metal_Mass_Resupply + plastic_Mass_Resupply;
        ISFR_Mass_Infra = metal_Mass_Infra + plastic_Mass_Infra;
        ISFR_Risk = metal_Risk + plastic_Risk;
        
        otherwise
        error('ISFR poorly defined in Morph Matrix, should be: None, Plastic, Metals or Both')
    end
    
    Total_Risk = Total_Risk + ISFR_Risk

        
    
    %% -----Surf Power Module----- (Chris)
    %{
    INPUTS: Cur_Arch, Hab_Power_Req, ISRU_Power_Req, Science_Req
    OUTPUTS: Power_Mass_Resupply, Power_Mass_Setup (eventually)
    %}
    
    %% Transfer to Logistics
    MTMS = Hab_Mass_Resupply + ISRU_Mass_Resupply + Science_Mass_Resupply + Power_Mass_Resupply;
    %IMMS = Hab_Mass_Infra + ISRU_Mass_Infra + Science_Mass_Infra + Power_Mass_Infra;
    
    %% Outgoing Logistics Begin
    
    
    %% -----EDL Module----- (Eric)
    %{
    INPUTS: Cur_Arch, FMMS, IMMS(eventually)
    OUTPUTS: MTMD, Time_of_Flight_Descent
    %}
    
    MTMO = MTMD + Earth_Area_Fuel; %Mass to Mars Orbit is the Mass to Mars Descent plus the Return Fuel from earth area
    
    %% ------Transit Module----- (Eric)
    %{
    INPUTS: Cur_Arch, MTMO, Trans_Hab_Mass, Prop_Nums,
    Time_of_Flight_Descent, Time_of_Flight_Return
    CALLS: Destination = Mars Orbit, Origin = Staging Point
    OUTPUTS: Departure_Mass, Departure_Fuel, Days_on_Mars,
    Total_Time_of_Flight
    %}
    
   
    % -----Rendevous Module----- (Eric)
    %{
    INPUTS: Cur_Arch, Departure_Mass, Departure_Fuel, Isp, FOx_Ratio,
    InertM_Ratio
    OUTPUTS: IMLEO, Rendevous_Risk
    %}
    
    %% Results
    Scientific_Value = Science_Value_per_Time * Days_on_Mars;
    Total_Risk = Surface_Risk + Logistics_Risk;
    
    %display the results
    disp('Architecture number:')
    disp(i)
    disp(IMLEO)
    disp(Scientific_Value)
    disp(Total_Risk)
    
    %add the results into the Results matrix
    Cur_Results = zeros(1,4); %initialize a temporary results vector, necessary for parfor
    
    Cur_Results(1) = i; %architecture number
    Cur_Results(2)=IMLEO;
    Cur_Results(3)=Scientific_Value;
    Cur_Results(4)=Total_Risk;
        
    Results(i,:) = Cur_Results; %input the entire Results vector into the appropriate row of the global results vector
    
    %% Close Loop
%end main for loop, go back and try the next architecture
end
disp (Results) %display the final results matrix