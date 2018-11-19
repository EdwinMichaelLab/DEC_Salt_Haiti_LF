function [mfPrevIntv,cfaPrevIntv,MBRIntv,L3Intv] = Modelling_MDAplusVC_new(kId,...
    alpha2,gamma2,ParameterVectors,L3Values,demog,ageMthMax,...
    da,bCulex,AgeLimits,VillageDrugEfficacy,MDAInterval,...
    NumYears,MultiVecMBR,IRSCoverages,ITNCoverages,MonthlyMDACov,...
    SwitchMonth,VCparams)

% initialize arrays
mfPrevIntv = zeros(1+NumYears*12,length(kId));
cfaPrevIntv = zeros(1+NumYears*12,length(kId));
MBRIntv = zeros(1+NumYears*12,length(kId));
L3Intv = zeros(1+NumYears*12,length(kId));

bSuppress = 1; % flag for if immunosuppression effects should be modeled

gVec=zeros((ageMthMax/da),1);
pVec=zeros((ageMthMax/da),1);
wVec=zeros((ageMthMax/da),1);
mVec=zeros((ageMthMax/da),1);
iVec=zeros((ageMthMax/da),1);
cfaVec=zeros((ageMthMax/da),1);

parfor i = 1:length(kId)
    
    [beta,alpha,k0,kLin,k1,r1,sigma1,psi1,psi2s2,mu,gamma,b1,c,ageLev,...
        ~,k2,gam2,immC,slopeC,PP,~,~,del] = ...
        get_theParametersLF(ParameterVectors,bSuppress,i);
    
    l3 = L3Values(i,:);
    VoverH  = MultiVecMBR(i)/beta;
        
    [pVec0,wVec0,mVec0,iVec0,cVec0]=...
        equilibriumValuesOfStateVars_CFA(beta,k0,kLin,...
        psi1,mu,alpha,gamma,c,ageLev,VoverH,psi2s2,immC,slopeC,del,...
        alpha2,gamma2,ageMthMax,da,l3,PP,pVec,wVec,mVec,iVec,gVec,cfaVec);
    % function to calculate VoverH at each month, returns a vector
   

    
    [MfPrevArray,CfaPrevArray,MBRArray,L3Array] = ...
        MDA_Intervention_w_VCLLIN(beta,alpha,k0,kLin,k1,r1,sigma1,psi1,...
        psi2s2,mu,gamma,b1,c,ageLev,k2,gam2,immC,slopeC,VoverH,del,...
        PP,alpha2,gamma2,ageMthMax,da,bCulex,l3,gVec,pVec0,...
        wVec0,mVec0,iVec0,cVec0,demog,AgeLimits,MonthlyMDACov,...
        VillageDrugEfficacy,MDAInterval,NumYears,VCparams,...
        IRSCoverages,ITNCoverages,SwitchMonth);
    
    mfPrevIntv(:,i) = MfPrevArray';
    cfaPrevIntv(:,i) = CfaPrevArray';
    MBRIntv(:,i) = MBRArray;
    L3Intv(:,i) = L3Array;
end
end
