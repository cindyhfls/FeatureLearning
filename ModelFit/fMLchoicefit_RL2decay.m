function loglikehood = fMLchoicefit_RL2decay(xpar, sesdata)
%
% DESCRIPTION: fits data to RL(2) model using ML method
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
NparamBasic = 4 ;

nChops = sesdata.nChops ;

BiasL = xpar(1) ;
magColor = xpar(2) ;
magShape = xpar(3) ;

xpar([NparamBasic:NparamBasic+sesdata.Nalpha*nChops])=1./(1+exp(-(xpar([NparamBasic:NparamBasic+sesdata.Nalpha*nChops]))./sesdata.sig) ) ;
decay = xpar(4) ;
alpha_rewColor = xpar([NparamBasic+1:NparamBasic+nChops]) ;
alpha_rewShape = xpar([NparamBasic+1+nChops:NparamBasic+2*nChops]) ;
if sesdata.flagUnr==1
    alpha_unrColor = xpar([NparamBasic+1+2*nChops:NparamBasic+3*nChops]) ;
    alpha_unrShape = xpar([NparamBasic+1+3*nChops:NparamBasic+4*nChops]) ;
else
    alpha_unrColor = alpha_rewColor ;
    alpha_unrShape = alpha_rewShape ;
end

shapeMap        = sesdata.expr.shapeMap ;
colorMap        = sesdata.expr.colorMap ;
inputTarget     = sesdata.input.inputTarget ;
ntrials         = sesdata.trials ;
correcttrials   = sesdata.results.reward ;
choicetrials    = sesdata.results.choice ;
flag_couple     = sesdata.flag_couple ;
flag_updatesim  = sesdata.flag_updatesim ;

cntChopShape = sesdata.cntChopShape ;
cntChopColor = sesdata.cntChopColor ;

v = (0.5*ones(4,1)) ; 
for cnt_trial=ntrials
    
    correct = correcttrials(cnt_trial) ;
    choice = choicetrials(cnt_trial) ; 
    
    cnt_ChopColor = cntChopShape(cnt_trial) ;
    cnt_ChopShape = cntChopColor(cnt_trial) ;
    
    idx_shape(2) = shapeMap(inputTarget(2, cnt_trial)) ;
    idx_color(2) = colorMap(inputTarget(2, cnt_trial)) ;
    idx_shape(1) = shapeMap(inputTarget(1, cnt_trial)) ;
    idx_color(1) = colorMap(inputTarget(1, cnt_trial)) ;
    
    pChoiceR = 1./(1+exp(-( magShape*(v(idx_shape(2))-v(idx_shape(1))) + magColor*(v(idx_color(2))-v(idx_color(1))) + BiasL ) )) ;
    pChoiceL = 1-pChoiceR ;
    if cnt_trial >= 1  
        if choice == 2 
            loglikehood = loglikehood - log(pChoiceR) ;
        else
            loglikehood = loglikehood - log(pChoiceL) ; 
        end                      
    end
    
    if correct
        idxC = idx_color(choice) ;
        idxW = idx_color(3-choice) ;
        v = decayV(v, find([1 2]~=idx_color(choice)), decay) ;
        [idxW, idxC] = idxcouple(idxW, idxC, correct, flag_couple, flag_updatesim) ;
        v = update(v, idxC, idxW, alpha_rewColor(cnt_ChopColor)) ;

        idxC = idx_shape(choice) ;
        idxW = idx_shape(3-choice) ;
        v = decayV(v, 2+find([3 4]~=idx_shape(choice)), decay) ;
        [idxW, idxC] = idxcouple(idxW, idxC, correct, flag_couple, flag_updatesim) ;
        v = update(v, idxC, idxW, alpha_rewShape(cnt_ChopShape)) ;
    else
        idxW = idx_color(choice) ;
        idxC = idx_color(3-choice) ;
        v = decayV(v, find([1 2]~=idx_color(choice)), decay) ;
        [idxW, idxC] = idxcouple(idxW, idxC, correct, flag_couple, flag_updatesim) ;
        v = update(v, idxC, idxW, alpha_unrColor(cnt_ChopColor)) ;

        idxW = idx_shape(choice) ;
        idxC = idx_shape(3-choice) ;
        v = decayV(v, 2+find([3 4]~=idx_shape(choice)), decay) ;
        [idxW, idxC] = idxcouple(idxW, idxC, correct, flag_couple, flag_updatesim) ;
        v = update(v, idxC, idxW, alpha_unrShape(cnt_ChopShape)) ;
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
    if isempty(idxW) && ~isempty(idxC)
        v(idxC) = v(idxC) + (1-v(idxC)).*Q ;
    elseif isempty(idxC) && ~isempty(idxW)
        v(idxW) = v(idxW) - (v(idxW).*Q) ;
    elseif ~isempty(idxW) && ~isempty(idxC)
        v(idxC) = v(idxC) + (1-v(idxC)).*Q ;
        v(idxW) = v(idxW) - (v(idxW).*Q) ;
    elseif isempty(idxW) && isempty(idxC)
    end
end

function [idxW, idxC] = idxcouple(idxW, idxC, rl2_correct, flag_couple, flag_updatesim)
    if rl2_correct
        if flag_couple==0
            idxW = [] ;
        elseif flag_couple==1
            if idxW==idxC                                                  % to avoid potentiating and depressing similar V in coupled cases
                idxW= [] ;
                if ~flag_updatesim
                    idxC = [] ;
                end
            end
        end
    else
        if flag_couple==0
            idxC = [] ;
        elseif flag_couple==1
            if idxW==idxC                                                  % to avoid potentiating and depressing similar V in coupled cases
                idxC= [] ;
                if ~flag_updatesim
                    idxW = [] ;
                end
            end
        end
    end
end