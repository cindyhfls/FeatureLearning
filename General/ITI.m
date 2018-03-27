% This function draws the blank screen for a period of time
% windowPtr is the window ID
% tsec is the length of delay
function ITI(windowPtr,tsec)

if nargin<2
    tsec = 1.5; % default ITI time delay in seconds
end

tStart = GetSecs;
tpresent = tStart ;
while tpresent<tStart+tsec
    % make each trial is at least tsec seconds by increasing ITI
    vbl = Screen('Flip', windowPtr);
    tpresent = vbl ;
end
end