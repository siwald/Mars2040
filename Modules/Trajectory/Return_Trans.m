function [ Return_SC, Mars_Fuel, Mars_O2 ] = Return_Trans( Cur_Arch, Descent_SC, Trans_SC, ~ )
%TRANSIT Solving for the Mass to Orbit based on the staging points and fuel
%sources, this is for the outgoing leg
%   Cur_Arch is the Architecture object for the current architecture,
%   Descent_SC in the spacecraft that descends to Mars Surface based on EDL
%   module, Trans_SC is the partially complete spacecraft from the Return
%   leg module, and Mission Type defines whether this is a human or cargo
%   mission.

%% ------Inputs and ititializations------
%Initialize the propulsion class from the current architecture
switch char(Cur_Arch.PropulsionType)
    case 'LH2'
        Cur_Prop = Propulsion.LH2;
    case 'NTR'
        Cur_Prop = Propulsion.NTR;
    case 'SEP'
        Cur_Prop = Propulsion.SEP;
    case 'CH4'
        Cur_Prop = Propulsion.CH4;
    otherwise
        disp('Architecture Propulsion error')
end

%Initialize the spacecrafts
    switch Cur_Arch.TransitTrajectory
        case 'Hohmann'
            Arrival_SC = Trans_SC; %Copy transit vehicle from Trans Hab Module
             %add descent vehicle and trans vehicle together
            Arrival_SC.Payload_Mass = (Descent_SC.Origin_Mass - Descent_SC.Hab_Mass) + Arrival_SC.Payload_Mass;
            Arrival_SC.Hab_Mass = Descent_SC.Hab_Mass + Arrival_SC.Hab_Mass;
            Arrival_SC.Hab_Vol = Descent_SC.Hab_Vol + Arrival_SC.Hab_Vol;
            Departure_Stage = SC_Class(Arrival_SC.Origin_Mass,0,'Departure Stage to Trans-Earth Injection');
        case 'Elliptic' %should be same as Hohmann
            Arrival_SC = SC_Class(Descent_SC.Origin_Mass,0,'Arrival Vehicle without Depart Stage');
            Departure_Stage = SC_Class(Arrival_SC.Origin_Mass,0,'Departure Vehicle');
        case 'Cycler_1L1'
            Taxi = SC_Class;
        case 'Cycler_2L3'
        otherwise
            disp('Human Mission, Transit Trajectory error')
    end
end
            
%Initialize the Strings

Stage_Point = char(Cur_Arch.Staging); %convert architecture 'location' type to string

%% Get the spacecraft at departure based on the selected transit orbit

switch Cur_Arch.TransitTrajectory
    case 'Hohmann'
        switch Cur_Arch.OrbitCapture
            case 'PropulsiveCapture'
                %arrival stage
                dV = Hohm_Chart('TMI','Earth'); %lookup final (arrival) stage in the dV in the Hohmann chart
                Arrival_SC = Propellant_Mass(Cur_Prop, Arrival_SC, dV); %Calc the S/C
               
                %departure stage
                dV = Hohm_Chart('LMO','TMI'); %lookup dV to get from stage point to Trans Mars Injection
                Departure_Stage.Payload_Mass = Arrival_SC.Origin_Mass; %update departure stage payload
                Departure_Stage = Propellant_Mass(Cur_Prop,Departure_Stage, dV); %Determine Departure Stage Fuel and Engine masses
                Mars_Fuel = Departure_Stage.Fuel_Mass;

            case 'Aerocapture'
                %should be capture code that outputs SC_Inst with mass to mars approach
                dV = Hohm_Chart(Stage_Point,'TMI');%lookup dV to mars approach
                Dep_Mass = Propellant_Mass(Cur_Prop, SC_Inst, dV); %Calc SC_Inst properties to get to aerocapture point (Mars Approach)
        end
    case 'Cycler_1L1'
        Approach_Vinf = 9.75; % McConaghy, Longuski & Byrnes
        Departure_Vinf = 6.54;% McConaghy, Longuski & Byrnes
        disp('Not Yet')
    case 'Cycler_2L3'
        Approach_Vinf = 3.05; % McConaghy, Longuski & Byrnes
        Departure_Vinf = 5.65; % McConaghy, Longuski & Byrnes
        disp('Not Yet')
    case 'Elliptical'
        disp('Not Yet')
end


%% Fuel Depot Section
                %Return Spacecraft definition, less Fuel from Mars
Return_SC = Departure_Stage; %initialize the Return_SC
if Cur_Arch.Return_Fuel = 'Mars_O2'
    Mars_O2 = Return_SC.Ox_Mass; %move O2 source to Mars
    Return_SC.Ox_Mass = 0;
elseif Cur_Arch.Return_Fuel = 'Mars_Fuel'
    Mars_Fuel = Return_SC.Fuel_Mass; %move fuel source to Mars
    Return_SC.Fuel_Mass = 0;
elseif Cur_Arch.Return_Fuel = 'Mars_All'
    Mars_O2 = Return_SC.Ox_Mass; %move both to Mars
    Return_SC.Ox_Mass = 0;
    Mars_Fuel = Return_SC.Fuel_Mass;
    Return_SC.Fuel_Mass = 0;
elseif Cur_Arch.Return_Fuel = 'Earth'
    Mars_O2 = 0; %move no source to Mars
    Mars_Fuel = 0;
end
Return_SC.Description = 'SC for return to Earth';
end