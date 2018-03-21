function input = fGenerateInput(expr)
%
% DESCRIPTION: Generates input for expreriment; 4 schedules and 6 total
% combinations 
%
% INPUT: 
% expr structure which includes number of short/long blocks, number
% of trials, and probabilities
%
% OUTPUT:
% inputSide: side which reward is assigned
% inputCombination: input combinations
%
% Version History:
% 1.1:  [2015-09-13]

% generate input
inputRewardR = [] ;
inputRewardL = [] ;
inputTargetR = [] ;
inputTargetL = [] ;
inputCombination = [] ;
Nschedule_blocksShortAll = [] ;
choiceMapL = expr.choiceMap(1, :) ;
choiceMapR = expr.choiceMap(2, :) ;
for cnt_NblocksLong = 1:expr.NblocksLong
    for cnt_NblocksShort = 1:expr.NblocksShort
        % schedule
        Nblock = (cnt_NblocksLong-1)*expr.NblocksShort + cnt_NblocksShort ;
        Nschedule = expr.ScheduleSeq{expr.transitionStart}(Nblock) ;
        Nschedule_blocksShortAll = [Nschedule_blocksShortAll Nschedule*ones(1,expr.NtrialsShort)] ;
        % repeat combinations sudo-randomly
        inputCombination_blocksShort = [] ;
        for cnt_sudo = 1:expr.NtrialsShort/expr.Ncombinations
            inputCombination_blocksShort = [inputCombination_blocksShort randperm(expr.Ncombinations)] ;
        end
        
        inputTargetR_blocksShort = choiceMapR(inputCombination_blocksShort) ;
        inputTargetL_blocksShort = choiceMapL(inputCombination_blocksShort) ;
        for cnt_Ncombinations = 1:4 % 4 possible objects set reward
            idxR_Ncombinations = find(inputTargetR_blocksShort==cnt_Ncombinations) ; % E.g. in this block, RS appears 5 times
            NR_Ncombinations = length(idxR_Ncombinations) ; % then this vector will be 5
            Nprob_NcombinationsR = round(expr.prob(Nschedule, cnt_Ncombinations)*length(idxR_Ncombinations)) ;
            SideR = [ones(1, Nprob_NcombinationsR) zeros(1, NR_Ncombinations-Nprob_NcombinationsR)] ;
            
            idxL_Ncombinations = find(inputTargetL_blocksShort==cnt_Ncombinations) ;
            NL_Ncombinations = length(idxL_Ncombinations) ;
            Nprob_NcombinationsL = round(expr.prob(Nschedule, cnt_Ncombinations)*length(idxL_Ncombinations)) ; 
            SideL = [ones(1, Nprob_NcombinationsL) zeros(1, NL_Ncombinations-Nprob_NcombinationsL)] ;
            
            % Above: looks like they are generating the 1 and 0 s from
            % absolute assignment instead of binomial distribution it
            % actually make more sense to use a binomial distribution I
            % think. Consider using the binornd function.
            
            for cnt_corr = 1:50 % generate a bunch and choose the least correlated one
                inputSideR_blocksShort(idxR_Ncombinations, cnt_corr) = SideR(randperm(NR_Ncombinations)) ;
                inputSideL_blocksShort(idxL_Ncombinations, cnt_corr) = SideL(randperm(NL_Ncombinations)) ;
            end
        end
        corr_blocksShort = abs(corr(inputSideR_blocksShort, inputSideL_blocksShort)) ;
        [idx_corrR idx_corrL] = find(corr_blocksShort==min(corr_blocksShort(:))) ;
        idx_rand = randi(length(idx_corrR)) ;
        
        inputRewardR = [inputRewardR; inputSideR_blocksShort(:,idx_corrR(idx_rand))] ;
        inputRewardL = [inputRewardL; inputSideL_blocksShort(:,idx_corrL(idx_rand))] ;
        inputCombination = [inputCombination inputCombination_blocksShort] ;
        inputTargetR = [inputTargetR inputTargetR_blocksShort] ;
        inputTargetL = [inputTargetL inputTargetL_blocksShort] ;
    end
end
input.inputReward = [inputRewardL inputRewardR]'  ;
input.inputCombination = inputCombination ;
input.inputTarget = [inputTargetL; inputTargetR] ;
input.Nschedule_blocksShortAll = Nschedule_blocksShortAll ;
input.probTarget = cell2mat(arrayfun(@(i)[expr.prob(input.Nschedule_blocksShortAll(i),input.inputTarget(:,i))]',...
    1:length(input.inputReward),'UniformOutput',false)); % add in probability
[~,input.betterchoice]= max(input.probTarget,[],1); % left/right is better


