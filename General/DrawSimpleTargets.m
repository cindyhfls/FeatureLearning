function DrawSimpleTargets(w,trNo,myinput,setup,coords)
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
switch myinput.inputTarget(2, trNo) % right target
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