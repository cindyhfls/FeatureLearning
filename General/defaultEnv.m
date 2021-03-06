% function env = defaultEnv()
global env
% Setup the environment struct - used by many task functions
env.screenNumber = 1;
env.resolution = Screen('Resolution',env.screenNumber);
env.pixwidth = env.resolution.width;
env.distance = 100; % in cm, monkey from screen
env.physicalWidth = 30; % in cm, width of the visible screen
% env.colorDepth = 255;
% env.juicePort = 0; % port for juice
% env.juiceCh = 0; % channel for juice
env.rigID = 'Shadowlands'; %
env.eyeside = 1;  %1= left 2= right

% open the DIO, make sure we can access everything
% setupDIO; % digital input-out from the juicer
% env.allDIOclosed = flags;
% env.nports = nports;
% env.digOut = digOut;

% KbName('UnifyKeyNames');

% set correct IP address for eyelink
% ipConfig = 'netsh int ip set address \"Local Area Connection\" static 100.1.1.2 255.255.255.0';
% result = system(ipConfig);
% 
% if result == 0
%     disp('ip address sucessfully configured for eyelink')
% else
%     disp('ERROR: problem with IP address configuration')
% end
% end