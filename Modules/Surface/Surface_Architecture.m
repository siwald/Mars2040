function [MTMS, Astronaut_Sci_Time] = Surface_Architecture (Cur_Arch, Mars_ISRU_Fuel, Ox_From_Mars)
%% Calulations
    
    %% Surface Begin   
    Cur_Arch = MarsArchitecture.DEFAULT;
    Surface_Output = Results_Class(1);
    Mars_ISRU_Fuel = 0;
    Ox_From_Mars = 0;
    
    %% -----Surf Structure----- (Chris)
    
%     The inputs are:
%     Cur_Arch
%     Rad_Exposure
%     
%     The outputs are:
%     Crew_Activity (Structure as of right now, may turn in to a class later)
%                     Crew_Acitivity.EVA_Freq (Units: EVA/wk Type:Number) for frequency of EVA activities
%                     Crew_Activity.CM_EVA (Units: CM/EVA Type: Number) for crew members per EVA activity
%                     Crew_Activity.EVA_Dur (Units: hrs/CM Type: Number) for duration of EVA activities
%     Hab_Mass_Resupply
%     Hab_Mass_Infra(eventually)
%     Habitat_Volume_Infra ( Units: m^3 Type:Number)
    
    [Surf_Mass, Surf_Volume, Surf_Power] = Surface_Habitat(Cur_Arch);
    
    
%     %% -----Surf ECLSS Module----- (Chris)

%     The input is:
%     Food_Supply (Units: % Type: Number) this is percent of food grown on Mars
%     Crew_Activity (Structure as of right now, may turn in to a class later)
%                     Crew_Acitivity.EVA_Freq (Units: EVA/wk Type:Number) for frequency of EVA activities
%                     Crew_Activity.CM_EVA (Units: CM/EVA Type: Number) for crew members per EVA activity
%                     Crew_Activity.EVA_Dur (Units: hrs/CM Type: Number) for duration of EVA activities
%     Habitat_Volume ( Units: m^3 Type:Number)
% 
%     The outputs are:
%     ISRU_Requirements (Structure as of right now, may turn in to a class later)
%                     ISRU_Requirements.Oxygen (Units: kg/day Type: Number) for expected oxygen usage
%                     ISRU_Requirements.Water (Units: kg/day Type: Number)  for expected water usage
%                     ISRU_Requirements.Nitrogen (Units: kg/day Type: Number)  for expected nitrogen usage
%                     ISRU_Requirements.CO2 (Units: kg/day Type: Number)  for expected CO2 usage
%     ECLSS_Power (Units: kW Type:Number)
%     ECLSS_Mass (Units: kg/mission Type:Number)
%     ECLSS_Volume(Units: m^3/mission Type:Number)

    [ISRU_Requirements, ECLSS_Power, ECLSS_Mass, ECLSS_Volume] = ECLSS(Cur_Arch,Surf_Volume);
    Surface_Output.ECLSS = {'POWER' ECLSS_Power; 'MASS' ECLSS_Mass; 'VOLUME' ECLSS_Volume};
    
%     
%     %% -----Surf ISRU Module----- (Chris)
%     %{
%     The inputs are:
%     Cur_Arch,
%     Mars_ISRU_Fuel,
%     Hab_Mass,
%     ECLSS_Mass
%     
%     The outputs are:
%     ISRU_Mass_Resupply,
%     ISRU_Power_Req,
%     ISRU_spares
%     %}
%     
    [ISRU_Power, ISRU_Volume, ISRU_Mass] = ISRU(Cur_Arch, ISRU_Requirements, Ox_From_Mars);
    Surface_Output.Mars_ISRU = {'POWER' ISRU_Power; 'MASS' ISRU_Mass; 'VOLUME' ISRU_Volume};
