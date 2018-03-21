% Function that generate input for a subject
% subName is the subject name
% transitionStart is a redundant variable which is always 1 as far as I am
% aware of
% flagExp is the condition within the experiment (color/shape volatility)
% flagModel distinguishes experiment 1 and 2 (generalizable VS
% non-generalizable)
function [expr,setup,myinput] = fGenerateInputIndividual(subName, transitionStart, flagExp, flagModel,sessionNum)

rng('shuffle')
setup = fPRL2initSetup ; % function that calls the initial device/background setup
expr = fPRL2initExp(flagModel, flagExp) ; % function that calls the experimental conditions (reward schedules)
expr.flagExp = flagExp ; % stores the experiment condition color/shape volatile?
expr.flagModel = flagModel ; % stores which experiment it is?
expr.transitionStart = transitionStart ; % OK this is to state the transition in next line, but it is always 1 OvO?
myinput = fGenerateInput(expr) ; % function that generates input from the experimental conditions stated above

% inputcheck = fCheckInput(expr, input)

save(['./inputs/input_',subName,'_', datestr(now,'yyyymmdd'),'_00',sessionNum,'.mat'],'expr','setup','myinput');
% The input file was saved to the inputs directory