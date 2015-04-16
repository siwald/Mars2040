function [ results_table ] = ResultsCompare( results_obj1, results_obj2 )
%RESULTSCOMPARE Summary of this function goes here
%   Detailed explanation goes here



%% Fill out Results Row
results_table = cell(50, 3);
results_table{1,1} = {'Component'};
results_table{1,2} = {results_obj1.Arch_Name};
results_table{1,3} = {results_obj2.Arch_Name};
results_table{1,4} = {'Difference'};

results_table{2,1} = {'Total IMLEO'};
results_table{2,2} = {results_obj1.IMLEO};
results_table{2,3} = {results_obj2.IMLEO};
results_table{2,4} = {results_obj1.IMLEO - results_obj2.IMLEO};
end

