function [Site_Sci_Value] = Site_Selection(Cur_Arch)

%------------------------------------------------------------------------
%----------------------Code Definition-----------------------------------
%Site selection will use a case statement to output the calculated
%scientific value for the site that has been selected. Future development
%will output radiation exposure and other variables depending on altitude
%and cooridnates of each site. 

%------Inputs------

% Site selected in Morphological Matrix
% Cur_Arch = 'Holden Crater'; 

%------Outputs------

%This module will output the scientific value for the site that is being
%evaluated. 

%Site_Sci_Value; % Site scientific value based on values in the site
%selection excel document. 

%------Constants------

%The following are constants that are used in equating the requried
%resources. These values can be changed once further information becomes
%available on the actual usage that is seen.


%------------------------------------------------------------------------

switch Cur_Arch.SiteSelection
    case Site.Holden_Crater
        Site_Sci_Value = 62; %Based on internal Site selection document
    case Site.Gale_Crater
        Site_Sci_Value = 57; %Based on internal Site selection document
end

%Calculations begin
% 
% if strcmp ('Site' ,'Gale Crater')
%     lat = -4.6;
%     long = -137.4;
% elseif strcmp( 'Site' , 'Meridiani Planum')
%     lat = -2.1;
%     long = 6;
% elseif strcmp ('Site' , 'Gusev Crater')
%     lat = -14.6;
%     long = 175.3;
% elseif strcmp('Site' , 'Isidis Planitia')
%     lat = 4.2;
%     long = 88.1;
% elseif strcmp('Site' , 'Elysium')
%     lat = 11.7;
%     long =123.9;
% elseif strcmp('Site' , 'Mawrth Vallis')
%     lat = 23.9;
%     long = -19;
% elseif strcmp('Site' , 'Eberswalde Ellipse')
%     lat = -23.9;
%     long = -33.3;
% elseif strcmp('Site' , 'Holden Crater')
%     lat = -26.4;
%     long = -34.8;
% elseif strcmp('Site' , 'Utopia Planitia')
%     lat = 45;
%     long = 110;
% elseif strcmp('Site' , 'Planus Boreum')
%     lat = 88;
%     long = 15;
% elseif strcmp('Site' , 'Hellas Planitia')
%     lat = -40;
%     long =  70;
% elseif strcmp('Site' , 'Amazonis Planitia')
%     lat = 24.8;
%     long = -164;
% end
% 
% end

