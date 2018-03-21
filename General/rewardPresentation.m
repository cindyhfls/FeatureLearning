% This part shows the reward presentation.
% It can be modified to a much simpler version because we don't need to
% present the 25 cents every whatever reward
function [thisreward,totalreward]=rewardPresentation(w,trNo,vbl,myinput,setup,coords,totalreward,thischoice)

%specify some parameters for reward display
thisreward = myinput.inputReward(thischoice, trNo) ; % get the reward according to choice
if thisreward % if the choice is rewarded
    feedbackColor = setup.correctFeedback; % visual feedback for correct
    totalreward = totalreward + 1 ;
else
    feedbackColor = setup.wrongFeedback; % visual feedback for wrong
end

tStart = GetSecs;
tpresent = tStart ;
rewardPresentationTemp = setup.rewardPresentationT ;  % how long is the reward feedback duration
if setup.feedbackOn == 0 % visual feedback off
    feedbackColor = setup.neutralFeedback;
end

while tpresent<tStart+rewardPresentationTemp
%     drawFixationObj(w,setup.correctFeedback,coords,'dot');
    Screen('FrameOval', w, feedbackColor, coords.targRectN(thischoice,:), 5);
    DrawSimpleTargets(w,trNo,myinput,setup,coords);
    vbl = Screen('Flip', w, vbl + 0.5 * coords.ifi);
    tpresent = vbl ;
end


if thisreward
    reward_digital_Juicer1(setup.rewardjuiceamount);
    % to be replaced with real juicer code
%     fprintf('juicer reward obtained\n'); % print strobe
end

end