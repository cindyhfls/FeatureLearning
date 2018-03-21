
clc
clear
close all
rng('shuffle')
randstate = clock ;

%%

subjects = {...
    'za01', 'la01', 'da01', 'ja01', 'ca01', 'ha01', 'ea01'...
    'aa01', 'aa02', 'ba01', 'ba02', 'zz01', 'zz02', ...
    'zw01', 'zw02', 'ma01', 'ma02', 'ka01', 'ka02', ...
    'zu01', 'zu02', ...
    'ia01', 'ia02', 'zy01', 'zy02', 'ga01', 'ga02', ...
    'fa01', 'fa02', 'zq01', 'zq02', 'zr01', 'zr02', ...
    'zn01', 'zn02', 'na01', 'na02', 'zo01', 'zo02', ...
    'oa01', 'oa02', 'zv01', 'zv02', 'pa01', 'pa02', ...
    'zp01', 'zp02', 'ra01', 'ra02', 'qa01', 'qa02', ...
    'ta01', 'ta02', 'ua01', 'ua02', 'sa01', 'sa02', ...
    'zm01', 'zm02', 'xa01', 'xa02', 'zg01', 'zg02', ...
    'zx01', 'zx02', 'zj01', 'zj02', 'zk01', 'zk02', ...
    'va01', 'va02', 'wa01', 'wa02', 'zh01', 'zh02', ...
    'cb01', 'cb02', 'ya01', 'ya02', 'bb01', 'bb02', ...
    'ab01', 'ab02', 'zt01', 'zt02', 'zc01', 'zc02', ...
    'eb01', 'eb02', ...
    'ca02', 'ha02', 'da02', 'ja02', 'ea02', 'la02', ...
    'zs01', 'ze01', 'zf01', 'zd01', 'zl01'} ;

nrep        = 5 ; 
randstate   = clock ;

op          = optimset;
sesdata.flagUnr = 1 ;

