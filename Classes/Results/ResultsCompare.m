function [ results_table ] = ResultsCompare( results_obj1, results_obj2, num_cargo, Ascent_mass)
%RESULTSCOMPARE Summary of this function goes here
%   Detailed explanation goes here

    if nargin == 0 ... % received no input arguments
            || ~isa(results_obj1, 'Results_Class') ... % is a Results object
            || ~isa(results_obj2, 'Results_Class') % is a Results object
        warning('Cannot compare result objects because of type mismatch.');
        return;
    end

    %% Fill out results table
    % header row
    results_table = cell(52, 3);
    results_table{1,1} = 'Component';
    results_table{1,2} = {results_obj1.Arch_Name};
    results_table{1,3} = {results_obj2.Arch_Name};
    results_table{1,4} = 'Difference';
    % IMLEO row
    results_table{2,1} = 'Total IMLEO';
    results_table{2,2} = results_obj1.IMLEO;
    results_table{2,3} = results_obj2.IMLEO;
    results_table{2,4} = results_obj1.IMLEO - results_obj2.IMLEO;
    % science row
    results_table{3,1} = 'Science Value';
    results_table{3,2} = results_obj1.Risk;
    results_table{3,3} = results_obj2.Risk;
    results_table{3,4} = results_obj1.Risk - results_obj2.Risk;
    % risk row
    results_table{4,1} = 'Risk Value';
    results_table{4,2} = results_obj1.Risk;
    results_table{4,3} = results_obj2.Risk;
    results_table{4,4} = results_obj1.Risk - results_obj2.Risk;
    % surface habitat
    results_table{5,1} = 'Surface_Habitat.Consumables';
    results_table{5,2} = results_obj1.Surface_Habitat.Consumables;
    results_table{5,3} = results_obj2.Surface_Habitat.Consumables;
    results_table{5,4} = results_obj1.Surface_Habitat.Consumables - results_obj2.Surface_Habitat.Consumables;
    results_table{6,1} = 'Surface_Habitat.Spares';
    results_table{6,2} = results_obj1.Surface_Habitat.Spares;
    results_table{6,3} = results_obj2.Surface_Habitat.Spares;
    results_table{6,4} = results_obj1.Surface_Habitat.Spares - results_obj2.Surface_Habitat.Spares;
    results_table{7,1} = 'Surface_Habitat.Replacements';
    results_table{7,2} = results_obj1.Surface_Habitat.Replacements;
    results_table{7,3} = results_obj2.Surface_Habitat.Replacements;
    results_table{7,4} = results_obj1.Surface_Habitat.Replacements - results_obj2.Surface_Habitat.Replacements;
    results_table{8,1} = 'Surface_Habitat.Mass';
    results_table{8,2} = results_obj1.Surface_Habitat.Mass;
    results_table{8,3} = results_obj2.Surface_Habitat.Mass;
    results_table{8,4} = results_obj1.Surface_Habitat.Mass - results_obj2.Surface_Habitat.Mass;
    results_table{9,1} = 'Surface_Habitat.Power';
    results_table{9,2} = results_obj1.Surface_Habitat.Power;
    results_table{9,3} = results_obj2.Surface_Habitat.Power;
    results_table{9,4} = results_obj1.Surface_Habitat.Power - results_obj2.Surface_Habitat.Power;
    results_table{10,1} = 'Surface_Habitat.Volume';
    results_table{10,2} = results_obj1.Surface_Habitat.Volume;
    results_table{10,3} = results_obj2.Surface_Habitat.Volume;
    results_table{10,4} = results_obj1.Surface_Habitat.Volume - results_obj2.Surface_Habitat.Volume;
    results_table{11,1} = 'Surface_Habitat.Fuel_Output';
    results_table{11,2} = results_obj1.Surface_Habitat.Fuel_Output;
    results_table{11,3} = results_obj2.Surface_Habitat.Fuel_Output;
    results_table{11,4} = results_obj1.Surface_Habitat.Fuel_Output - results_obj2.Surface_Habitat.Fuel_Output;
    results_table{12,1} = 'Surface_Habitat.Oxidizer_Output';
    results_table{12,2} = results_obj1.Surface_Habitat.Oxidizer_Output;
    results_table{12,3} = results_obj2.Surface_Habitat.Oxidizer_Output;
    results_table{12,4} = results_obj1.Surface_Habitat.Oxidizer_Output - results_obj2.Surface_Habitat.Oxidizer_Output;
    % ECLSS
    results_table{13,1} = 'ECLSS.Consumables';
    results_table{13,2} = results_obj1.ECLSS.Consumables;
    results_table{13,3} = results_obj2.ECLSS.Consumables;
    results_table{13,4} = results_obj1.ECLSS.Consumables - results_obj2.ECLSS.Consumables;
    results_table{14,1} = 'ECLSS.Spares';
    results_table{14,2} = results_obj1.ECLSS.Spares;
    results_table{14,3} = results_obj2.ECLSS.Spares;
    results_table{14,4} = results_obj1.ECLSS.Spares - results_obj2.ECLSS.Spares;
    results_table{15,1} = 'ECLSS.Replacements';
    results_table{15,2} = results_obj1.ECLSS.Replacements;
    results_table{15,3} = results_obj2.ECLSS.Replacements;
    results_table{15,4} = results_obj1.ECLSS.Replacements - results_obj2.ECLSS.Replacements;
    results_table{16,1} = 'ECLSS.Mass';
    results_table{16,2} = results_obj1.ECLSS.Mass;
    results_table{16,3} = results_obj2.ECLSS.Mass;
    results_table{16,4} = results_obj1.ECLSS.Mass - results_obj2.ECLSS.Mass;
    results_table{17,1} = 'ECLSS.Power';
    results_table{17,2} = results_obj1.ECLSS.Power;
    results_table{17,3} = results_obj2.ECLSS.Power;
    results_table{17,4} = results_obj1.ECLSS.Power - results_obj2.ECLSS.Power;
    results_table{18,1} = 'ECLSS.Volume';
    results_table{18,2} = results_obj1.ECLSS.Volume;
    results_table{18,3} = results_obj2.ECLSS.Volume;
    results_table{18,4} = results_obj1.ECLSS.Volume - results_obj2.ECLSS.Volume;
    results_table{19,1} = 'ECLSS.Fuel_Output';
    results_table{19,2} = results_obj1.ECLSS.Fuel_Output;
    results_table{19,3} = results_obj2.ECLSS.Fuel_Output;
    results_table{19,4} = results_obj1.ECLSS.Fuel_Output - results_obj2.ECLSS.Fuel_Output;
    results_table{20,1} = 'ECLSS.Oxidizer_Output';
    results_table{20,2} = results_obj1.ECLSS.Oxidizer_Output;
    results_table{20,3} = results_obj2.ECLSS.Oxidizer_Output;
    results_table{20,4} = results_obj1.ECLSS.Oxidizer_Output - results_obj2.ECLSS.Oxidizer_Output;
    % Mars ISRU
    results_table{21,1} = 'Mars_ISRU.Consumables';
    results_table{21,2} = results_obj1.Mars_ISRU.Consumables;
    results_table{21,3} = results_obj2.Mars_ISRU.Consumables;
    results_table{21,4} = results_obj1.Mars_ISRU.Consumables - results_obj2.Mars_ISRU.Consumables;
    results_table{22,1} = 'Mars_ISRU.Spares';
    results_table{22,2} = results_obj1.Mars_ISRU.Spares;
    results_table{22,3} = results_obj2.Mars_ISRU.Spares;
    results_table{22,4} = results_obj1.Mars_ISRU.Spares - results_obj2.Mars_ISRU.Spares;
    results_table{23,1} = 'Mars_ISRU.Replacements';
    results_table{23,2} = results_obj1.Mars_ISRU.Replacements;
    results_table{23,3} = results_obj2.Mars_ISRU.Replacements;
    results_table{23,4} = results_obj1.Mars_ISRU.Replacements - results_obj2.Mars_ISRU.Replacements;
    results_table{24,1} = 'Mars_ISRU.Mass';
    results_table{24,2} = results_obj1.Mars_ISRU.Mass;
    results_table{24,3} = results_obj2.Mars_ISRU.Mass;
    results_table{24,4} = results_obj1.Mars_ISRU.Mass - results_obj2.Mars_ISRU.Mass;
    results_table{25,1} = 'Mars_ISRU.Power';
    results_table{25,2} = results_obj1.Mars_ISRU.Power;
    results_table{25,3} = results_obj2.Mars_ISRU.Power;
    results_table{25,4} = results_obj1.Mars_ISRU.Power - results_obj2.Mars_ISRU.Power;
    results_table{26,1} = 'Mars_ISRU.Volume';
    results_table{26,2} = results_obj1.Mars_ISRU.Volume;
    results_table{26,3} = results_obj2.Mars_ISRU.Volume;
    results_table{26,4} = results_obj1.Mars_ISRU.Volume - results_obj2.Mars_ISRU.Volume;
    results_table{27,1} = 'Mars_ISRU.Fuel_Output';
    results_table{27,2} = results_obj1.Mars_ISRU.Fuel_Output;
    results_table{27,3} = results_obj2.Mars_ISRU.Fuel_Output;
    results_table{27,4} = results_obj1.Mars_ISRU.Fuel_Output - results_obj2.Mars_ISRU.Fuel_Output;
    results_table{28,1} = 'Mars_ISRU.Oxidizer_Output';
    results_table{28,2} = results_obj1.Mars_ISRU.Oxidizer_Output;
    results_table{28,3} = results_obj2.Mars_ISRU.Oxidizer_Output;
    results_table{28,4} = results_obj1.Mars_ISRU.Oxidizer_Output - results_obj2.Mars_ISRU.Oxidizer_Output;
    % Lunar ISRU
    results_table{29,1} = 'Lunar_ISRU.Consumables';
    results_table{29,2} = results_obj1.Lunar_ISRU.Consumables;
    results_table{29,3} = results_obj2.Lunar_ISRU.Consumables;
    results_table{29,4} = results_obj1.Lunar_ISRU.Consumables - results_obj2.Lunar_ISRU.Consumables;
    results_table{30,1} = 'Lunar_ISRU.Spares';
    results_table{30,2} = results_obj1.Lunar_ISRU.Spares;
    results_table{30,3} = results_obj2.Lunar_ISRU.Spares;
    results_table{30,4} = results_obj1.Lunar_ISRU.Spares - results_obj2.Lunar_ISRU.Spares;
    results_table{31,1} = 'Lunar_ISRU.Replacements';
    results_table{31,2} = results_obj1.Lunar_ISRU.Replacements;
    results_table{31,3} = results_obj2.Lunar_ISRU.Replacements;
    results_table{31,4} = results_obj1.Lunar_ISRU.Replacements - results_obj2.Lunar_ISRU.Replacements;
    results_table{32,1} = 'Lunar_ISRU.Mass';
    results_table{32,2} = results_obj1.Lunar_ISRU.Mass;
    results_table{32,3} = results_obj2.Lunar_ISRU.Mass;
    results_table{32,4} = results_obj1.Lunar_ISRU.Mass - results_obj2.Lunar_ISRU.Mass;
    results_table{33,1} = 'Lunar_ISRU.Power';
    results_table{33,2} = results_obj1.Lunar_ISRU.Power;
    results_table{33,3} = results_obj2.Lunar_ISRU.Power;
    results_table{33,4} = results_obj1.Lunar_ISRU.Power - results_obj2.Lunar_ISRU.Power;
    results_table{34,1} = 'Lunar_ISRU.Volume';
    results_table{34,2} = results_obj1.Lunar_ISRU.Volume;
    results_table{34,3} = results_obj2.Lunar_ISRU.Volume;
    results_table{34,4} = results_obj1.Lunar_ISRU.Volume - results_obj2.Lunar_ISRU.Volume;
    results_table{35,1} = 'Lunar_ISRU.Fuel_Output';
    results_table{35,2} = results_obj1.Lunar_ISRU.Fuel_Output;
    results_table{35,3} = results_obj2.Lunar_ISRU.Fuel_Output;
    results_table{35,4} = results_obj1.Lunar_ISRU.Fuel_Output - results_obj2.Lunar_ISRU.Fuel_Output;
    results_table{36,1} = 'Lunar_ISRU.Oxidizer_Output';
    results_table{36,2} = results_obj1.Lunar_ISRU.Oxidizer_Output;
    results_table{36,3} = results_obj2.Lunar_ISRU.Oxidizer_Output;
    results_table{36,4} = results_obj1.Lunar_ISRU.Oxidizer_Output - results_obj2.Lunar_ISRU.Oxidizer_Output;
    % ISFR
    results_table{37,1} = 'ISFR.Consumables';
    results_table{37,2} = results_obj1.ISFR.Consumables;
    results_table{37,3} = results_obj2.ISFR.Consumables;
    results_table{37,4} = results_obj1.ISFR.Consumables - results_obj2.ISFR.Consumables;
    results_table{38,1} = 'ISFR.Spares';
    results_table{38,2} = results_obj1.ISFR.Spares;
    results_table{38,3} = results_obj2.ISFR.Spares;
    results_table{38,4} = results_obj1.ISFR.Spares - results_obj2.ISFR.Spares;
    results_table{39,1} = 'ISFR.Replacements';
    results_table{39,2} = results_obj1.ISFR.Replacements;
    results_table{39,3} = results_obj2.ISFR.Replacements;
    results_table{39,4} = results_obj1.ISFR.Replacements - results_obj2.ISFR.Replacements;
    results_table{40,1} = 'ISFR.Mass';
    results_table{40,2} = results_obj1.ISFR.Mass;
    results_table{40,3} = results_obj2.ISFR.Mass;
    results_table{40,4} = results_obj1.ISFR.Mass - results_obj2.ISFR.Mass;
    results_table{41,1} = 'ISFR.Power';
    results_table{41,2} = results_obj1.ISFR.Power;
    results_table{41,3} = results_obj2.ISFR.Power;
    results_table{41,4} = results_obj1.ISFR.Power - results_obj2.ISFR.Power;
    results_table{42,1} = 'ISFR.Volume';
    results_table{42,2} = results_obj1.ISFR.Volume;
    results_table{42,3} = results_obj2.ISFR.Volume;
    results_table{42,4} = results_obj1.ISFR.Volume - results_obj2.ISFR.Volume;
    results_table{43,1} = 'ISFR.Fuel_Output';
    results_table{43,2} = results_obj1.ISFR.Fuel_Output;
    results_table{43,3} = results_obj2.ISFR.Fuel_Output;
    results_table{43,4} = results_obj1.ISFR.Fuel_Output - results_obj2.ISFR.Fuel_Output;
    results_table{44,1} = 'ISFR.Oxidizer_Output';
    results_table{44,2} = results_obj1.ISFR.Oxidizer_Output;
    results_table{44,3} = results_obj2.ISFR.Oxidizer_Output;
    results_table{44,4} = results_obj1.ISFR.Oxidizer_Output - results_obj2.ISFR.Oxidizer_Output;
    % power plant
    results_table{45,1} = 'PowerPlant.Consumables';
    results_table{45,2} = results_obj1.PowerPlant.Consumables;
    results_table{45,3} = results_obj2.PowerPlant.Consumables;
    results_table{45,4} = results_obj1.PowerPlant.Consumables - results_obj2.PowerPlant.Consumables;
    results_table{46,1} = 'PowerPlant.Spares';
    results_table{46,2} = results_obj1.PowerPlant.Spares;
    results_table{46,3} = results_obj2.PowerPlant.Spares;
    results_table{46,4} = results_obj1.PowerPlant.Spares - results_obj2.PowerPlant.Spares;
    results_table{47,1} = 'PowerPlant.Replacements';
    results_table{47,2} = results_obj1.PowerPlant.Replacements;
    results_table{47,3} = results_obj2.PowerPlant.Replacements;
    results_table{47,4} = results_obj1.PowerPlant.Replacements - results_obj2.PowerPlant.Replacements;
    results_table{48,1} = 'PowerPlant.Mass';
    results_table{48,2} = results_obj1.PowerPlant.Mass;
    results_table{48,3} = results_obj2.PowerPlant.Mass;
    results_table{48,4} = results_obj1.PowerPlant.Mass - results_obj2.PowerPlant.Mass;
    results_table{49,1} = 'PowerPlant.Power';
    results_table{49,2} = results_obj1.PowerPlant.Power;
    results_table{49,3} = results_obj2.PowerPlant.Power;
    results_table{49,4} = results_obj1.PowerPlant.Power - results_obj2.PowerPlant.Power;
    results_table{50,1} = 'PowerPlant.Volume';
    results_table{50,2} = results_obj1.PowerPlant.Volume;
    results_table{50,3} = results_obj2.PowerPlant.Volume;
    results_table{50,4} = results_obj1.PowerPlant.Volume - results_obj2.PowerPlant.Volume;
    results_table{51,1} = 'PowerPlant.Fuel_Output';
    results_table{51,2} = results_obj1.PowerPlant.Fuel_Output;
    results_table{51,3} = results_obj2.PowerPlant.Fuel_Output;
    results_table{51,4} = results_obj1.PowerPlant.Fuel_Output - results_obj2.PowerPlant.Fuel_Output;
    results_table{52,1} = 'PowerPlant.Oxidizer_Output';
    results_table{52,2} = results_obj1.PowerPlant.Oxidizer_Output;
    results_table{52,3} = results_obj2.PowerPlant.Oxidizer_Output;
    results_table{52,4} = results_obj1.PowerPlant.Oxidizer_Output - results_obj2.PowerPlant.Oxidizer_Output;
    %Transit Hab
        results_table{53,1} = 'Transit_Habitat.Mass';
    results_table{53,2} = results_obj1.Transit_Habitat.Mass;
    results_table{53,3} = results_obj2.Transit_Habitat.Mass;
    results_table{53,4} = results_obj1.Transit_Habitat.Mass - results_obj2.Transit_Habitat.Mass;
    results_table{54,1} = 'Transit_Habitat.Power';
    results_table{54,2} = results_obj1.Transit_Habitat.Power;
    results_table{54,3} = results_obj2.Transit_Habitat.Power;
    results_table{54,4} = results_obj1.Transit_Habitat.Power - results_obj2.Transit_Habitat.Power;
    results_table{55,1} = 'Transit_Habitat.Volume';
    results_table{55,2} = results_obj1.Transit_Habitat.Volume;
    results_table{55,3} = results_obj2.Transit_Habitat.Volume;
    results_table{55,4} = results_obj1.Transit_Habitat.Volume - results_obj2.Transit_Habitat.Volume;
    %IMLEO Breakdown
    	results_table{56,1} = 'Crew_Spacecraft.Mass';
    results_table{56,2} = results_obj1.HumanSpacecraft.Mass;
    results_table{56,3} = 333000;
    results_table{56,4} = results_obj1.HumanSpacecraft.Mass - 33000;
    results_table{57,1} = 'Cargo_Spacecraft.Mass';
    results_table{57,2} = results_obj1.CargoSpacecraft.Mass;
    results_table{57,3} = 246000;
    results_table{57,4} = results_obj1.CargoSpacecraft.Mass - 246000;
    results_table{58,1} = 'Cargo_Spacecraft.Landed_Mass';
    temp = results_obj1.CargoSpacecraft.Copy_Craft('Cargo Lander');
    results_table{58,2} = temp.Payload_Mass;
    results_table{58,3} = 36000;
    results_table{58,4} = (results_obj1.CargoSpacecraft.Mass / num_cargo) - 246000;
    results_table{59,1} = 'Cargo_Spacecraft.Number';
    results_table{59,2} = num_cargo;
    results_table{59,3} = 2;
    results_table{59,4} = num_cargo - 2;
    results_table{60,1} = 'Ascent Spacecraft Mass';
    results_table{60,2} = Ascent_mass;
    results_table{60,3} = 42783; %kg, DRA ADD1, T3-26
    results_table{60,4} = Ascent_mass - 42783;
    
    power = cell(1,4);
    power{1,1} = 'Surface_Power_Needs';
    power{1,2} = results_obj1.Cum_Surface_Power;
    power{1,3} = results_obj2.Cum_Surface_Power;
    power{1,4} = results_obj1.Cum_Surface_Power - results_obj2.Cum_Surface_Power;
    results_table(53:end+1,:) = results_table(52:end,:);
    results_table(52,:) = power;
    %% clean empty
    ind = [];
    [numrows, ~] = size(results_table);
    for i=1:numrows
        if (isempty(results_table{i,2}) && isempty(results_table{i,3}))
            ind(end+1) = i;
        end
    end
    results_table = removerows(results_table,ind);
    
    %% add percent
    results_table{1,5} = 'percent off';
    [numrows , ~] = size(results_table);
    for i = 2:numrows
        results_table{i,5} = 100*(results_table{i,2}-results_table{i,3})/results_table{i,3};
    end
    
    %% add S/C report
    results_table{end+1,1} = 'Crew';
    results_table{end,2} = 'Payload';
    results_table{end,3} = 'Engines and Bus';
    results_table{end,4} = 'Propellant';
    results_table{end,5} = 'Habitat';
    for i = 1:length(results_obj1.HumanSpacecraft.SC)
        results_table{end+1,1} = results_obj1.HumanSpacecraft.SC{i}.Description;
        results_table{end,2} = results_obj1.HumanSpacecraft.SC{i}.Payload_Mass;
        results_table{end,3} = nansum([results_obj1.HumanSpacecraft.SC{i}.Eng_Mass, results_obj1.HumanSpacecraft.SC{i}.Bus_Mass]);
        results_table{end,4} = results_obj1.HumanSpacecraft.SC{i}.Prop_Mass;
        results_table{end,5} = results_obj1.HumanSpacecraft.SC{i}.Hab_Mass;
    end
    results_table{end+1,1} = 'Cargo';
    results_table{end,2} = 'Quantity:';
    results_table{end,3} = results_obj1.Num_CargoSpacecraft;
    for i = 1:length(results_obj1.CargoSpacecraft.SC)
        results_table{end+1,1} = results_obj1.CargoSpacecraft.SC{i}.Description;
        results_table{end,2} = results_obj1.CargoSpacecraft.SC{i}.Payload_Mass;
        results_table{end,3} = nansum([results_obj1.CargoSpacecraft.SC{i}.Eng_Mass, results_obj1.CargoSpacecraft.SC{i}.Bus_Mass]);
        results_table{end,4} = results_obj1.CargoSpacecraft.SC{i}.Prop_Mass;
    end
    results_table{end+1,1} = 'Human MALMO';
    results_table{end,2} = results_obj1.HumanSpacecraft.MALMO;
    results_table{end,3} = results_obj2.HumanSpacecraft.MALMO;
    results_table{end+1,1} = 'Human MAMA';
    results_table{end,2} = results_obj1.HumanSpacecraft.MAMA;
    results_table{end,3} = results_obj2.HumanSpacecraft.MAMA;
    results_table{end+1,1} = 'Human Final';
    results_table{end,2} = results_obj1.HumanSpacecraft.Mass;
    results_table{end,3} = results_obj2.HumanSpacecraft.Mass;
    results_table{end+1,1} = 'Cargo MALMO';
    results_table{end,2} = results_obj1.CargoSpacecraft.MALMO;
    results_table{end,3} = results_obj2.CargoSpacecraft.MALMO;
    results_table{end+1,1} = 'Cargo MAMA';
    results_table{end,2} = results_obj1.CargoSpacecraft.MAMA;
    results_table{end,3} = results_obj2.CargoSpacecraft.MAMA;
    results_table{end+1,1} = 'Cargo Final';
    results_table{end,2} = results_obj1.CargoSpacecraft.Mass;
    results_table{end,3} = results_obj2.CargoSpacecraft.Mass;

    %     results_table{end+1,1} = 'Lunar Ferry';
%     for i = 1:length(results_obj1.FerrySpacecraft.SC)
%         results_table{end+1,1} = results_obj1.FerrySpacecraft.SC{i}.Description;
%         results_table{end,2} = results_obj1.FerrySpacecraft.SC{i}.Origin_Mass;
%     end
end

