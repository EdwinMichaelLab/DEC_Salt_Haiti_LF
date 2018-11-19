% Site data: Mf prevalence, blood sample volume, MDA regimen, MDA frequency,...
% MDA coverage, number of years of treatment, vector control, switch year

function [ LeoganeMf,LeoganeVol,LeoganeReg,LeoganeFreq,LeoganeMDACov,LeoganeNumYears,...
    LeoganeVC,LeoganeSwitchYear,LeoganeITNCov,LeoganeIRSCov]...
    = PostIntv_data_Leogane
%% Post-intervention Mf Data
% enter overall community prevalence in a single line
% 1st column = month of survey; 2nd: Total number of samples; 3rd: Mf +ves;
LeoganeMf = [(2013-2013)*12+1 100 15.5];



%% Blood sample volume used to test presence of mf (in uL)
% Standard volumes are 1000 uL, 100 uL, or 20 uL (60 uL uses 100 uL
% correction)
% Model operates based on 1 mL samples, so smaller samples will be
% corrected to reflect this
LeoganeVol = 60; 


%% MDA Regimen 
% if more than one treatment regimen, given frequency for each regimen
% (i.e. [5,2] for ALB followed by DEC+ALB)

% 1: IVM 
% 2: DEC+ALB
% 3: IVM+DEC+ALB
% 4: IVM+ALB
% 5: ALB
% 6: DEC salt
% 7: DEC+IVM
% 8: DEC
LeoganeReg = [2]; 



%% MDA Frequency
% in months
% if more than one treatment regimen, given frequency for each regimen
% (i.e. [12,6] for annual followed by biannial)
LeoganeFreq = [12]; 


%% Annual MDA Coverage
% enter as proportion (i.e. 0.8)
% LeoganeMDACov = [80 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80 80]/100; % 20 years
LeoganeMDACov = [65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65 65]/100; % 30 years
% LeoganeMDACov = [90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90]/100; % 20 years

%% Total number of years of treatment
% (last year - first year) + 1
LeoganeNumYears = 30;


%% Vector control
% 0: no VC, 1: VC
LeoganeVC = 0;


%% Year to switch treatment regimens
% enter 0 if a single treatment regimen is followed
LeoganeSwitchYear = 0; 

%% Vector control Coverage
% enter as proportion (i.e. 0.8)
LeoganeITNCov = 0; 

LeoganeIRSCov = 0; 


end
