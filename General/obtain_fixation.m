function [vbl] = obtain_fixation(w,setup,coords)
global continuing pauseexp
startTime = GetSecs;
vbl = startTime;
fixcompleteflag = 0;

% ITI: Dram fixation point for random time U(0.5, 1.5)
% draw fixation object (dot)
drawFixationObj(w,setup.centerFeedback,coords,'dot');
vbl = Screen('Flip', w);

%%%% To-do: printstrobe(fixation dot appear);%%%%%%
while fixcompleteflag ~= 1 && continuing == 1 && pauseexp~=1
    if strcmp(setup.devicename,'eye')
        fixcompleteflag = getEyeFixation([coords.x0,coords.y0],setup.pxerr);
        if fixcompleteflag
%             fprintf('Fixation on dot was initiated\n'); % print fixation start strobe %
            tfix = vbl;
        end
        while fixcompleteflag == 1 && tfix-vbl < setup.fixationtime && pauseexp~=1
            fixcompleteflag = getEyeFixation([coords.x0,coords.y0],setup.pxerr); % check fixation here
            tfix = GetSecs; % how long is the fixation for
            if fixcompleteflag == 0
                % fprintf('Fixation on dot was broken\n');
                % print fixation broken strobe
            elseif tfix-vbl >setup.fixationtime
                % fprintf('Fixation on dot was complete\n');
                % print fixation complete strobe
            end
        end
    else
        fixcompleteflag = 1;
    end
end
% rng('shuffle'); % I added this just in case rng was set
% waitTime(trNo,1) = 0.5 + setup.beforeWait(1)+rand*diff(setup.beforeWait);
% WaitSecs(waitTime(trNo,1));

% fixation dot changes color meaning fixation complete
if fixcompleteflag == 1
drawFixationObj(w,setup.correctFeedback,coords,'dot'); 
vbl = Screen('Flip', w);
end

%%%% To-do: printstrobe(strobeName);%%%%%%

WaitSecs(setup.fix); % originally for reading the text
% I think this is the time delay from fixation complete to the target
% presentation
end
