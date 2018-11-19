%% add CommonFunctions folder containing basic model functions and Baseline folder containing baseline fits to path
% addpath('../CommonFunctions/');
% addpath('../BaselineFitting/Baseline_MATLAB');

%% User-defined inputs

% integration time step
da = 1; % 1 month

% Site details: Relevant endemic regions, Country (pertains only Sub-Saharan Africa cases), Village
Regions = {'Haiti'}; % at least one required
Countries = {'Haiti'};% required only for SSA sites, names should follow format of Countries_w_Demo.mat

Haitisites = {'Leogane'};



% Site data: Mf prevalence, blood sample volume, MDA regimen, MDA frequency,...
% MDA coverage, number of years of treatment, vector control, switch year
% arranged in region-specific .m data files created by the user
[ LeoganeMf,LeoganeVol,LeoganeReg,LeoganeFreq,LeoganeMDACov,LeoganeNumYears,...
    LeoganeVC,LeoganeSwitchYear,LeoganeITNCov,LeoganeIRSCov]...
    = PostIntv_data_Leogane;

% Number of workers for parallel pool settings
NumWorkers = 3; % dependent on system capabilities

%% Intervention specifications

% Mass drug administration parameters
AgeLimits=[5 100]; % treatment for > 5 yrs old
RegimenEfficacy0 = [0.1 0.99 9; % IVM worm kill rate, mf kill rate, sterilization period (months)
    0.55 0.95 6; % DEC+ALB
    0.55 1 120; % IVM+DEC+ALB (permanent sterilization - 10 yrs)
    0.35 0.99 9; % IVM+ALB
    0.35 0 0; % ALB
    0.59 0.86 10; % DEC salt
    0.45 0.99 9;  % DEC+IVM
    0.35 0.90 3];  % DEC

% Vector control parameters
AnnualDecrease = 0;
IRSParams = [87.5, 93, 277, 6, 80]; % Vector control by indoor residual spraying
ITNParams = [20, 90, 97, 26, 12*3, 80]; % Vector control by long lasting insecticide nets
VCparams = SSA_IRS_ITN_Parameters(IRSParams,ITNParams,AnnualDecrease);

setupParallelPool(); % Initialize the parallel workers

%% Run fitting procedure for each site

for iReg = 1%:%length(Regions)
    Sites  = eval(sprintf('%ssites',Regions{iReg}));
    for iSites = 1:length(Sites)
        %% set up inputs
        
        % define data
        MfData  = eval(sprintf('%sMf',Sites{iSites}));
        Vol     = eval(sprintf('%sVol',Sites{iSites}));
        MDAReg = eval(sprintf('%sReg',Sites{iSites}));
        MDAFreq = eval(sprintf('%sFreq',Sites{iSites}));
        MDACov  = eval(sprintf('%sMDACov',Sites{iSites}));
        VC  = eval(sprintf('%sVC',Sites{iSites}));
        IRSCov  = eval(sprintf('%sIRSCov',Sites{iSites}));
        ITNCov  = eval(sprintf('%sITNCov',Sites{iSites}));
        NumYears  = eval(sprintf('%sNumYears',Sites{iSites}));
        SwitchYear  = eval(sprintf('%sSwitchYear',Sites{iSites}));
        
        % convert data into format compatible with model
        
        % correct mf data for blood sample volume
        if ~isnan(MfData(1,1)) && (Vol == 20)
            MfData(:,3)=floor(min(MfData(:,2),MfData(:,3)*1.95));
        elseif ~isnan(MfData(1,1)) && (Vol == 100 || Vol == 60)
            MfData(:,3)=floor(min(MfData(:,2),MfData(:,3)*1.15));
        end
        
        % Month to switch drug treatment regimen
        SwitchMonth = zeros(1,length(SwitchYear));
        for h = 1:length(SwitchYear)
            if SwitchYear(h) == 0
                SwitchMonth(h) = 0;
            else
                SwitchMonth(h) = SwitchYear(h)*12;
            end
        end
        
               
               
%         % MDA Frequency
        MDAInterval = zeros(1,NumYears*12);
        if length(MDAFreq)==1
            MDAInterval(1,1:end) = MDAFreq(1);
        else
            MDAInterval(1,1:SwitchMonth) = MDAFreq(1);
            MDAInterval(1,SwitchMonth+1:end) = MDAFreq(2);
        end
        
        % MDA Drug Regimen Efficacy
        RegimenEfficacy = zeros(length(MDAReg),length(RegimenEfficacy0(1,:)));
        for j = 1:length(MDAReg)
            RegimenEfficacy(j,:) = RegimenEfficacy0(MDAReg(j),:);
        end
        
        % MDA Coverage
        MonthlyMDACov = zeros(NumYears*12,1);
        for i = 1:length(MDACov)
            MonthlyMDACov((i-1)*MDAFreq(1)+1:i*MDAFreq(1)) = MDACov(i);
        end
% %         
        % VC coverages
        IRSCoverages=ones(1,NumYears*12)*IRSCov;
        ITNCoverages=ones(1,NumYears*12)*ITNCov;
        
        MfData0=MfData;
        %% load baseline fits
        % ABR, L3Values, ParameterVectors, ageMthMax, bCulex, demog, mfPrevArray are loaded.
        load(sprintf('ParamVectors_SIR_%s.mat',Sites{iSites}));
        MultiVecMBR = ABR/12;
        kId = 1:length(ABR);
        
                      
        %% model interventions
        
        % run interventions as observed 
        [mfPrevIntv1,MBRIntv1,L3Intv1] =...
            Modelling_MDAplusVC(kId,...
            ParameterVectors,L3Values,demog,ageMthMax,da,bCulex,...
            AgeLimits,RegimenEfficacy,MDAInterval,NumYears,...
            MultiVecMBR,IRSCoverages,ITNCoverages,MonthlyMDACov,SwitchMonth,VCparams);
        
       
         
         tWHO = Time_toCross_below_Threshold(mfPrevIntv1,1); % finds month where 1% is reached
        
         

save(sprintf('Intv_%s.mat',char(Sites{iSites})),...
                'mfPrevIntv1','MBRIntv1','L3Intv1','RegimenEfficacy',...
                'MonthlyMDACov','IRSCoverages',...
                'ITNCoverages','MfData*','SwitchMonth','tWHO');
        
%         
    end
end
