% This part shows the reward presentation.
function [thisreward,totalreward]=rewardPresentation(w,trNo,vbl,myinput,setup,coords,totalreward,thischoice)
%specify some parameters for reward display
thisreward = myinput.inputReward(thischoice, trNo) ; % get the reward according to choice
if thisreward % if the choice is rewarded
    feedbackColor(thischoice,:) = setup.correctFeedback; % visual feedback for correct
    totalreward = totalreward + 1 ;
else
    feedbackColor(thischoice,:) = setup.wrongFeedback; % visual feedback for wrong
end

unchosen = setdiff(1:2,thischoice) ;
if myinput.inputReward(unchosen,trNo)% if the choice is rewarded
    feedbackColor(unchosen,:) = setup.correctFeedback; % visual feedback for correct
else
    feedbackColor(unchosen,:) = setup.wrongFeedback; % visual feedback for wrong
end

tStart = GetSecs;
tpresent = tStart ;
rewardPresentationTemp = setup.rewardPresentationT ;  % how long is the reward feedback duration

if setup.feedbackOn == 0 % visual feedback off
    feedbackColor = repmat(setup.neutralFeedback,2,1);
end

while tpresent<tStart+rewardPresentationTemp
%     drawFixationObj(w,setup.correctFeedback,coords,'dot');
    DrawSimpleTargets(w,trNo,myinput,setup,coords,thischoice)
    Screen('FrameOval', w, feedbackColor(thischoice,:), coords.targRectN(thischoice,:), 5); % feedback circle for correct feedback
%     Screen('FrameOval', w, feedbackColor(unchosen,:), coords.targRectN(unchosen,:), 5); % feedback circle for correct feedback
    vbl = Screen('Flip', w, vbl + 0.5 * coords.ifi);
    tpresent = vbl ;
end


if thisreward
    reward_digital_Juicer1(setup.rewardjuiceamount);
%     fprintf('juicer reward obtained\n'); % print strobe
end



% %post-hoc display
% tStart = GetSecs;
% tpresent = tStart ;
% while tpresent<tStart+rewardPresentationTemp/2
%     vbl = Screen('Flip', w);
%     tpresent = vbl ;
% end
% while tpresent<tStart+rewardPresentationTemp
% %     drawFixationObj(w,setup.correctFeedback,coords,'dot');
%     DrawSimpleTargets(w,trNo,myinput,setup,coords);
%     Screen('FrameOval', w, feedbackColor(thischoice,:), coords.targRectN(thischoice,:), 5); % feedback circle for correct feedback
%     Screen('FrameOval', w, feedbackColor(unchosen,:), coords.targRectN(unchosen,:), 5); % feedback circle for correct feedback
%     vbl = Screen('Flip', w, vbl + 0.5 * coords.ifi);
%     tpresent = vbl ;
% end

end