% returns flag = 1 when fixation is initiated
function flag = getEyeFixation(objcoords,pxerr) 

% need object coords and err (in pixels) this can be converted from degree
% actually don't bother, we can convert that to degrees later,
% 15 pixels seems to be a good radius or maybe use 1.5*radius?
global env
% env.eyeside = 1;  %1= left 2= right
% For different monkeys/rigs the eye tracked might be different


% Watch for keyboard interaction
a = KeyCapture();


flag = 0;

e = Eyelink('NewestFloatSample'); % eyelink function to get eye position in screen coordinates
x = e.gx(env.eyeside);
y = e.gy(env.eyeside);
pup = e.pa(env.eyeside);

xpos = objcoords(1);
ypos = objcoords(2);

if pup>0 && abs(x-xpos)<=pxerr && abs(y-ypos)<=pxerr
    % only when pupil size is larger than zero, difference in x-direction
    % and y-direction both satisfy the error window
    flag = 1; % successful fixation
end

            

end