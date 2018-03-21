function [setup] = fPRL2initSetup
global env
% Original human-version:
setup.feedbackOn = 1;                      % turn feedback on or off
% setup.va2p = 75;                            % pixels per visual degree % I think I will need to recalculate this using the rig_specific environment
setup.va2p = deg2px(1,env); %111

% added non-specific
setup.windowedMode = 0; % 0 = run full-screen, 1 = run in window
setup.textfeedbackOn = 0;
setup.devicename = 'eye'; % 'key' or 'eye'

% added for monkey-specific eye-tracking:
setup.rewardjuiceamount = .2;
setup.manualjuiceamount = .1; % should be less than reward ideally
setup.fixationtime = 0.4; % fixation completes in 0.4 s (change to 0 for human)
% setup.pxerr = 200; % radius of fixation position tolerance in pixels
setup.pxerr = setup.va2p * 2;
setup.pseudorandomblock = true;


setup.neutralFeedback = [255 255 255] ;
setup.correctFeedback = [255 255 -128]; 
setup.wrongFeedback =   [255/2 255/2 255/2] ;
setup.totalColor =      [255 255 -128] ;
setup.messageColor =    [255 255 -128] ;
setup.angrymessageColor = [255 -128 255] ;
setup.centerFeedback = setup.neutralFeedback ;

setup.rewardColor = setup.correctFeedback;
setup.punishColor = setup.wrongFeedback;

setup.choicePresentationT = .5 ;
setup.rewardPresentationT = 1.0 ;
setup.dispDur = 10 ;                                % how long are stimuli displayed for
setup.extrDsc = .5 ;                                 % how long extra descion time after stimuli is removed
setup.targSize = round(setup.va2p*1.0) ;             % size of target
setup.fix = .5 ;
setup.targSizeN = round(setup.va2p*3) ;            % size of choice/reward circle
setup.targDist = round(setup.va2p*4) ;               % target distance from center
setup.beforeWait = [0.5 1];

setup.overallrewfeedbacktime = 0.5 ;                 % after which it comes on
setup.BannerDisTime = 1.5 ;
setup.rewardpoint2Money = 10 ;
setup.rewardFBwhenNoFB = 5 ;                         % interval in which to show reward FB when FB is off

% Square/Triangle parameter
setup.targetColor(1,:) = [255 -128 -128] ; % red
setup.targetColor(2,:) = [255 -128 -128] ; % red
setup.targetColor(3,:) = [-128 -128 255] ; % blue
setup.targetColor(4,:) = [-128 -128 255] ; % blue

% keyboard setup
KbName('UnifyKeyNames') ;
setup.leftKey = KbName('LeftArrow') ;                % left choice
setup.rightKey = KbName('RightArrow') ;              % right choice
setup.gKey = KbName('g') ;                           % go key

% fixation cross setup
setup.bigSize = 15 ; % outer rectangle?
setup.smallSize = 5 ; % inner rectangle?

% reward feedback location
setup.rewCoords = [-90 180] ;
setup.banCoords = [-90 120] ;
    
end

