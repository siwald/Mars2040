classdef OverallSC < dynamicprops
    %OVERALLSC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SC %Cell array of S/C elements 
    end
    
    properties (SetAccess = private) %thus GetAccess = public
        Mass %will return the total mass of all S/C elements
        ListDescriptions
    end
    properties (GetAccess = private) %thus SetAccess = public
        Add_Craft
    end
    
    methods
        function obj = OverallSC()
            obj.SC = cell(0);
        end
        
        function out = get.Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(1,num); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(1,i) = current.Origin_Mass; %set Origin_Mass to current col
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end
        
        function out = get.ListDescriptions(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            descrips = cell(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                descrips{i,1} = current.Description;
            end
            out = descrips;
        end
        
        function obj = set.Add_Craft(obj,craft)
            [row, ~] = size(obj.SC); %get # rows in the current S/C
            row = row + 1; %set the next row for added craft
            temp = obj.SC; %initialize temp
            temp{row,1} = craft; %put the input craft at the next row
            obj.SC = temp; %turn temp into SC
        end
    end
    
end

