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
    LEOtoGSTO = 1.47;
    GSTtoMT = 0.68;
    MTtoEML2 = 0.35;
    EML2toLO = 0.64;
    MTtoEML1 = 0.58;
    EML1toLO = 0.64;
    MTtoCapEsc = 0.14;
    CapEsctoLO = 0.68;
    LOtoMoon = 1.72;
    MTtoECE = 0.09;
    ECEtoEMT = 0.39;
    EMTtoCapEsc = 0.67;
    MarsCapEsctoLO = 1.44;
    LOtoMars = 3.6;
    
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
                    dV = LEOtoGST + GSTtoMT;
                case 'EML2'
                    dV = LEOtoGST + GSTtoMT + MTtoEML2;
                case 'EML1'
                    dV = LEOtoGST + GSTtoMT + MTtoEML1;
                case 'Moon'
                    dV = LEOtoGST + GSTtoMT + MTtoCapEsc + CapEsctoLO + LOtoMoon;
                case 'MoonOrbit'
                    dV = LEOtoGST + GSTtoMT + MTtoCapEsc + CapEsctoLO;
                case 'TMI'
                    dV = LEOtoGST + GSTtoMT + MTtoECE + ECEtoEMT;
                case 'LMO'
                    dV = LEOtoGST + GSTtoMT + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO;
                case 'Mars'
                    dV = LEOtoGST + GSTtoMT + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO + LOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'Moon'
            switch final
                case 'EML1'
                    dV = LOtoMoon + EML1toLO;
                case 'EML2'
                    dV = LOtoMoon + EML2toLO;
                case 'LLO'
                    dV = LOtoMoon;
                case 'LEO'
                    dV = LOtoMoon + CapEsctoLO + MTtoCapEsc + GSTtoMT + LEOtoGST;
                case 'Earth'
                    dV = LOtoMoon + CapEsctoLO + MTtoCapEsc + GSTtoMT + LEOtoGST + EarthtoLEO;
                case 'LMO'
                    dV = LOtoMoon + CapEsctoLO + MTtoCapEsc + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO;
                case 'Mars'
                    dV = LOtoMoon + CapEsctoLO + MTtoCapEsc + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLEO + LOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'LLO'
            switch final
                case 'EML1'
                    dV = EML1toLO;
                case 'EML2'
                    dV = EML2toLO;
                case 'Moon'
                    dV = LOtoMoon;
                case 'LEO'
                    dV = CapEsctoLO + MTtoCapEsc + GSTtoMT + LEOtoGST;
                case 'Earth'
                    dV = CapEsctoLO + MTtoCapEsc + GSTtoMT + LEOtoGST + EarthtoLEO;
                case 'LMO'
                    dV = CapEsctoLO + MTtoCapEsc + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO;
                case 'Mars'
                    dV = CapEsctoLO + MTtoCapEsc + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLEO + LOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'EML1'
            switch final
                case 'LLO'
                    dV = EML1toLO;
                case 'Moon'
                    dV = EML1toLO + LOtoMoon;
                case 'LEO'
                    dV = MTtoEML1 + GSTtoMT + LEOtoGST;
                case 'Earth'
                    dV = MTtoEML1 + GSTtoMT + LEOtoGST + EarthtoLEO;
                case 'LMO'
                    dV = MTtoEML1 + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO;
                case 'Mars'
                    dV = MTtoEML1 + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO + LOtoMars;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'EML2'
            switch final
                case 'LLO'
                    dV = EML2toLO;
                case 'Moon'
                    dV = EML2toLO + LOtoMoon;
                case 'LEO'
                    dV = MTtoEML2 + GSTtoMT + LEOtoGST;
                case 'Earth'
                    dV = MTtoEML2 + GSTtoMT + LEOtoGST + EarthtoLEO;
                case 'LMO'
                    dV = MTtoEML2 + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO;
                case 'Mars'
                    dV = MTtoEML2 + MTtoECE + ECEtoEMT + EMTtoCapEsc + MarsCapEsctoLO + LOtoMars;
                otherwise
                    disp('Please consult the table itself');

            end
        case 'Mars'
            switch final
                case 'Earth'
                    dV = LOtoMars + MarsCapEsctoLO + EMTtoCapEsc + ECEtoCapEsc + MTtoCapEsc + GSTtoMT + LEOtoGST + EarthtoLEO;
                case 'LEO'
                    dV = LOtoMars + MarsCapEsctoLO + EMTtoCapEsc + ECEtoCapEsc + MTtoCapEsc + GSTtoMT + LEOtoGST;
                case 'LMO'
                    dV = LOtoMars;
                case 'EML2'
                    dV = LOtoMars + MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + MTtoEML2;
                case 'EML1'
                    dV = LOtoMars + MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + MTtoEML1;
                case 'LLO'
                    dV = LOtoMars + MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + MTtoCapEsc + CapEsctoLO;
                otherwise
                    disp('Please consult the table itself');
            end
        case 'LMO'
            switch final
                case 'Earth'
                    dV = MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + GSTtoMT + LEOtoGST + LEOtoGST;
                case 'LEO'
                    dV = MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + GSTtoMT + LEOtoGST;
                case 'Mars'
                    dV = LOtoMars;
                case 'EML2'
                    dV = MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + MTtoEML2;
                case 'EML1'
                    dV = MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + MTtoEML1;
                case 'LLO'
                    dV = MarsCapEsctoLO + EMTtoCapEsc + ECEtoEMT + MTtoECE + MTtoCapEsc + CapEsctoLO;
                otherwise
                    disp('Please consult the table itself');
            end
        otherwise
            disp('Please consult the table itself');
    end
end
            

                    
                    
                    
                    
                    
                    
                    
                    
                    
                    