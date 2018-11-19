% Calculate the binomial likelihoods of each of the curves generated by the
% parameter vectors. These lkelihoods will then go on to be used to
% resample the parameter vectors for the determination of the posterior
% distributions.

% example prevReal data:
% col 1) The middle ages of each group; col 2) The number of
% samples; col 3) the number of mf-positive samples;
% col 4) the upper ages of each group
% MfData =...
%     [5	7	2	10
%     15	14	9	20
%     25	18	11	30
%     35	10	8	40
%     45	8	8	50
%     55	6	4	60];
% mPrevVal is the model-generated mf prevalence for each age in months
function likeliPrev=calculateLikelihoods(prevReal,mPrevVal,...
    demographic,da,ageMthMax)

warning('off','all');

ageGroup = prevReal(:,4); % max age of each group

% Initialize arrays and counters
mfPrevGroup = zeros(length(ageGroup),1);
iGroup = 1;
weightedMfPrev = 0;
numPeopleInGroup = 0;
iCheck =1;

% First find the prevalences for each age group
% for each age group, need to check if it's mPrevVal is calculated and added
% into the weightedMfPrev
for iAge = 1:da:ageMthMax

    if iGroup <= length(ageGroup)
        if iAge/12.0 < ageGroup(iGroup) % count ages that fall in current age group
            pia=pi_PeopleFun(iAge/12.0,demographic);
            weightedMfPrev = weightedMfPrev + pia*mPrevVal(iCheck);  % mPrevVal is the mfPrevArray in RunSelectP...
            numPeopleInGroup = numPeopleInGroup + pia;
        else % reached end of age group, aggregate overall prevalence of age group
            mfPrevGroup(iGroup) = weightedMfPrev/(numPeopleInGroup*100);
            iGroup = iGroup + 1;
            weightedMfPrev = 0;
            numPeopleInGroup = 0;
        end
    end

    iCheck = iCheck + 1; % recommend to replace iCheck with iAge

end

%% need to check the following three lines is necessary or not

if iGroup == length(ageGroup) % reached end of final age group, aggregate overall prevalence of final age group
    mfPrevGroup(iGroup) = weightedMfPrev/(numPeopleInGroup*100);
end

% Correct for extreme prevalence values
tol = 0.000001;
for iGroup = 1:length(ageGroup)
    if abs(mfPrevGroup(iGroup)) < tol
        mfPrevGroup(iGroup) = 0.0000001;
    elseif abs(1-mfPrevGroup(iGroup)) < tol
        mfPrevGroup(iGroup) = 0.999999;
    end
end

% Calculate binomial likelihood
loglikeliPrev=0;
for iGroup = 1:length(ageGroup)
    loglikeliPrev = loglikeliPrev + prevReal(iGroup,3)*...  % prevReal = MfData
        log(mfPrevGroup(iGroup))+(prevReal(iGroup,2)-prevReal(iGroup,3))*...
        log(1-mfPrevGroup(iGroup));
end

likeliPrev=exp(loglikeliPrev);

end
