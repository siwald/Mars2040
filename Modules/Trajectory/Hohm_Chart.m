% Implementation of Delta-V chart http://i.imgur.com/WGOy3qT.png
% DISCLAIMERS:
%   - Inclination changes not included
%   - No aerocapture
%   - Transfers are assumed as Hohmann transfer orbits
%Input: start location, final location
%Output: delta-V (km/s)

%Possible Locations: 'Earth', 'LEO', 'Moon', 'LLO', 'EML1', 'EML2',
% 'Mars', 'LMO'
function[dV] = Hohm_Chart(initial,final)
    %Delta-V's from the chart, all in km/s
    EarthtoLEO = 9.0;
    LEOtoGST = 2.44;
    GSTtoGEO = 1.47;
    GSTtoLTrans = 0.68;
    LTranstoEML2 = 0.35;
    EML2toLLO = 0.64;
    LTranstoEML1 = 0.58;
    EML1toLLO = 0.64;
    LTranstoLunarEsc = 0.14;
    LunarEsctoLLO = 0.68;
    LLOtoMoon = 1.72;
    LTranstoECE = 0.09;
    EEsctoEMT = 0.39;
    EMTtoCapEsc = 0.67;
    MarsCapEsctoLMO = 1.44;
    LMOtoMars = 3.6;
    
%If initial and final are the same, return dV = 0
if strcmp(initial,final)
    dV = 0.0;
    return
end    
    
    switch initial
        case 'LEO'
            switch final
                case 'GST'
                    dV = LEOtoGST;
                case 'MoonTransfer'
                    dV = LEOtoGST + GSTtoLTrans;
                case 'EML2'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoEML2;
                case 'EML1'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoEML1;
                case 'Moon'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoLunarEsc + LunarEsctoLLO + LLOtoMoon;
                case 'MoonOrbit'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoLunarEsc + LunarEsctoLLO;
                case 'TMI'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoECE + EEsctoEMT;
                case 'LMO'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO;
                case 'Mars'
                    dV = LEOtoGST + GSTtoLTrans + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO + LMOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'Moon'
            switch final
                case 'EML1'
                    dV = LLOtoMoon + EML1toLLO;
                case 'EML2'
                    dV = LLOtoMoon + EML2toLLO;
                case 'LLO'
                    dV = LLOtoMoon;
                case 'LEO'
                    dV = LLOtoMoon + LunarEsctoLLO + LTranstoLunarEsc + GSTtoLTrans + LEOtoGST;
                case 'Earth'
                    dV = LLOtoMoon + LunarEsctoLLO + LTranstoLunarEsc + GSTtoLTrans + LEOtoGST + EarthtoLEO;
                case 'LMO'
                    dV = LLOtoMoon + LunarEsctoLLO + LTranstoLunarEsc + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO;
                case 'Mars'
                    dV = LLOtoMoon + LunarEsctoLLO + LTranstoLunarEsc + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO + LMOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'LLO'
            switch final
                case 'EML1'
                    dV = EML1toLLO;
                case 'EML2'
                    dV = EML2toLLO;
                case 'Moon'
                    dV = LLOtoMoon;
                case 'LEO'
                    dV = LunarEsctoLLO + LTranstoLunarEsc + GSTtoLTrans + LEOtoGST;
                case 'Earth'
                    dV = LunarEsctoLLO + LTranstoLunarEsc + GSTtoLTrans + LEOtoGST + EarthtoLEO;
                case 'TMI'
                    dV = LunarEsctoLLO + LTranstoLunarEsc + LTranstoECE + EEsctoEMT;
                case 'LMO'
                    dV = LunarEsctoLLO + LTranstoLunarEsc + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO;
                case 'Mars'
                    dV = LunarEsctoLLO + LTranstoLunarEsc + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLEO + LMOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'EML1'
            switch final
                case 'LLO'
                    dV = EML1toLLO;
                case 'Moon'
                    dV = EML1toLLO + LLOtoMoon;
                case 'LEO'
                    dV = LTranstoEML1 + GSTtoLTrans + LEOtoGST;
                case 'Earth'
                    dV = LTranstoEML1 + GSTtoLTrans + LEOtoGST + EarthtoLEO;
                case 'TMI'
                    dV = LTranstoEML1 + LTranstoECE + EEsctoEMT;
                case 'LMO'
                    dV = LTranstoEML1 + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO;
                case 'Mars'
                    dV = LTranstoEML1 + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO + LMOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'EML2'
            switch final
                case 'LLO'
                    dV = EML2toLLO;
                case 'Moon'
                    dV = EML2toLLO + LLOtoMoon;
                case 'LEO'
                    dV = LTranstoEML2 + GSTtoLTrans + LEOtoGST;
                case 'Earth'
                    dV = LTranstoEML2 + GSTtoLTrans + LEOtoGST + EarthtoLEO;
                case 'TMI'
                    dV = LTranstoEML2 + LTranstoECE + EEsctoEMT;
                case 'LMO'
                    dV = LTranstoEML2 + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO;
                case 'Mars'
                    dV = LTranstoEML2 + LTranstoECE + EEsctoEMT + EMTtoCapEsc + MarsCapEsctoLMO + LMOtoMars;
                otherwise
                    disp('Please consult the table itself');

            end
        case 'Mars'
            switch final
                case 'Earth'
                    dV = LMOtoMars + MarsCapEsctoLMO + EMTtoCapEsc + ECEtoCapEsc + LTranstoLunarEsc + GSTtoLTrans + LEOtoGST + EarthtoLEO;
                case 'LEO'
                    dV = LMOtoMars + MarsCapEsctoLMO + EMTtoCapEsc + ECEtoCapEsc + LTranstoLunarEsc + GSTtoLTrans + LEOtoGST;
                case 'LMO'
                    dV = LMOtoMars;
                case 'EML2'
                    dV = LMOtoMars + MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + LTranstoEML2;
                case 'EML1'
                    dV = LMOtoMars + MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + LTranstoEML1;
                case 'LLO'
                    dV = LMOtoMars + MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + LTranstoLunarEsc + LunarEsctoLLO;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'LMO'
            switch final
                case 'Earth'
                    dV = MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + GSTtoLTrans + LEOtoGST + LEOtoGST;
                case 'LEO'
                    dV = MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + GSTtoLTrans + LEOtoGST;
                case 'Mars'
                    dV = LMOtoMars;
                case 'EML2'
                    dV = MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + LTranstoEML2;
                case 'EML1'
                    dV = MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + LTranstoEML1;
                case 'LLO'
                    dV = MarsCapEsctoLMO + EMTtoCapEsc + EEsctoEMT + LTranstoECE + LTranstoLunarEsc + LunarEsctoLLO;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'TMI'
            switch final
                case 'LMO'
                    dV = EMTtoCapEsc + MarsCapEsctoLMO;
                case 'Mars'
                    dV = EMTtoCapEsc + MarsCapEsctoLMO + LMOtoMars;
        otherwise
            disp('Please consult the table itself');
    end
end
            

                    
                    
                    
                    
                    
                    
                    
                    
                    
                    