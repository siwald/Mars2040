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
    case ArrivalEntry.AEROCAPTURE   %Based on AeroCapture AeroShell Mass
        Capture_Time = 30; %days based on DRA 5.0?
        if ~isequal(Cur_Arch.EDL, ArrivalDescent.AEROENTRY)
            Cap_Stage.Bus_Mass = 66100; % Based on DRA 5.0, including payload fairing & adapter
        elseif isequal(Cur_Arch.EDL, ArrivalDescent.AEROENTRY)
            Cap_Stage.Bus_Mass = 0; %Aeroshell aleady added, used for descent as well.
        end
    case ArrivalEntry.PROPULSIVE %Based on Propulsive Capture Engines
        Capture_Time = 0; %Don't need to wait in circularization
        Cap_Stage = Propellant_Mass(Cur_Arch.PropulsionType, Cap_Stage, Hohm_Chart('TMI','LMO'), spacecraft.Mass);
    case TrajectoryType.ALDRIN.Type
        disp('too bad')
    case TrajectoryType.LONGCYCLER.Type
        disp('too bad')
    case TrajectoryType.SHORTCYCLER.Type
        disp('too bad')
    otherwise
        warning('NewTransit line 15 switch case error');
end
spacecraft.Add_Craft = Cap_Stage;
spacecraft.MAMA = spacecraft.Mass;


%% Transit Engines

switch Cur_Trajectory.Type
    case TrajectoryType.HOHMANN.Type
        Trans_Eng = SC_Class('Transit Engines');
        Trans_Eng = Propellant_Mass(Cur_Arch.PropulsionType,Trans_Eng,Hohm_Chart(Cur_Arch.Staging.Code,'TMI'),spacecraft.Mass);
        spacecraft.Add_Craft = Trans_Eng;
    case TrajectoryType.ELLIPTICAL.Type
        disp('too bad')
    otherwise
        disp('NewTransit error, line 29 switch case')
end

%% Update to Astronaut_Sci_Time

if type == 'Human'
    Results.Science_Time = Results.Science_Time - (Capture_Time * Cur_Arch.TransitCrew.Size); % subtract the CM-day stuck in capture each rotation
end

end

