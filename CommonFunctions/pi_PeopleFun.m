% distribution of ages based on country demographics
% used to calculate the probability of a person being age a
function pia=pi_PeopleFun(a,demographic)
pia = demographic(3)*exp(-((a-demographic(4))/demographic(5)).^2); % to calculate the density of the age 'a'
end

