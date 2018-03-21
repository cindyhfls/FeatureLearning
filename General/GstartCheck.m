function vbl = GstartCheck(w,setup)
DrawFormattedText(w,'Press G to begin/continue','center','center',256); % start of task instruction
vbl = Screen('Flip', w); % display background
FlushEvents('keyDown'); % Remove events from the system event queue.
[~, ~, keyCode] = KbCheck;
while ~keyCode(setup.gKey) % Check if 'G' is pressed to continue
    [~, ~, keyCode] = KbCheck;
end
end