function DrawSimpleTargets(w,trNo,myinput,setup,coords,varargin)

drawleft = 1; drawright = 1;
if ~isempty(varargin)
    if varargin{1}== 1
        drawleft = 1; drawright = 0;
    elseif varargin{1} == 2
        drawleft = 0; drawright = 1;
    end
end
if drawleft == 1
    switch myinput.inputTarget(1, trNo) % left target
        case 2
            Screen('FillPoly',w,setup.targetColor(myinput.inputTarget(1, trNo),:),coords.diamondL,1);
        case 1
            Screen('FillRect',w,setup.targetColor(myinput.inputTarget(1, trNo),:),coords.targRect(1,:));
        case 4
            Screen('FillPoly',w,setup.targetColor(myinput.inputTarget(1, trNo),:),coords.diamondL,1);
        case 3
            Screen('FillRect',w,setup.targetColor(myinput.inputTarget(1, trNo),:),coords.targRect(1,:));
    end
end
if drawright == 1
    switch myinput.inputTarget(2, trNo)  % right target
        case 2
            Screen('FillPoly',w,setup.targetColor(myinput.inputTarget(2, trNo),:),coords.diamondR,1);
        case 1
            Screen('FillRect',w,setup.targetColor(myinput.inputTarget(2, trNo),:),coords.targRect(2,:));
        case 4
            Screen('FillPoly',w,setup.targetColor(myinput.inputTarget(2, trNo),:),coords.diamondR,1);
        case 3
            Screen('FillRect',w,setup.targetColor(myinput.inputTarget(2, trNo),:),coords.targRect(2,:));
    end
end

end