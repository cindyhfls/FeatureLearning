% KeyCapture obtains keyboard interaction
%% Change the rule

function runPRLexp1_2(subName, flagModel, sessionNum)
sca % close screen
clear
clc
close all

filepath = fileparts( which( mfilename ) );
cd(filepath)

% Add all files in the umbrella
cd '..'
% Get the name of current directory
cur_path = pwd; % current directory
% cur_path = fileparts( which( mfilename ) );
addpath(genpath(fullfile(cur_path,'General'))); % add everything in the mother folder
addpath(genpath(fullfile(cur_path,'Exp1-2'))); % add everything in the mother folder

global setup continuing pauseexp

% Set up the default environment for the rig (change the parameters)
if exist('./Environment/RigEnvSpecifications.mat','file')
    load('./Environment/RigEnvSpecifications.mat','env');
else
    run('./General/defaultEnv.m'); % creates a local variable for rig specifications
    % change directory
    cd './Exp1-2'
    save ('./Environment/RigEnvSpecifications.mat','env');
end

DataDir = 'E:/Data/FeatureObjectLearning/Exp1-2'; %./SubjectData
%% function input check
if nargin < 1
    subName = input('Initials of subject? [tmp]  ','s');                   % get subject's initials from user
end
if nargin < 2
    flagModel = input('Experiment? [1] , 2 ');
end
if nargin <3
    sessionNum = input('Session? [1] ','s');
end
flagExp = input('Type? [1] , 2 '); % color/shape volatile

% default inputs
if isempty(subName)
    subName = 'tmp';
end
if isempty(flagModel) || ~(flagModel==1 || flagModel==2)
    flagModel = 1 ;
end
if isempty(sessionNum)
    sessionNum = '1';
end
if isempty(flagExp) || ~(flagExp==1 || flagExp==2)
    flagExp = 1 ;
end
transitionStart = 1 ;

%% Generate input parameters
gi = input('Load input file? [Y/N]','s');
if strcmp((gi),'y')    
    uiimport % if it says no, manually load an input file which is
    trNo = input(['Start from which trial [out of ',num2str(expr.Ntrialstot),']? ']);
    [responsetime,repeat,choice,reward,betterchoice] = deal(NaN(trNo,1));
else %otherwise just generate a new set
    [expr,setup,myinput] = fGenerateInputIndividual(subName, transitionStart, flagExp, flagModel,sessionNum); % This is a helper function
    trNo = 1;