%%
for cnt_sbj = 1:length(subjects)
    
    if cnt_sbj<22
        inputname   = ['/Users/shiva/Dropbox (CCNL-Dartmouth)/MdPRL/Experiments/PRLexp/inputs/input_', subjects{cnt_sbj} , '.mat'] ;
        resultsname = ['/Users/shiva/Dropbox (CCNL-Dartmouth)/MdPRL/Experiments/PRLexp/SubjectData/PRL_', subjects{cnt_sbj} , '.mat'] ;
    else
        inputname   = ['/Users/shiva/Dropbox (CCNL-Dartmouth)/MdPRL/Experiments/PRLexpv2/inputs/input_', subjects{cnt_sbj} , '.mat'] ;
        resultsname = ['/Users/shiva/Dropbox (CCNL-Dartmouth)/MdPRL/Experiments/PRLexpv2/SubjectData/PRL_', subjects{cnt_sbj} , '.mat'] ;
    end
    
    load(inputname)
    load(resultsname)

    sesdata.nChops = 1 ;
    sesdata.sig = 0.2 ;

    %%
    sch_colorMap = ( mean(expr.prob(:, [1 2]),2)>mean(expr.prob(:, [3 4]),2) ) + 1 ;
    sch_shapeMap = 2 - (mean(expr.prob(:, [1 3]),2)>mean(expr.prob(:, [2 4]),2)) ;
    sesdata.Nschedule(1,:) = sch_colorMap(input.Nschedule_blocksShortAll) ;
    sesdata.Nschedule(2,:) = sch_shapeMap(input.Nschedule_blocksShortAll) ;

    revColor = [0; find(diff(sch_colorMap(input.Nschedule_blocksShortAll))); length(input.Nschedule_blocksShortAll)] ;
    revShape = [0; find(diff(sch_shapeMap(input.Nschedule_blocksShortAll))); length(input.Nschedule_blocksShortAll)] ;
    rev = sort(unique([revColor; revShape]), 'ascend') ;
    for cnt_rev = 1:length(revColor)-1
        N = 1:revColor(cnt_rev+1)-(revColor(cnt_rev)) ;
        sesdata.revCountColor(revColor(cnt_rev)+1:revColor(cnt_rev+1))  = 1:N ;
        sesdata.cntChopColor(revColor(cnt_rev)+1:revColor(cnt_rev+1))   = ceil([1:N]./(N/sesdata.nChops)) ;
    end
    for cnt_rev = 1:length(revShape)-1
        N = revShape(cnt_rev+1)-(revShape(cnt_rev)) ;
        sesdata.revCountShape(revShape(cnt_rev)+1:revShape(cnt_rev+1))  = 1:N ;
        sesdata.cntChopShape(revShape(cnt_rev)+1:revShape(cnt_rev+1))   = ceil([1:N]./(N/sesdata.nChops)) ;
    end
    for cnt_rev = 1:length(rev)-1
        N = rev(cnt_rev+1)-(rev(cnt_rev)) ;
        sesdata.revCount(rev(cnt_rev)+1:rev(cnt_rev+1)) = 1:N ;
        sesdata.cntChop(rev(cnt_rev)+1:rev(cnt_rev+1))  = ceil([1:N]./(N/sesdata.nChops)) ;
    end

    sesdata.input   = input ;
    sesdata.expr    = expr ;
    sesdata.results = results ;
    sesdata.trials  = [1:768] ;
    
    fvalminRL2_couple           = length(sesdata.results.reward) ;
    fvalminRL2_coupleupdatesim  = length(sesdata.results.reward) ;
    fvalminRL2_uncouple         = length(sesdata.results.reward) ;
    fvalminRL2_decay            = length(sesdata.results.reward) ;
    fvalminRL2conj_couple       = length(sesdata.results.reward) ;
    fvalminRL2conj_uncouple     = length(sesdata.results.reward) ;
    fvalminRL2conj_decay        = length(sesdata.results.reward) ;

    for cnt_rep = 1:nrep
        disp(['----------------------------------------------'])
        disp(['Subject: ', num2str(cnt_sbj),', Repeat: ', num2str(cnt_rep)])

        %% RL2 coupled
        sesdata.flag_couple = 1 ;
        sesdata.flag_updatesim = 0 ;
        NparamBasic = 3 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2v2, ipar, op, sesdata) ;
        if fval <= fvalminRL2_couple
            xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2_couple = fval ;
            mlparRL2_couple{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2_couple{cnt_sbj}(100) = fval ;
            mlparRL2_couple{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2_couple{cnt_sbj}(102) = output.iterations;
            mlparRL2_couple{cnt_sbj}(103) = exitflag ;
        end

        %% RL2 coupled, update similar features
        sesdata.flag_couple = 1 ;
        sesdata.flag_updatesim = 1 ;
        NparamBasic = 3 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2v2, ipar, op, sesdata) ;
        if fval <= fvalminRL2_coupleupdatesim
            xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2_coupleupdatesim = fval ;
            mlparRL2_coupleupdatesim{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2_coupleupdatesim{cnt_sbj}(100) = fval ;
            mlparRL2_coupleupdatesim{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2_coupleupdatesim{cnt_sbj}(102) = output.iterations;
            mlparRL2_coupleupdatesim{cnt_sbj}(103) = exitflag ;
        end

        %% RL2 uncoupled
        sesdata.flag_couple = 0 ;
        sesdata.flag_updatesim = 0 ;
        NparamBasic = 3 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2v2, ipar, op, sesdata) ;
        if fval <= fvalminRL2_uncouple
            xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2_uncouple = fval ;
            mlparRL2_uncouple{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2_uncouple{cnt_sbj}(100) = fval ;
            mlparRL2_uncouple{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2_uncouple{cnt_sbj}(102) = output.iterations;
            mlparRL2_uncouple{cnt_sbj}(103) = exitflag ;
        end
        
        %% RL2 decay
        sesdata.flag_couple = 0 ;
        sesdata.flag_updatesim = 0 ;
        NparamBasic = 4 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2decayv2, ipar, op, sesdata) ;
        if fval <= fvalminRL2_decay
            xpar([NparamBasic:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2_decay = fval ;
            mlparRL2_decay{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2_decay{cnt_sbj}(100) = fval ;
            mlparRL2_decay{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2_decay{cnt_sbj}(102) = output.iterations;
            mlparRL2_decay{cnt_sbj}(103) = exitflag ;
        end

        %% RL2 conjunction coupled
        sesdata.flag_couple = 1 ;
        NparamBasic = 2 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2conj, ipar, op, sesdata) ;
        if fval <= fvalminRL2conj_couple
            xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2conj_couple = fval ;
            mlparRL2conj_couple{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2conj_couple{cnt_sbj}(100) = fval ;
            mlparRL2conj_couple{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2conj_couple{cnt_sbj}(102) = output.iterations;
            mlparRL2conj_couple{cnt_sbj}(103) = exitflag ;
        end

        %% RL2 conjunction uncoupled
        sesdata.flag_couple = 0 ;
        NparamBasic = 2 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2conj, ipar, op, sesdata) ;
        if fval <= fvalminRL2conj_uncouple
            xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic+1:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2conj_uncouple = fval ;
            mlparRL2conj_uncouple{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2conj_uncouple{cnt_sbj}(100) = fval ;
            mlparRL2conj_uncouple{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2conj_uncouple{cnt_sbj}(102) = output.iterations;
            mlparRL2conj_uncouple{cnt_sbj}(103) = exitflag ;
        end
        
        %% RL2 conjunction decay
        sesdata.flag_couple = 0 ;
        NparamBasic = 3 ;
        if sesdata.flagUnr==1
            sesdata.Nalpha = 2 ;
        else
            sesdata.Nalpha = 1 ;
        end
        ipar= 0.1*[rand(1,NparamBasic+sesdata.Nalpha*sesdata.nChops)]  ;
        [xpar fval exitflag output] = fminsearch(@fMLchoicefit_RL2conjdecay, ipar, op, sesdata) ;
        if fval <= fvalminRL2conj_decay
            xpar([NparamBasic:NparamBasic+sesdata.Nalpha*sesdata.nChops])=1./(1+exp(-(xpar([NparamBasic:NparamBasic+sesdata.Nalpha*sesdata.nChops]))./sesdata.sig) ) ;
            fvalminRL2conj_decay = fval ;
            mlparRL2conj_decay{cnt_sbj}(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)= (xpar(1:NparamBasic+sesdata.Nalpha*sesdata.nChops)) ;
            mlparRL2conj_decay{cnt_sbj}(100) = fval ;
            mlparRL2conj_decay{cnt_sbj}(101) = fval./length(sesdata.results.reward) ;
            mlparRL2conj_decay{cnt_sbj}(102) = output.iterations;
            mlparRL2conj_decay{cnt_sbj}(103) = exitflag ;
        end
    end
end

save ../files/RPL2Analysisv2


