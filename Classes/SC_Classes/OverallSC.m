classdef OverallSC < dynamicprops
    %OVERALLSC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SC %Cell array of S/C elements 
    end
    
    properties (SetAccess = private) %thus GetAccess = public
        Mass %will return the total mass of all S/C elements
        Eng_Mass
        Bus_Mass
        Static_Mass
        ListDescriptions
        Ox_Mass
        Fuel_Mass
        Prop_Mass
    end
    
    properties
        MALMO %Mass at Low Mars Orbit
        MAMA %Mass at Mars Approach
    end
    
    properties (GetAccess = private) %thus SetAccess = public
        Add_Craft
    end
    
    methods
        %Constructor
        function obj = OverallSC()
            obj.SC = cell(0); %initializes the module array
        end
        %% Getters
        function out = get.Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Origin_Mass]); %set Origin_Mass to current col
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end 
        
        function out = get.Eng_Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Eng_Mass]); %set Origin_Mass to current col
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end 

        function out = get.Static_Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Static_Mass]); %set Origin_Mass to current col
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end
        
        function out = get.Bus_Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Bus_Mass]); %set Origin_Mass to current col
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
         end 
        
        function out = get.Ox_Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Ox_Mass]);%set Ox_Mass to current col
                current.origin_calc; %recalc origin of current SC element
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end
        
        function out = get.Fuel_Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Fuel_Mass]); %set Fuel_Mass to current col
                current.origin_calc; %recalc origin of current SC element
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end
        
        function out = get.Prop_Mass(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            masses = zeros(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                masses(i,1) = nansum([current.Prop_Mass]); %set Prop_Mass to current col
            end
            out = sum(masses); %deliver the sum of masses for all SC elements
        end
        
        function out = get.ListDescriptions(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            descrips = cell(num,1); %initialize array of masses
            for i=1:num
                current = obj.SC{i}; %extract the current SC element
                descrips{i} = current.Description;
            end
            out = descrips;
        end
        %% Add a new element
        function obj = set.Add_Craft(obj, craft)
            [row, ~] = size(obj.SC); %get # rows in the current S/C
            row = row + 1; %set the next row for added craft
            temp = obj.SC; %initialize temp
            temp{row,1} = craft; %put the input craft at the next row
            obj.SC = temp; %turn temp into SC
        end
        
        %% Remove an element
        function out = Get_Craft(obj, name)
            [num, ~] = size(obj.SC);
            for i=1:num
                if strcmp(obj.SC{i,1}.Description, name)
                    out = obj.SC{i,1}; %copy out the entry module
                    obj.SC(i,:) = []; %remove the module from the SCModulesList
                    break
                end
            end
        end
        %% Copy an element
        function out = Copy_Craft(obj, name)
            [num, ~] = size(obj.SC);
            for i=1:num
                if strcmp(obj.SC{i,1}.Description, name)
                    out = obj.SC{i,1}; %copy out the entry module
                    break
                end
            end
        end
        %% Remove Propellents for ISRU generation
        %Clear all oxidizer from SC elements
        function remove_ox(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                current.Ox_Mass = 0; %set ox to 0
                current.Prop_Mass = current.Fuel_Mass + 0; %reset Prop_mass without Ox.
                obj.SC{i,1} = current; %and put it back
            end
        end
        
        %Clear all fuel from SC elements
        function remove_fuel(obj)
            [num,~] = size(obj.SC); %get number of SC elements
            for i=1:num
                current = obj.SC{i,1}; %extract the current SC element
                current.Fuel_Mass = 0; %set fuel to 0
                current.Prop_Mass = current.Ox_Mass + 0; %reset Prop_mass without fuel.
                obj.SC{i,1} = current; %and put it back
            end
        end
    end
    
end

