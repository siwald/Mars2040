function [ Spacecraft, Results] = Return_Trans( Cur_Arch, Spacecraft, Results)
%TRANSIT Solving for the Mass to Orbit based on the staging points and fuel
%sources, this is for the outgoing leg
%   Cur_Arch is the Architecture object for the current architecture,
%   Descent_SC in the spacecraft that descends to Mars Surface based on EDL
%   module, Trans_SC is the partially complete spacecraft from the Return
%   leg module, and Mission Type defines whether this is a human or cargo
%   mission.

%% ------Inputs and ititializations------
%Initialize the propulsion class from the current architecture
Cur_Prop = Cur_Arch.PropulsionType;
            
%Initialize the Strings

%% Get the spacecraft at departure based on the selected transit orbit

switch Cur_Arch.CrewTrajectory
    case TrajectoryType.HOHMANN
        switch Cur_Arch.ReturnCapture
       %switch Cur_Arch.EarthCapture
            case ReturnEntry.PROPULSIVE
%                 %arrival stage
%                 dV = Hohm_Chart('TMI','LEO'); %lookup final (arrival) stage in the dV in the Hohmann chart
%                 Arrival_SC = Propellant_Mass(Cur_Prop, Arrival_SC, dV); %Calc the S/C
%                
%                 %departure stage
%                 dV = Hohm_Chart('LMO','TMI'); %lookup dV to get from stage point to Trans Mars Injection
%                 Return_SC.Payload_Mass = Arrival_SC.Origin_Mass; %update departure stage payload
%                 Return_SC = Propellant_Mass(Cur_Prop,Return_SC, dV); %Determine Departure Stage Fuel and Engine masses
%                 Mars_Fuel = Return_SC.Fuel_Mass;

            case ReturnEntry.AEROCAPTURE
%                 Cap_Syst_Mass = 4000; %est basd on DRA 5.0 Add 1 pg 99.
%                 Arrival_SC.Bus_Mass = Cap_Syst_Mass; %Calc the S/C
%                 origin_calc(Arrival_SC);
%                 
%                 %departure stage
%                 dV = Hohm_Chart('LMO','TMI'); %lookup dV to get from stage point to Trans Mars Injection
%                 Return_SC.Payload_Mass = Arrival_SC.Origin_Mass; %update departure stage payload
%                 Return_SC = Propellant_Mass(Cur_Prop,Return_SC, dV); %Determine Departure Stage Fuel and Engine masses
            
            case ReturnEntry.DIRECT
                %Arrival Stage is just direct Entry by the Earth Entry
                %module
                
                %Mars Depature Stage
                dV = Hohm_Chart('LMO','TMI');%lookup trans-earth injection in the Hohm chart table
                Return_Engine = SC_Class('Return Engines'); %Initialize the Return Engine S/C module
                Return_Engine = Propellant_Mass(Cur_Prop, Return_Engine, dV, Spacecraft.Mass);
                Spacecraft.Add_Craft = Return_Engine;
        end
%     case TrajectoryType.1L1
%         Approach_Vinf = 9.75; % McConaghy, Longuski & Byrnes
%         Departure_Vinf = 6.54;% McConaghy, Longuski & Byrnes
%         disp('Not Yet')
%     case TrajectoryType.2L3
%         Approach_Vinf = 3.05; % McConaghy, Longuski & Byrnes
%         Departure_Vinf = 5.65; % McConaghy, Longuski & Byrnes
%         disp('Not Yet')
    case TrajectoryType.ELLIPTICAL
        disp('Not Yet')
end


%% Fuel Depot Section
if isempty(Results.Mars_ISRU.Oxidizer_Output)
    Results.Mars_ISRU.Oxidizer_Output = 0; %initialize this if empty
end
if isempty(Results.Mars_ISRU.Fuel_Output)
    Results.Mars_ISRU.Fuel_Output = 0; %initialize this if empty
end

if ~(Cur_Arch.PropulsionType == Propulsion.CH4)
 %Normal ISRU if not CH4
    %Move Ox to Mars ISRU if appropriate
    if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_O2, ...
            Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_O2)
        Results.Mars_ISRU.Oxidizer_Output = Results.Mars_ISRU.Oxidizer_Output + Spacecraft.Ox_Mass; %add O2 to Mars generation
        remove_ox(Spacecraft); %remove all O2 from Spacecraft Modules
    end
    %Move Fuel to Mars ISRU if appropriate
    if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_LH2, ...
           Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_LH2)
            Results.Mars_ISRU.Fuel_Output = Results.Mars_ISRU.Fuel_Output + Spacecraft.Fuel_Mass; %add LH2 to Mars generation
            remove_fuel(Spacecraft); %remove all LH2 from Spacecraft Modules
    end

elseif (Cur_Arch.PropulsionType == Propulsion.CH4)
  %if CH4, and fuel ISRU, use Sabatier
    if or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_LH2, ...
           Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_LH2)
       %If CH4 and Fuel ISRU, use Sabatier, both CH4 and O2, produced.
            Results.Mars_ISRU.CH4_Prop_Output = Results.Mars_ISRU.Fuel_Output + Spacecraft.Fuel_Mass + Spacecraft.Ox_Mass; %add LH2 to Mars generation
            remove_fuel(Spacecraft); %remove all LH2 from Spacecraft Modules
            remove_ox(Spacecraft); %remove all O2 from Spacecraft Modules
    elseif or(Cur_Arch.ReturnFuel(1) == ReturnFuel.MARS_O2, ... use else-if to skip if it already move O2 because Sabatier
            Cur_Arch.ReturnFuel(2) == ReturnFuel.MARS_O2) 
        Results.Mars_ISRU.Oxidizer_Output = Results.Mars_ISRU.Oxidizer_Output + Spacecraft.Ox_Mass; %add O2 to Mars generation
        remove_ox(Spacecraft); %remove all O2 from Spacecraft Modules
    end
    
end

end