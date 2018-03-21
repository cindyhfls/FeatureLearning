function [w,coords] = setupscreen(env,setup)

screenId = env.screenNumber; % which monitor in the rig for the task display
% screenId = max(Screen('Screens'));
windowedMode = setup.windowedMode; % 0 = run full-screen, 1 = run in window
AssertOpenGL;     % Make sure this is running on OpenGL Psychtoolbox:
InitializePsychSound(1);        % Low latency sound playback for making the beeps!
Screen('Preference','SkipSyncTests', 1);
Screen('Preference', 'SuppressAllWarnings', 1);
PsychImaging('PrepareConfiguration'); % configuration
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
if ~windowedMode
    [w, rect] = PsychImaging('OpenWindow', screenId, 0);     % open screen full screen
    % 0 is the background color?
else % w is the window ID I think? rect is a vector of position
    [w, rect] = PsychImaging('OpenWindow', screenId, 0, [0,0,600,450]); % running as a small window
end
% Now the onscreen window is ready for drawing and display of stimuli

ifi = Screen('GetFlipInterval', w);        % Retrieve video redraw interval for later control of our animation timing:
AssertGLSL;   % Make sure the GLSL shading language is supported: whatever that is
Screen('BlendFunction', w, GL_ONE, GL_ONE);
Screen('TextFont', w, 'Arial');
Screen('TextSize', w, 25);
KbReleaseWait; %  waits until all keys on the keyboard are released.

coords = coordsSetup(rect,setup); % function that calls to state where to draw whatever given the screen resolution
coords.ifi = ifi;

end