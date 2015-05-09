prop_inst = Propulsion.CH4;
dV = 3 ; %km/s
Payload_Mass = 20000; %kg

%-----Constants-----
g0=0.0098665; %km/s^2
e=2.71828182845904523536028747135266249;

%-----Constants-----

%----Initialize other SC Module stuff

Static_Mass = prop_inst.StaticMass; %add engine Static Mass to bus mass.
Eng_Mass = 0;
Bus_Mass = 0;
%tic

%Convergent loop
converge_to = 0.0000001; %set convergence limit in difference percent
converge = 1; %initialize convergence factor
last = 0; %initialize tracking variable

it = 0;
while converge > converge_to
    %sum rocket parts to see final mass
    Final_Mass = nansum([Eng_Mass, Static_Mass, Payload_Mass, Bus_Mass]);
    
    %evaluate the rocket equation for fuel mass
    Mass_Ratio=e^((dV)/(g0*prop_inst.Isp));
    Prop_Mass = (Final_Mass * Mass_Ratio) - Final_Mass;
    
    %evaluate engine mass %determine SpaceCraft Origin Mass
    if (Eng_Mass < (Prop_Mass * prop_inst.InertMassRatio)) %don't overwrite if engine is already big enough
        Eng_Mass = Prop_Mass * prop_inst.InertMassRatio;
    end
    
    %determine SpaceCraft Origin Mass
    Origin_Mass = Final_Mass + Prop_Mass + Eng_Mass;  
    %compare results to last iteration
    converge = (Origin_Mass - last) / Origin_Mass;
    last = Origin_Mass; %set tracking variable to this iteration
    it = it + 1;

end

Stage_Mass = Eng_Mass + Prop_Mass + Static_Mass