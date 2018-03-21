function a = KeyCapture()

global setup continuing pauseexp

KbName('UnifyKeyNames')
gokey = KbName('RightArrow');
stopkey=KbName('ESCAPE');
pausekey = KbName('P');
reward=KbName('space');
lessjuice = KbName('DownArrow');
morejuice = KbName('UpArrow');

[keyIsDown,~,keyCode] = KbCheck;
if keyCode(stopkey)
    a = -1;
    continuing = 0;
elseif keyCode(gokey)
    a = 1;
    pauseexp = 0;
elseif keyCode(reward)
    a = 2;
    reward_digital_Juicer1(setup.manualjuiceamount);
elseif keyCode(pausekey)
    a = 3;
    pauseexp = 1;
elseif keyCode(lessjuice)
    a = 4;
    setup.rewardjuiceamount = setup.rewardjuiceamount*.8;
elseif keyCode(morejuice)
    a= 5;
    setup.rewardjuiceamount = setup.rewardjuiceamount*1.2;
else
    a = 0;
end

while keyIsDown
    [keyIsDown,~,keyCode] = KbCheck; % Not sure whether we need this
end

% pressedKey = KbName (find(keyCode))  % for debug purposes
% fprintf('\n Key %s was pressed \n', pressedKey);


end