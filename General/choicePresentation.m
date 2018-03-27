function choicePresentation(w,trNo,thischoice,setup,myinput,coords)
tStart = GetSecs;
tpresent = tStart ;
while tpresent<tStart+setup.choicePresentationT% draw the choice for how long
%     drawFixationObj(w,setup.correctFeedback,coords,'dot');
    Screen('FrameOval', w, setup.neutralFeedback, coords.targRectN(thischoice,:), 5); %circle the chosen target    
%     DrawSimpleTargets(w,trNo,myinput,setup,coords); % this is the function that can be replaced
    DrawSimpleTargets(w,trNo,myinput,setup,coords,thischoice)
    vbl = Screen('Flip', w);
    tpresent = vbl ;
end
end