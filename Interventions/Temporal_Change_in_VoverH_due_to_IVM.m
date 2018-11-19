function VH=Temporal_Change_in_VoverH_due_to_IVM(NumYears,VoverH,DecayRate)
VH=zeros(NumYears*12,length(VoverH));
% DecayRate = -2.1; % from ensemble paper supp info fitted to Pondicherry
for jj=1:length(VoverH)
    VH(1,jj)=VoverH(jj);
    VH(2:NumYears*12,jj)=VoverH(jj)*exp(-DecayRate.*((1:NumYears*12-1)/12)); % MBR decrease during control
end
end
