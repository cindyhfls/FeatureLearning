function loglikehood = fMLchoiceLL_RL2conjdecay(xpar, sesdata)
%
% DESCRIPTION: fits data to RL(2)conj model using ML method
%
% INPUT: 
% sesdata structure which includes input, experiment and behavioral data
%
% OUTPUT:
% fitted parametres
%
% Version History:
% 0.1:  [2015-09-13]

loglikehood = 0 ;
NparamBasic = 3 ;

nChops = sesdata.nChops ;

BiasL = xpar(1) ;
mag = xpar(2) ;

% xpar([NparamBasic:NparamBasic+sesdata.Nalpha*nChops])=1./(1+exp(-(xpar([NparamBasic:NparamBasic+sesdata.Nalpha*nChops]))./sesdata.sig) ) ;
decay = xpar(3) ;
alpha_rew = xpar([NparamBasic+1:NparamBasic+nChops]) ;
if sesdata.flagUnr==1
    alpha_unr = xpar([NparamBasic+1+nChops:NparamBasic+2*nChops]) ;
else
    alpha_unr = alpha_rew ;
end

shapeMap        = sesdata.expr.shapeMap ;
colorMap        = sesdata.expr.colorMap ;
inputTarget     = sesdata.input.inputTarget ;
ntrials         = sesdata.trials ;
correcttrials   = sesdata.results.reward ;
choicetrials    = sesdata.results.choice ;
flag_couple     = sesdata.flag_couple ;

cntChop = sesdata.cntChop ;

v = (0.5*ones(4,1)) ; 
for cnt_trial=ntrials
    
    correct = correcttrials(cnt_trial) ;
    choice = choicetrials(cnt_trial) ; 
    
    cnt_Chop = cntChop(cnt_trial) ;
    
    idx_shape(2) = shapeMap(inputTarget(2, cnt_trial)) ;
    idx_color(2) = colorMap(inputTarget(2, cnt_trial)) ;
    idx_shape(1) = shapeMap(inputTarget(1, cnt_trial)) ;
    idx_color(1) = colorMap(inputTarget(1, cnt_trial)) ;
    
    pChoiceR = 1./(1+exp(-( mag*(v(inputTarget(2, cnt_trial))-v(inputTarget(1, cnt_trial))) + BiasL ) )) ;
    pChoiceL = 1-pChoiceR ;
    if cnt_trial >= 1  
        if choice == 2 
            loglikehood(cnt_trial) =  - log(pChoiceR) ;
        else 
            loglikehood(cnt_trial) =  - log(pChoiceL) ; 
        end                     
    end
    
    if correct
        idxC = inputTarget(choice, cnt_trial) ;
        idxW = inputTarget(3-choice, cnt_trial) ;
        v = decayV(v, find([1 2 3 4]~=inputTarget(choice, cnt_trial)), decay) ;
        [idxW, idxC] = idxcouple(idxW, idxC, correct, flag_couple) ;
        v = update(v, idxC, idxW, alpha_rew(cnt_Chop)) ;
    else
        idxC = inputTarget(3-choice, cnt_trial) ;
        idxW = inputTarget(choice, cnt_trial) ;
        v = decayV(v, find([1 2 3 4]~=inputTarget(choice, cnt_trial)), decay) ;
        [idxW, idxC] = idxcouple(idxW, idxC, correct, flag_couple) ;
        v = update(v, idxC, idxW, alpha_unr(cnt_Chop)) ;
    end
    V(:,cnt_trial) = v ;
    
end
end

% function v = decayV(v, unCh, decay)
%     v(unCh) = v(unCh)*(1-decay) ;
% end
function v = decayV(v, unCh, decay)
    v(unCh) = v(unCh) - (v(unCh)-0.5)*(decay) ;
end

function v = update(v, idxC, idxW, Q)
    if isempty(idxW)
        v(idxC) = v(idxC) + (1-v(idxC)).*Q ;
    elseif isempty(idxC)
        v(idxW) = v(idxW) - (v(idxW).*Q) ;
    elseif ~isempty(idxW) && ~isempty(idxC)
        v(idxC) = v(idxC) + (1-v(idxC)).*Q ;
        v(idxW) = v(idxW) - (v(idxW).*Q) ;
    end
end

function [idxW, idxC] = idxcouple(idxW, idxC, rl2_correct, flag_couple)
    if rl2_correct
        if flag_couple==0
            idxW = [] ;
        end
    else
        if flag_couple==0
            idxC = [] ;
        end
    end
end