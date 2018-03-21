% check for keyboard/eye/joystick response for 2AFC tasks
% out is a binary code of whether there is a response
% whichout is the whether the left/right is the response
% whichout = 1 when left chosen
% whichout = 2 when right chosen

function [out,whichout] = fcheckResponse2AFC(setup,coords)


if ~isfield(setup,'devicename')
error('You need to state the input devicename in the setup');
elseif strcmp(setup.devicename,'key')
    deviceType = 1;
elseif strcmp(setup.devicename,'eye')
    deviceType = 2;
    objLcoords = coords.objLcoords;
    objRcoords = coords.objRcoords;
%     objLcoords = [coords.x0-setup.targDist,coords.y0];
%     objRcoords = [coords.x0+setup.targDist,coords.y0];
    pxerr = setup.pxerr; % fixation window radius in pixels
end
    

switch deviceType
    case 1 %key
        FlushEvents('keyDown');
        [keyIsDown, ~, keyCode] = KbCheck;    % Look for response (left/right key)
        out = keyIsDown;
        temp = keyCode([setup.leftKey,setup.rightKey]);
        whichout = find(temp);
    case 2 % eye
        outL = getEyeFixation(objLcoords,pxerr);
        outR = getEyeFixation(objRcoords,pxerr);
        whichout = find([outL,outR]);
        out = or(outL,outR);
end


end