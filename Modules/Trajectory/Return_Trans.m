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
        switch Cur_Arch.OrbitCapture
       %switch Cur_Arch.EarthCapture
            case EntryType.PROPULSIVE
%                 %arrival stage
%                 dV = Hohm_Chart('TMI','LEO'); %lookup final (arrival) stage in the dV in the Hohmann chart
%                 Arrival_SC = Propellant_Mass(Cur_Prop, Arrival_SC, dV); %Calc the S/C
%                
%                 %departure stage
%                 dV = Hohm_Chart('LMO','TMI'); %lookup dV to get from stage point to Trans Mars Injection
%                 Return_SC.Payload_Mass = Arrival_SC.Origin_Mass; %update departure stage payload
%                 Return_SC = Propellant_Mass(Cur_Prop,Return_SC, dV); %Determine Departure Stage Fuel and Engine masses
%                 Mars_Fuel = Return_SC.Fuel_Mass;

            case EntryType.AEROCAPTURE
%                 Cap_Syst_Mass = 4000; %est basd on DRA 5.0 Add 1 pg 99.
%                 Arrival_SC.Bus_Mass = Cap_Syst_Mass; %Calc the S/C
%                 origin_calc(Arrival_SC);
%                 
%                 %departure stage
%                 dV = Hohm_Chart('LMO','TMI'); %lookup dV to get from stage point to Trans Mars Injection
%                 Return_SC.Payload_Mass = Arrival_SC.Origin_Mass; %update departure stage payload
%                 Return_SC = Propellant_Mass(Cur_Prop,Return_SC, dV); %Determine Departure Stage Fuel and Engine masses
            
            case EntryType.DIRECT
                %Arrival Stage is just direct Entry by the Earth Entry
                %module
                
                %Mars Depature Stage
                dV = Hohm_Chart('LMO','TMI');%lookup trans-earth injection in the Hohm chart table
                Return_Engine = SC_Class('Return Engines'); %Initialize the Return Engine S/C module
                Return_Engine = Propellant_Mass(Cur_Prop, Return_Engine, dV, Spacecraft.Mass);
                Spacecraft.Add_Craft(Return_Engine);
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
for i=1:2
    if Cur_Arch.ReturnFuel(i).Location == Location.MARS &.
        Results.Mars_ISRU.Oxidizer_Output = nansum([Results.Mars_ISRU.Oxidizer_Output, Spacecraft.Ox_Mass]); %add O2 to Mars generation
        remove_ox(Spacecraft); %remove all O2 from Spacecraft Modules
    end
    if (ReturnFuel.MARS_LH2 == Cur_Arch.ReturnFuel(i))
        if Cur_Arch.PropulsionType ~= Propulsion.CH4; %skip if Methane, can't gen on Mars ISRU
            Results.Mars_ISRU.Fuel_Output = nansum([Results.Mars_ISRU.Fuel_Output, Spacecraft.Fuel_Mass]); %add LH2 to Mars generation
            remove_fuel(Spacecraft); %remove all LH2 from Spacecraft Modules
        end
    end
end
end