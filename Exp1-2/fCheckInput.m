function inputcheck = fCheckInput(expr, input)
%
% DESCRIPTION: checks probablities and sudo randomness of input
% combinations
%
% INPUT: 
% expr structure which includes number of trials for short and long blocks
% and input structure in check 
%
% OUTPUT:
% inputSide: resluts for checking probablities and sudo randomness of
% combinations
%
% Version History:
% 1.1:  [2015-09-13]

% double check input
sudorandom = mean(sort(reshape(input.inputCombination, 12, [])),2) ;       % should be 1:12
inputcheck.inputCombination = mean(sudorandom==[1:12]')==1 ;
inputcheck.corr = corr(input.inputReward(1,:)', input.inputReward(2,:)') ;

for cnt_RL = 1:2
    inputSide = input.inputReward(cnt_RL,:) ;
    inputCombination = input.inputTarget(cnt_RL,:) ; 

    alignedinputSide = reshape(inputSide, expr.NblocksLong*expr.NtrialsLong, []) ;
    alignedinputSide_Long0 = alignedinputSide(1:expr.NtrialsLong, :) ;
    alignedinputSide_Long1 = alignedinputSide(1+expr.NtrialsLong:2*expr.NtrialsLong, :) ;
    alignedinputSide_Long2 = alignedinputSide(1+2*expr.NtrialsLong:3*expr.NtrialsLong, :) ;
    alignedinputSide_Long3 = alignedinputSide(1+3*expr.NtrialsLong:4*expr.NtrialsLong, :) ;
    alignedinputSide_Schedule12 = reshape(alignedinputSide_Long0(:), 2*expr.NtrialsShort, [] ) ;
    alignedinputSide_Schedule34 = reshape(alignedinputSide_Long1(:), 2*expr.NtrialsShort, [] ) ;
    alignedinputSide_Schedule56 = reshape(alignedinputSide_Long2(:), 2*expr.NtrialsShort, [] ) ;
    alignedinputSide_Schedule78 = reshape(alignedinputSide_Long3(:), 2*expr.NtrialsShort, [] ) ;

    alignedinputSide_Schedule1 = alignedinputSide_Schedule12(1:expr.NtrialsShort, :) ;
    alignedinputSide_Schedule2 = alignedinputSide_Schedule12(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;
    alignedinputSide_Schedule3 = alignedinputSide_Schedule34(1:expr.NtrialsShort, :) ;
    alignedinputSide_Schedule4 = alignedinputSide_Schedule34(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;
    alignedinputSide_Schedule5 = alignedinputSide_Schedule56(1:expr.NtrialsShort, :) ;
    alignedinputSide_Schedule6 = alignedinputSide_Schedule56(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;
    alignedinputSide_Schedule7 = alignedinputSide_Schedule78(1:expr.NtrialsShort, :) ;
    alignedinputSide_Schedule8 = alignedinputSide_Schedule78(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;

    alignedinputCombination = reshape(inputCombination, expr.NblocksLong*expr.NtrialsLong, []) ;
    alignedinputCombination_Long0 = alignedinputCombination(1:expr.NtrialsLong, :) ;
    alignedinputCombination_Long1 = alignedinputCombination(1+expr.NtrialsLong:2*expr.NtrialsLong, :) ;
    alignedinputCombination_Long2 = alignedinputCombination(1+2*expr.NtrialsLong:3*expr.NtrialsLong, :) ;
    alignedinputCombination_Long3 = alignedinputCombination(1+3*expr.NtrialsLong:4*expr.NtrialsLong, :) ;
    alignedinputCombination_Schedule12 = reshape(alignedinputCombination_Long0(:), 2*expr.NtrialsShort, [] ) ;
    alignedinputCombination_Schedule34 = reshape(alignedinputCombination_Long1(:), 2*expr.NtrialsShort, [] ) ;
    alignedinputCombination_Schedule56 = reshape(alignedinputCombination_Long2(:), 2*expr.NtrialsShort, [] ) ;
    alignedinputCombination_Schedule78 = reshape(alignedinputCombination_Long3(:), 2*expr.NtrialsShort, [] ) ;

    alignedinputCombination_Schedule1 = alignedinputCombination_Schedule12(1:expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule2 = alignedinputCombination_Schedule12(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule3 = alignedinputCombination_Schedule34(1:expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule4 = alignedinputCombination_Schedule34(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule5 = alignedinputCombination_Schedule56(1:expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule6 = alignedinputCombination_Schedule56(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule7 = alignedinputCombination_Schedule78(1:expr.NtrialsShort, :) ;
    alignedinputCombination_Schedule8 = alignedinputCombination_Schedule78(1+expr.NtrialsShort:2*expr.NtrialsShort, :) ;

    for cnt_Ncombinations = 1:4
        idx_Ncombinations_Schedule1 = find(alignedinputCombination_Schedule1==cnt_Ncombinations) ;
        inputcheck.prob_check(1,cnt_Ncombinations) = mean(alignedinputSide_Schedule1(idx_Ncombinations_Schedule1)) ;

        idx_Ncombinations_Schedule2 = find(alignedinputCombination_Schedule2==cnt_Ncombinations) ;
        inputcheck.prob_check(2,cnt_Ncombinations) = mean(alignedinputSide_Schedule2(idx_Ncombinations_Schedule2)) ;

        idx_Ncombinations_Schedule3 = find(alignedinputCombination_Schedule3==cnt_Ncombinations) ;
        inputcheck.prob_check(3,cnt_Ncombinations) = mean(alignedinputSide_Schedule3(idx_Ncombinations_Schedule3)) ;

        idx_Ncombinations_Schedule4 = find(alignedinputCombination_Schedule4==cnt_Ncombinations) ;
        inputcheck.prob_check(4,cnt_Ncombinations) = mean(alignedinputSide_Schedule4(idx_Ncombinations_Schedule4)) ;
        
        idx_Ncombinations_Schedule5 = find(alignedinputCombination_Schedule5==cnt_Ncombinations) ;
        inputcheck.prob_check(5,cnt_Ncombinations) = mean(alignedinputSide_Schedule5(idx_Ncombinations_Schedule5)) ;
        
        idx_Ncombinations_Schedule6 = find(alignedinputCombination_Schedule6==cnt_Ncombinations) ;
        inputcheck.prob_check(6,cnt_Ncombinations) = mean(alignedinputSide_Schedule6(idx_Ncombinations_Schedule6)) ;
        
        idx_Ncombinations_Schedule7 = find(alignedinputCombination_Schedule7==cnt_Ncombinations) ;
        inputcheck.prob_check(7,cnt_Ncombinations) = mean(alignedinputSide_Schedule7(idx_Ncombinations_Schedule7)) ;
        
        idx_Ncombinations_Schedule8 = find(alignedinputCombination_Schedule8==cnt_Ncombinations) ;
        inputcheck.prob_check(8,cnt_Ncombinations) = mean(alignedinputSide_Schedule8(idx_Ncombinations_Schedule8)) ;
    end
    inputcheck.prob(cnt_RL) = mean(mean(abs(inputcheck.prob_check-expr.prob(expr.ScheduleSeqOrd{expr.transitionStart}([1 2 5 6 9 10 13 14]), :))<expr.precision))==1 ;
end

