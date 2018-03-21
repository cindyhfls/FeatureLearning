% It is currently run as a file not a function, but I will make some
% adjustments after talking to Shiva

% Esp about removing the repetition part

rep = 1 ; % First time targets are displayed
flagmessage = 0 ; % flag for timeout repetition
RewBannerOn = 0; % whether to show reward feedback?
while rep ~= 0
    FlushEvents('keyDown');
    keyCode=zeros([1 256]);
    
    % ITI: Dram fixation point for random time U(0.5, 1.5)
    % Why do we need random ITI???????
    Screen('FillRect',w,0);
    Screen('FillRect',w,setup.centerFeedback,coords.fixCoords);
    %             if setup.feedbackOn ~=0
    %                 % when the visual feedback is on, make a text of how much reward points we have now (maybe the jackpot? Why do we need to have reward accumulated anyway??)
    %                 Screen('DrawText',w, sprintf('%s%d','Reward points = ', runningreward),coords.x0+setup.rewCoords(1),coords.y0+setup.rewCoords(2),setup.totalColor);
    %             end
    vbl = Screen('Flip', w); % flip to background again
    %             rng('shuffle'); % I added this just in case rng was set
    waitTime(trNo,1) = 0.5 + setup.beforeWait(1)+rand*diff(setup.beforeWait);
    WaitSecs(waitTime(trNo,1));
    
    % Fixation time: Dram fixation point
    % Wait.. How is different from above? Fixed wait time?
    Screen('FillRect',w,0);
    Screen('FillRect',w,setup.correctFeedback,coords.fixCoords);
    if setup.feedbackOn ~=0
        Screen('DrawText',w, sprintf('%s%d','Reward points = ', runningreward),coords.x0+setup.rewCoords(1),coords.y0+setup.rewCoords(2),setup.totalColor);
    end
    vbl = Screen('Flip', w);
    WaitSecs(setup.fix);
    
    % Draw targets
    Screen('FillRect',w,0);
    Screen('FillRect',w,setup.correctFeedback,coords.fixCoords);
    DrawSimpleTargets(w,trNo,myinput,setup,coords); % function that calls the draw of targets
    
    if setup.feedbackOn ~=0 % visual feedback of reward points
        Screen('DrawText',w, sprintf('%s%d','Reward points = ', runningreward),coords.x0+setup.rewCoords(1),coords.y0+setup.rewCoords(2),setup.totalColor);
    end
    vbl = Screen('Flip', w); % outputs the system time of flip
    tStart = vbl ; % assign this time to be the trial start time
    tpresent = tStart ;                % initialize the RT/trial duartion timer
    % I am assuming the below part repeats the drawing of target
    % when the subject does not select anything after a certain time, and gives output if they do
    % but I don't think I need that timeout for monkeys and they use too many if conditions!
    
    while tpresent<tStart+setup.dispDur+setup.extrDsc && fcheckResponse(setup,keyCode) == 0 % fcheckFixation is a function that checks
        [~, ~, keyCode] = KbCheck;               % Look for response (left/right key)
        if tpresent<tStart+setup.dispDur
            Screen('FillRect',w,0);
            Screen('FillRect',w,setup.correctFeedback,coords.fixCoords);
            
            DrawSimpleTargets(w,trNo,myinput,setup,coords);
            
            if setup.feedbackOn ~=0
                Screen('DrawText',w, sprintf('%s%d','Reward points = ', runningreward),coords.x0+setup.rewCoords(1),coords.y0+setup.rewCoords(2),setup.totalColor);
            end
            if flagmessage % They tell the subject to select side if they haven't
                Screen('DrawText',w,'Select side please!',coords.x0+setup.banCoords(1),coords.y0-setup.banCoords(2),setup.angrymessageColor);
            end
            vbl = Screen('Flip', w);
        else
            Screen('FillRect',w,0);
            Screen('FillRect',w,setup.correctFeedback,coords.fixCoords);
            if setup.feedbackOn == 0
            else % give visual feedback for reward points
                Screen('DrawText',w, sprintf('%s%d','Reward points = ', runningreward),coords.x0+setup.rewCoords(1),coords.y0+setup.rewCoords(2),setup.totalColor);
            end
            if flagmessage
                Screen('DrawText',w,'Select side please!',coords.x0+setup.banCoords(1),coords.y0-setup.banCoords(2),setup.angrymessageColor);
            end
            vbl = Screen('Flip', w);
        end
        tpresent = vbl ; % get the present time for screen
    end    
end