% 
%         
%     
%     %% -----Surf Power Module----- (Chris)
%     %{
%     The inputs are: Cur_Arch, Hab_Power_Req, ISRU_Power_Req, Science_Req
%     The outputs are: Power_Mass_Resupply, Power_Mass_Setup (eventually)
%     %}
        
    Cumulative_Power = Surf_Power + ECLSS_Power + ISRU_Power;
    [Power_Mass, Power_Volume] = Surface_Power(Cur_Arch, Cumulative_Power);
    Surface_Output.PowerPlant = {'MASS' Power_Mass; 'VOLUME' Power_Volume};
    
 %     
%     %% -----ISFR Module----- (Chris)
%     %{
%     The inputs are: Cur_Arch, Hab_Spares, ECLSS_Spares, ISRU_Spares
%     The outputs are: ISFR_Power_Req, ISFR_Mass_Resupply,
%     ISFR_Mass_Infra(eventually)
%     %}
%     
%     %sum up the total spares needed from previous modules
%     Total_Spares_Mass = Hab_Spares, ECLSS_Spares, ISRU_Spares + Science_Spares;
%     
%     %determine the current architectural decisions
%     ISFR = Cur_Arch.ISFR_Index;
%     
%     switch ISFR 
%         case 'None'
%         Spares_Mass = Total_Spares_Mass;
%         ISFR_Power_Req = 0;
%         ISFR_Mass_Resupply = 0;
%         ISFR_Mass_Infra = 0;
%         
%         case 'Plastic'
%         Spares_Mass = Total_Spares_Mass * metal_ratio;
%         ISFR_Prod = Total_Spares_Mass * plastic_ratio;
%         [ISFR_Power_Req, ISFR_Mass_Resupply, ISFR_Mass_Infra, ISFR_Risk] = ISFR_Plastics(ISFR_Prod);
%         
%         case 'Metals'
%         Spares_Mass = Total_Spares_Mass * plastic_ratio;
%         ISFR_Prod = Total_Spares_Mass * metals_ratio;
%         [ISFR_Power_Req, ISFR_Mass_Resupply, ISFR_Mass_Infra, ISFR_Risk] = ISFR_Metals(ISFR_Prod);
%        
%         case 'Both'
%         metal_Spares = Total_Spares_Mass * metal_ratio;
%         [metal_Power_Req, metal_Mass_Resupply, metal_Mass_Infra, metal_Risk] = ISFR_Metals(metal_Spares);
%         plastic_Spares = Total_Spares_Mass * plastic_ratio;
%         [plastic_Power_Req, plastic_Mass_Resupply, plastic_Mass_Infra, plastic_Risk] = ISFR_Plastics(plastic_Spares);
%         
%         ISFR_Power_Req = metal_Power_Req + plastic_Power_Req;
%         ISFR_Mass_Resupply = metal_Mass_Resupply + plastic_Mass_Resupply;
%         ISFR_Mass_Infra = metal_Mass_Infra + plastic_Mass_Infra;
%         ISFR_Risk = metal_Risk + plastic_Risk;
%         
%         otherwise
%         error('ISFR poorly defined in Morph Matrix, should be: None, Plastic, Metals or Both')
%     end
%     
%     
        Surf_Spares = (Surf_Mass + ECLSS_Mass + ISRU_Mass + Power_Mass) * 0.5; % Assume 50% ISFR rate for spiral 1
        Surface_Output.ISFR = Surf_Spares;
        %Total_Risk = Total_Risk + ISFR_Risk   
    %% -----Site Selection Analysis----- (Ryan)
    %{
    The inputs are:Cur_Arch
    The outputs are:Rad_Exposure, Site_Sci_Value
    %}
    
    Astronaut_Sci_Time = Astronaut_Time(Cur_Arch, Surf_Spares);
    Surface_Output.Science = Astronaut_Sci_Time
%     
%     %% Transfer to Logistics
     MTMS = Surf_Spares;
%     %IMMS = Hab_Mass_Infra + ISRU_Mass_Infra + Science_Mass_Infra + Power_Mass_Infra;
    
end
    
   