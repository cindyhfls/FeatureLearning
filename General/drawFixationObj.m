% This function draws a center fixation object
% w is the windowId
% color contains color information
% coords contain the position and size information

function drawFixationObj(w,color,coords,varargin)

if isempty(varargin)
    shape = 'dot' ;% dafult is drawing a dot
else
    shape = varargin{1};
end


Screen('FillRect',w,0); % black background
switch shape
    case 'dot'
        Screen('FillOval',w,color,coords.fixCoords);
    case 'cross'
        Screen('FillRect',w,color,coords.fixCoords); % 
end

end