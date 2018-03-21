function degrees = px2deg(pixels,varargin)

if isempty(varargin)
    env.distance = 50; % default 50 cm
    env.physicalWidth = 30; % default screen width 30 cm
    env.pixwidth = 960; % default screen width 960 pixels
else
    env = varargin{1};
end

% stimCm = tand(degrees)*env.distance;% stimulus size in cm
convF = env.pixwidth./env.physicalWidth; % ratio of pixels to cm
stimCm = pixels./convF;
degrees = atand(stimCm./env.distance);
% pixels = stimCm * convF;

end