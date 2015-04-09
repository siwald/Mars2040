Cur_Arch = MarsArchitecture.DEFAULT;
DescentSC = SC_Class(50000,0,'direct entry craft');

%LH2
Cur_Arch.PropulsionType = Propulsion.LH2;
DepartureSC = SC_Class(DescentSC.Origin_Mass,0,'craft leaving Mars');
DepartureSC = Propellant_Mass(Cur_Arch.PropulsionType,DepartureSC,Hohm_Chart('LMO','TMI'));
AscentSC = SC_Class(DepartureSC.Origin_Mass,0,'Ascent Vehicle');
AscentSC = Propellant_Mass(Cur_Arch.PropulsionType,AscentSC,4.08);
LH2_Prop = DepartureSC.Prop_Mass + AscentSC.Prop_Mass;
LH2 = LH2_Prop / 7
LH2_O2 = LH2_Prop / 7 * 6

%CH4
Cur_Arch.PropulsionType = Propulsion.CH4;
DepartureSC = SC_Class(DescentSC.Origin_Mass,0,'craft leaving Mars');
DepartureSC = Propellant_Mass(Cur_Arch.PropulsionType,DepartureSC,Hohm_Chart('LMO','TMI'));
AscentSC = SC_Class(DepartureSC.Origin_Mass,0,'Ascent Vehicle');
AscentSC = Propellant_Mass(Cur_Arch.PropulsionType,AscentSC,4.08);
CH4_Prop = DepartureSC.Prop_Mass + AscentSC.Prop_Mass;
CH4 = CH4_Prop / 7
CH4_O2 = CH4_Prop / 7 * 6

%NTR
Cur_Arch.PropulsionType = Propulsion.NTR;
DepartureSC = SC_Class(DescentSC.Origin_Mass,0,'craft leaving Mars');
DepartureSC = Propellant_Mass(Cur_Arch.PropulsionType,DepartureSC,Hohm_Chart('LMO','TMI'));
AscentSC = SC_Class(DepartureSC.Origin_Mass,0,'Ascent Vehicle');
AscentSC = Propellant_Mass(Cur_Arch.PropulsionType,AscentSC,4.08);
NTR_Prop = DepartureSC.Prop_Mass + AscentSC.Prop_Mass