function [thisresponsetime,thischoice,thisrepeat,thisbetterchoice] = target_presentation(w,trNo,myinput,setup,coords)

global continuing pauseexp 
rep = 1 ; % First time targets are displayed
responseout = 0; % initial default response = 0

% default output to prevent error crashing when paused/stopped
thisresponsetime = NaN;
thischoice = NaN;
thisrepeat = NaN;
thisbetterchoice = NaN;

while rep ~= 0 && continuing ==1 && pauseexp==0 % repeat display after timeout
    % Draw targets
%     drawFixationObj(w,setup.centerFeedback,coords,'dot')
    DrawSimpleTargets(w,trNo,myinput,setup,coords); % function that calls the draw of targets
    
    vbl = Screen('Flip', w); % outputs the system time of flip
    
    tStart = vbl ; % assign this time to be the trial start time
    tpresent = tStart ;                % initialize the RT/trial duartion timer
    
    
    % I am assuming the below part repeats the drawing of target
    while tpresent<tStart+setup.dispDur+setup.extrDsc && responseout == 0 && continuing ==1 && pauseexp==0
        if tpresent<tStart+setup.dispDur
            % target dissappears after certain time
            % print fixation start strobe %
            [responseout,whichout] = fcheckResponse2AFC(setup,coords);
            if responseout
%                 fprintf('Fixation on target was initiated\n');
                tfix = vbl;
            end
            while responseout == 1 && tfix-vbl < setup.fixationtime && continuing ==1 && pauseexp==0
                [responseout,whichout] = fcheckResponse2AFC(setup,coords); % check persistent fixation
                tfix = GetSecs; % how long is the fixation for
                if responseout == 0
%                     fprintf('Fixation on target was broken\n'); % print fixation broken strobe
                elseif tfix-vbl >setup.fixationtime
%                     fprintf('Fixation on target was complete\n'); % print fixation complete strobe
                end
            end
%             drawFixationObj(w,setup.centerFeedback,coords,'dot')
            DrawSimpleTargets(w,trNo,myinput,setup,coords);
            vbl = Screen('Flip', w); % now the stimulus is on screen
            tpresent = vbl ; % get the present time for screen
        else
%             drawFixationObj(w,setup.centerFeedback,coords,'dot')
            vbl = Screen('Flip', w);
            tpresent = vbl ; % get the present time for screen
        end
        
        if  responseout == 0 % exit while loop by timeout
            rep = rep + 1 ;
        elseif responseout == 1 % exit while loop by responding
            thisresponsetime= GetSecs - tStart ;
            thischoice= whichout; % this line and below are to replace the original keyboard check
            thisrepeat = rep;
            if ~isnan(thischoice)
            thisbetterchoice = myinput.betterchoice(trNo) == thischoice;
            end
            rep = 0 ; % return to default to exit while loop
        end
    end
end

end
