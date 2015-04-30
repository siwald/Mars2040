function [Site_Sci_Value, Site_Elevation, Site_Water_Percent] = Site_Selection(Cur_Arch)

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
% Science Value Based on internal Site selection document
% Regolith Moisture Content extracted from Mars Odyssey: GRS H2O
% Concentration Map

switch Cur_Arch.SurfaceSites
    case Site.HOLDEN
        Site_Sci_Value = 7.25; 
        Site_Elevation = -4.5;
        Site_Water_Percent = 2;
        
    case Site.GALE
        Site_Sci_Value = 6.5; %Based on internal Site selection document
         Site_Elevation = -4.5;
        Site_Water_Percent = 6;
        
    case Site.MERIDIANI
        Site_Sci_Value = 5.25;
         Site_Elevation = -1.3;
        Site_Water_Percent = 7;
        
    case Site.GUSEV
        Site_Sci_Value = 9;
         Site_Elevation = -1.9;
        Site_Water_Percent = 8;
        
    case Site.ISIDIS
        Site_Sci_Value = 3.75;
         Site_Elevation = -4.0;
        Site_Water_Percent = 3;
        
    case Site.ELYSIUM
        Site_Sci_Value = 3.75;
         Site_Elevation = -3.0;
        Site_Water_Percent = 5;
        
    case Site.MAWRTH
        Site_Sci_Value = 6.5;
         Site_Elevation = -2.2;
        Site_Water_Percent = 3.5;
        
    case Site.EBERSWALDE
        Site_Sci_Value = 7;
         Site_Elevation = -1.4;
        Site_Water_Percent = 2.5;
        
    case Site.UTOPIA
        Site_Sci_Value = 5.75;
         Site_Elevation = -5.0;
        Site_Water_Percent = 3.75;
        
    case Site.PLANUS_BOREUM
        Site_Sci_Value = 5;
         Site_Elevation = -5.0;
        Site_Water_Percent = 64;
        
    case Site.HELLAS
        Site_Sci_Value = 5.75;
         Site_Elevation = -7.2;
        Site_Water_Percent = 3;
        
    case Site.AMAZONIS
        Site_Sci_Value = 3.75;
         Site_Elevation = -3.5;
        Site_Water_Percent = 4;
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