%     [responsetime,repeat,choice,reward,betterchoice] = deal(NaN(expr.Ntrialstot,1));
    % This is an umbrella that contains several functions
    % fPRL2initSetup contains all the device setup/keyboard/feedback etc.
    % fPRL2initExp contains all the experimental condition/reward schedule for
    % % fGenerateInput takes the experimental conditions and
    % The whole function fGenerateInputIndividual saves the input setting in a .mat file
    % which is loaded below (why don't they just output it as a structure???)
    % which contains 3 structures: expr, setup, myinput (it was input but I
    % changed it because it conflicts with the built-in function);
end
%% Initialize Eyelink and juicer
if strcmp(setup.devicename,'eye')
    if ~Eyelink('IsConnected')
        Eyelink('initialize'); %Connects to eyelink
    end
    Eyelink('startrecording');
    reward_digital_Juicer1(.1); % test juicer, see if a click sound is heard
end
%% ###### Start Experiment #########
totalreward  = 0  ; 
results.startTime = datetime('now');
fprintf('Experiment started at %s\n',datestr(results.startTime));
try % debug
    %% Open up a screen
    [w,coords] = setupscreen(env,setup);
    fEyelinkSetup(setup,coords);
    %% Begin Experiment
    vbl = GstartCheck(w,setup); % function that checks if the G key is pressed to manually start experiment
    SessionStartTime = GetSecs;
    
    continuing = 1; pauseexp = 0;
    while continuing == 1 % progress through trial
        % Original code: pause in the middle before continuing, changed to
        % pause every superblock (aka interdimensional shift)
        %         if trNo==expr.Ntrialstot/2
        iStage = 1;
        while iStage<6 && continuing == 1
            switch iStage
                case 1
                    %% obtain center fixation
                    [vbl] = obtain_fixation(w,trNo,setup,coords);
                case 2
                    [responsetime(trNo,1),choice(trNo,1),repeat(trNo,1),betterchoice(trNo,1)] = target_presentation(w,trNo,myinput,setup,coords);
                case 3
                    %% present choice (visual circling for the chosen object)
                      choicePresentation(w,trNo,choice(trNo,1),setup,myinput,coords);
                case 4
                    %% present reward feedback
                    [reward(trNo,1),totalreward]=rewardPresentation(w,trNo,vbl,myinput,setup,coords,totalreward,choice(trNo,1));
                case 5
                    %% compensate for RT
                    RTcompensation(w,responsetime(trNo,1));
            end            
            KeyCapture();% keyboard interaction at the end of each stage (and also during eye fixation)
            if pauseexp == 1
                fprintf('Experiment paused, press RIGHT ARROW to continue...\n');
                while pauseexp == 1
                Screen('FillRect',w,0); % blank screen
                vbl = Screen('Flip', w);
                KeyCapture();
                end
            else
                iStage = iStage+1; % repeat the stage if the experiment is paused
            end
        end
        %% End-of-session
        if continuing == 0  %whenever stops manually/end of experiment save the results
            results.runTime = (GetSecs-SessionStartTime)/60; % in minutes
            results.endTime = datetime('now');
            fprintf('Experiment ended at %s\n',datestr(results.endTime));
            save([DataDir,'/PRL_',subName,'_', datestr(now,'yyyymmdd'),'_00',sessionNum,'.mat'],'expr','myinput','setup','coords','-append');
            % I think this appends the results to the already existing
            % experimental condition section .mat file
            %% Finish Experiment
            getfileclean; % remove the eyelink settings
            sca
            ListenChar(1); % listen for keyboard input
            ShowCursor; % show mouse
            fprintf('The total number of trial complete:  %i \n',trNo);
            fprintf('Total time (mins) taken for this session: %4.2f \n',results.runTime);
            fprintf('The total reward obtained:  %i \n\n',totalreward);
        end
        %% Save the behavioural output as a structure every trial in case subject aborts
        results.choice = choice ; % subjects choice (1-left, 2-right)
        results.reward = reward ; % reward responses
        results.betterchoice = betterchoice; % whether this is the "correct" response
        results.responsetime = responsetime ;
        save([DataDir,'/PRL_',subName,'_', datestr(now,'yyyymmdd'),'_00',sessionNum,'.mat'],'results','-append');
        %% Broadcasting result
        if continuing == 1 && pauseexp == 0 % don't broadcast if stopped or paused
        schedule = myinput.Nschedule_blocksShortAll(trNo);
        fprintf('Trial # %i: RULE ''%s'', BEST *%s*,Prob L: %2.1f / R:%2.1f. ',trNo,expr.schedulestring{schedule},expr.bestTarget{schedule},[myinput.probTarget(:,trNo)]);
        fprintf('The ChosenProb was %s : %2.1f .',expr.sidestring{choice(trNo)},myinput.probTarget(choice(trNo),trNo));
        if reward(trNo)==1 
            fprintf('REWARDED =] ');
        else
            fprintf('UNREWARDED =[ ');
        end
        if myinput.betterchoice(trNo) == choice(trNo)
            fprintf('BETTER OPTION + \n');
        else
            fprintf('WORSE OPTION - \n');
        end
        fprintf('Cumulative Performance = %2.1f %% \n\n',sum(results.betterchoice)/numel(results.betterchoice)*100)
        trNo = trNo+1; % proceed to the next trial
        end
        %% trial end check points
        if mod(trNo,expr.NtrialsShort)==0 % report performance every block
            fprintf('The total reward obtained in this block is %i \n',totalreward);
            totalreward =0;
        end      
        if trNo> expr.Ntrialstot % stop task at the end of trial (no more input available)
            continuing = 0;
            fprintf('No more input available. Start another session.');
        end          
        if mod(trNo,expr.NtrialsLong) == 0 % pause task at the end of each superblock
            vbl = GstartCheck(w,setup);        
        end
    end % end of the while loop of whole trial    
catch err
    % Save the results even when an error is catched
    results.runTime = (GetSecs-SessionStartTime)/60; % in minutes
    results.endTime = datetime('now');
    fprintf('Experiment ended at %s\n',datestr(results.endTime));
    results.choice = choice ;                                          % subjects choice (1-left, 2-right)
    results.reward = reward ; % reward responses
    results.betterchoice = betterchoice; % if no choice is made it will throw an error when stopped
    results.responsetime = responsetime ;
    save([DataDir,'/PRL_',subName,'_', datestr(now,'yyyymmdd'),'_00',sessionNum,'.mat'],'results','coords','expr','myinput','setup','-append');
    %% Finish Experiment    
    fprintf('The total number of trial complete:  %i \n',trNo);
    fprintf('Total time (mins) taken for this session: %4.2f \n',results.runTime);
    fprintf('The total reward obtained:  %i \n\n',totalreward);
    % automatically close screen if something goes wrong
    sca %close screen
    getfileclean;
    ListenChar(1);
    ShowCursor; % show mouse
    save('error.mat');                               % save the whole workspace to work on error
    fprintf('Something went wrong.\n')
    rethrow(err);
end

% utility functions
    function RTcompensation(w,thisresponsetime) 
        tStart = GetSecs;
        tpresent = tStart ;
        while tpresent<tStart+(2-thisresponsetime)
            % make each trial is at least 2 seconds by increasing ITI
%             drawFixationObj(w,setup.centerFeedback,coords,'dot')
            vbl = Screen('Flip', w);
            tpresent = vbl ;
        end
    end
end

