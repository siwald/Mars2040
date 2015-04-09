function [ spacecraft, Results ] = NewTransit( Cur_Arch, spacecraft, type, Results)
%NEWTRANSIT Summary of this function goes here
%   Detailed explanation goes here

%swap trajectory based on type
switch type
    case 'Human'
        Cur_Trajectory = Cur_Arch.CrewTrajectory;
    case 'Cargo'
        Cur_Trajectory = Cur_Arch.CargoTrajectory;
end

%% Mars Capture
Cap_Stage = SC_Class('Mars Capture');
switch Cur_Arch.OrbitCapture
% switch Cur_Arch.MarsCapture %Define Capture Stage craft     
    case EntryType.AEROCAPTURE   %Based on AeroCapture AeroShell Mass
        Capture_Time = 30; %days based on DRA 5.0?
        Cap_Stage.Bus_Mass = 4000; %based on DRA5.0 ADD 1 pg.99
    case EntryType.PROPULSIVECAPTURE %Based on Propulsive Capture Engines
        Capture_Time = 0; %Don't need to wait in circularization
        Cap_Stage = Propellant_Mass(Cur_Arch.Propulsion, Cap_Stage, Hohm('TMI','LMO'), spacecraft.Mass);
end
spacecraft.Add_Craft = Cap_Stage;


%% Transit Engines
switch Cur_Trajectory
    case TrajectoryType.HOHMANN
        Rotation_Period = 540; %days based on DRA 5.0 Exec Summary
        Trans_Eng = SC_Class('Transit Engines');
        Trans_Eng = Propellant_Mass(Cur_Arch.PropulsionType,Trans_Eng,Hohm_Chart('EML1','TMI'),spacecraft.Mass);
        spacecraft.Add_Craft = Trans_Eng;
    case TrajectoryType.ELLIPTICAL
        disp('too bad')
end

%% Update to Astronaut_Sci_Time
if type == 'Human'
    Results.Science_Time = Results.Science_Time * Rotation_Period ... now it's in CM-days/Rotation Period
        - Capture_Time * Cur_Arch.TransitCrew.Size; %and subtract the CMs stuck in capture
end

end

